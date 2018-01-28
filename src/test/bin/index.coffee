os            = require 'os'
path          = require 'path'
fs            = require 'fs'
childProcess  = require 'child_process'
{expect}      = require 'chai'
tmp           = require 'tmp'
LAYLA_VERSION = require '../../lib/version'

exec = (args, options = {}) ->
  bin = fs.realpathSync "#{__dirname}/../../bin/layla"
  args = args.split /\s+/

  options.cwd ?= __dirname

  res = childProcess.spawnSync bin, args, options

  if res.error
    throw res.error

  return {
    status: res.status
    stderr: res.stderr.toString()
    stdout: res.stdout.toString()
  }

describe 'CLI', ->

  describe 'The `layla` command', ->

    it 'Compiles lay code from one file', ->
      {status, stdout, stderr} = exec '1.lay'
      expected = fs.readFileSync("#{__dirname}/1.css").toString()
      expect(status).to.equal 0
      expect(stdout).to.equal expected
      expect(stderr).to.be.empty

    it 'Compiles lay code from more than one file', ->
      {status, stdout, stderr} = exec '1.lay 2.lay'
      expected = fs.readFileSync("#{__dirname}/1+2.css").toString()
      expect(status).to.equal 0
      expect(stdout).to.equal expected
      expect(stderr).to.be.empty

    it 'Returns `EX_ERROR_DATAERR` when a `SyntaxError` happens', ->
      {status, stdout, stderr} = exec 'syntax-error.lay'
      expect(status).to.equal 65
      expect(stderr).to.contain 'SyntaxError'


    it 'Returns `EX_ERROR_DATAERR` when a `RuntimeError` happens', ->
      {status, stdout, stderr} = exec 'reference-error.lay'
      expect(status).to.equal 65
      expect(stderr).to.contain 'ReferenceError'

    describe 'Options', ->

      describe '`--out-file`, `-o`', ->

        it 'Sets an output file', ->
          out_file = tmp.fileSync().name
          {status, stdout, stderr} = exec "1.lay -o #{out_file}"
          actual = fs.readFileSync(out_file).toString()
          expected = fs.readFileSync("#{__dirname}/1.css").toString()
          expect(status).to.equal 0
          expect(stdout).to.be.empty
          expect(stderr).to.be.empty
          expect(actual).to.equal expected

          out_file = tmp.fileSync().name
          {status, stdout, stderr} = exec "2.lay --out-file #{out_file}"
          actual = fs.readFileSync(out_file).toString()
          expected = fs.readFileSync("#{__dirname}/2.css").toString()
          expect(status).to.equal 0
          expect(stdout).to.be.empty
          expect(stderr).to.be.empty
          expect(actual).to.equal expected

          out_file = tmp.fileSync().name
          {status, stdout, stderr} = exec "1.lay --out-file=#{out_file} 2.lay"
          actual = fs.readFileSync(out_file).toString()
          expected = fs.readFileSync("#{__dirname}/1+2.css").toString()
          expect(status).to.equal 0
          expect(stdout).to.be.empty
          expect(stderr).to.be.empty
          expect(actual).to.equal expected

        it 'Overwrites existing files', ->
          out_file = tmp.fileSync().name

          {status, stdout, stderr} = exec "1.lay -o #{out_file}"
          actual = fs.readFileSync(out_file).toString()
          expected = fs.readFileSync("#{__dirname}/1.css").toString()
          expect(status).to.equal 0
          expect(stdout).to.be.empty
          expect(stderr).to.be.empty
          expect(actual).to.equal expected

          out_file = tmp.fileSync().name
          {status, stdout, stderr} = exec "2.lay -o #{out_file}"
          actual = fs.readFileSync(out_file).toString()
          expected = fs.readFileSync("#{__dirname}/2.css").toString()
          expect(status).to.equal 0
          expect(stdout).to.be.empty
          expect(stderr).to.be.empty
          expect(actual).to.equal expected

        it 'Fails if output file is not writable', ->
          out_file = tmp.fileSync().name
          out_file_basename = path.basename out_file
          out_file = "#{out_file}#{out_file_basename}/#{out_file_basename}.css"
          {status, stdout, stderr} = exec "1.lay -o #{out_file}"
          expect(status).to.equal 74
          expect(stdout).to.be.empty
          expect(stderr).to.contain out_file
          expect(stderr).to.contain 'directory does not exist'

          # Should fail because first part of path is a regular file, not a dir.
          out_file = tmp.fileSync().name
          out_file = "#{out_file}/#{out_file_basename}"
          {status, stdout, stderr} = exec "1.lay -o #{out_file}"
          expect(status).to.equal 74
          expect(stdout).to.be.empty
          expect(stderr).to.contain out_file
          expect(stderr).to.contain 'directory does not exist'

          out_file = tmp.fileSync().name
          fs.chmodSync out_file, 0o444

          {status, stdout, stderr} = exec "1.lay -o #{out_file}"
          expect(status).to.equal 74
          expect(stdout).to.be.empty
          expect(stderr).to.contain out_file
          expect(stderr).to.contain 'permission denied'

      describe '`--version`', ->

        testVersion = (args) ->
          expected = LAYLA_VERSION + os.EOL
          {status, stdout, stderr} = exec args
          expect(status).to.equal 0
          expect(stdout).to.equal expected
          expect(stderr).to.be.empty

        it 'Prints Layla version', ->
          testVersion '-v'
          testVersion '--version'

        it 'Causes all other arguments to be ignored', ->
          testVersion '-v 1.lay'
          testVersion '1.lay 2.lay --version'

      describe '`--help`', ->

        testHelp = (args) ->
          {status, stdout, stderr} = exec args
          expect(status).to.equal 0
          expect(stdout).to.contain 'Usage'
          expect(stdout).to.contain 'Options'
          expect(stdout).to.contain 'Layla'
          expect(stdout).to.contain 'layla'
          expect(stderr).to.be.empty

        it 'Displays usage info', ->
          testHelp '-h'
          testHelp '--help'

        it 'Causes all other arguments to be ignored', ->
          testHelp '-h 1.lay'
          testHelp '1.lay 2.lay --help 3.lay'

      describe 'Unkown options', ->

        testUsageError = (args, err = null) ->
          {status, stdout, stderr} = exec args
          expect(status).to.equal 64
          expect(stderr).to.contain 'Usage'
          if err?
            expect(stderr).to.contain err
          expect(stdout).to.be.empty

        it 'Cause errors', ->
          testUsageError '-f', '`f`'
