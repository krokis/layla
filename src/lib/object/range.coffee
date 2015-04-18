List      = require './list'
Number    = require './number'
String    = require './string'
TypeError = require '../error/type'

# TODO this should *not* extend List. This should extend `Indexed`
class Range extends List

  {abs, floor} = Math

  min: 0
  max: 0
  resolution: 1
  unit: null

  @property 'items',
    get: -> ([@min..@max]).map (item) => new Number item, @unit

  length: -> 1 + abs (@max - @min)

  constructor: (@min = 0, @max = 0, @unit = null, @resolution = 1) ->
    super()
    @min = floor @min
    @max = floor @max

  push: (args...) ->
    # TODO check units
    vals = []
    for arg in args
      unless arg instanceof Number
        throw new TypeError "Cannot add that to a range"

      if arg.unit and not @unit
        @unit = arg.unit
      else
        arg = arg.convert @unit

      vals.push floor arg.value

    @min = Math.min @min, vals...
    @max = Math.max @max, vals...

    super

  convert: (unit) ->
    if unit isnt ''
      @unit = unit
    else
      @unit = null

    return @

  '.<<': (other) ->
    # TODO do a custom, faster << method
    super

  contains: (other) ->
    try
      other = other.convert @unit
      @min <= other.value <= @max
    catch
      no

  clone: (min = @min, max = @max, unit = @unit) ->
    new @constructor min, max, unit

  '.convert': (args...) -> @convert args...

Number::['...'] = (other) ->
  if other instanceof Number
    if @unit
      other = other.convert @unit
      unit = @unit
    else if other.unit
      unit = other.unit
    else
      unit = null

    return new Range @value, other.value, unit

  throw new TypeError "Cannot make a range with that: #{other.type}"

do ->
  {min, max} = Math

  _paamayim = String::['.::']

  String::['.::'] = (other, etc...) ->
    if other instanceof Range
      str = ''
      if @value isnt ''
        len = @value.length

        end = other.max + 1
        end += len if end < 0
        end = min end, (len - 1)

        idx = other.min
        idx += len if idx < 0
        idx = max -len, idx

        while idx isnt end
          str += @value.charAt idx
          idx = (idx + 1) % len
      @clone str
    else
      _paamayim.call this, other, etc...

module.exports = Range
