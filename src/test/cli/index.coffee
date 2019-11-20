os            = require 'os'
path          = require 'path'
fs            = require 'fs'
stream        = require 'stream'
{expect}      = require 'chai'
tmp           = require 'tmp'
uuid4         = require 'uuid/v4'
Command       = require '../../cli/command'
LAYLA_VERSION = require '../../lib/version'


ANSI_ESCAPE = "\\u001B"
ANSI_COLOR = ///(^$)|#{ANSI_ESCAPE}\[(#{[16..231].join('|')})m///
NO_ANSI_COLOR = ///(^(?!.*?(#{ANSI_ESCAPE}\[(#{[16..231].join('|')})m)))///


class StreamMock extends stream.Duplex

  constructor: (args...) ->
    super args...
    @data = ''

  write: (data) ->
    @data += data
    @emit 'data', data

  _read: -> @data

  _transform: (data, encoding, callback) ->
    @write data
    callback()

  end: (data) ->
    @write(data) if data?
    @emit 'end', {}

class TTYMock extends StreamMock
  constructor: (args...) ->
    super args...
    @isTTY = yes

exec = (args, options = {}) ->
  stdout = new StreamMock
  stderr = new StreamMock

  options.stdout = stdout
  options.stderr = stderr
  options.cwd = __dirname

  command = new Command(options)

  return new Promise (done) ->
    command.run(args).then (status) ->
      done [status, stdout.data, stderr.data]

readFile = (file) ->
  if file[0] isnt '/'
    file = "#{__dirname}/#{file}"

  return fs.readFileSync(file).toString()

tmpFile = -> tmp.fileSync().name

testCommand = (args, options = {}) ->
  expectations =
    status: 0
    stderr: /^$/
    stdout: /^[\s\S]*$/

  for expectation in ['stdout', 'stderr', 'status']
    if options[expectation] isnt undefined
      expectations[expectation] = options[expectation]
      delete options[expectation]

  return new Promise (done, err) ->
    exec(args, options).then (res) ->
      [status, stdout, stderr] = res

      try
        for expected_stdout in [].concat(expectations.stdout)
          if expected_stdout instanceof RegExp
            expect(stdout).to.match expected_stdout
          else
            expect(stdout).to.equal expected_stdout

        for expected_stderr in [].concat(expectations.stderr)
          if expected_stderr instanceof RegExp
            expect(stderr).to.match expected_stderr
          else
            expect(stderr).to.equal expected_stderr

        expect(status).to.equal(expectations.status)
      catch e
        err e

      done res

describe 'CLI', ->
  describe 'The `layla` command', ->

    it 'Compiles lay code from one file', ->
      testCommand '1.lay', stdout: readFile('1.css')

    it 'Compiles lay code from more than one file', ->
      testCommand '1.lay 2.lay', stdout: readFile('1+2.css')

    it "Compiles lay code from stdin when it's not a TTY", ->
      stdin = new StreamMock

      promise = testCommand '', {
        stdin: stdin
        stdout: "body {\n  color: #f00;\n}\n"
      }

      stdin.end 'body{color:red}'

      return promise

    it 'Returns `EX_ERROR_DATAERR` when a `SyntaxError` happens', ->
      testCommand 'syntax-error.lay', {
        status: 65,
        stderr: /SyntaxError/
      }

    it 'Returns `EX_ERROR_DATAERR` when a `RuntimeError` happens', ->
      testCommand 'reference-error.lay', {
        status: 65,
        stderr: /ReferenceError/
      }

    describe 'Options', ->
      describe '`--out-file`', ->
        it 'Sets an output file', ->
          out_file = tmpFile()
          testCommand("1.lay --out-file #{out_file}").then ->
            actual = readFile(out_file)
            expected = readFile '1.css'
            expect(actual).to.equal expected

        it 'Is abbreviated as `-o`', ->
          out_file = tmpFile()
          testCommand("2.lay -o #{out_file}").then ->
            actual = readFile(out_file)
            expected = readFile '2.css'
            expect(actual).to.equal expected

        it 'Can appear between files', ->
          out_file = tmpFile()
          testCommand("1.lay --out-file=#{out_file} 2.lay").then ->
            actual = readFile(out_file)
            expected = readFile '1+2.css'
            expect(actual).to.equal expected

        it 'Overwrites existing files', ->
          out_file = tmpFile()
          testCommand("1.lay -o #{out_file}").then ->
            actual = readFile(out_file)
            expected = readFile '1.css'
            expect(actual).to.equal expected

            testCommand("2.lay -o #{out_file}").then ->
              actual = readFile(out_file)
              expected = readFile '2.css'
              expect(actual).to.equal expected

        do ->
          testIOError = (args, stderr...) ->
            testCommand args, status: 74, stderr: stderr

          it 'Fails if output file is not writable', ->
            out_file = tmpFile()
            fs.chmodSync out_file, 0o444
            testIOError "1.lay -o #{out_file}", /permission denied/

          it 'Fails if output path does not exist', ->
            out_file = tmpFile()
            out_file_basename = path.basename out_file
            out_file += "#{out_file_basename}/#{out_file_basename}.css"
            testIOError "1.lay -o #{out_file}", /directory does not exist/

          it 'Fails if output path is invalid', ->
            # Should fail because first part of path is a regular file,
            # not a dir.
            out_file = tmpFile()
            out_file_basename = path.basename out_file
            out_file += "/#{out_file_basename}"
            testIOError "1.lay -o #{out_file}", /directory does not exist/

      describe '`--interactive`', ->
        prompt = '> '
        env = HOME: __dirname

        testREPL = (args, statements, options = {}) ->
          stdin = new TTYMock

          promise = testCommand args, {
            stdin: stdin
            env: env
            options...
          }

          for statement in statements
            stdin.write(statement + '\n')

          stdin.end ''

          return promise

        it 'Starts a REPL console', ->
          testREPL(
            '--interactive --no-color',
            ['(1cm + 10mm)cm'],
            stdout: "#{prompt}2cm\n#{prompt}\n"
          )

        it 'Can be abbreviated as `-i`', ->
          testREPL(
            '-iC',
            ['(2cm + 10mm)cm'],
            "#{prompt}3cm\n#{prompt}\n"
          )

        it 'Is aliased as `--repl`', ->
          testREPL(
            '-iC',
            ['(3cm + 10mm)cm'],
            "#{prompt}4cm\n#{prompt}\n"
          )

        describe 'History', ->
          it 'Executed statements are logged to a history file', ->
            history_file = "#{__dirname}/#{uuid4()}"
            testREPL("-i --history-file #{history_file}", ['foo=1'])
            expect(readFile(history_file)).to.equal('foo=1\0')

            testREPL("-i --history-file #{history_file}", ['bar=2'])
            expect(readFile(history_file)).to.equal('foo=1\0bar=2\0')

          it 'Empty statements are not logged', ->
            history_file = "#{__dirname}/#{uuid4()}"
            testREPL("-i --history-file #{history_file}", ['', ' '])
            expect(fs.existsSync(history_file)).to.be.false

            testREPL("-i --history-file #{history_file}", ['foo', '', 'bar'])
            expect(fs.existsSync(history_file)).to.be.true
            expect(readFile(history_file)).to.equal('foo\0bar\0')

          describe '--history-file', ->
            it 'Defaults to ~/.layla_history', ->
              history_file = "#{__dirname}/.layla_history"

              if fs.existsSync(history_file)
                fs.unlinkSync(history_file)

              command = "U = '#{uuid4()}'"

              testREPL("-i --history-file #{history_file}", [command])
              expect(fs.existsSync(history_file)).to.be.true
              expect(readFile(history_file)).to.equal("#{command}\0")

          describe '--no-history', ->
            it 'Disables the history', ->
              history_file = "#{__dirname}/#{uuid4()}"

              testREPL(
                "-i --history-file #{history_file} --no-history",
                ['foo']
              )
              expect(fs.existsSync(history_file)).to.be.false

              testREPL(
                "-i --no-history=no --history-file #{history_file}",
                ['foo']
              )
              expect(fs.existsSync(history_file)).to.be.true

          describe '--history', ->
            it 'Enables the history', ->
              history_file = "#{__dirname}/#{uuid4()}"

              testREPL(
                "-i --history=no --history-file #{history_file}",
                ['foo']
              )
              expect(fs.existsSync(history_file)).to.be.false

              testREPL(
                "-i --history-file #{history_file} --no-history --history",
                ['foo']
              )
              expect(fs.existsSync(history_file)).to.be.true

      describe '`--color` and `--no-color', ->
        testColors = (args, options = {}) ->
          default_options = {
            status: 0
            stdout: yes
            stderr: yes
          }

          options = global.Object.assign {}, default_options, options

          if options.stdout is yes
            options.stdout = ANSI_COLOR
          else if options.stdout is no
            options.stdout = NO_ANSI_COLOR

          if options.stderr is yes
            options.stderr = ANSI_COLOR
          else if options.stderr is no
            options.stderr = NO_ANSI_COLOR

          return testCommand args, options

        it 'Force or disable color output', ->
          Promise.all [
            testColors '--color 1.lay', stdout: yes
            testColors '--no-color 1.lay', stdout: no
          ]

        it 'Accept "true", "yes", "y", "1", "on" as trueish values', ->
          Promise.all [
            testColors '--color=true 1.lay', stdout: yes
            testColors '--color=yes 1.lay', stdout: yes
            testColors '--color=YES 1.lay', stdout: yes
            testColors '--color=1 1.lay', stdout: yes
            testColors '--color=y 1.lay', stdout: yes
            testColors '--color=on 1.lay', stdout: yes
            testColors '--no-color=true 1.lay', stdout: no
            testColors '--no-color=yes 1.lay', stdout: no
            testColors '--no-color=YES 1.lay', stdout: no
            testColors '--no-color=1 1.lay', stdout: no
            testColors '--no-color=y 1.lay', stdout: no
            testColors '--no-color=on 1.lay', stdout: no
          ]

        it 'Take any other value as falsy', ->
          Promise.all [
            testColors '--color=tr 1.lay', stdout: no
            testColors '--color=no 1.lay', stdout: no
            testColors '--color=0 1.lay', stdout: no
            testColors '--color=n 1.lay', stdout: no
            testColors '--color=off 1.lay', stdout: no
            testColors '--color=bananas 1.lay', stdout: no
            testColors '--no-color=tr 1.lay', stdout: yes
            testColors '--no-color=no 1.lay', stdout: yes
            testColors '--no-color=0 1.lay', stdout: yes
            testColors '--no-color=n 1.lay', stdout: yes
            testColors '--no-color=off 1.lay', stdout: yes
            testColors '--no-color=bananas 1.lay', stdout: yes
          ]

        it 'Can be abbreviated as `-c` and `-C`', ->
          testColors '-c 1.lay', stdout: yes

        describe 'By default', ->
          it 'Colors are disabled on stdout', ->
            Promise.all [
              testColors '1.lay', {
                stdout: no
                env: {
                  TERM: 'xterm'
                  COLORTERM: 'gnome-terminal'
                }
              }
            ]

          it 'Colors are enabled on stderr when the terminal supports them', ->
            Promise.all [
              testColors 'syntax-error.lay', {
                stderr: no
                status: 65
                env: TERM: 'dumb'
              }
              testColors 'syntax-error.lay', {
                stderr: yes
                status: 65
                env: {
                  TERM: 'xterm'
                  COLORTERM: 'gnome-terminal'
                }
              }
              testColors 'syntax-error.lay', {
                stderr: yes
                status: 65
                env: {
                  CI: '1'
                  TRAVIS: '1'
                }
              }
            ]

          it 'Colors are enabled on REPL stdout if the term supports them', ->
            stdin = new TTYMock

            promise = testCommand '--interactive', {
              stdin: stdin
              stdout: ANSI_COLOR
              env: {
                HOME: __dirname
                TERM: 'xterm'
                COLORTERM: 'gnome-terminal'
              }
            }

            stdin.end '(1cm + 10mm)cm'

            return promise

          it 'Colors are enabled on REPL stderr if the term supports them', ->
            stdin = new TTYMock

            promise = testCommand '--repl', {
              stdin: stdin
              stderr: ANSI_COLOR
              env: {
                HOME: __dirname
                TERM: 'xterm'
                COLORTERM: 'gnome-terminal'
              }
            }

            stdin.end '1cm + 10deg'

            return promise

      describe '`--version`', ->
        testVersion = (args) ->
          testCommand args, {
            stdout: LAYLA_VERSION + os.EOL
          }

        it 'Prints Layla version', ->
          Promise.all [
            testVersion '-v'
            testVersion '--version'
          ]

        it 'Causes all other arguments to be ignored', ->
          Promise.all [
            testVersion '-v 1.lay'
            testVersion '1.lay 2.lay --version'
          ]

      describe '`--help`', ->
        testHelp = (args) ->
          testCommand args, {
            stdout: [/Usage/, /Options/, /Layla/, /layla/]
          }

        it 'Displays usage info', ->
          Promise.all [
            testHelp '-h'
            testHelp '--help'
          ]

        it 'Causes all other arguments to be ignored', ->
          Promise.all [
            testHelp '-h 1.lay'
            testHelp '1.lay 2.lay --help 3.lay'
          ]

      describe '`--no-css`', ->
        it 'Disables loading the `css` plugin', ->
          testCommand '--no-css 2.lay', status: 65, stderr: /ValueError/

      describe 'Unkown options', ->
        testUsageError = (args, err = null) ->
          stderr = [/Usage/]
          stderr.push(err) if err?

          testCommand args, status: 64, stderr: stderr

        it 'Cause errors', ->
          Promise.all [
            testUsageError '-f', /`f`/
            testUsageError '--bananas', /bananas/
          ]
