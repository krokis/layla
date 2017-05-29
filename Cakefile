# 3rd party
fs           = require 'fs-extra'
{dirname}    = require 'path'
which        = require 'which'
childProcess = require 'child_process'
coffee       = require 'coffee-script'
glob         = require 'glob'
Layla        = require './src/lib'

#
QUEUE = []

ESC    = '\u001b'
RESET  = "#{ESC}[0m"
BOLD   = "#{ESC}[1m"
RED    = "#{ESC}[31m"
GREEN  = "#{ESC}[32m"
YELLOW = "#{ESC}[33m"
CHECK  = "#{GREEN}√#{RESET}"
CROSS  = "#{BOLD}#{RED}×#{RESET}"

ERRORS = 0

VERBOSE = no
WATCH   = no

# Cheating a bit to get "global" options in this Cakefile
_task = global.task

global.task = (name, description, action) ->
  _task name, description, (options) ->
    if options.verbose
      VERBOSE = yes

    if options.watch
      WATCH = yes

    action options

log = (type = '', text = '') ->
  if type is 'task'
    text = "#{YELLOW}#{text} "
  else
    if type is 'ok'
      mark = CHECK
    else if type is 'error'
      mark = CROSS
    else if not VERBOSE
      return
    else
      mark = "#{BOLD}#{type}#{RESET}"

    if VERBOSE
      text = "#{mark} #{text}"
    else
      text = "#{mark}\n"

  text += RESET

  process.stdout.write text

  if VERBOSE
    process.stdout.write "\n"

next = ->
  if QUEUE.length
    QUEUE[0]()
  else
    exit()

queue = (func) ->
  QUEUE.push func
  if QUEUE.length is 1
    next()

exit = ->
  if ERRORS and VERBOSE
    s = if ERRORS.length > 1 then 's' else ''
    log 'error', "#{BOLD}#{ERRORS} task#{s} failed"

  process.exit ERRORS

done = ->
  log 'ok', 'Done'
  log()
  QUEUE.shift()
  next()

fail = (text = 'Error') ->
  ERRORS++
  log 'error', text
  log()
  QUEUE.shift()
  next()

exec = (cmd,  callback = done) ->
  log 'exec', cmd
  args = cmd.split /\s+/
  cmd = args.shift()
  wcmd = which.sync cmd

  stdio = if VERBOSE then 'inherit' else 'ignore'

  child = childProcess.spawn wcmd, args, stdio: stdio

  child.on 'exit', (status) ->
    if status is 0
      callback()
    else
      fail "Command #{BOLD}#{cmd}#{RESET} did not exited nicely (#{status})"

mkdir = (path, callback = done) ->
  fs.stat path, (err, stat) ->
    if err
      log 'mkdir', path
      fs.mkdirsSync path
    else unless stat.isDirectory()
      throw new Error "Cannot make directory #{path}: file exists"

    callback()

remove = (paths, callback = done) ->
  for path in [].concat paths
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

chmod = (path, mode, callback = done) ->
  log 'chmod', "#{mode} #{path}"
  mode = parseInt mode, 8
  fs.chmod path, mode, (err) ->
    throw err if err
    callback()

uncoffee = (source) ->
  coffee.compile source, bare: yes, header: no

test = (path, source = no, callback = done) ->
  path = "test/#{path}"

  args = [
    '--slow 500'
    '--timeout 10000'
    '--reporter ' + (if VERBOSE then 'spec' else 'base')
  ]

  args.push '--watch' if WATCH

  if source
    path = "src/#{path}"
    args.push '--compilers coffee:coffee-script/register'

  exec "mocha #{args.join ' '} #{path}", callback

option '-v', '--verbose', 'Enable verbose output'

option '-w', '--watch', 'Whatch sources for changes and re-run tasks'

task 'clean', 'Remove all built files and directories', ->
  queue ->
    log 'task', 'Cleaning up'
    remove ['bin', 'lib', 'dist', 'test']

task 'build:bin', 'Build CLI binary', ->
  queue ->
    log 'task', 'Building binary'

    read "src/bin/layla", (source) ->
      js = """
           #!/usr/bin/env node
           #{uncoffee source}
           """
      mkdir 'bin', ->
        write 'bin/layla', js, ->
          chmod 'bin/layla', '0755'

task 'build:test', 'Build tests', ->
  queue ->
    log 'task', 'Building tests'
    exec 'coffee --compile --output test/ src/test'

  queue ->
    log 'task', 'Copying test fixtures'
    fixtures = require './src/test/fixtures.json'
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
      args = ['--compile', '--no-header']
      args.push '--watch' if WATCH
      exec "coffee #{args.join ' '} --output lib/ src/lib"

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

task 'build', 'Alias of build:all', ->
  invoke 'build:all'

[no, yes].forEach (source) ->

  prefix = 'test'

  if source
    prefix += ':source'
    expl = ' (source)'
  else
    expl = ''

  task "#{prefix}:cases", "Run test cases#{expl}", ->
    queue ->
      log 'task', "Running test cases#{expl}"
      test 'cases', source

  task "#{prefix}:style", "Run style tests#{expl}", ->
    queue ->
      log 'task', "Running style tests#{expl}"
      test 'style', yes

  task "#{prefix}:docs", "Run docs tests#{expl}", ->
    queue ->
      log 'task', "Running docs tests#{expl}"
      test 'docs', source

  task "#{prefix}:bin", "Run CLI tests#{expl}", ->
    queue ->
      log 'task', "Running CLI tests#{expl}"
      test 'bin', source

  task "#{prefix}:all", "Run all tests#{expl}", ->
    invoke "#{prefix}:cases"
    invoke "#{prefix}:style"
    invoke "#{prefix}:docs"
    invoke "#{prefix}:bin"

  task "#{prefix}", 'Alias of test:all', ->
    invoke "#{prefix}:all"

task 'all', 'Build, test and then clean everything', ->
  invoke 'build:all'
  invoke 'test:all'
  invoke 'clean'
