os            = require 'os'
fs            = require 'fs'
Path          = require 'path'
readline      = require 'readline'
colorSupport  = require 'color-support'

Layla         = require '../lib'
CSSPlugin     = require '../css'
CSSNormalizer = require '../css/normalizer'
ProgramError  = require '../lib/error/program'
EOTError      = require '../lib/error/eot'
UsageError    = require './error/usage'
IOError       = require './error/io'
CLIContext    = require './context'
CLIEmitter    = require './emitter'
Args          = require './args'
VERSION       = require './version'


###
###
class Command

  USAGE = """
  Usage:
    layla [options] [file...]

  Options:
    -u, --use <plugin>...       Use one or more plugins
    -o, --out-file <file>       Write compiled code to a file instead of stdout
    -i, --interactive           Start an interactive console
        --history               Enable history (default)
        --no-history            Disable history
    -H, --history-file <file>   Set custom history file path. Defaults to
                                `~/.layla_history`
    -c, --color                 Force colors on the output
    -C, --no-color              Disable colors on the output
    -v, --version               Print out Layla version
    -h, --help                  Show this help
  """

  # Exit codes from http://www.gsp.com/cgi-bin/man.cgi?section=3&topic=sysexits
  EX_OK              = 0
  EX_ERROR_GENERAL   = 1  # Not currently used
  EX_ERROR_USAGE     = 64
  EX_ERROR_DATAERR   = 65
  EX_ERROR_SOFTWARE  = 70 # TODO Ensure it's used on any uncaught error
  EX_ERROR_IOERR     = 74

  HISTORY_SEPARATOR = '\0'

  constructor: (options = {}) ->
    @options = @getOptions options

  promise: (func) -> new Promise func

  run: (argv = []) ->
    @promise (exit) =>
      try
        options = @options

        if typeof argv is 'string'
          argv = argv.trim().split /^|\s+/

        [argv_options, files] = @parseArgv argv
        options = @getOptions options, argv_options

        if options.help
          @help options
          exit EX_OK
        else if options.version
          @version options
          exit EX_OK
        else
          unless options.no_css
            options.context.use new CSSPlugin

          for plugin in options.plugins
            options.context.use plugin

          if files.length
            for file in files
              # TODO Throw proper exception if file is not readable
              # BUT.... I'm using `context.include` right now. It will throw its
              # own exceptions, but will also allow us to incude non-local
              # files! :)
              # ie: `layla -use http-loader http://foo.com/file.lay > file.css
              file = Path.resolve options.cwd, file
              options.context.include file

          if options.interactive
            @repl(options).then -> exit EX_OK
          else if files.length
            @emit options.context.block, options
            exit EX_OK
          else if @options.stdin.isTTY
            @usage options
            exit EX_ERROR_USAGE
          else
            source = ''

            options.stdin.resume()
            options.stdin.setEncoding options.charset

            options.stdin.on 'data', (chunk) ->
              source += chunk

            options.stdin.on 'end', =>
              options.context.evaluate source
              @emit options.context.block, options
              exit EX_OK
      catch e
        message = "[#{e.constructor.name}] #{e.message}" + options.eol

        if e instanceof UsageError
          @warning message, options
          @usage options
          exit EX_ERROR_USAGE
        else
          @error message, options

          if e instanceof ProgramError
            status = EX_ERROR_DATAERR
          else if e instanceof IOError
            status = EX_ERROR_IOERR
          else
            status = EX_ERROR_SOFTWARE

          exit status

  usage: (options = @options) ->
    @stderr USAGE + options.eol, options

  help: (options = @options) ->
    @stdout USAGE + options.eol, options

  version: (options = @options) ->
    @stdout VERSION + options.eol

  repl: (options = @options) ->
    @promise (exit) =>
      buffer = ''

      repl = readline.createInterface {
        input: options.stdin
        output: options.stdout
      }

      if options.history
        repl.history = @readHistory(options)

      reset = ->
        buffer = ''
        repl.setPrompt '> '
        repl.prompt()

      # Clear screen with `^L`
      handleCls = (seq) =>
        if seq is '\f'
          repl.clearLine()
          @stdout '\u001B[2J\u001B[0;0f', options
          reset()

      options.stdin.on 'keypress', handleCls

      repl.on 'line', (text) =>
        if (buffer + text).trim() is ''
          reset()
        else
          if buffer isnt ''
            text = "#{buffer}\n#{text}"

          try
            # TODO Set a filename
            res = options.context.evaluate text
            @emit res, options
            @stdout options.eol, options
            reset()
          catch e
            if e instanceof ProgramError
              if e instanceof EOTError
                buffer = text
                repl.setPrompt '| '
                repl.prompt()
                return

              msg = e.toString()

              if e.line? and e.column?
                msg += ' @ ' + e.line + ':' + e.column

              @error msg, options
              @stderr options.eol, options
              reset()
            else
              throw e

          if options.history
            @writeHistory text, options

      repl.on 'close', =>
        options.stdin.removeListener 'keypress', handleCls
        @stdout options.eol, options
        exit()

      # Discard line on `^C`
      repl.on 'SIGINT', =>
        @stdout options.eol, options
        repl.write null, ctrl: yes, name: 'u' # Clears current line
        reset()

      reset()

  emit: (node, options = @options) ->
    normalizer = new CSSNormalizer

    node = normalizer.normalize node

    emitter = new CLIEmitter {
      colors: options.stdout_color
      charset: options.charset
    }

    res = emitter.emit node

    if options.out_file
      try
        out_file = Path.resolve options.cwd, options.out_file
        fs.writeFileSync out_file, res
      catch e
        switch e.code
          when 'EACCES'
            cause = 'permission denied'
          when 'ENOTDIR', 'ENOENT'
            cause = 'directory does not exist'
          when undefined
            cause = null
          else
            cause = "got an `#{e.code}` error while trying to write file"

        message = "Could not write to `#{out_file}`"
        message += ": #{cause}" if cause
        message += '.'

        throw new IOError message
    else
      @stdout res, options

  getHistoryFile: (options = @options) ->
    history_file = (options.history_file or '').trim()

    if history_file[0] is '~'
      home = options.env.HOME

      if home
        history_file = home + history_file[1..]

    return history_file

  readHistory: (options = @options) ->
    history_file = @getHistoryFile options

    if history_file
      if fs.existsSync history_file
        # TODO handle IO errors
        history = fs.readFileSync(history_file).toString()

        history = history
          .replace(///(#{HISTORY_SEPARATOR})+$///, '')
          .split(///(#{HISTORY_SEPARATOR})+///)
          .reverse()

        return history

    return []

  writeHistory: (text, options = @options) ->
    history_file = @getHistoryFile options

    if history_file
      if not fs.existsSync history_file
        fs.writeFileSync history_file, '' # TODO Set permission

      fs.appendFileSync history_file, text + HISTORY_SEPARATOR

  stdout: (text = '', options = @options) ->
    options.stdout.write text

  stderr: (text = '', options = @options) ->
    options.stderr.write text

  error: (text, options = @options) ->
    text = "\x1b[31m#{text}\x1b[0m" if options.stderr_color
    @stderr text, options

  warning: (text, options = @options) ->
    text = "\x1b[33m#{text}\x1b[0m" if options.stderr_color
    @stderr text, options

  parseArgv: (argv) ->
    files = []

    options =
      plugins: []

    args = new Args argv

    loop
      if opt = args.getOpt()
        switch opt.name
          when 'h', 'help'
            # Show usage and exit
            options.help = opt.bool()
          when 'v', 'version'
            # Print version and exit
            options.version = opt.bool()
          when 'c', 'color'
            # Enable or disable colors
            options.color = opt.bool()
          when 'C', 'no-color'
            # Disable colors
            options.color = not opt.bool()
          when 'ascii', 'utf8'
            options.charset = opt.name
          when 'i', 'interactive', 'repl'
            # Set interactive mode
            options.interactive = opt.bool()
          when 'history'
            # Enable  history file
            options.history = opt.bool()
          when 'no-history'
            # Disable history file
            options.history = not opt.bool()
          when 'history-file'
            # Set history file path
            if opt.value
              path = opt
            else
              path = args.getArg()

            if path
              options.history_file = path.value.trim()
            else
              throw new UsageError """
                Expected file name after `--history-file` option
                """
          when 'o', 'out-file'
            if opt.value
              file = opt
            else
              file = args.getArg()

            if file
              options.out_file = file.value.trim()
            else
              throw new UsageError """
                Expected file name after `--out-file` option
                """
          when 'no-css'
            # Do *not* use the CSS plugin
            options.no_css = opt.bool()
          when 'u', 'use'
            # Use one or more plugins
            if opt.value
              plugin = opt.value.trim()
            else
              plugin = args.getArg()

            unless plugin
              throw new UsageError "Expected plugin name after `--use` option"

            options.plugins.push plugin
          else
            throw new UsageError "Unknown option: `#{opt.name}`"
      else if arg = args.getArg()
        files.push arg.value
      else
        break

    return [options, files]


  mergeOptions: (options...) ->
    merged_options = {
      plugins: []
      env: {}
    }

    for opts in options
      for key of opts
        switch key
          when 'plugins'
            merged_options.plugins.push opts.plugins...
          else
            unless opts[key] is undefined
              merged_options[key] = opts[key]

    return merged_options

  getOptions: (options...) ->
    defaults =
      eol:          os.EOL
      charset:      'utf8'
      env:          {}
      context:      new CLIContext
      history:      yes
      history_file: '~/.layla_history'
      color:        null
      cwd:          ''
      no_css:       no

    options = @mergeOptions defaults, options...

    if options.color?
      options.stderr_color = options.color
      options.stdout_color = options.color
    else
      supports_color = colorSupport {
        env: options.env
        stream: options.stdin
        ignoreTTY: yes
      }

      options.stdout_color = options.interactive and supports_color
      options.stderr_color = supports_color

    return options


module.exports = Command
