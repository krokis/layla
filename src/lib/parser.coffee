Lexer        = require './lexer'
Token        = require './token'
Expression   = require './node/expression'
Operation    = require './node/expression/operation'
Group        = require './node/expression/group'
Call         = require './node/expression/call'
String       = require './node/expression/literal/string'
URL          = require './node/expression/literal/url'
Color        = require './node/expression/literal/color'
Number       = require './node/expression/literal/number'
RegExp       = require './node/expression/literal/regexp'
Function     = require './node/expression/literal/function'
List         = require './node/expression/literal/list'
Block        = require './node/expression/literal/block'
This         = require './node/expression/literal/this'
Break        = require './node/statement/break'
Continue     = require './node/statement/continue'
Return       = require './node/statement/return'
With         = require './node/statement/with'
Import       = require './node/statement/import'
Use          = require './node/statement/use'
Conditional  = require './node/statement/conditional'
Loop         = require './node/statement/loop'
For          = require './node/statement/for'
Property     = require './node/statement/declaration/property'
AtRule       = require './node/statement/declaration/rule/at-rule'
RuleSet      = require './node/statement/declaration/rule/rule-set'
LineComment  = require './node/comment/line'
BlockComment = require './node/comment/block'
Root         = require './node/root'

SyntaxError  = require './error/syntax'

{
  PUNC
  UNARY_OPERATOR
  BINARY_OPERATOR
  IDENT
  UNIT
  AT_IDENT
  NUMBER
  COLOR
  REGEXP
} = Token

class Parser extends Lexer

  # All operators, with their precedence, from highest to lowest.
  PREC =
    '+@'     : 100 # Unary plus
    '-@'     : 100 # Unary minus
    'not@'   :  11 # Unary boolean negation
    '::'     :  99 # Property access
    '.'      :  99 # Method access
    '('      :  99 # Method arguments
    '*'      :  50 # Multiplication
    '/'      :  50 # Division
    '+'      :  45 # Addition
    '-'      :  45 # Substraction
    '..'     :  40 # Range
    '<'      :  30 # Less than
    '<='     :  30 # Less than or equal
    '>'      :  30 # Greater than
    '>='     :  30 # Greater than or equal
    'is-a'   :  30 # Type test: `a is-a Number`
    'is-an'  :  30 # Same
    'isnt-a' :  30 # Negated type test: `a isnt-a Number`
    'isnt-an':  30 # Same
    'has'    :  30 # Ownership
    'hasnt'  :  30 # Negated ownership
    'is'     :  20 # Equality
    'isnt'   :  20 # Negated
    'in'     :  18 # Existence
    '~'      :  15 # String/RegExp matching
    ' '      :  10 # List separator
    ','      :   9 # List separator
    '='      :   8 # Assignment
    '|='     :   8 # Conditional assignment
    'and'    :   7 # Logical "and"
    'or'     :   6 # Logical "or"
    '>>'     :   2 # Push-out
    '<<'     :   2 # Push-in
    'if'     :   0 # Postfix conditional TODO
    'unless' :   0 # Negated postfix conditional TODO

  # Operators associativity (0: left to right, 1: right to left)
  ASSOC =
    '+@'   : 1
    '-@'   : 1
    'not@' : 1
    '+'    : 0
    '-'    : 0
    '/'    : 0
    '*'    : 0
    '.'    : 0
    '::'   : 0
    '('    : 0
    'and'  : 0
    'or'   : 0
    'is'   : 0
    'isnt' : 0
    '>'    : 0
    '>='   : 0
    '<'    : 0
    '<='   : 0
    '='    : 1
    '|='   : 1
    ','    : 0
    ' '    : 0
    '<<'   : 0
    '>>'   : 0

  ###
  Node maker.
  ###
  makeNode: (type, func) ->
    node = new type
    start = node.start = @position

    if func
      # If the callback returns a boolean `no`, then this function does not
      # return a node, but `undefined`.
      try
        if no is func.call this, node
          @moveTo start
          return
      catch e
        @moveTo start
        throw e

    node.end ?= @position
    node

  ###
  ###
  isStartOfBlock: -> !!(@peek PUNC, '{')

  ###
  Returns `yes` if after current position there's nothing but whitespace
  followed a block end (`}`).
  ###
  isEndOfBlock: -> !!(@peek PUNC, '}')

  ###
  ###
  parseUnaryOperation: (prec = 0) ->
    if op = (@peek UNARY_OPERATOR)
      unless op.value is '-' and @peek IDENT
        if PREC["#{op.value}@"] >= prec
          @makeNode Operation, (expr) ->
            @moveTo op.end
            expr.start = op.start
            if expr.right = @parseExpression PREC["#{op.value}@"], no, no, no
              expr.operator = op.value
              expr.end = expr.right.end
            else
              return no

  ###
  ###
  parseRightOperation: (left, prec, blocks = yes, commas = yes, spaces = yes) ->
    if next_op = @peek BINARY_OPERATOR, null, no
      unless commas
        if next_op.value is ','
          return left
        unless spaces or next_op.value isnt ' '
          return left

    while next_op and (PREC[next_op.value] >= prec)
      op = next_op

      if next_op.value is '('
        right = @parseCallArguments()
      else
        @moveTo op.end
        right = @parsePrimaryExpression prec, blocks

      unless right
        if op.value is ','
          # Explicitly create a list: `(0,)`
          unless (left instanceof List) and (left.separator is ',')
            left = new List [left], ','
          return left
        else if op.value is ' '
          return left
        throw new SyntaxError "Expected right side of `#{op.value}` operation"

      next_op = @peek BINARY_OPERATOR, null, no

      while next_op and (
        (PREC[next_op.value] > PREC[op.value]) or
        ((ASSOC[next_op.value] is 1) and
        (PREC[next_op.value] is PREC[op.value])
        ))
        right = @parseRightOperation right, PREC[next_op.value], blocks, commas
        next_op = @peek BINARY_OPERATOR, null, no

      if op.value in [' ', ',']
        if (left instanceof List) and (op.value is left.separator)
          left.body.push right
        else
          left = new List [left, right], op.value
      else
        left = new Operation op.value, left, right

    return left

  ###
  ###
  parseCommaList: ->
    start = @position
    items = []
    parens = 0

    while @read PUNC, '('
      parens++

    while item = (@parseExpression null, no, no)
      items.push item
      break unless comma = @eat PUNC, ','

    while parens
      @expect PUNC, ')'
      parens--

    if items.length
      return items
    else
      @moveTo start
      return

  ###
  ###
  parseFunctionArguments: ->
    start = @position

    if @eat PUNC, '('
      args = []

      while id = @parseUnquotedString()
        name = id.value
        if op = @eat PUNC, ['=']
          break if (op.value is ':') and (@peek PUNC, ':')
          break unless val = @parseExpression 0, no, no, no
        else
          val = null
        args.push {name: name, value: val}
        break unless comma = @eat PUNC, ','

      if @eat PUNC, ')'
        return args

    @moveTo start

  ###
  ###
  parseCallArguments: ->
    start = @position

    if @read PUNC, '(', no
      args = @parseCommaList()
      if @eat PUNC, ')'
        return args || []

    @moveTo start

  ###
  ###
  parseURL: ->
    if tok = @peek IDENT, 'url'
      @makeNode URL, (url) ->
        @moveTo tok.end

        unless @eat PUNC, '('
          return no

        url.start = tok.start
        val = @parseQuotedString()

        unless val
          val = @makeNode String, (str) ->
            str.value = '' # TODO why is this necessary'
            until @char is ')'
              if @isEndOfLine()
                throw new SyntaxError "Unterminated `url()`"
              str.value += @char
              @move()

        @expect PUNC, ')'
        url.value = val

  ###
  ###
  parseCall: ->
    if token = @peek IDENT
      @makeNode Call, (call) ->
        call.start = token.start
        call.name = token.value
        call.value = token.value
        @moveTo token.end

        if @peek PUNC, '('
          call.arguments = @parseCallArguments()

          if @char in ['!', '?']
            unless @peek IDENT, null, no
              call.name += @char
              call.value += @char
              @move()

  ###
  ###
  parseThis: ->
    if token = @read PUNC, '&'
      @makeNode This, -> @moveTo token.end

  ###
  ###
  parseFunction: ->
    @makeNode Function, (func) ->
      no unless (func.arguments = @parseFunctionArguments()) and
                (func.block = @parseBlock())

  ###
  ###
  parseNumber: ->
    if token = @peek NUMBER
      @moveTo token.start
      @makeNode Number, (num) ->
        num.value = parseFloat token.value
        num.unit = token.unit
        @moveTo token.end

  ###
  Parse a quoted or unquoted string
  ###
  parseString: ->
    @parseQuotedString() or @parseUnquotedString()

  parseQuotedString: ->
    if token = @read PUNC, ['"', "'", '`']
      @makeNode String, (str) ->
        str.start = token.start
        quote = token.value
        chunks = []
        chunk = ''

        loop
          if @isEndOfText()
            throw new SyntaxError "Unterminated string"

          if @char is quote
            # End string
            @move()
            break

          else if @char is '\\'
            @move()
            switch @char
              when null
                continue
              when 'n'
                chunk += '\n'
              when 'r'
                chunk += '\r'
              when 't'
                chunk += '\t'
              when '{'
                chunk += '{'
              when '\n'
              else
                chunk += ('\\' + @char)
            @move()

          else if @char is '{'
            # Start interpolation
            @move()
            chunks.push chunk if chunk isnt ''
            chunks.push @parseExpression 0, no
            @expect PUNC, '}'
            chunk = ''
          else
            chunk += @char
            @move()

        chunks.push chunk if chunk isnt ''
        str.quote = quote if quote isnt '`'
        str.value = chunks

  parseUnquotedString: ->
    if token = @peek IDENT
      @makeNode String, (str) ->
        str.start = token.start
        str.end = token.end
        str.value = token.value
        @moveTo token.end

  ###
  ###
  parseRegExp: ->
    if tok = @read REGEXP
      @makeNode RegExp, (reg) ->
        reg.start = tok.start
        reg.value = tok.value
        reg.flags = tok.flags

  ###
  ###
  parseColor: ->
    if token = @peek COLOR
      @makeNode Color, (color) ->
        color.start = token.start
        color.value = token.value
        @moveTo token.end

  ###
  ###
  parseLiteral: ->
    @parseThis() or
    @parseQuotedString() or
    @parseNumber() or
    @parseColor() or
    @parseRegExp() or
    @parseURL() or
    @parseCall()

  ###
  Parenthesized expressions.
  ###
  parseParens: ->
    if token = (@read PUNC, '(')
      node =
        if expr = @parseExpression()
          new Group expr
        else
          new List

      @expect PUNC, ')'

      if unit = (@read UNIT, null, no)
        new Operation 'convert', node, (new String unit.value)
      else
        node

  ###
  ###
  parsePrimaryExpression: (prec = 0, blocks = yes) ->
    (blocks and (@parseFunction() or @parseBlock())) or
    (@parseUnaryOperation prec) or
    @parseParens() or
    @parseLiteral()

  ###
  ###
  parseExpression: (prec = null, blocks = yes, commas = yes, spaces = yes) ->
    if left = @parsePrimaryExpression prec, blocks
      @parseRightOperation left, prec, blocks, commas, spaces

  parseAtRule: ->
    if ident = @read AT_IDENT
      @makeNode AtRule, (rule) ->
        rule.start = ident.start
        rule.name = ident.value.substr 1
        @moveTo ident.end
        rule.arguments = @readAtRuleArguments()
        rule.block = @parseBlock() or null

  ###
  ###
  parseRuleSet: ->
    start = @position

    if selectors = @readSelectorList()
      if @isStartOfBlock()
        return @makeNode RuleSet, (rule) ->
          rule.start = selectors[0].start
          rule.selector = []
          for sel in selectors
            rule.selector.push sel.value
          rule.block = @parseBlock()

    @moveTo start

  ###
  Parse a single property name.
  ###
  parsePropertyName: -> @parseString()

  ###
  Parses the left side of a declaration. This should resolve to an ident or to
  a string. As in any ident or string, interpolation is allowed.
  ###
  parsePropertyNames: ->
    names = []

    while str = @parsePropertyName()
      names.push str
      break unless @eatAll PUNC, ','

    names if names.length

  ###
  Parses a `property: value` declaration.
  ###
  parseProperty: ->
    start = @position

    if names = @parsePropertyNames()
      if op = @read PUNC, ['|', ':'], /[ \t]*/
        other = @peek PUNC, ':', no

        loop
          if op.value is '|'
            break unless other
            @moveTo other.end
          else
            break if other

          return @makeNode Property, (prop) ->
            prop.names = names
            prop.start = names[0].start
            prop.conditional = op.value is '|'
            return no unless prop.value = @parseExpression()

    @moveTo start

  parseDeclaration: ->
    @parseAtRule() or
    @parseRuleSet() or
    @parseProperty()

  ###
  ###
  parseLineComment: ->
    if token = @peek LINE_COMMENT
      @makeNode LineComment, (comment) ->
        comment.comment = token.value
        @move token.length

  ###
  ###
  parseBlockComment: ->
    if token = @peek BLOCK_COMMENT
      @makeNode BlockComment, (comment) ->
        comment.comment = token.value
        @move token.length

  ###
  Parse a line or block comment.
  ###
  parseComment: ->
    @parseLineComment() or
    @parseBlockComment()

  ###
  Parse the predicate of a `if` or an `unless` statement.
  ###
  parseConditionalPredicate: (node) ->
    unless node.condition = (@parseExpression 0, no)
      throw new SyntaxError 'Expected expression after conditional'

    unless node.block = @parseBlock()
      throw new SyntaxError 'Expected block after conditional expression'

    # Additional else(if)'s
    try
      while @read IDENT, 'else'
        @skipWhitespace()
        els = {negate: no}

        if tok = @read IDENT, ['if', 'unless']
          unless els.condition = (@parseExpression 0, no)
            throw new SyntaxError (
              "Expected expression after `else #{tok.value}`"
            )
          els.negate = tok.value is 'unless'

        unless els.block = @parseBlock()
          throw new SyntaxError 'Expected block after `else`'

        node.elses.push els

        # If it's an `else`, it must be the last in the conditional block
        break unless els.condition

  ###
  Parse an `if|unless ... [else if|unless...]... [else]` block.
  ###
  parseConditional: ->
    if tok = @read IDENT, ['if', 'unless']
      @makeNode Conditional, (node) ->
        node.start = tok.start
        node.negate = tok.value is 'unless'
        @parseConditionalPredicate node

  ###
  ###
  parseWith: ->
    if token = @read IDENT, 'with'
      @makeNode With, (node) ->
        node.start = token.start
        unless node.reference = (@parseExpression 0, no)
          throw new SyntaxError 'Expected expression after `with`'
        unless block = @parseBlock()
          throw new SyntaxError 'Expected block after `while` expression'
        node.body = block.body
        node.end = block.end

  ###
  Parse a `loop|while|until ...` block.
  ###
  parseLoop: ->
    if token = @read IDENT, ['while', 'until']
      @moveTo token.start
      @makeNode Loop, (node) ->
        @moveTo token.end
        node.negate = token.value is 'until'
        unless node.condition = (@parseExpression 0, no)
          throw new SyntaxError (
            "Expected expression after `#{token.value}`"
          )

        unless node.block = @parseBlock()
          throw new SyntaxError (
            "Expected block after `#{token.value}` expression"
          )

        node.end = node.block.end

  ###
  Parses a `for .. in ...` block.
  ###
  parseFor: ->
    if tok = @read IDENT, 'for'
      @makeNode For, (f) ->
        f.start = tok.start
        @moveTo tok.end

        arg = @expect IDENT

        if @eat PUNC, ','
          f.key = arg
          f.value = @expect IDENT
        else
          f.value = arg

        @expect IDENT, 'in'

        unless f.expression = @parseExpression 0, no
          throw new SyntaxError "Expected expression after for ... in"

        unless f.block = @parseBlock()
          throw new SyntaxError "Expected block after for ... in expression"

  ###
  ###
  parseBreak: ->
    if tok = @read IDENT, 'break'
      @makeNode Break, (br) ->
        br.start = tok.start
        br.depth = @parseExpression()

  ###
  ###
  parseContinue: ->
    if tok = @read IDENT, 'continue'
      @makeNode Continue, (cont) ->
        cont.start = tok.start
        cont.depth = @parseExpression()

  parseReturn: ->
    if tok = @read IDENT, 'return'
      @makeNode Return, (ret) ->
        ret.start = tok.start
        ret.expression = @parseExpression()

  ###
  ###
  parseImport: ->
    if tok = (@read IDENT, 'import')
      @makeNode Import, (imp) ->
        imp.start = tok.start
        imp.arguments = []

        while arg = @parseExpression 0, no, no, no
          if @read IDENT, 'as'
            as = (@expect IDENT).value
          else
            as = '&'
          imp.arguments.push [as, arg]
          break unless @eat PUNC, ','

        unless imp.arguments.length
          throw new SyntaxError "Expected string after import!"

  ###
  ###
  parseUse: ->
    if tok = @read IDENT, ['use', 'dont-use']
      @makeNode Use, (use) ->
        use.start = tok.start
        use.dont = tok.value is 'dont-use'
        unless use.arguments = @parseCommaList()
          throw new SyntaxError "Expected `use` arguments"

  ###
  Inside a block body, any of the valid statements, delimited with new lines or
  semicolons.
  ###
  parseStatement: ->
    @parseConditional() or
    @parseLoop() or
    @parseFor() or
    @parseReturn() or
    @parseBreak() or
    @parseContinue() or
    @parseWith() or
    @parseImport() or
    @parseUse() or
    @parseDeclaration() or
    @parseExpression()

  parseBody: ->
    stmts = []

    loop
      @eatAll PUNC, ';'
      @skipWhitespace() # TODO I'd like to remove this
      break unless stmt = @parseStatement()
      stmts.push stmt
      @expect PUNC, ';' unless @isEndOfBlock() or @isEndOfLine()

    stmts

  ###
  Parse a block and all its sublocks.
  ###
  parseBlock: ->
    if brace = @read PUNC, '{'
      @makeNode Block, (block) ->
        block.start = brace.start
        block.body = @parseBody()
        @expect PUNC, '}'

  ###
  ###
  parseRoot: ->
    @makeNode Root, (doc) ->
      doc.source = @source
      doc.body = @parseBody()

  parse: (source) ->
    @prepare source
    @parseRoot()

module.exports = Parser
