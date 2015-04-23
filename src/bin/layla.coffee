#!/usr/bin/env coffee

# 3rd party
fs       = require 'fs'
readline = require 'readline'

# Main lib
Layla = require '../lib'
CLIEmitter = require '../lib/emitter/cli'

# Layla instance to be used and reused
$layla = new Layla
$layla.emitter = new CLIEmitter

# Global options
$colors = yes

###
Write a line to stdout.
###
out = (text) ->
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
    -v, --version            Print out Layla version
    -h, --help               Display this help text
  '''

###
###
evaluate = (source) ->
  try
    ast = $layla.parse source
    doc = $layla.evaluate ast
    doc = $layla.normalize doc
    css = $layla.emit doc
    return css
  catch e
    if false
      warn "\x1b[33m#{e}\x1b[0m"
    else
      err "\x1b[31m#{e}\x1b[0m"

compile = (source) ->
  ast = $layla.parse source
  css = $layla.evaluate ast
  $layla.emit css

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

      when '--color'
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

      when '--no-color'
        if val isnt null
          warn """
          Bad value for --no-color option: \
          this option does not accept arguments
          """
          exit 1

        $colors = no

      when '--repl', '-i', '--interactive'
        interactive = yes

      when '--reporter', '-r'
        try
          while arg = args.shift()
            if arg.substr(0, 1) is '-'
              throw null
            reporter = arg
          break
        catch
          continue

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

if interactive
  doc = new Layla.Document
  scope = new Layla.Scope

  repl = readline.createInterface(process.stdin, process.stdout)
  repl.setPrompt '> '

  repl.on 'line', (text) ->
    if text.trim() isnt ''
      try
        $layla.parser.prepare text
        res = null
        for stmt in $layla.parser.parseBody()
          if stmt?
            res = $layla.evaluator.evaluateNode stmt, doc, scope
        if res
          out $layla.emit res
      catch e
        if e instanceof Layla.Error
          err "\u001b[31m#{e}\u001b[0m"
        else
          throw e

    repl.prompt()

  repl.on 'close', ->
    out()
    exit()

  repl.on 'SIGINT', ->
    out '^C'
    # Simulate ctrl+u to delete the line previously written
    repl.write null, {ctrl: yes, name: 'u'}
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

  stdin.on 'end', -> evaluate text
