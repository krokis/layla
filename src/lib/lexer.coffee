Class         = require './class'
Token         = require './token'
SyntaxError   = require './error/syntax'
InternalError = require './error/internal'

{
  PUNC
  UNARY_OPERATOR
  BINARY_OPERATOR
  IDENT
  UNIT
  AT_IDENT
  STRING
  SELECTOR
  SIMPLE_SELECTOR
  COMBINATOR
  NUMBER
  COLOR
  REGEXP
  WHITESPACE
} = Token

###
###
class Lexer extends Class

  RE_IDENT                 = /([\!\?\_\-\$]+)?[a-z][a-z\d\!\?\_\-]*/i
  RE_NUMBER                = /(?:\d*\.)?\d+/i
  RE_UNIT                  = /(%|(?:[a-z]+))/i
  RE_REGEXP                = /\/([^\s](?:(?:\\.)|[^\\\/\n\r])+)\/([a-z]+)?/i
  RE_COLOR                 = /#([a-f\d]{1,2}){1,4}/i
  RE_PUNCTUATION           = /[\{\}\(\),;:=&"'`\|]/
  RE_ALL_WHITESPACE        = /\s+/
  RE_HORIZONTAL_WHITESPACE = /[ \t]+/
  RE_TRAILING_WHITESPACE   = /[ \t]*(\n|$)/
  RE_UNARY_OPERATOR        = /\-|\+|not/
  RE_BINARY_OPERATOR       = ///
                             (::|\.\.|\.|\()|(([\t\ ]*)
                             (\,|\|?=|~|\*|\/|
                             (?:[\+\-]
                             (?!(?:\d|(?:(?:[\!\?\_\-\$]+)?
                             [a-z]))))
                             |>>|<<|>=|>|<=|<|
                             and|or|is-a|is-an|isnt-a|isnt-an|isnt|is|in|hasnt|
                             has|if|unless))
                             |([\t\ ]+)
                             ///
  RE_ID_SELECTOR           = /#[a-z][a-z\d_-]*/i
  RE_CLASS_SELECTOR        = /\.[a-z][a-z\d_-]*/i
  RE_ELEMENTAL_SELECTOR    = ///
                             ((([a-z]+)|(\*))?\|)? # Namespace?
                             (
                               \*                  # Universal selector
                               |                   # or
                               &                   # Parent selector
                               |                   # or
                               ([a-z][a-z\d_-]*)   # Type selector
                             )
                             ///i
  RE_ATTRIBUTE_NAME        = /((([a-z]+)|(\*))?\|)?([a-z]+\|)?[a-z][a-z\d_-]*/i
  RE_ATTRIBUTE_OPERATOR    = /[\~\^\$\*\|]?=/i
  RE_COMBINATOR            = /\>|\~|\+/i

  constructor: ->
    @prepare()

  prepare: (source = '') ->
    # Remove UTF-8 BOM.
    if '\uFEFF' is source.charAt 0
      source = source.substr 1

    # Normalize line endings. Consecutive breaks will be ignored, so, instead of
    # removing `\r`, I'll just replace them with '\n' so positions on source
    # will be still valid.
    source = source.replace /\r/g, '\n'

    # Remove escaped new lines. This breaks locations, so TODO be fixed later or
    # something.
    source = source.replace /\\(\\\\)+\n/, ''

    @source = source

    # Cache source length value.
    @length = source.length

    # This will also initialize `@char`.
    @moveTo @position = 0

  ###
  ###
  isEndOfText: ->
    @position >= @length

  ###
  ###
  isStartOfLine: ->
    @position is 0 or @source[@position - 1] is '\n'

  ###
  Returns `yes` if there's nothing but horizontal whitespace (`[\n\t ]` between
  current character and the end of the line.
  ###
  isEndOfLine: ->
    !!(@match RE_TRAILING_WHITESPACE)

  ###
  Skip all whitespace, including new lines.
  ###
  skipWhitespace: ->
    if match = @match RE_ALL_WHITESPACE
      @move match[0].length
      match[0]

  skipSpaces: ->
    if match = @match /[ \t]/
      @move match[0].length
      match[0]

  ###
  ###
  chars: (length, start = @position) ->
    @source.substr start, length

  ###
  Find the `boundary` expression starting from current position and return the
  slice of source til that boundary or the end of text, whatever comes first.
  ###
  charsUntil: (boundary) ->
    i = @position + 1

    while ++i < @length
      break if (boundary.indexOf @source[i]) >= 0

    @source.substring @position, i

  ###
  Advance until a character that matches `boundary` or the end of the document
  is found.
  ###
  skipCharsUntil: (boundary) ->
    chars = @charsUntil boundary
    @move chars.length
    chars

  ###
  Matches remaining slice of source against a regular `expression` and returns
  the match or `null` if there's no match.
  ###
  match: (expression, offset = 0) ->
    matches = (@source.substring @position + offset).match expression
    if matches?.index is 0 then matches else null

  ###
  ###
  moveTo: (position) ->
    unless 0 <= position <= @length
      throw new InternalError "Cannot move to position #{position}"

    @position = position
    @char = if position < @length then @source[position] else null
    return #undefined

  ###
  Move `n` positions.
  ###
  move: (n = 1) ->
    @moveTo @position + n

  ###
  Token maker.
  ###
  makeToken: (type, func) ->
    token = new Token type
    start = token.start = @position # Might be wasted...

    if func
      # If the callback returns a boolean `no`, then this function does not
      # return a token, but `undefined`.
      try
        if no is (func.call this, token)
          @moveTo start
          return
      catch e
        throw e

    # Hey, a token must be at least 1 character long
    @move() if @position is token.start
    token.end ?= @position
    token.value ?= @source.substring token.start, token.end

    token

  ###
  ###
  readLineComment: ->
    if '//' is @chars 2
      @makeToken LINE_COMMENT, -> @skipCharsUntil '\n'

  ###
  ###
  readBlockComment: ->
    if '/*' is @chars 2
      @makeToken BLOCK_COMMENT, ->
        end = @source.indexOf '*/', (@position + 2)
        throw new SyntaxError 'Unterminated /* block comment */' if end < 0
        @move 2

  ###
  TODO: Interpolation
  ###
  readStringContent: (boundary) ->
    value = ''

    while @char isnt boundary
      if @isEndOfText()
        throw new SyntaxError "Text termined before boundary ('#{boundary}')"

      if @char is '\\'

        if @isEndOfText()
          throw new SyntaxError (
            "Unexpected end of text before boundary ('#{boundary}')"
          )
        @move()

        switch @char
          when 'n'
            value += '\n'
          when 'r'
            value += '\r'
          when 't'
            value += '\t'
          else
            value += ('\\' + @char)

      else
        value += @char
      @move()

    value

  ###
  TODO: Interpolation
  ###
  readName: (offset = 0) ->
    if match = @match RE_IDENT, offset
      name = match[0]

  ###
  ###
  readIdent: ->
    if (name = @readName())?
      @makeToken IDENT, -> @move name.length

  ###
  At-idents may have interpolation too, but they have to start with an `@`.
  ###
  readAtIdent: ->
    if @char is '@'
      name = @readName 1
      if name is undefined
        throw new SyntaxError "Unfinished at-ident"
      else
        @makeToken AT_IDENT, -> @move name.length + 1 # Skip `@` and name
  ###
  ###
  readPunc: ->
    if match = @match RE_PUNCTUATION
      @makeToken PUNC, -> @move match[0].length

  ###
  TODO Refactor this
  ###
  readBinaryOperator: ->
    if match = @match RE_BINARY_OPERATOR
      @move match[3].length if match[3]?

      @makeToken BINARY_OPERATOR, (op) ->
        if match[1]?
          @move match[1].length
        else if match[4]?
          if match[4] is '/' and @match RE_REGEXP
            if match[3]?
              op.start = @position - match[3].length
              op.value = ' '
            else
              return no
          else
            @move match[4].length
        else
          op.value = ' '
          @move match[5].length

  ###
  ###
  readUnaryOperator: ->
    if op = @match RE_UNARY_OPERATOR
      @makeToken UNARY_OPERATOR, -> @move op[0].length

  readUnit: ->
    if @char is '`'
      @readString()
    else if match = @match RE_UNIT
      @makeToken UNIT, -> @move match[0].length

  ###
  ###
  readNumber: ->
    if match = @match RE_NUMBER
      @makeToken NUMBER, (number) ->
        @move match[0].length
        number.value = match[0]
        number.unit = (@read UNIT, null, no) or null

  ###
  ###
  readString: ->
    if @char in ['"', "'", '`']
      quote = @char
      @makeToken STRING, (str) ->
        str.quote = quote
        @move()
        str.value = @readStringContent quote
        @move()

  ###
  ###
  readHexColor: ->
    if match = @match RE_COLOR
      @makeToken COLOR, -> @move match[0].length

  ###
  ###
  readColor: ->
    @readHexColor()

  ###
  /regular expression/options
  ###
  readRegExp: ->
    if match = @match RE_REGEXP
      @makeToken REGEXP, (reg) ->
        reg.value = match[1]
        reg.flags = match[2]
        @move match[0].length

  readAtRuleProperty: ->
    start = @position
    if id = @peek IDENT
      @moveTo id.end
      if sc = @read PUNC, ':'
        if val = @readAtRuleIdent() or @readAtRuleString() or (@read NUMBER)
          return yes
        else
          throw new SyntaxError ":( #{@position}"
    @moveTo start
    return

  readAtRuleGroup: ->
    if tok = @peek PUNC, '('
      @makeToken IDENT, (group) ->
        group.start = tok.start
        @moveTo tok.end
        loop
          break unless arg = @readAtRuleArgument()
        @expect PUNC, ')'

  readAtRuleString: -> @read STRING

  readAtRuleIdent: -> @read IDENT

  readAtRuleFunction: ->
    if name = @peek IDENT
      @makeToken IDENT, (fun) ->
        @moveTo name.end
        if @eat PUNC, '(', no
          parens = 1
          while parens
            if @isEndOfText()
              throw new SyntaxError "Unterminated at-rule function call"
            if @char is ')'
              parens--
            else if @char is '('
              parens++
            @move()
          return yes
        return no

  readAtRulePseudo: ->
    if tok = @peek PUNC, ':'
      @moveTo tok.start
      @makeToken IDENT, ->
        @eat PUNC, ':', no
        unless @read IDENT, null, no
          return no

  readAtRuleArgument: ->
    tok = @readAtRuleFunction() or
    tok = @readAtRuleProperty() or
          @readAtRuleString() or
          @readAtRuleGroup() or
          @readAtRulePseudo() or
          @readAtRuleIdent()

    if tok

      return tok

  ###
  TODO do a real parsing of arguments.
  ###
  readAtRuleArguments: ->
    start = @position
    yeah = no
    @skipWhitespace()

    until @isEndOfLine()
      break unless @readAtRuleArgument()
      if @eat PUNC, ','
        @skipWhitespace()
      yeah = yes

    if yeah
      (@source.substring start, @position).trim()
    else
      @moveTo start
      return
  ###
  foo
  *
  &
  ###
  readElementalSelector: ->
    if match = @match RE_ELEMENTAL_SELECTOR
      @makeToken SIMPLE_SELECTOR, -> @move match[0].length

  ###
  #foo
  ###
  readIdSelector: ->
    if match = @match RE_ID_SELECTOR
      @makeToken SIMPLE_SELECTOR, -> @move match[0].length

  ###
  .foo
  ###
  readClassSelector: ->
    if match = @match RE_CLASS_SELECTOR
      @makeToken SIMPLE_SELECTOR, -> @move match[0].length

  readComplementarySelector: ->
    @readIdSelector() or
    @readClassSelector() or
    @readAttributeSelector() or
    @readPseudoSelector()

  ###
  ###
  readKeyFramesSelector: ->
    if (number = @peek NUMBER)?.unit?.value is '%'
      @moveTo number.start
      @makeToken Number, -> @moveTo number.end

  ###
  ###
  readSimpleSelector: ->
    @readKeyFramesSelector() or
    @makeToken SIMPLE_SELECTOR, ->
      @skipSpaces()
      elem = @readElementalSelector()
      sel = if elem then elem.value else ''
      sel += sp.value while sp = @readComplementarySelector()
      return no if sel is ''

  ###
  [foo...]
  ###
  readAttributeSelector: ->
    if @char is '['
      @makeToken SIMPLE_SELECTOR, (sel) ->
        @move()
        @skipWhitespace()
        if name = (@match RE_ATTRIBUTE_NAME)
          @move name[0].length
          @skipWhitespace()

          if match = @match RE_ATTRIBUTE_OPERATOR
            @move match[0].length
            @readString() or @readIdent()

          # CSS4 case sensitivity
          if c = (@eat IDENT, 'i')
            sel.case = c.value
          else
            sel.case = null

          if @char is ']'
            @move()
            return yes

        return no

  ###
  :foo
  ::foo
  ###
  readPseudoSelector: ->
    if @char is ':'
      @makeToken SIMPLE_SELECTOR, ->
        @move()
        @move() if @char is ':'
        unless @readIdent()
          return no

        # Arguments
        if tok = @peek PUNC, '('
          # TODO real parse "not()" arguments as another selector?
          @moveTo tok.end
          parens = 1
          while parens
            return no if @isEndOfLine()
            parens-- if @char is ')'
            parens++ if @char is '('
            @move()
  ###
  ###
  readCombinator: ->
    @makeToken COMBINATOR, ->
      @skipWhitespace()
      if match = @match RE_COMBINATOR
        @move match[0].length
      else
        return no

  ###
  ###
  readSelector: ->
    @makeToken SELECTOR, (sel) ->
      @readCombinator()
      i = 0
      loop
        if @readSimpleSelector()
          i++
          @readCombinator()
        else
          return i > 0

  readSelectorList: ->
    selectors = []

    while selector = @readSelector()
      selectors.push selector
      break unless @read PUNC, ','
      @skipWhitespace()

    return selectors if selectors.length

  ###
  ###
  readWhitespace: ->
    if match = @match RE_HORIZONTAL_WHITESPACE
      @makeToken WHITESPACE, -> @move match[0].length

  ###
  Generic `read*`. Try to read a token of given `type` with optional `value`.

  This will have a token cache which should make it a lot faster.
  ###
  read: (type, value, ignore = /\s*/) ->
    if token = @peek type, value, ignore
      @moveTo token.end
      token

  peek: (type, value, ignore = /\s*/) ->
    start = @position

    if ignore? and (m = @match ignore)
      @move m[0].length

    if token = (this["read#{type}"])()
      if (not value?) or (([].concat value).indexOf token.value) >= 0
        @moveTo start
        return token

    @moveTo start
    return

  ###
  ###
  expect: (type, value, ignore = /\s*/) ->
    if token = (@read type, value, ignore)
      return token

    throw new SyntaxError """
      "Unexpected `don't know what` type or value. \
      Expected `#{type}` (#{value})  at #{@position}"
      """

  ###
  ###
  eat: @::read

  ###
  ###
  eatAll: (type, value, ignore = /\s*/) ->
    loop
      break unless @eat type, value, ignore

module.exports = Lexer
