#!/usr/bin/env coffee
os              = require 'os'
fs              = require 'fs'
path            = require 'path'
readline        = require 'readline'
colorSupport    = require 'color-support'

Layla         = require '../lib'
ProgramError  = require '../lib/error/program'
EOTError      = require '../lib/error/eot'
CSSNormalizer = require '../css/normalizer'
CLIContext    = require './context'
CLIEmitter    = require './emitter'


EOL = os.EOL

# Exit codes from http://www.gsp.com/cgi-bin/man.cgi?section=3&topic=sysexits
EX_OK              = 0
EX_ERROR_GENERAL   = 1  # Not currently used
EX_ERROR_USAGE     = 64
EX_ERROR_DATAERR   = 65
EX_ERROR_SOFTWARE  = 70 # TODO Ensure it's used on any uncaught error
EX_ERROR_IOERR     = 74

SUPPORTS_COLORS = colorSupport()

USAGE = """
  Usage:
    layla [options] file...|< [>]

  Options:
    -u, --use <plugin>      Use a plugin
    -o, --out-file <file>   Write compiled code to a file instead of printing it
    -i, --interactive       Start an interactive console
    -c, --colors            Use colors on the output
    -C, --no-colors         Don't use colors on the output
    -v, --version           Print out Layla version
    -h, --help              Show this help
  """


class CLIError
  constructor: (@message) ->
  toString: -> @message

class UsageError extends CLIError

class IOError extends CLIError

class UnknownOptionError extends UsageError

class Arg
  constructor: (@value) ->

class Opt extends Arg
  constructor: (@name, value) -> super value
  bool: ->
    @value is null or /^\s*1|true|y|yes|on\s*/i.test(@value)

# "Global" options
$interactive = no
$colors = no
$out_file = null
$files = []

stdout = (text = '', new_line = yes) ->
  process.stdout.write text
  if new_line
    stdout EOL, no

stderr = (text = '', new_line = yes) ->
  process.stderr.write text
  if new_line
    stderr EOL, no

###
Write a warning line to stderr.
###
warn = (text) ->
  text = "\x1b[33m#{text}\x1b[0m" if SUPPORTS_COLORS
  stderr text

###
Write an error line to stderr.
###
err = (text) ->
  text = "\x1b[31m#{text}\x1b[0m" if SUPPORTS_COLORS
  stderr text

###
Exit with given `code`.
###
exit = (code = EX_OK) -> process.exit code

###
Print Layla version.
###
version = -> stdout Layla.version

###
Print out usage.
###
help = -> stdout USAGE

###
Emit and print or write to file a Layla node.
###
emit = (node, new_line = no) ->
  normalizer = new CSSNormalizer
  node = normalizer.normalize node

  emitter = new CLIEmitter colors: $colors
  res = emitter.emit node

  if $out_file
    try
      fs.writeFileSync $out_file, res
    catch e
      cause = null

      switch e.code
        when 'EACCES'
          cause = 'permission denied'
        when 'ENOTDIR', 'ENOENT'
          cause = 'directory does not exist'
        else
          cause = "got a `#{e.code}` error while trying to write file"

      message = "Could not write to `#{$out_file}`"
      message += ": #{cause}" if cause
      message += '.'

      throw new IOError message
  else
    stdout res, new_line

###
Start interactive (REPL) console.
###
repl = (context) ->
  buffer = ''

  repl = readline.createInterface process.stdin, process.stdout, autocomplete

  if process.env.HOME
    historyFile = path.join process.env.HOME, '.layla_history'

    if fs.existsSync historyFile
      history = (fs.readFileSync historyFile).toString()
      history = history.replace /\0$/, ''
      history = (history.split '\0').reverse()
      repl.history = history

    saveHistoryLine = (line) ->
      fs.appendFileSync historyFile, line + '\0'
  else
    saveHistoryLine = ->

  autocomplete = (line) -> [[], line]

  reset = ->
    buffer = ''
    repl.setPrompt '> '
    repl.prompt()

  # Clear screen with `^L`
  process.stdin.on 'keypress', (seq) ->
    if seq is '\f'
      process.stdout.write '\u001B[2J\u001B[0;0f'
      reset()

  repl.on 'line', (text) ->
    if text.trim() is '' and buffer is ''
      reset()
    else
      try
        res = null
        text = "#{buffer}\n#{text}" if buffer isnt ''
        block = $layla.parser.parse text, '<stdin>'

        for stmt in block.body
          if stmt?
            res = context.evaluate stmt
        if res
          emit res
          stdout()

        reset()
      catch e
        if e instanceof Layla.Error
          if e instanceof EOTError
            buffer = text
            repl.setPrompt '| '
            repl.prompt()
            return

          msg = e.toString()

          if e.line? and e.column?
            msg += ' @ ' + e.line + ':' + e.column

          err msg
          reset()
        else
          throw e

      saveHistoryLine text

  repl.on 'close', ->
    stdout()
    exit()

  # Discard line on `^C`
  repl.on 'SIGINT', ->
    stdout()
    repl.write null, ctrl: yes, name: 'u' # Clears current line
    reset()

  reset()

###
Main
###
process.title = 'layla' # Sets process name, plus shell title on Windows

try
  # Pre-parse arguments
  args = []

  for arg in process.argv.slice 2
    if arg[0] is '-'
      if arg[1] is '-'
        name = arg[2..]
        e = name.indexOf '='

        if e >= 0
          value = name[e + 1..]
          name = name[0..e - 1]
        else
          value = null

        args.push new Opt name, value
      else
        for c in arg[1..]
          args.push new Opt c, null
    else
      args.push new Arg arg

  getArg = ->
    if args.length and args[0] instanceof Arg
      return args.shift()

  getOpt = ->
    if args.length and args[0] instanceof Opt
      return args.shift()

  handleOpt = (opt) ->
    switch opt.name
      when 'h', 'help'
        # Show usage and exit
        help()
        exit()
      when 'v', 'version'
        # Print version and exit
        version()
        exit()
      when 'c', 'colors'
        # Enable or disable colors
        $colors = opt.bool()
      when 'C', 'no-colors'
        # Disable colors
        $colors = not opt.bool()
      when 'i', 'interactive', 'repl'
        # Set interactive mode
        $interactive = opt.bool()
        $colors or= SUPPORTS_COLORS
      when 'o', 'out-file'
        if opt.value
          file = opt
        else
          file = getArg()

        unless file
          throw new UsageError "Expected file name after `--out-file` option"

        $out_file = file.value.trim()
      when 'u', 'use'
        if opt.value
          plugin = opt.value.trim()
        else
          plugin = getArg()

        unless plugin
          throw new UsageError "Expected plugin name after `--use` option"

        $plugins.push plugin
      else
        throw new UsageError "Unkown option: `#{opt.name}`"

  # Iterate parsed arguments
  loop
    if opt = getOpt()
      handleOpt opt
    else if arg = getArg()
      $files.push arg.value
    else
      break

  context = new CLIContext
  $layla = new Layla context

  # $layla.use $plugins... # TODO

  if $files.length
    for file in $files
      # TODO Throw proper exception if file is not writable
      # BUT.... I'm using `context.include` right now. It will throw its own
      # exceptions, but will also allow us to incude non-local files! :)
      # ie: `layla -use http-loader http://foo.com/file.lay > file.css
      context.include file

  if $interactive
    repl context
  else if $files.length
    emit context.block
    exit()
  else
    source = ''

    stdin = process.openStdin()
    stdin.setEncoding 'utf8'

    stdin.on 'data', (chunk) ->
      source += chunk

    stdin.on 'end', ->
      $layla.evaluate source
      emit context.block
      exit()

catch e
  ex = EX_ERROR_SOFTWARE

  if e instanceof CLIError
    if e instanceof UsageError
      warn e.toString()
      stderr()
      stderr USAGE
      ex = EX_ERROR_USAGE
    else if e instanceof IOError
      ex = EX_ERROR_IOERR
  else if e instanceof ProgramError
    ex = EX_ERROR_DATAERR

  err e.toString()
  exit ex
