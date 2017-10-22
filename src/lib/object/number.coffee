Object     = require '../object'
Boolean    = require './boolean'
ValueError = require '../error/value'


###
###
class Number extends Object

  {ceil, floor, abs, pow, sin, cos, tan, asin, acos, atan} = Math

  round = (number, places = 0) ->
    m = pow 10, places
    return Math.round(number * m) / m

  RE_NUMERIC = /^\s*([\+-]?(?:\d*\.)?\d+)\s*(%|(?:[a-z]+))?\s*$/i

  @define: (from, to, context) ->
    unless from instanceof Number
      from = @fromString from, context

    unless to instanceof Number
      to = @fromString to, context

    to = to.clone()

    if from.unit and to.unit
      if from.unit isnt to.unit
        factors = {}

        if context.has '__UNITS__'
          global.Object.assign factors, context.get('__UNITS__')

        factors[from.unit] ?= {}
        factors[from.unit][to.unit] = to.value / from.value

        factors[to.unit] ?= {}
        factors[to.unit][from.unit] = from.value / to.value

        context.set '__UNITS__', factors

      else if from.value isnt to.value
        throw new ValueError "Bad unit definition"

      return to

    throw new ValueError "Bad unit definition"

  @isDefined: (context, unit) ->
    if context.has '__UNITS__'
      factors = context.get '__UNITS__'

      return unit of factors

    return no

  @fromString: (str, context) ->
    try
      str = str.toString()

      if match = RE_NUMERIC.exec str
        value = parseFloat match[1]
        unit = match[2]
        return new Number value, unit

    throw new ValueError "Could not convert \"#{str}\" to #{@reprType()}"

  constructor: (value = 0, @unit = null) ->
    super()
    @value = parseFloat value.toString()

  doConvert = (value, from_unit, to_unit, factors, stack) ->
    if from_unit of factors
      if to_unit of factors[from_unit]
        return value * factors[from_unit][to_unit]
      else
        stack.push from_unit

        for u of factors[from_unit]
          unless u in stack
            stack.push u
            val = factors[from_unit][u] * value
            try
              return doConvert val, u, to_unit, factors, stack
            stack.pop()

        stack.pop()

    throw new ValueError "Cannot convert #{value}#{from_unit} to #{to_unit}"

  @convert: (value, from_unit, to_unit = null, context) ->
    if to_unit is from_unit or (to_unit and not from_unit)
      return value
    else if not to_unit
      return value

    factors = if context?.has('__UNITS__') then context.get('__UNITS__') else {}

    return doConvert value, from_unit, to_unit, factors, []

  ###
  ###
  convert: (unit = null, context) ->
    if unit
      unit = unit.toString().trim()

    value = @class.convert @value, @unit, unit, context

    return @copy value, unit

  ###
  ###
  negate: -> @copy -1 * @value

  ###
  ###
  isEqual: (other, context) ->
    other instanceof Number and
    try round(other.convert(@unit, context).value, 10) is round(@value, 10)

  compare: (other, context) ->
    if other instanceof Number
      other = other.convert @unit, context
      if other.value is @value
        return 0
      else if other.value > @value
        return 1
      else
        return -1

    throw new ValueError (
      """
      Cannot compare #{@repr()} with #{other.repr()}: \
      that's not a [Number]
      """
    )

  isPure: -> not @unit

  isInteger: -> @value % 1 is 0

  isEmpty: -> @value is 0

  isPositive: -> @value > 0

  isNegative: -> @value < 0

  # http://www.javascripter.net/faq/numberisprime.htm
  isPrime: ->
    n = @value

    if n < 2 or n % 1
      return no

    if not (n % 2)
      return n is 2

    if not (n % 3)
      return n is 3

    i = 5
    m = Math.sqrt n

    while i <= m
      if not (n % i)
        return no

      if not (n % (i + 2))
        return no

      i += 6

    return yes

  toNumber: -> @clone()

  toString: ->
    str = "#{@value}"
    str += @unit if @unit

    return str

  reprValue: -> "#{@value}#{@unit or ''}"

  clone: -> @

  copy: (value = @value, unit = @unit) ->
    super value, unit

  ZERO = @ZERO = new @ 0
  TWO  = @TWO  = new @ 2
  TEN  = @TEN  = new @ 10
  ONE_HUNDRED_PERCENT = @ONE_HUNDRED_PERCENT = new @ 100, '%'
  FIFTY_PERCENT = @FIFTY_PERCENT = new @ 50, '%'
  TEN_PERCENT = @TEN_PERCENT = new @ 10, '%'

  '.+@': -> @clone()

  '.-@': -> @copy -@value

  '.+': (context, other) ->
    unless other instanceof Number
      throw new ValueError """
        Cannot perform #{@repr()} + #{other.repr()}: \
        right side must be a #{Number.repr()}
        """

    value = @convert(other.unit, context).value + other.value
    unit = other.unit or @unit

    return @copy value, unit

  '.-': (context, other) ->
    unless other instanceof Number
      throw new ValueError """
        Cannot perform #{@repr()} - #{other.repr()}: \
        right side must be a #{Number.repr()}
        """

    value = @convert(other.unit, context).value - other.value
    unit = other.unit or @unit

    return @copy value, unit

  '.*': (context, other) ->
    unless other instanceof Number
      throw new ValueError """
        Cannot perform #{@repr()} * #{other.repr()}: \
        right side must be a #{Number.repr()}
        """

    if not (@isPure() or other.isPure())
      throw new ValueError """
        Cannot perform #{@repr()} * #{other.repr()}
        """

    # TODO should fail for incompatible units
    return @copy other.value * @value, other.unit or @unit

  './': (context, other) ->
    unless other instanceof Number
      throw new ValueError """
        Cannot perform #{@repr()} / #{other.repr()}: \
        right side must be a #{Number.repr()}
        """

    if other.value is 0
      throw new ValueError 'Cannot divide by 0'

    if !@isPure() and !other.isPure()
      value = @value / other.convert(@unit, context).value
      unit = ''
    else
      value = @value / other.value
      unit = @unit or other.unit

    return @copy value, unit

  '.unit?': -> Boolean.new @unit

  '.pure?': -> Boolean.new @isPure()

  '.pure': -> new Number @value

  '.zero?': -> Boolean.new @value is 0

  '.integer?': -> Boolean.new @isInteger()

  '.decimal?': -> Boolean.new @value % 1 isnt 0

  '.divisible-by?': (context, other) ->
    unless other.isPure()
      try
        other = other.convert @unit, context
      catch
        return Boolean.FALSE

    div = @value / other.value

    return Boolean.new div is floor(div)

  '.even?': -> Boolean.new @value % 2 is 0

  '.odd?': -> Boolean.new @value % 2 isnt 0

  '.sign': ->
    if @value is 0
      sign = 0
    else if @value > 0
      sign = 1
    else
      sign = -1

    return new @class sign

  '.positive?': -> Boolean.new @isPositive()

  '.positive': -> @copy abs(@value)

  '.negative': -> @copy -1 * abs(@value)

  '.negate': -> @negate()

  '.negative?': -> Boolean.new @isNegative()

  '.round': (context, places = ZERO) ->
    @copy round(@value, places.value)

  '.ceil': ->  @copy ceil(@value)

  '.floor': -> @copy floor(@value)

  '.abs': -> @copy abs(@value)

  '.pow': (context, exp = TWO) -> @copy pow(@value, exp.value)

  '.sq': -> @['.pow'] TWO

  '.root': (context, deg = TWO) ->
    if @value < 0
      throw new ValueError """
      Cannot make #{deg.value}th root of #{@repr()}: Base cannot be negative
      """
    @copy pow(@value, 1 / (deg.value))

  '.sqrt': -> @['.root'] TWO

  '.mod': (context, other) ->
    if other.value is 0
      throw new ValueError 'Cannot divide by 0'
    @copy @value % other.value

  '.sin': -> @copy sin(@value)

  '.cos': -> @copy cos(@value)

  '.tan': -> @copy tan(@value)

  '.asin': -> @copy asin(@value)

  '.acos': -> @copy acos(@value)

  '.atan': -> @copy atan(@value)

  '.prime?': -> Boolean.new @isPrime()

  '.convert': (context, unit) ->
    if unit.isNull()
      unit = null
    else
      unit = unit.toString()

    @convert unit, context

Object::toNumber = -> throw new Error "Cannot convert #{@repr()} to number"

Boolean::toNumber = -> new Number (if @value then 1 else 0)

Object::['.number'] = -> @toNumber()


module.exports = Number
