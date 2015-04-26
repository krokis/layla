#!/usr/bin/env coffee

# 3rd party
fs       = require 'fs'
readline = require 'readline'

# Main lib
Layla = require '../lib'
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

# Global options
$colors = null
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
commands =
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
        "Unkown option: #{opts[0].name} for `compile` command"
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
        "Unkown option: #{opts[0].name} or `compile` command"
      )

    if args.length > 0
      for arg in args
        file = arg.value
        fs.lstat file, (err, stat) ->
          throw err if err
          if stat.isFile()
            fs.readFile file, 'utf8', (err, str) ->
              throw err if err
              doCompile str
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
    $colors = $colors isnt no

    doc = new Layla.Document
    scope = new Layla.Scope
    emitter = new CLIEmitter colors: $colors

    repl = readline.createInterface(process.stdin, process.stdout)

    buffer = null

    do reset = ->
      buffer = ''
      repl.setPrompt '> '

    repl.on 'line', (text) ->
      if text.trim() isnt ''
        try
          res = null
          $layla.parser.prepare "#{buffer}\n#{text}"
          for stmt in $layla.parser.parseBody()
            if stmt?
              res = $layla.evaluator.evaluateNode stmt, doc, scope
          if res
            out emitter.emit res
          reset()
        catch e
          if e instanceof Layla.Error
            if e instanceof EOTError
              buffer += "\n" + text
              repl.setPrompt '| '
            else
              err e.toString()
              reset()
          else
            throw e

      repl.prompt()

    repl.on 'close', -> exit()

    repl.on 'SIGINT', ->
      out '^C'
      # Simulate ctrl+u to delete the line previously written
      repl.write null, ctrl: yes, name: 'u'
      reset()
      repl.prompt()

    repl.prompt()

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
            Compiles lay source code into CSS and outputs it.

            Usage:
              layla compile [<file>...|<stdin]
            '''

      when 'parse'
        out '''
            Parses lay source code and outputs an AST in JSON format.

            Usage:
              layla parse [<file>]
            '''

      when 'repl'
        out '''
            Starts an interactive console.

            Usage:
              layla [options] repl [<file>...]
            '''

      when 'help'
        out '''
            Displays help about a specific command.

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
            Displays Layla version.

            Usage:
              layla version
            '''
      else
        if command isnt null
          unless command of commands
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

            Global options:
              --use <plugin>,...   Use one or more plugins
              --colors             Use colors on the output
              --no-colors          Don't use colors on the output
            '''

commands.repl = commands.interactive

###
"main"
###

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

# Global options

i = 0

while i < opts.length
  opt = opts[i]

  switch opt.name
    when 'h', 'help'
      command = 'help'
    when 'colors', 'no-colors'
      if opt.value isnt undefined
        throw new Error """
          Bad syntax for `#{opt.name}` option: \
          this option does not accept a value.
          """
      $colors = opt.name is 'colors'
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

  if command of commands
    commands[command] args, opts
  else
    throw new UnknownCommandError "Unknown command: `#{command}`"
catch e
  err e.toString()
  if e instanceof UsageError
    commands.help()
