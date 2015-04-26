# 3rd party
fs            = require 'fs-extra'
{dirname}     = require 'path'
which         = require 'which'
childProcess  = require 'child_process'
coffee        = require 'coffee-script'
uglify        = require 'uglify-js'
glob          = require 'glob'
CSON          = require 'season'
Layla         = require './src/lib'

#
QUEUE = []

ESC        = '\u001b'
RESET      = "#{ESC}[0m"
BOLD       = "#{ESC}[1m"
RED        = "#{ESC}[31m"
GREEN      = "#{ESC}[32m"
YELLOW     = "#{ESC}[33m"
CHECK      = "#{GREEN}√#{RESET}"

SOURCE = no
VERBOSE = no

next = ->
  if QUEUE.length
    QUEUE[0]()

queue = (func) ->
  QUEUE.push func
  if QUEUE.length is 1
    next()

log = (type, text = '', format...) ->
  if type is 'task'
    text = "#{YELLOW}#{text}"
  else if type is 'ok'
    if VERBOSE
      text = "#{CHECK} #{text}"
    else
      text = " #{CHECK}\n"
  else if not VERBOSE
    return
  else
    text = "#{BOLD}#{type}#{RESET} #{text}"

  text += RESET

  process.stdout.write text

  if VERBOSE
    process.stdout.write "\n"

done = ->
  if QUEUE.length > 0
    log 'ok', 'Done'
    QUEUE.shift()
    next()

exit = (status = 0) -> process.exit status

exec = (cmd,  callback = done) ->
  log 'exec', cmd
  args = cmd.split /\s+/
  cmd = args.shift()
  cmd = which.sync cmd
  cmd += ' ' + args.join ' '

  childProcess.exec cmd, (err, stdout, stderr) ->
    throw err if err
    console.log stdout if stdout
    console.error stderr if stderr
    callback()

spawn = (cmd,  callback = done) ->
  log 'exec', cmd
  args = cmd.split /\s+/
  cmd = args.shift()
  cmd = which.sync cmd

  child = childProcess.spawn cmd, args, stdio: 'inherit'

  child.on 'exit', (status) ->
    if status is 0
      callback()
    else
      exit status

mkdir = (path, callback = done) ->
  fs.stat path, (err, stat) ->
    if err
      log 'mkdir', path
      fs.mkdirsSync path
    else unless stat.isDirectory()
      throw new Error "Cannot make directory #{path}: file exists"

    callback()

remove = (paths, callback = done) ->
  for path in paths
    try
      fs.statSync path
      log 'rm', path
      fs.removeSync path

  callback()

copy = (src, dest, callback = done) ->
  mkdir (dirname dest), ->
    log 'cp', "#{src} -> #{dest}"
    fs.copySync src, dest
    callback()

read = (path, callback = done) ->
  fs.readFile path, 'utf-8', (err, data) ->
    throw err if err
    callback data

write = (path, contents, callback = done) ->
  log 'write', path
  fs.writeFile path, contents, (err) ->
    throw err if err
    callback()

uncoffee = (source) -> coffee.compile source, bare: yes, header: no

test = (path, source = SOURCE, callback = done) ->
  path = "test/#{path}"

  args = [
    '--require should'
    '--slow 500'
    '--reporter ' + (if VERBOSE then 'spec' else 'base')
  ]

  if source
    path = "src/#{path}"
    args.push '--compilers coffee:coffee-script/register'

  spawn "mocha #{args.join ' '} #{path}", callback

# Cheating a bit to get "global" options in this Cakefile
_task = global.task

global.task = (name, description, action) ->
  _task name, description, (options) ->
    if options.verbose
      VERBOSE = yes
    if options.source
      SOURCE = yes

    action options

option '-v', '--verbose', 'Be verbose'

option null, '--source', 'Run tests against source coffee'

task 'clean', 'Remove all built files and directories', ->
  queue ->
    log 'task', 'Cleaning up'
    remove ['bin', 'lib', 'dist', 'test']

task 'build:bin', 'Build CLI binary', ->
  queue ->
    log 'task', 'Building binary'

    read "src/bin/layla.coffee", (source) ->
      js = uncoffee source
      js = "#!/usr/bin/env node\n#{js}"

      mkdir 'bin', ->
        write 'bin/layla', js

task 'build:test', 'Build tests', ->
  queue ->
    log 'task', 'Building tests'
    spawn 'coffee --compile --output test/ src/test'

  queue ->
    log 'task', 'Copying test fixtures'
    fixtures = CSON.readFileSync 'src/test/fixtures.cson'

    files = []

    for pattern in fixtures
      files.push (glob.sync "src/test/#{pattern}", nodir: yes)...

    do cp = ->
      if files.length
        file = files.shift()
        dest = file.replace /^src\//, ''
        copy file, dest, -> cp()
      else
        done()

task 'build:lib', 'Build library', ->
  queue ->
    log 'task', 'Building lib'
    mkdir 'lib', ->
      exec "coffee --compile --no-header --output lib/ src/lib"

task 'build:license', 'Build license file', ->
  queue ->
    log 'task', 'Building license'
    write './License.md', require './src/license'

task 'build:index', 'Build root `index.js`', ->
  queue ->
    log 'task', 'Building index.js'
    read 'src/index.coffee', (source) ->
      write 'index.js', uncoffee source

task 'build:module', 'Build NPM module', ->
  invoke 'build:index'

task 'build:all', 'Build everything', ->
  invoke 'build:lib'
  invoke 'build:bin'
  invoke 'build:license'
  invoke 'build:module'
  invoke 'build:test'

task 'build', 'Alias of build:all', -> invoke 'build:all'

task 'test:cases', 'Run test cases', ->
  queue ->
    log 'task', 'Running test cases'
    test 'cases'

task 'test:style', 'Run style tests', ->
  queue ->
    log 'task', 'Running style tests'
    test 'style', yes

task 'test:docs', 'Run docs test', ->
  queue ->
    log 'task', 'Running docs tests'
    test 'docs'

task 'test:bin', 'Run CLI tests', ->
  queue ->
    log 'task', 'Running CLI tests'
    test 'bin'

task 'test:all', 'Test everything', ->
  invoke 'test:cases'
  invoke 'test:style'
  invoke 'test:docs'
  invoke 'test:bin'

task 'test', 'Alias of test:all', -> invoke 'test:all'
