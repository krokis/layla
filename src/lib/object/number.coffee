Object     = require '../object'
Null       = require './null'
Boolean    = require './boolean'
TypeError  = require '../error/type'
RangeError = require '../error/range'

FACTORS = {}
DERIVED = {}

###
TODO use some arbitrary precission library; I cannot stand `10 - 9.9` being
`0.09999999999999964`
###
class Number extends Object

  {round, ceil, floor, abs, pow, sin, cos, tan, asin, acos, atan} = Math

  RE_NUMERIC = /^\s*([\+-]?(?:\d*\.)?\d+)\s*(%|(?:[a-z]+))?\s*$/i

  @define: (from, to, derived = no) ->
    unless from instanceof Number
      from = @fromString from

    unless to instanceof Number
      to = @fromString to

    if from.unit and to.unit
      if from.unit isnt to.unit
        # Now check from.unit has not been defined before. If it is, throw an
        # error if passed factor doesn't match existing.
        if derived
          DERIVED[from.unit] = to.unit
        else
          delete DERIVED[from.unit]

        FACTORS[from.unit] ?= {}
        FACTORS[from.unit][to.unit] = to.value / from.value

        FACTORS[to.unit] ?= {}
        FACTORS[to.unit][from.unit] = from.value / to.value

      else if from.value isnt to.value
        throw new TypeError "Bad unit definition"

      return to

    throw new TypeError "Bad unit definition"

  @isDefined: (unit) -> unit of FACTORS

  @fromString: (str) ->
    try
      str = str.toString()
      if match = RE_NUMERIC.exec str
        return new Number (parseFloat match[1]), match[2]

    throw new TypeError "Could not convert \"#{str}\" to #{@reprType()}"

  constructor: (value = 0, unit) ->
    @value = parseFloat value.toString()

    if unit?
      @unit = unit
      if DERIVED[unit]
        try return @convert DERIVED[unit]
    else
      @unit = null

  ###
  ###
  convert: (unit = null, stack = []) ->
    unit = unit.toString().trim() if unit

    if unit is @unit or (unit and not @unit)
      return new Number @value, unit
    else if not unit
      return new Number @value
    else if @unit of FACTORS
      if unit of FACTORS[@unit]
        return new Number @value * FACTORS[@unit][unit], unit
      else
        stack.push @unit
        for u of FACTORS[@unit]
          unless u in stack
            stack.push u
            value = FACTORS[@unit][u] * @value
            try
              return (new Number value, u).convert unit, stack
            stack.pop()

        stack.pop()

    throw new TypeError "Cannot convert #{this} to #{unit}"

  ################
  # TODO TODO TODO
  # Super temporary. USE an arbitrary precision library
  #
  isEqual: (other) ->
    other instanceof Number and
    try (round (other.convert @unit).value, 10) is (round @value, 10)

  compare: (other) ->
    if other instanceof Number
      other = other.convert @unit
      if other.value is @value
        0
      else if other.value > @value
        1
      else
        -1
    else
      throw new TypeError (
        """
        Cannot compare #{this.repr()} with #{other.repr()}: \
        that's not a [Number]
        """
      )

  isPure: -> @unit is null

  isEmpty: -> @value is 0

  toNumber: -> @clone()

  toString: ->
    str = "#{@value}"
    str += @unit if @unit
    str

  toJSON: ->
    json = super
    json.value = @value
    json.unit = @unit
    json

  reprValue: -> "#{@value}#{@unit or ''}"

  clone: (value = @value, unit = @unit, etc...) -> super value, unit, etc...

  ZERO = @ZERO = new @ 0
  TWO  = @TWO  = new @ 2
  TEN  = @TEN  = new @ 10

  '.+@': -> @clone()

  '.-@': -> @clone -@value

  '.+': (other) ->
    if other instanceof Number
      @clone (@convert other.unit).value + other.value, other.unit or @unit
    else
      throw new TypeError (
        """
        Cannot perform #{this.repr()} + #{other.repr()}: \
        that's not a [Number]
        """
      )

  '.-': (other) ->
    if other instanceof Number
      @clone (@convert other.unit).value - other.value, other.unit or @unit
    else
      throw new TypeError (
        """
        Cannot perform #{this.repr()} - #{other.repr()}: \
        that's not a [Number]
        """
      )

  '.*': (other) ->
    if other instanceof Number
      # TODO should fail for incompatible units
      @clone (other.convert @unit).value * @value, other.unit or @unit
    else
      throw new TypeError (
        """
        Cannot perform #{this.repr()} * #{other.repr()}: \
        that's not a [Number]
        """
      )

  './': (other) ->
    if other instanceof Number
      if other.value is 0
        throw new TypeError 'Cannot divide by 0'
      @clone (@convert other.unit).value / other.value, other.unit or @unit
    else
      throw new TypeError (
        """
        Cannot perform #{this.repr()} / #{other.repr()}: \
        that's not a [Number]
        """
      )

  '.unit?': -> Boolean.new @unit

  '.pure?': -> Boolean.new @isPure()

  '.pure': -> new Number @value

  '.zero?': -> Boolean.new @value is 0

  '.integer?': -> Boolean.new @value % 1 is 0

  '.decimal?': -> Boolean.new @value % 1 isnt 0

  '.divisible-by?': (other) -> Boolean.new (@value % other.value) is 0

  '.even?': -> Boolean.new @value % 2 is 0

  '.odd?': -> Boolean.new @value % 2 isnt 0

  '.positive?': -> Boolean.new @value > 0

  '.positive': -> @clone abs @value

  '.negative': -> @clone -1 * (abs @value)

  '.negate': -> @clone -1 * @value

  '.negative?': -> Boolean.new @value < 0

  '.round': (places = ZERO) ->
    m = pow 10, places.value
    @clone (round (@value * m)) / m

  '.ceil': ->  @clone ceil @value

  '.floor': -> @clone floor @value

  '.abs': -> @clone abs @value

  '.pow': (exp = TWO) -> @clone pow @value, exp.value

  '.sq': -> @['.pow'] TWO

  '.root': (deg = TWO) ->
    if @value < 0
      throw new TypeError """
      Cannot make #{deg.value}th root of #{@repr()}: Base cannot be negative
      """
    @clone pow @value, 1 / (deg.value)

  '.sqrt': -> @['.root'] TWO

  '.mod': (other) ->
    if other.value is 0
      throw new TypeError 'Cannot divide by 0'
    @clone @value % other.value

  '.sin': -> @clone sin @value

  '.cos': -> @clone cos @value

  '.tan': -> @clone tan @value

  '.asin': -> @clone asin @value

  '.acos': -> @clone acos @value

  '.atan': -> @clone atan @value

  '.convert': (unit) -> @convert unit

Object::toNumber = -> throw new Error "Cannot convert #{@repr()} to number"

Boolean::toNumber = -> new Number (if @value then 1 else 0)

Object::['.number'] = -> @toNumber()

###
TODO: This should go to the `css-units` module.
###
Number.define from, to for from, to of {
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
