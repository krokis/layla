Call       = require './call'
Number     = require './number'
ValueError = require '../error/value'


###
###
class Calc extends Call

  RE_TOKEN = /^(([\(\)\+\-\*\/])|(\s+)|([^\(\)\+\-\*\/\s]+))/

  UNARY_OPERATORS = [ '+', '-' ]

  BINARY_OPERATORS = ['+', '-', '/', '*']

  OPERATOR_PRECEDENCE =
    '+@':  900
    '-@':  900
    '*' :  500
    '/' :  500
    '+' :  450
    '-' :  450

  class CalcExpression

    constructor: (@type, props = {}) ->
      global.Object.assign @, props

    # Unary `+` does *nothing* actually.
    '+@': -> @

    '-@': ->
      new CalcExpression 'operation', {
        right: @
        operator: '-'
        binary: no
      }

    BINARY_OPERATORS.forEach (op) ->
      CalcExpression::[op] = (right) ->
        new CalcExpression 'operation', {
          left: @
          right: right
          operator: op
          binary: yes
        }

    toString: ->
      str = ''
      str += '('

      if @type is 'operation'

        if @binary
          str += '(' + @left.toString() + ')'
          str += ' ' + @operator + ' '
          str += '(' + @right.toString() + ')'
        else
          str += @operator + @right.toString()
      else if @type is 'literal'
        str += @value.toString()

      str += ')'

      return str

  class CalcParser

    error: (message = '') ->
      message = "Invalid calc() expression" +
                if message then ": #{message}." else ''

      throw new ValueError message

    move: ->
      @tokens.shift()

    eat: (type) ->
      if @tokens[0].type is type
        return @move()

    expect: (type) ->
      @eat(type) or @error "Expected #{type}"

    tokenize: (expression) ->
      tokens = []
      braces = 0

      while match = expression.match RE_TOKEN
        match = match[0]
        expression = expression[match.length...]
        match = match.trim()
        token = null

        switch match
          when '('
            braces++
          when ')'
            braces--
            if braces < 0
              @error("Unmatched `)`")
          when ''
            continue
          when '+', '-', '/', '*'
            break # TODO Needed?
          else
            try
              token =
                type: 'number'
                value: Number.fromString(match).toString()
            catch e
              @error("Unexpected `#{match}`")

        if not token
          token =
            type: match
            value: match

        tokens.push token

      if expression.length
        @error()

      tokens.push {
        type: 'eof'
        value: ''
      }

      return tokens

    peekBinaryOperator: ->
      if @tokens[0].type in BINARY_OPERATORS
        return @tokens[0]

    parseRightOperation: (left, prec = 0) ->
      next_op = @peekBinaryOperator()

      while next_op and OPERATOR_PRECEDENCE[next_op.value] > prec
        op = @move()
        right = @parsePrimaryExpression()

        unless right
          @error "Expected right side of `#{op.value}` unary operation"

        next_op = @peekBinaryOperator()

        while next_op
          next_prec = OPERATOR_PRECEDENCE[next_op.value]
          op_prec = OPERATOR_PRECEDENCE[op.value]

          break unless next_prec > op_prec

          right = @parseRightOperation right, op_prec

          next_op = @peekBinaryOperator()

        left = new CalcExpression 'operation', {
          left: left,
          right: right,
          operator: op.value,
          binary: yes
        }

      return left

    parseUnaryOperation: (precedence = 0) ->
      if @tokens[0].type in UNARY_OPERATORS
        op = @tokens[0].value
        @move()
        prec = OPERATOR_PRECEDENCE["#{op}@"]

        if prec >= precedence
          right = @parseExpression prec

          unless right
            @error "Expected right side of `#{op}` binary operation"

          return new CalcExpression 'operation', {
            right: right,
            operator: op,
            binary: no
          }

    parseLiteralNumber: ->
      if number = @eat('number')
        return new CalcExpression 'literal', {
          value: Number.fromString(number.value)
        }

    parseLiteral: -> @parseLiteralNumber()

    parsePrimaryExpression: ->
      @parseGroup() or @parseLiteral()

    parseGroup: ->
      if @tokens[0].type is '('
        @move()
        expression = @parseExpression()
        @expect ')'

        return expression

    parseExpression: (precedence = 0) ->
      left = @parseUnaryOperation(precedence) or @parsePrimaryExpression()

      if left
        return @parseRightOperation left, precedence

      @error 'Unrecognized syntax'

    parse: (expression) ->
      @tokens = @tokenize expression
      expression = @parseExpression()

      @expect 'eof'

      return expression

  @fromNumber: (number) ->
    expression = new CalcExpression 'literal', value: number

    return new @ undefined, expression

  @parse: (expression) ->
    (new CalcParser).parse expression

  constructor: (@name, expression = '') ->
    super()

    unless expression instanceof CalcExpression
      expression = @class.parse expression.toString()

    @expression = expression

  op: (operator, other = null, context = null) ->
    if other?
      if other instanceof Number
        other = @class.fromNumber other

      unless other instanceof Calc
        throw new ValueError "Cannot perform #{@repr()} + #{other.repr()}"

    expression = @expression[operator] other?.expression

    return @copy undefined, expression

  clone: -> @

  copy: (name = @name, expression = @expression, etc...) ->
    super name, expression, etc...

  toString: -> @expression.toString()

  UNARY_OPERATORS.forEach (op) ->
    Calc::[".#{op}@"] = ->
      @op "#{op}@"

  BINARY_OPERATORS.forEach (op) ->
    Calc::[".#{op}"] = (context, other) ->
      @op op, other, context


module.exports = Calc
