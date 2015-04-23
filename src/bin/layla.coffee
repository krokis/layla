#!/usr/bin/env coffee

# 3rd party
fs       = require 'fs'
readline = require 'readline'

# Main lib
Layla = require '../lib'
CLIEmitter = require '../lib/emitter/cli'
EOTError   = require '../lib/error/eot'

# Layla instance to be used and reused
$layla = new Layla

# Global options
$colors = yes

###
Write a line to stdout.
###
out = (text = '') ->
  console.log text

###
Write a warning line to stderr.
###
warn = (text) ->
  console.warn text

###
Write an error line to stderr.
###
err = (text) ->
  console.error text

###
###
exit = (status = 0) -> process.exit status

###
###
version = -> out Layla.version

###
###
help = ->
  out '''
  Usage: layla [options] [<pipes>]  [[--] file [file...]] | < in]

  Emitters:
    css

  Options:
    -u, --use <plugin>,...   Use one or more plugins
    -i, --interactive        Start an interactive console
    --colors                 Use colors on the console output
    --no-colors              Don't use colors on the console output
    -v, --version            Print out Layla version
    -h, --help               Display this help text
  '''

###
###
compile = (source) ->
  try
    $layla.compile source
  catch e
    if false
      warn "\x1b[33m#{e}\x1b[0m"
    else
      err "\x1b[31m#{e}\x1b[0m"

###
main
###
args        = process.argv.slice 2
plugins     = []
files       = []
interactive = no
emitter     = null

try
  arg = args.shift()
  val = null

  while arg
    i = arg.indexOf '='

    if i == 0
      arg = arg.substr 1
    else if i > 0
      if i < (arg.length - 1)
        val = arg.substr i + 1
        args.unshift val

      arg = arg.substr 0, i

    switch arg
      when '--use', '-u'
        try
          while arg = args.shift()
            if arg.substr(0, 1) is '-'
              throw null
          plugins.push arg
        catch
          continue

      when '--version', '-v'
        version()
        exit()

      when '--colors'
        if val isnt null
          if val is 'auto'
            $colors = yes
          else if val = 'yes'
            $colors = yes
          else if val = 'no'
            $colors = no
          else
            warn "Bad value for --color option: `#{val}`"
            exit 1

      when '--no-colors'
        if val isnt null
          warn """
          Bad value for --no-color option: \
          this option does not accept arguments
          """
          exit 1

        $colors = no

      when '--repl', '-i', '--interactive'
        interactive = yes

      when '--help', '-h'
        help()
        exit()

      else
        if arg[0] is '-'
          throw new Error "Unknown option: #{arg}"
        else
          files.push arg

    arg = args.shift()

catch e
  out e.message
  help()
  exit()

for plugin in plugins
  $layla.use plugin

if interactive
  doc = new Layla.Document
  scope = new Layla.Scope
  $layla.emitter = new CLIEmitter colors: $colors

  repl = readline.createInterface(process.stdin, process.stdout)

  buffer = ''

  do resetBuffer = ->
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
          out $layla.emit res
        resetBuffer()
      catch e
        if e instanceof Layla.Error
          if e instanceof EOTError
            buffer += "\n" + text
            repl.setPrompt '| '
          else
            err "\u001b[31m#{e}\u001b[0m"
            resetBuffer()
        else
          throw e

    repl.prompt()

  repl.on 'close', -> exit()

  repl.on 'SIGINT', ->
    out '^C'
    # Simulate ctrl+u to delete the line previously written
    repl.write null, ctrl: yes, name: 'u'
    repl.prompt()

  repl.prompt()

else if files.length > 0
  for file in files
    fs.lstat file, (err, stat) ->
      throw err if err
      if stat.isFile()
        fs.readFile file, 'utf8', (err, str) ->
          throw err if err
          out compile str
      else
        throw new Error

else
  text = ''
  stdin = process.openStdin()
  stdin.setEncoding 'utf8'
  stdin.on 'data', (chunk) ->
    text += chunk

  stdin.on 'end', -> out compile str
