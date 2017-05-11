Parser                = require '../parser'
T                     = require '../token'
Expression            = require '../node/expression'
Operation             = require '../node/expression/operation'
Group                 = require '../node/expression/group'
String                = require '../node/expression/string'
Number                = require '../node/expression/number'
URL                   = require '../node/expression/url'
Color                 = require '../node/expression/color'
RegExp                = require '../node/expression/regexp'
Function              = require '../node/expression/function'
List                  = require '../node/expression/list'
Block                 = require '../node/expression/block'
This                  = require '../node/expression/this'
Call                  = require '../node/expression/call'
UnicodeRange          = require '../node/expression/unicode-range'
SelectorList          = require '../node/selector/list'
ComplexSelector       = require '../node/selector/complex'
CompoundSelector      = require '../node/selector/compound'
ElementalSelector     = require '../node/selector/elemental'
KeyframeSelector      = require '../node/selector/keyframe'
ClassSelector         = require '../node/selector/class'
IdSelector            = require '../node/selector/id'
AttributeSelector     = require '../node/selector/attribute'
PseudoClassSelector   = require '../node/selector/pseudo-class'
PseudoElementSelector = require '../node/selector/pseudo-element'
ParentSelector        = require '../node/selector/parent'
Combinator            = require '../node/selector/combinator'
Directive             = require '../node/statement/directive'
Conditional           = require '../node/statement/conditional'
Loop                  = require '../node/statement/loop'
For                   = require '../node/statement/for'
Property              = require '../node/statement/property'
AtRule                = require '../node/statement/at-rule'
RuleSet               = require '../node/statement/rule-set'
Root                  = require '../node/root'
SyntaxError           = require '../error/syntax'
EOTError              = require '../error/eot'

class BaseParser extends Parser

  BINARY_OPERATORS = [
    '::'    # Subscript
    '.'     # Method
    '('     # Arguments
    '..'    # Range
    '*'     # Multiplication
    '/'     # Division
    '+'     # Addition
    '-'     # Substraction
    '<'     # Less than
    '<='    # Less than or equal
    '>'     # Greater than
    '>='    # Greater than or equal
    'is'    # Equality
    'isnt'  # Negated equality
    'has'   # Ownership
    'hasnt' # Negated ownership
    'in'    # Existence
    '~'     # String/RegExp matching
    'and'   # Logical "and"
    'or'    # Logical "or"
    ' '     # List separator
    ','     # List separator
    '='     # Assignment
    '|='    # Conditional assignment
    '>>'    # Push right
    '<<'    # Push left
  ]

  UNARY_OPERATORS = [
    '+@'   # Plus
    '-@'   # Minus
    'not@' # Boolean negation
  ]

  # Operator precedence, from highest to lowest.
  PRECEDENCE =
    '+@'    :  900
    '-@'    :  900
    '('     :  700
    '::'    :  700
    '.'     :  700
    '*'     :  500
    '/'     :  500
    '+'     :  450
    '-'     :  450
    '..'    :  400
    '<'     :  300
    '<='    :  300
    '>'     :  300
    '>='    :  300
    'has'   :  250
    'hasnt' :  250
    'is'    :  200
    'isnt'  :  200
    'in'    :  190
    '~'     :  150
    'not@'  :  110
    'and'   :   90
    'or'    :   80
    ' '     :   70
    ','     :   60
    '='     :   50
    '|='    :   50
    '>>'    :   20
    '<<'    :   20
    # '!important' :    0

  # Operators with right-to-left associativity.
  RIGHT_ASSOC =
    '+@'   : 1
    '-@'   : 1
    'not@' : 1
    '='    : 1
    '|='   : 1

  # Selector combinators
  COMBINATORS = [
    T.GT
    T.TILDE
    T.PLUS
    # T.H_WHITESPACE
  ]

  # Attribute selector operators
  ATTRIBUTE_OPERATORS = [
    T.EQUAL
    T.TILDE_EQUAL
    T.PIPE_EQUAL
    T.CARET_EQUAL
    T.DOLLAR_EQUAL
    T.ASTERISK_EQUAL
  ]

  # Allowed punctuation in at-rule arguments
  AT_RULE_PUNCTUATION = [
    T.TILDE_EQUAL
    T.CARET_EQUAL
    T.DOLLAR_EQUAL
    T.ASTERISK_EQUAL
    T.LT_EQUAL
    T.GT_EQUAL
    T.PIPE_EQUAL
    T.DOUBLE_COLON
    T.DOUBLE_DOT
    T.EQUAL
    T.DOT
    T.ASTERISK
    T.SLASH
    T.PLUS
    T.MINUS
    T.LT
    T.GT
    T.TILDE
    T.COMMA
    T.PIPE
    T.COLON
    T.PIPE_COLON
    T.AT_SYMBOL
    T.AMPERSAND
    T.PERCENT
  ]

  PSEUDO_ARGS_PUNCTUATION = [
    T.ASTERISK
    T.SLASH
    T.PLUS
    T.MINUS
    T.GT
    T.TILDE
  ]

  # These constructors share the same syntax.
  DIRECTIVES = [
    'return'
    'break'
    'continue'
    'import'
    'use'
  ]

  ###
  ###
  constructor: ->
    @directives = DIRECTIVES

  @location: -> @token.start

  ###
  Move to given `token`
  ###
  move: (@token) ->

  ###
  Move to next token.
  ###
  next: -> @move @token.next

  ###
  Try to consume a token of given `kind` and move to next token.
  ###
  eat: (kind, value) ->
    if @token.is kind, value
      token = @token
      @next()
      return token

  ###
  ###
  error: (msg) ->
    if @isEndOfFile()
      unexpected = 'end of file'
      Err = EOTError
    else
      unexpected = "`#{@token.value}` (#{@token.kind})"
      Err = SyntaxError

    message = "Unexpected #{unexpected}"

    if msg
      message += ': ' + msg

    throw new Err message, @token.location

  ###
  Expect current token to be of given `kind` and move to next, or throw a
  `SyntaxError`.
  ###
  expect: (kind, value) ->
    if token = @eat kind, value
      return token

    @error "Expected #{kind}"

  ###
  Return `yes` if next token is a line break or end of text.
  ###
  isEndOfLine: -> @token.kind in [T.V_WHITESPACE, T.EOF]

  ###
  Return `yes` if at end of source text.
  ###
  isEndOfFile: -> @token.is T.EOF

  ###
  Skip all consecutive horizontal (non-breaking) whitespace tokens, which may
  include embedded comments. Returns last skipped token, if any.
  ###
  skipHorizontalWhitespace: ->
    w = null

    while @token.is T.H_WHITESPACE
      w = @token
      @next()

    return w

  ###
  Skip all consecutive vertical (breaking) whitespace. Returns last skipped
  token, if any.
  ###
  skipVerticalWhitespace: ->
    w = null

    while @token.is T.V_WHITESPACE
      w = @token
      @next()

    return w

  ###
  Skip all consecutive whitespace, including comments. Returns last skipped
  token, if any.
  ###
  skipAllWhitespace: ->
    w = null

    while @token.kind in [T.H_WHITESPACE, T.V_WHITESPACE]
      w = @token
      @next()

    return w

  ###
  Make a node of given `kind` by constructing it and passing it to given `func`
  callback, if provided. If `func` is defined and returns boolean `false`, this
  function will go back to start token and return `undefined`.
  ###
  node: (kind, func) ->
    node = new kind
    start = @token
    node.start = @token.start

    if func
      if no is func.call this, node
        @move start
        return

    node.end ?= @token?.start

    return node

  ###
  Parse an array of 'pieces' (strings and token streams) returned by
  `Tokenizer.readSequence()`.
  ###
  parseSequence: (pieces) ->
    pieces = [].concat pieces

    return pieces.map (piece) =>
      if piece instanceof Array
        piece = (new @class).parse piece
      return piece

  ###
  Parse a literal string of any kind and any embedded -interpolated- expression.
  ###
  parseString: ->
    raw = no
    quote = null

    if @token.is T.UNQUOTED_STRING
      quote = null
    else if @token.is T.QUOTED_STRING
      if @token.quote is '`'
        raw = yes
      else
        quote = @token.quote
    else if @token.is T.RAW_STRING
      raw = yes
    else unless @token.is T.UNQUOTED_STRING  # TODO ????
      return

    value = @parseSequence @token.value

    str = new String value, quote, raw
    str.start = @token.start
    str.end = @token.end

    @next()

    return str

  ###
  Parse an ident-like unquoted string.
  ###
  parseUnquotedString: ->
    if @token.is T.UNQUOTED_STRING
      return @parseString()

  ###
  ###
  parseCallArguments: (token) ->
    args = []

    for arg in token.arguments
      if arg.kind in [T.QUOTED_STRING, T.RAW_STRING]
        value = @parseSequence arg.value
        raw = arg.is T.RAW_STRING
        str = new String value, arg.quote, raw
        args.push str
      else
        @syntaxError "Expected quoted or raw string"

    return args

  ###
  ###
  parseNumber: ->
    if @token.is T.NUMBER
      # TODO Support line-height (`16px/50%`) syntax: if it's followed by a
      # SLASH and then another literal number, make a raw string of it (#14).
      num = new Number @token.value, @token.unit
      @next()
      return num

  ###
  ###
  parseColor: ->
    if @token.is(T.HASH) and @token.isColor
      color = new Color "##{@token.value}"
      @next()
      return color

  ###
  ###
  parseCall: ->
    if @token.is T.CALL
      name = new String @token.name
      args = @parseCallArguments @token
      node = new Call name, args
      @next()
      return node
  ###
  ###
  parseUnicodeRange: ->
    if @token.is T.UNICODE_RANGE
      urange = new UnicodeRange @parseSequence @token.value
      @next()
      return urange

  ###
  ###
  parseAmpersand: ->
    if @token.is T.AMPERSAND
      ths = new This
      @next()
      return ths

  ###
  ###
  parseRegExp: ->
    if @token.is T.REGEXP
      regexp = new RegExp @token.value, @token.flags
      @next()
      return regexp

  ###
  Parse a literal number, string, ampersand, color, regexp, `url()`, unicode
  range, block or function definition.

  Functions and blocks are only included if `blocks` is `yes`.
  ###
  parseLiteral: (blocks = yes) ->
    node = @parseNumber()

    if node
      if @token.is T.SLASH
        if @token.next.is T.NUMBER
          left = node
          @move @token.next
          right = @parseNumber()

          pieces = [left, '/', right]

          return new String pieces, null, yes, left.start, right.end

      return node

    node = @parseString() or
           @parseColor() or
           @parseCall() or
           @parseUnicodeRange() or
           @parseAmpersand() or
           @parseRegExp()

    if not node and blocks
      node = @parseFunction() or @parseBlock()

    return node

  ###
  Parse a literal `{ block }`
  ###
  parseBlock: ->
    if @token.is T.CURLY_OPEN
      block = new Block
      block.start = @token.start
      @next()

      block.body = @parseBody()

      @expect T.CURLY_CLOSE
      block.end = @location

      return block

  ###
  Parse a (parenthesized) expression.
  ###
  parseParens: ->
    if @token.is T.PAREN_OPEN
      start = @token.start

      @next()
      @skipAllWhitespace()

      if expr = @parseExpression()
        node = new Group expr
      else
        node = new List

      @skipAllWhitespace()
      @expect T.PAREN_CLOSE

      if perc = @eat T.PERCENT
        unit = new String '%'
      else if str = @parseString()
        unit = str
      else
        unit = null

      if unit
        node = new Operation 'convert', node, unit

      node.start = start
      node.end = @location

      return node

  ###
  Parse a single function argument: `name(: value)?`.
  ###
  parseFunctionArgument: ->
    if @token.is T.UNQUOTED_STRING
      name = @token.value
      @next()
      @skipHorizontalWhitespace()

      if @eat T.COLON
        @skipAllWhitespace()

        unless value = @parseExpression 0, no, no
          @error 'Expected expression after `:`'
      else
        value = null

      return [name, value]

  ###
  Parse a list of function arguments separated by commas. Each single argument
  may have a value.
  ###
  parseFunctionArguments: ->
    start = @token

    if @token.is T.PAREN_OPEN
      @next()
      @skipAllWhitespace()

      args = []

      loop
        if arg = @parseFunctionArgument()
          args.push arg
          @skipAllWhitespace()

          if @eat T.COMMA
            @skipAllWhitespace()
            continue

        if @eat T.PAREN_CLOSE
          return args

        break

    @move start
    return # nothing

  ###
  Parse a literal function definition: `(arg: val,...) { ... }`
  ###
  parseFunction: ->
    start = @token

    if args = @parseFunctionArguments()
      @skipAllWhitespace()

      if block = @parseBlock()
        func = new Function block, args
        func.start = start
        func.end = block.end

        return func

    @move start
    return # nothing

  ###
  Parse a combinator: `>`, `+`, `~` or horizontal whitespace.
  ###
  parseCombinator: ->
    token = @eat T.H_WHITESPACE

    if @token?.kind in COMBINATORS
      token = @token
      value = token.value
      @next()
    else
      value = ' '

    if token
      comb = new Combinator value
      comb.start = token.start
      comb.end = token.end

      return comb

  ###
  Parse simple `.class` selector.
  ###
  parseClassSelector: ->
    if @token.is T.DOT
      return @node ClassSelector, (sel) ->
        @next()
        return no unless sel.name = @parseUnquotedString()

  ###
  Parse a simple `#id` selector.
  ###
  parseIdSelector: ->
    if @token.is(T.HASH) and @token.isIdent
      # Damn it
      pieces = @parseSequence @token.value
      @next()
      return new IdSelector new String pieces

  ###
  Parse a simple `[attribute]` selector.
  ###
  parseAttributeSelector: ->
    if @token.is T.BRACKET_OPEN
      return @node AttributeSelector, (sel) ->
        @next()
        @skipHorizontalWhitespace()

        if @token.is T.UNQUOTED_STRING
          name = @parseString()
        else if @token.is T.ASTERISK
          name = new UnquotedString @token.value
        else
          name = null

        namespace = null

        if @token.is T.PIPE
          if @token.next.is T.UNQUOTED_STRING
            @next()
            namespace = name
            name = @parseString()

        unless name
          return no

        sel.name = name
        sel.namespace = namespace

        @skipHorizontalWhitespace()

        if @token.kind in ATTRIBUTE_OPERATORS
          sel.operator = @token.value
          @next()
          @skipHorizontalWhitespace()
          sel.value = @parseString()
          @skipHorizontalWhitespace()

        if sel.flags = @parseUnquotedString()
          @skipHorizontalWhitespace()

        unless @eat T.BRACKET_CLOSE
          return no


  ###
  ###
  parsePseudoSelectorArgument: ->
    allow_unary = yes
    args = []

    loop
      if @token.kind in PSEUDO_ARGS_PUNCTUATION
        punc = @token.value
        @next()

        if @token.is(T.NUMBER) and allow_unary and (punc in ['+', '-'])
          number = @parseNumber()
          arg = new Operation punc, null, number
        else
          arg = new String punc, null, yes
      else
        arg = @parseString() or @parseNumber()

        if not arg
          arg = @parseCompoundSelector()

      if not arg
        break

      args.push arg

      if @skipAllWhitespace()
        allow_unary = yes
      else
        allow_unary = no

    if args.length
      return args

    return null

  ###
  Parse the optional arguments of a pseudo `:class` or `::element` selector.
  ###
  parsePseudoSelectorArguments: ->
    if @token.is T.PAREN_OPEN
      args = []
      @next()
      @skipAllWhitespace()

      while arg = @parsePseudoSelectorArgument()
        args.push arg
        @skipAllWhitespace()

        if @eat T.COMMA
          @skipAllWhitespace()

      @expect T.PAREN_CLOSE

      return args

  ###
  Parse a pseudo `:class` selector.
  ###
  parsePseudoClassSelector: ->
    if @token.is T.COLON
      return @node PseudoClassSelector, (sel) ->
        @next()

        unless sel.name = @parseUnquotedString()
          return no

        sel.arguments = @parsePseudoSelectorArguments()

  ###
  Parse a pseudo `::element` selector.
  ###
  parsePseudoElementSelector: ->
    if @token.is T.DOUBLE_COLON
      return @node PseudoElementSelector, (sel) ->
        @next()

        unless sel.name = @parseUnquotedString()
          return no

        sel.arguments = @parsePseudoSelectorArguments()

  ###
  Parse a pseudo `:class` or `::element` selector.
  ###
  parsePseudoSelector: ->
    @parsePseudoClassSelector() or
    @parsePseudoElementSelector()

  ###
  Parse one of the possible complementary selectors.
  ###
  parseParentSelector: ->
    if @token.is T.AMPERSAND
      return @node ParentSelector, ->
        @next()

  ###
  Parse one of the possible complementary selectors.
  ###
  parseComplementarySelector: ->
    @parseClassSelector() or
    @parseIdSelector() or
    @parseAttributeSelector() or
    @parsePseudoSelector() or
    @parseParentSelector()

  ###
  Parse a type (`body`) or universal (`*`) selector.
  ###
  parseElementalSelector: ->
    start = @token.start

    if @token.kind is T.UNQUOTED_STRING
      name = @parseString()
    else if @token.is T.ASTERISK
      name = @token.value
      @next()
    else
      name = null

    namespace = null

    if @token.is T.PIPE
      if @token.next.kind in [T.ASTERISK, T.UNQUOTED_STRING]
        @next()
        namespace = name or '' # TODO :S Sure want to keep empty namespaces?
        name = @token.value
        @next()

    if name
      selector = new ElementalSelector name, namespace
      selector.start = start
      selector.end = @location

      return selector

    return # nothing

  ###
  ###
  parseKeyframeSelector: ->
    if @token.is(T.NUMBER) and @token.unit is '%'
      selector = new KeyframeSelector "#{@token.value}%"
      selector.start = @token.start
      selector.end = @token.end
      @next()

      return selector

  ###
  Parse a compound selector, made of one or more simple (elemental or
  complementary selectors). There can be only one elemental selector and, if
  present, must at the begining.
  ###
  parseCompoundSelector: ->
    start = @token

    if not elemental
      elemental = @parseElementalSelector()
      complementary = (compl while compl = @parseComplementarySelector())
    else
      compl = []

    if elemental or complementary.length
      selector = new CompoundSelector elemental, complementary
      selector.start = start
      selector.end = @location

      return selector

    return # nothing

  ###
  Parse a complex selector, made of a list of compound selectors separated by
  combinators. We're allowing a selector to *start* or *end* with a selector
  for nesting.
  ###
  parseComplexSelector: ->
    @node ComplexSelector, (sel) ->
      loop
        comb = @parseCombinator()

        if not comb and sel.items.length > 0
          break

        @skipHorizontalWhitespace()

        if compound = (@parseKeyframeSelector() or @parseCompoundSelector())
          if comb
            sel.items.push comb

          sel.items.push compound
        else
          if comb and comb.value isnt ' '
            sel.items.push comb
          break

      if not sel.items.length
        return no

  ###
  Parse a comma separated list of complex selectors.
  ###
  parseSelectorList: ->
    @node SelectorList, (sel) ->
      sels = []

      while complex = @parseComplexSelector()
        sels.push complex
        @skipHorizontalWhitespace()

        # TODO: we're allowing a trailing comma here. Don't
        if @eat T.COMMA
          @skipAllWhitespace()
        else
          break

      unless sels.length
        return no

      sel.items = sels

  ###
  Parse a rule set statement. A rule set is made of a selector followed by a
  block.
  ###
  parseRuleSet: ->
    @node RuleSet, (rule) ->
      if rule.selector = @parseSelectorList()
        @skipAllWhitespace()

        if rule.block = @parseBlock()
          return

      return no

  ###
  ###
  parseAtRuleGroup: ->
    if @token.is T.PAREN_OPEN
      args = []
      @next()
      @skipAllWhitespace()
      args.push @parseAtRuleArguments(yes)...
      @skipAllWhitespace()
      @expect T.PAREN_CLOSE

      return args

  ###
  ###
  parseAtRulePunctuation: ->
    if @token.kind in AT_RULE_PUNCTUATION
      value = @token.value
      @next()

      return new String value, null, yes

  ###
  TODO We're allowing multiple properties
  ###
  parseAtRuleProperty: -> @parseProperty(no)

  ###
  ###
  parseAtRuleString: -> @parseString()

  ###
  ###
  parseAtRuleURL: ->
    if @token.is T.URL
      url = new URL @parseSequence @token.value
      @next()

      return url

  ###
  ###
  parseAtRuleCall: ->
    if call = @parseCall()
      return call

    if @token.is(T.UNQUOTED_STRING) and @token.next.is(T.PAREN_OPEN)
      call = new Call @token
      @move @token.next.next
      @skipAllWhitespace()

      args = []

      while arg = @parseAtRuleArgument()
        args.push arg

        @skipAllWhitespace()

        if @eat T.COMMA
          @skipAllWhitespace()
        else
          break

      @expect T.PAREN_CLOSE

      call.arguments = args

      return call

  ###
  ###
  parseAtRuleSelector: -> @parsePseudoSelector()

  ###
  Parse a single at-rule argument.
  ###
  parseAtRuleArgument: (props = no) ->
    (props and @parseAtRuleProperty()) or
    @parseAtRuleURL() or
    @parseAtRuleSelector() or
    @parseAtRuleCall() or
    @parseAtRuleString() or
    @parseAtRuleGroup() or
    @parseAtRulePunctuation()

  ###
  Parse the arguments of an at-rule.
  ###
  parseAtRuleArguments: (props = no) ->
    start = @token
    args = []

    until @isEndOfLine()
      arg = @parseAtRuleArgument(props)
      break unless arg

      args.push arg

      @skipHorizontalWhitespace()

      if @eat T.COMMA
        args.push new String ',', null, yes
        @skipAllWhitespace()

    return args

  ###
  Parse an at-rule statement. Is't made of an at-ident optionally followed by a
  list of arguments and/or a block.
  ###
  parseAtRule: ->
    if @token.is T.AT_SYMBOL
      return @node AtRule, (rule) ->
        @next()

        unless rule.name = @parseUnquotedString()
          @error "Expected at-rule name"

        back = @token

        @skipHorizontalWhitespace()

        if rule.arguments = @parseAtRuleArguments()
          back = @token

        @skipAllWhitespace()

        unless rule.block = @parseBlock()
          @move back

  ###
  Parse a single name at the left side of a property declaration.
  ###
  parsePropertyName: -> @parseUnquotedString()

  ###
  Parse a comma separated list names at the left side of a property declaration.

  TODO: Trailing comma should be disallowed. Write tests.
  ###
  parsePropertyNames: (multiple = yes) ->
    names = []
    comma = null

    while str = @parsePropertyName()
      names.push str

      break unless multiple

      @skipHorizontalWhitespace()

      if comma = @eat T.COMMA
        @skipAllWhitespace()
      else
        break

    if not comma and names.length
      return names

  ###
  Parse a `property: value` declaration.
  ###
  parseProperty: (multiple = yes) ->
    start = @token

    if names = @parsePropertyNames(multiple)
      @skipHorizontalWhitespace()

      if @token.kind in [T.PIPE_COLON, T.COLON]
        conditional = @token.value is '|:'
        @next()
        @skipAllWhitespace()

        if value = @parseExpression()
          prop = new Property names, value, conditional
          prop.start = start
          prop.end = value.end

          return prop
        else
          @error "Expected property value expression"

    @move start
    return

  ###
  Parse a declaration ("CSS statement"), ie: a rule or a property.
  ###
  parseDeclaration: ->
    @parseAtRule() or
    @parseRuleSet() or
    @parseProperty()

  ###
  Parse the predicate of an `if` or an `unless` statement.
  ###
  parseConditionalPredicate: (cond) ->
    unless cond.condition = @parseExpression 0, no
      @error 'Expected expression after conditional'

    @skipAllWhitespace()

    unless cond.block = @parseBlock()
      @error 'Expected block after conditional'

    # Parse additional `else (if|unless)`s
    elses = []
    back = @token
    @skipAllWhitespace()

    while @token.is T.UNQUOTED_STRING, ['else']
      els = negate: no

      @next()
      @skipHorizontalWhitespace()

      if @token.is T.UNQUOTED_STRING, ['if', 'unless']
        els.negate = @token.value is 'unless'
        @next()

        @skipHorizontalWhitespace()

        unless els.condition = @parseExpression 0, no
          @error "Expected expression after `else #{@token.value}`"

      @skipAllWhitespace()

      unless els.block = @parseBlock()
        @error 'Expected block after `else`'

      elses.push els

      back = @token

      # If it's a standalone `else`, it has to be the last in the
      # conditional block
      break unless els.condition

      @skipAllWhitespace()

    cond.elses = elses
    @move back

  ###
  Parse an `if|unless ... [[else if|unless ...]... [else]]` block.
  ###
  parseConditional: ->
    if @token.is T.UNQUOTED_STRING, ['if', 'unless']
      return @node Conditional, (cond) ->
        cond.negate = @token.value is 'unless'
        @next()
        @skipHorizontalWhitespace()
        @parseConditionalPredicate cond
    else if @token.is T.UNQUOTED_STRING, ['else']
      @error "Unexpected `else`"

  ###
  Parse a `loop|while|until ...` block.
  ###
  parseLoop: ->
    if @token.is T.UNQUOTED_STRING, ['while', 'until']
      return @node Loop, (lp) ->
        lp.start = @token.start
        lp.negate = @token.value is 'until'
        @next()
        @skipHorizontalWhitespace()

        unless lp.condition = @parseExpression 0, no
          @error "Expected expression after `#{@token.value}`"

        @skipAllWhitespace()

        unless lp.block = @parseBlock()
          @error "Expected block after `#{@token.value}` expression"

  ###
  Parse a `for .. in ...` block.
  ###
  parseFor: ->
    if @token.is T.UNQUOTED_STRING, ['for']
      return @node For, (fr) ->
        @next()
        @skipHorizontalWhitespace()

        arg = @expect T.UNQUOTED_STRING
        @skipHorizontalWhitespace()

        if @eat T.COMMA
          fr.key = arg
          @skipAllWhitespace()
          fr.value = @expect T.UNQUOTED_STRING
        else
          fr.value = arg

        @skipHorizontalWhitespace()

        @expect T.UNQUOTED_STRING, ['in']

        @skipHorizontalWhitespace()

        unless fr.expression = @parseExpression 0, no
          @error "Expected expression after for ... in"

        unless fr.block = @parseBlock()
          @error "Expected block after for ... in expression"


  ###
  Parse a comma-list of arguments.
  ###
  parseArguments: ->
    items = []

    while item = @parseExpression 0, no, no
      items.push item
      @skipHorizontalWhitespace()

      unless @eat T.COMMA
        break

      @skipAllWhitespace()

    return items

  ###
  Parse one of the 'directives': `return`, `break`, `continue`, `import` or
  `use`.
  ###
  parseDirective: ->
    if @token.is T.UNQUOTED_STRING, @directives
      return @node Directive, (dir) ->
        dir.name = @token.value
        @next()
        @skipHorizontalWhitespace()
        dir.arguments = @parseArguments()

  ###
  ###
  precedence: (op, unary = no) ->
    value = if op.is T.H_WHITESPACE then ' ' else op.value
    value += '@' if unary
    return PRECEDENCE[value]

  ###
  ###
  peekUnaryOperator: ->
    if "#{@token.value}@" in UNARY_OPERATORS
      return @token

  ###
  ###
  peekBinaryOperator: ->
    if @token.is T.H_WHITESPACE
      next = @token.next

      if next.value in BINARY_OPERATORS
        if next.kind in [T.PLUS, T.MINUS]
          if next.next.kind in [T.H_WHITESPACE, T.V_WHITESPACE]
            return next
        else if not next.is T.PAREN_OPEN
          return next

      return @token
    else if @token.value in BINARY_OPERATORS
      return @token

  ###
  With given `left` expression, try parse a binary operation with a higher
  precedence than passed `left` (or same, with right associativity).
  ###
  parseRightOperation: (left, prec, blocks, commas, spaces) ->
    next_op = @peekBinaryOperator()

    while (next_op and (\
        (@precedence(next_op) > prec) or \
        (RIGHT_ASSOC[next_op.value] and (@precedence(next_op) is prec))))

      if not commas and next_op.is T.COMMA
        break

      if next_op.is T.H_WHITESPACE
        if not spaces
          break

        blocks = no

      op = next_op
      @move next_op.next

      unless next_op.is T.H_WHITESPACE
        @skipAllWhitespace()

      if next_op.is T.PAREN_OPEN
        right = @parseArguments()
        @skipAllWhitespace()
        @expect T.PAREN_CLOSE
      else
        right = @parsePrimaryExpression prec, blocks

      unless right
        if op.is T.COMMA
          unless (left instanceof List) and (left.separator is ',')
            left = new List [left], ','
          return left
        else if not op.is T.H_WHITESPACE
          @error "Expected right side of `#{op.value}` operation"

        return left

      # TODO I'm pretty sure this second loop is not necessary and can be
      # replace with a recursive call if we add an `associativity` argument.
      next_op = @peekBinaryOperator()

      while next_op
        next_prec = @precedence(next_op)
        op_prec = @precedence(op)

        break unless  (next_prec > op_prec) or
          (RIGHT_ASSOC[next_op.value] and (next_prec is op_prec))

        # TODO Mmm...
        break if right is (right =
          @parseRightOperation right, @precedence(op), blocks, commas, spaces)

        next_op = @peekBinaryOperator()

      if op.kind in [T.H_WHITESPACE, T.COMMA]
        sep = if op.is T.H_WHITESPACE then ' ' else op.value

        if (left instanceof List) and (sep is left.separator)
          left.body.push right
        else
          left = new List [left, right], sep
      else
        left = new Operation op.value, left, right

    return left

  ###
  ###
  parseUnaryOperation: (prec, blocks) ->
    if op = @peekUnaryOperator()
      if @precedence(op, yes) >= prec
        return @node Operation, (expr) ->
          expr.operator = op.value
          @next()
          @skipHorizontalWhitespace()
          expr.right = @parseExpression(@precedence(op, yes), blocks, no, no)

          return no unless expr.right

  ###
  ###
  parsePrimaryExpression: (prec = 0, blocks = yes) ->
    @parseUnaryOperation(prec, blocks) or
    @parseLiteral(blocks) or
    @parseParens()

  ###
  ###
  parseExpression: (prec = 0, blocks = yes, commas = yes, spaces = yes) ->
    if left = @parsePrimaryExpression prec, blocks
      return @parseRightOperation left, prec, blocks, commas, spaces

  ###
  Inside a block body or at root, any of the valid statements, delimited by new
  lines or semicolons.
  ###
  parseStatement: ->
    @parseConditional() or
    @parseLoop() or
    @parseFor() or
    @parseDirective() or
    @parseDeclaration() or
    @parseExpression()

  ###
  Parse statements at root level or inside a block.
  ###
  parseBody: ->
    stmts = []

    loop
      @skipAllWhitespace()

      break if @isEndOfFile()

      while @eat T.SEMICOLON
        @skipAllWhitespace()

      if stmt = @parseStatement()
        stmts.push stmt
      else
        break

      @skipHorizontalWhitespace()

      # No semicolon required if there's a line break (or EOT).
      # TODO Allow to end a statement with `}`
      break unless stmt.block or @isEndOfLine() or @eat T.SEMICOLON

    return stmts

  ###
  Parse document root.
  ###
  parseRoot: ->
    return @node Root, (root) ->
      root.bom = !!@eat T.BOM
      root.body = @parseBody()
      @skipAllWhitespace()
      eof = @expect T.EOF
      root.end = eof.start

module.exports = BaseParser
