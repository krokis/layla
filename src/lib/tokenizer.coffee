Class       = require './class'
T = Token   = require './token'
Location    = require './location'
SyntaxError = require './error/syntax'
EOTError    = require './error/eot'

###
###
class Tokenizer extends Class

  PUNCTUATION =
    '...': T.ELLIPSIS
    '~=' : T.TILDE_EQUAL
    '^=' : T.CARET_EQUAL
    '$=' : T.DOLLAR_EQUAL
    '*=' : T.ASTERISK_EQUAL
    '<=' : T.LT_EQUAL
    '>=' : T.GT_EQUAL
    '|=' : T.PIPE_EQUAL
    '>>' : T.PUSH_RIGHT
    '<<' : T.PUSH_LEFT
    '::' : T.DOUBLE_COLON
    '..' : T.DOUBLE_DOT
    '='  : T.EQUAL
    '.'  : T.DOT
    '*'  : T.ASTERISK
    '/'  : T.SLASH
    '+'  : T.PLUS
    '-'  : T.MINUS
    '<'  : T.LT
    '>'  : T.GT
    '~'  : T.TILDE
    ','  : T.COMMA
    '|'  : T.PIPE
    ':'  : T.COLON
    '|:' : T.PIPE_COLON
    '@'  : T.AT_SYMBOL
    '&'  : T.AMPERSAND
    '%'  : T.PERCENT
    ';'  : T.SEMICOLON
    '('  : T.PAREN_OPEN
    ')'  : T.PAREN_CLOSE
    '{'  : T.CURLY_OPEN
    '}'  : T.CURLY_CLOSE
    '['  : T.BRACKET_OPEN
    ']'  : T.BRACKET_CLOSE

  RE_HEX_DIGIT      = /[0-9a-fA-F]/
  RE_COLOR          = ///(#{RE_HEX_DIGIT.source})+///
  RE_BREAK          = /\r\n?|\n/
  RE_NON_ASCII      = /[^\x00-\x80]/
  RE_IDENT_START    = ///^(
                        ([\!\$])?(-+|_+)?)
                        (?=[a-zA-Z\\]|(#{RE_NON_ASCII.source})|(\#\{)
                      )///
  RE_IDENT_CHAR     = ///([a-zA-Z\d_\-\\])|(#{RE_NON_ASCII.source})///
  RE_IDENT_END      = /^[\!\?]+/
  RE_PUNC           = ///^
                        (::|\|?:|\.{1,3}|\(|\)|\{|\}|\[|\]|\&|@|;|%|
                        \,|[\|\$~*^]?=|~|\*|\/|
                        \||>>|<<|>=|>|<=|<|
                        ([\+\-](?!#{RE_IDENT_START.source})))
                      ///
  RE_NUMBER         = ///
                        ^((?:\d*\.)?\d+)
                        (%|(([a-z]|#{RE_NON_ASCII.source})+))?
                      ///i
  RE_REGEXP         = /^\/([^\s](?:(?:\\.)|[^\\\/\n\r])+)\/([a-z]+)?/i
  RE_UNICODE_RANGE  = /^u\+[0-9a-f?]{1,6}(-[0-9a-f?]{1,6})?/i
  RE_H_WHITESPACE   = ///^(
                        ([\x20\t]+)| # Non breaking whitespace or
                        (\/\*(#{RE_BREAK.source}|.)*?\*\/)| # embedded comment
                        (\/\/.*(?=(#{RE_BREAK.source})|$)) # or line comment
                      )+///
  RE_V_WHITESPACE   = ///^(#{RE_BREAK.source})///
  RE_WHITESPACE     = /^(\r\n|[\x20\n\r\t\f])+/

  ###
  Return current location, which includes file, line and column information.
  ###
  @property 'location',
    get: -> new Location @file, @line, @column

  ###
  Prepare internals for tokenizing.
  ###
  prepare: (source = '', @file = '<unknown>') ->
    @buffer = source
    @length = source.length
    @line = 0
    @column = 0
    @position = 0
    @move 0

  syntaxError: (msg) ->
    if @isEndOfFile()
      unexpected = 'end of file'
      Err = EOTError
    else
      unexpected = "`#{@char}`"
      Err = SyntaxError

    message = "Unexpected #{unexpected}"

    if msg
      message += '. ' + msg

    throw new Err message, @location

  ###
  Move cursor by `n` characters. You *cannot* move backwards.
  ###
  move: (n = 1) ->
    @position += n
    lines = @buffer[0...n].split RE_BREAK
    @line += (lines.length - 1)

    if lines.length > 1
      @column = lines.pop().length
    else
      @column += n

    @buffer = @buffer[n..]
    @char = @buffer[0] || ''

  ###
  ###
  isEndOfFile: -> @position >= @length

  ###
  ###
  match: (reg) ->
    if m = reg.exec @buffer
      m.start = @location
      @move m[0].length
      m.end = @location
      m.value = m[0]

      return m

  ###
  Try to read any of the `PUNCTUATION` tokens.
  ###
  readPunctuation: ->
    if m = @match RE_PUNC
      return new Token PUNCTUATION[m.value], m.start, m.end, m.value

  ###
  Try to read a literal number, with optional units.
  ###
  readNumber: ->
    if m = @match RE_NUMBER
      num = new Token T.NUMBER, m.start, m.end, m[1]
      num.unit = m[2] or null

      return num

  ###
  Read a 'hash ident', which might be interpreted as a literal color or
  as a CSS id selector.
  ###
  readHash: ->
    if @char is '#'
      hash = new Token T.HASH, @location
      @move()
      hash.isIdent = RE_IDENT_START.test @buffer
      hash.value = @readSequence RE_IDENT_CHAR

      unless hash.value
        @syntaxError "Expected ident or hex color"

      hash.end = @location
      hash.isColor = RE_COLOR.test hash.value

      return hash

  ###
  ###
  readEscape: ->
    val = ''

    @move()

    switch @char
      when 'n'
        val = '\n'
      when 'r'
        val = '\r'
      when 't'
        val = '\t'
      when 'v'
        val = '\v'
      when '"', "'", '\\'
        val = @char
      when '\n' # TODO what about other line endings?
        val = ''
      when undefined # end of text
        @syntaxError 'Unterminated escape'
      else
        code = ''
        while 7 > code.length && @char.match RE_HEX_DIGIT
          code += @char
          @move()

        if code.length > 0
          # After an escaped code point, if next char is whitespace, it must
          # be eaten
          # https://www.w3.org/TR/css-syntax-3/#consume-an-escaped-code-point
          @move() if @char.match RE_WHITESPACE
          code = parseInt code, 16
          return global.String.fromCharCode code
        else
          val = @char

    @move()

    return val

  ###
  ###
  readSequence: (chars, prefix, suffix) ->
    buffer = ''
    pieces = []

    if prefix and m = @buffer.match(prefix)
      buffer = m[0]
      @move m[0].length

    loop
      while @char is '\\'
        buffer += @readEscape()

      if @buffer[0..1] is '#{'
        # Start interpolation
        if buffer isnt ''
          pieces.push buffer
          buffer = ''

        @move()
        tokens = []
        token = null
        braces = [@readPunctuation()]

        while token = @readToken(token)
          switch token.kind
            when T.PAREN_OPEN, T.CURLY_OPEN
              braces.push token

            when T.PAREN_CLOSE
              if braces[braces.length - 1].is T.PAREN_OPEN
                braces.pop()
              else if braces.length is 0
                # TODO ???? Should it throw?
                break
              # TODO else??

            when T.CURLY_CLOSE
              if braces[braces.length - 1].is T.CURLY_OPEN
                braces.pop()
              # TODO else??

          if braces.length is 0
            eof = new Token T.EOF, token.start, token.start

            # Ugly TODO
            if l = tokens.length
              last = tokens[l - 1]
              last.next = eof

            tokens.push eof
            break

          tokens.push token

        pieces.push tokens

      else if not @char.match chars
        break

      else
        buffer += @char
        @move()

    if suffix and (m = @buffer.match(suffix))
      buffer += m[0]
      @move m[0].length

    if buffer isnt ''
      pieces.push buffer

    # TODO :S
    switch pieces.length
      when 0
        return ''
      when 1
        if typeof pieces[0] is 'string'
          return pieces[0]

    return pieces

  ###
  ###
  readUnquotedString: ->
    if @buffer.match RE_IDENT_START
      str = new Token T.UNQUOTED_STRING, @location
      str.value = @readSequence RE_IDENT_CHAR, RE_IDENT_START, RE_IDENT_END
      str.end = @location

      return str

  ###
  ###
  readQuotedString: ->
    if @char in ['"',"'", '`']
      str = new Token T.QUOTED_STRING, @location
      str.quote = @char

      @move()

      str.value = @readSequence ///[^#{str.quote}]///

      if @isEndOfFile()
        @syntaxError "Unterminated string"

      @move() # Skip closing quote
      str.end = @location

      return str

  ###
  ###
  readRegExp: ->
    if m = @match RE_REGEXP
      regexp = new Token T.REGEXP, m.start, m.end
      regexp.value = m[1]
      regexp.flags = m[2]
      return regexp

  ###
  ###
  readUnicodeRange: ->
    if m = @match RE_UNICODE_RANGE
      return new Token T.UNICODE_RANGE, m.start, m.end, m.value

  ###
  Read the virtual 'End of file' token.

  TODO: add a null '\0' character at the end of the file and look for it?
  A '\0' in the middle of a source code could break it, but people **should
  not** do that, and it could be a mostly useless hidden feature.
  ###
  readEOF: ->
    if @position is @length
      @position++ # TODO :S
      return new Token T.EOF, @location, @location

  ###
  Try to read horizontal (non-breaking) whitespace, including embedded and
  line comments.
  ###
  readHorizontalWhitespace: ->
    if m = @match RE_H_WHITESPACE
      return new Token T.H_WHITESPACE, m.start, m.end, m.value

  ###
  Try to read vertical (breaking) whitespace.
  ###
  readVerticalWhitespace: ->
    if m = @match RE_V_WHITESPACE
      return new Token T.V_WHITESPACE, m.start, m.end, m.value

  ###
  Try to read horizontal (non-breaking) or vertical (breaking) whitespace,
  including any kind of comment.
  ###
  readWhitespace: ->
    @readHorizontalWhitespace() or
    @readVerticalWhitespace()

  ###
  ###
  skipAllWhitespace: -> @match RE_WHITESPACE

  ###
  TODO Should this be case-insensitive?
  ###
  readURL: ->
    # TODO toLowerCase() will fail if we're at last position.
    if 'url(' is @buffer[0..3].toLowerCase()
      url = new Token T.URL, @location
      @move 4
      @skipAllWhitespace()

      if str = @readQuotedString()
        url.value = str.value
      else
        url.value = @readSequence /[^\)]/

      @skipAllWhitespace()

      unless @char is ')'
        @syntaxError 'Unterminated url()'

      @move()
      return url

  readCallArguments: ->
    args = []

    loop
      str = @readQuotedString()

      if not str
        start = @location
        value = @readSequence /[^,\)]/

        if value
          str = new Token T.RAW_STRING, start
          str.value = value
          str.end = @location

      if not str
        break

      args.push str

      @skipAllWhitespace()

      if @char is ','
        @move()
        @skipAllWhitespace()

    return args

  ###
  ###
  readCall: ->
    if m = @match /^(url-prefix|url|domain|regexp)\(/i
      call = new Token T.CALL, m.start
      call.name = m[1]
      @skipAllWhitespace()

      switch call.name.toLowerCase()
        when 'url', 'url-prefix'
          uri = @readQuotedString()

          if not uri
            uri = new Token T.RAW_STRING, @location
            value = @readSequence /[^\)]/
            uri.value = value

          call.arguments = [uri]
        else
          call.arguments = @readCallArguments()

      @skipAllWhitespace()

      unless @char is ')'
        @syntaxError "Expected `)`"

      @move()

      return call

  ###
  ###
  readBOM: ->
    if @position is 0 and @char is '\uFEFF'
      @move()
      return new Token T.BOM, 0, 1, @char

  ###
  Try to read any kind of token (except BOM), starting at current position. The
  order in which these readers are called is essential.
  ###
  readToken: (prev) ->
    token = @readWhitespace() or
            @readNumber() or
            @readQuotedString() or
            @readRegExp()

    if not token and not (prev?.kind in [T.DOT, T.DOUBLE_COLON])
      token = @readCall()

    if not token
      token = @readUnicodeRange() or
              @readUnquotedString() or
              @readPunctuation() or
              @readHash() or
              @readEOF()

    if token and prev
      prev.next = token

    return token

  ###
  ###
  tokenize: (source, file) ->
    @prepare source, file

    tokens = []

    if token = @readBOM()
      tokens.push token

    while token = @readToken(token)
      tokens.push token

    unless @isEndOfFile()
      @syntaxError "Unrecognized syntax"

    return tokens

module.exports = Tokenizer
