Object     = require '../object'
Boolean    = require './boolean'
ValueError = require '../error/value'


FACTORS = {}

###
###
class Number extends Object

  {ceil, floor, abs, pow, sin, cos, tan, asin, acos, atan} = Math

  round = (number, places = 0) ->
    m = pow 10, places
    return Math.round(number * m) / m

  RE_NUMERIC = /^\s*([\+-]?(?:\d*\.)?\d+)\s*(%|(?:[a-z]+))?\s*$/i

  @define: (from, to) ->
    unless from instanceof Number
      from = @fromString from

    unless to instanceof Number
      to = @fromString to

    if from.unit and to.unit
      if from.unit isnt to.unit
        FACTORS[from.unit] ?= {}
        FACTORS[from.unit][to.unit] = to.value / from.value

        FACTORS[to.unit] ?= {}
        FACTORS[to.unit][from.unit] = from.value / to.value

      else if from.value isnt to.value
        throw new ValueError "Bad unit definition"

      return to

    throw new ValueError "Bad unit definition"

  @isDefined: (unit) -> unit of FACTORS

  @fromString: (str) ->
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

  @convert: (value, from_unit, to_unit = null, stack = []) ->
    if to_unit is from_unit or (to_unit and not from_unit)
      return value
    else if not to_unit
      return value
    else if from_unit of FACTORS
      if to_unit of FACTORS[from_unit]
        return value * FACTORS[from_unit][to_unit]
      else
        stack.push from_unit

        for u of FACTORS[from_unit]
          unless u in stack
            stack.push u
            val = FACTORS[from_unit][u] * value
            try
              return @convert val, u, to_unit, stack
            stack.pop()

        stack.pop()

    throw new ValueError "Cannot convert #{value}#{from_unit} to #{to_unit}"

  ###
  ###
  convert: (unit = null) ->
    if unit
      unit = unit.toString().trim()

    value = @class.convert @value, @unit, unit

    return @copy value, unit

  ###
  ###
  negate: -> @copy -1 * @value

  ###
  ###
  isEqual: (other) ->
    other instanceof Number and
    try round(other.convert(@unit).value, 10) is round(@value, 10)

  compare: (other) ->
    if other instanceof Number
      other = other.convert @unit
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
    if other instanceof Number
      return @copy @convert(other.unit).value + other.value, other.unit or @unit

    throw new ValueError (
      """
      Cannot perform #{@repr()} + #{other.repr()}: \
      right side must be a #{Number.repr()}
      """
    )

  '.-': (context, other) ->
    if other instanceof Number
      return @copy @convert(other.unit).value - other.value, other.unit or @unit

    throw new ValueError (
      """
      Cannot perform #{@repr()} - #{other.repr()}: \
      right side must be a #{Number.repr()}
      """
    )

  '.*': (context, other) ->

    if other instanceof Number
      if @isPure() or other.isPure()
        # TODO should fail for incompatible units
        return @copy other.value * @value, other.unit or @unit

      throw new ValueError """
        Cannot perform #{@repr()} * #{other.repr()}
        """

    throw new ValueError """
      Cannot perform #{@repr()} * #{other.repr()}: \
      right side must be a #{Number.repr()}
      """

  './': (context, other) ->
    if other instanceof Number
      if other.value is 0
        throw new ValueError 'Cannot divide by 0'
      if !@isPure() and !other.isPure()
        return @copy @value / other.convert(@unit).value, null
      else
        return @copy @value / other.value, @unit or other.unit

    throw new ValueError (
      """
      Cannot perform #{@repr()} / #{other.repr()}: \
      right side must be a #{Number.repr()}
      """
    )

  '.unit?': -> Boolean.new @unit

  '.pure?': -> Boolean.new @isPure()

  '.pure': -> new Number @value

  '.zero?': -> Boolean.new @value is 0

  '.integer?': -> Boolean.new @isInteger()

  '.decimal?': -> Boolean.new @value % 1 isnt 0

  '.divisible-by?': (context, other) ->
    unless other.isPure()
      try
        other = other.convert @unit
      catch
        return Boolean.false

    div = @value / other.value

    Boolean.new div is floor div

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

    @convert unit

Object::toNumber = -> throw new Error "Cannot convert #{@repr()} to number"

Boolean::toNumber = -> new Number (if @value then 1 else 0)

Object::['.number'] = -> @toNumber()

###
TODO: This should go to the `css-units` module.
###
Number.define frm, to for frm, to of {
  '1cm':     '10mm'
  '40q':     '1cm'
  '1in':     '25.4mm'
  '96px':    '1in'
  '72pt':    '1in'
  '1pc':     '12pt'
  '180deg':  "#{Math.PI}rad"
  '1turn':   '360deg'
  '400grad': '1turn'
  '1s':      '1000ms'
  '1kHz':    '1000Hz'
  '1dppx':   '96dpi'
  '1dpcm':   '2.54dpi'
}

module.exports = Number
