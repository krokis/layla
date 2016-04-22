#!/usr/bin/env coffee

# 3rd party
fs            = require 'fs'
path          = require 'path'
readline      = require 'readline'
supportsColor = require 'supports-color'

Layla      = require '../lib'
CLIEmitter = require '../lib/emitter/cli'
EOTError   = require '../lib/error/eot'

class UsageError
  constructor: (@message) ->
  toString: -> @message

class TooManyArgumentsError extends UsageError

class UnknownCommandError extends UsageError

class UnknownOptionError extends UsageError

class Arg
  constructor: (@value) ->

class Opt
  constructor: (@name, @value) ->

# Layla instance to be used and reused
$layla = new Layla
$layla.scope.set 'LAYLA-VERSION', new Layla.String Layla.version

# Global options
$colors = !!supportsColor
$plugins = []

###
Write a line to stdout.
###
out = (text = '') -> console.log text

outJSON = (obj) -> out JSON.stringify obj, null, ' '

###
Write a warning line to stderr.
###
warn = (text) ->
  text = "\x1b[33m#{text}\x1b[0m" if $colors isnt no
  console.warn text

###
Write an error line to stderr.
###
err = (text) ->
  text = "\x1b[31m#{text}\x1b[0m" if $colors isnt no
  console.error text

###
###
exit = (status = 0) -> process.exit status

###
###
Commands =
  parse: (args = [], opts = []) ->
    colors = $colors is yes

    doParse = (source) ->
      try
        outJSON $layla.parse source
      catch e
        if false
          warn e
        else
          throw e

    if opts.length > 0
      throw new UnknownOptionError (
        "Unkown option: #{opts[0].name} for `parse` command"
      )

    if args.length > 0
      for arg in args
        file = arg.value
        fs.lstat file, (err, stat) ->
          throw err if err
          if stat.isFile()
            fs.readFile file, 'utf8', (err, str) ->
              throw err if err
              doParse str
          else
            throw new Error
    else
      source = ''
      stdin = process.openStdin()
      stdin.setEncoding 'utf8'
      stdin.on 'data', (chunk) ->
        source += chunk

      stdin.on 'end', ->
        doParse source

  compile: (args = [], opts = []) ->
    colors = $colors is yes

    $layla.emitter = new CLIEmitter colors: colors

    doCompile = (source) ->
      try
        out $layla.compile source
      catch e
        if e instanceof Layla.Error
          if false
            warn e
          else
            err e.toString()
        else
          throw e

    if opts.length > 0
      throw new UnknownOptionError (
        "Unkown option: #{opts[0].name} for `compile` command"
      )

    if args.length > 0
      for arg in args
        file = arg.value
        fs.lstat file, (err, stat) ->
          throw err if err

          if stat.isFile()
            fs.readFile file, 'utf8', (err, str) ->
              $layla.scope.paths.push path.dirname file
              throw err if err
              doCompile str
              $layla.scope.paths.pop()
          else
            throw new Error
    else
      source = ''
      stdin = process.openStdin()
      stdin.setEncoding 'utf8'
      stdin.on 'data', (chunk) ->
        source += chunk

      stdin.on 'end', ->
        doCompile source

  interactive: (args = [], opts = []) ->
    if opts.length > 0
      throw new UnknownOptionError (
        "Unkown option: #{opts[0].name} for `interactive` command"
      )

    $colors = $colors isnt no

    doc = new Layla.Document
    emitter = new CLIEmitter colors: $colors

    if args.length > 0
      for arg in args
        file = arg.value
        $layla.scope.paths.push path.dirname file
        $layla.evaluator.importFile file, doc, $layla.scope
        $layla.scope.paths.pop()

    $layla.scope.paths.push process.cwd()

    buffer = null

    repl = readline.createInterface process.stdin, process.stdout, autocomplete

    if process.env.HOME
      historyFile = path.join process.env.HOME, '.layla_history'

      do loadHistory = ->
        if fs.existsSync historyFile
          history = (fs.readFileSync historyFile).toString().trim()
          history = (history.split '\n').reverse()
          repl.history = history

      saveHistoryLine = (line) ->
        fs.appendFile historyFile, line + "\n"

    autocomplete = (line) -> [[], line]

    reset = ->
      buffer = ''
      repl.setPrompt '> '
      repl.prompt()

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
          $layla.parser.prepare "#{buffer}\n#{text}"
          for stmt in $layla.parser.parseBody()
            if stmt?
              res = $layla.evaluator.evaluateNode stmt, doc, $layla.scope
          if res
            out emitter.emit res
          reset()
        catch e
          if e instanceof Layla.Error
            if e instanceof EOTError
              buffer += "\n" + text
              repl.setPrompt '| '
              repl.prompt()
            else
              err e.toString()
              reset()
          else
            throw e

    repl.on 'close', ->
      out ''
      exit()

    repl.on 'SIGINT', ->
      out ''
      repl.write null, ctrl: yes, name: 'u'
      reset()

    reset()

  ###
  ###
  version: -> out Layla.version

  ###
  ###
  help: (args = [], opts = []) ->
    command = null

    if args.length > 1
      throw new TooManyArgumentsError 'Too many arguments for `help` command'
    else if args.length is 1
      command = args[0].value
    else
      command = null

    for opt in opts
      throw new UnknownOptionError "Unknown option `#{opt.name}`"

    switch command
      when 'compile'
        out '''
            Compile lay source code into CSS and output it.

            Usage:
              layla compile [<file>...]

            Options:
               --use <plugin>,...   Use one or more plugins
            '''

      when 'parse'
        out '''
            Parse lay source code and output an AST in JSON format.

            Usage:
              layla parse [<file>]
            '''

      when 'interactive'
        out '''
            Start an interactive console.

            Usage:
              layla [options] interactive [<file>...]

            Options:
               --colors             Use colors on the output
               --no-colors          Don't use colors on the output
               --use <plugin>,...   Use one or more plugins
            '''

      when 'help'
        out '''
            Show help about a specific command.

            Usage:
              layla help <command>
              layla <command> --help
              layla <command> -h

            Available comands:
              compile
              parse
              interactive
              version
              help
            '''

      when 'version'
        out '''
            Print Layla version.

            Usage:
              layla version
              layla --version
              layla -v
            '''
      else
        if command isnt null
          unless command of Commands
            throw new UnknownCommandError "Unknown command: #{command}"

        out '''
            Usage:
              layla command [options] [args...]

            Commands:
              compile              Compile lay into css
              parse                Parse lay source code and return an AST
              interactive          Start an interactive console
              version              Print out Layla version
              help                 Show help

            Common options:
              --use <plugin>,...   Use one or more plugins
              -c, --colors         Use colors on the output
              -C, --no-colors      Don't use colors on the output
            '''

Commands.repl = Commands.interactive

###
"main"
###
process.title = 'Layla'

command = null
args = []
opts = []

for arg, i in process.argv.slice 2
  if arg[0] is '-'
    if m = arg.match /(?:\-{1,2}([^=]+))(?:(?:=(.+))|$)/
      opts.push new Opt m[1], m[2]
    else
      throw new UsageError "Bad argument: #{arg}"
  else
    args.push new Arg arg

bool = (val) -> return !!(val.toString().match /1|true|yes|on/i)

i = 0

while i < opts.length
  opt = opts[i]

  switch opt.name
    when 'h', 'help'
      command = 'help'
    when 'v', 'version'
      command = 'version'
    when 'colors', 'c'
      if opt.value is undefined
        $colors = yes
      else
        $colors = bool opt.value
    when 'no-colors', 'C'
      if opt.value isnt undefined
        throw new Error """
          Bad syntax for `#{opt.name}` option: \
          this option does not accept a value.
          """
      $colors = no
    when 'use'
      if opt.value isnt undefined
        $plugins.push (opt.value.split ',')...
    else
      i++
      continue

  opts.splice i, 1

# $layla.use $plugins... # TODO
try
  if command is null
    if args.length > 0
      command = (args.shift()).value
    else
      command = 'help'

  if command of Commands
    Commands[command] args, opts
  else
    throw new UnknownCommandError "Unknown command: `#{command}`"
catch e

  if e instanceof UsageError
    warn e.toString()
    out()
    Commands.help()
  else
    err e.toString()
