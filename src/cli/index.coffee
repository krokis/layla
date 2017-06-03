#!/usr/bin/env coffee
os              = require 'os'
fs              = require 'fs'
path            = require 'path'
readline        = require 'readline'
colorSupport    = require 'color-support'

Layla         = require '../lib'
EOTError      = require '../lib/error/eot'
CSSNormalizer = require '../css/normalizer'
CLIContext    = require './context'
CLIEmitter    = require './emitter'


EOL = os.EOL

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

class UsageError
  constructor: (@message) ->
  toString: -> @message

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
Exit with given `status`.
###
exit = (status = 0) -> process.exit status

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
    fs.writeFileSync $out_file, res
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
      history = (fs.readFileSync historyFile).toString().trim()
      history = (history.split '\n').reverse()
      repl.history = history

    saveHistoryLine = (line) ->
      fs.appendFileSync historyFile, line + "\n"
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
      saveHistoryLine text

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
process.title = 'layla' # Sets window title on Windows

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
        exit 0
      when 'v', 'version'
        # Print version and exit
        version()
        exit 0
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
      context.include file

  if $interactive
    repl context
  else if $files.length
    emit context.block
    exit 0
  else
    source = ''

    stdin = process.openStdin()
    stdin.setEncoding 'utf8'

    stdin.on 'data', (chunk) ->
      source += chunk

    stdin.on 'end', ->
      $layla.evaluate source
      emit context.block
      exit 0

catch e
  if e instanceof UsageError
    warn e.toString()
    stderr()
    stderr USAGE
  else
    err e.toString()
    throw e

  exit 1
