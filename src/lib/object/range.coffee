Indexed   = require './indexed'
List      = require './list'
Number    = require './number'
String    = require './string'
TypeError = require '../error/type'

class Range extends Indexed

  {abs, floor} = Math

  @property 'items',
    get: -> ([@min..@max]).map (item) => new Number item, @unit

  @property 'resolution',
    get: -> if @min >= @max then -1 else 1

  length: -> 1 + abs (@max - @min)

  getByIndex: (index) -> new Number @min + index * @resolution

  constructor: (@min = 0, @max = 0, @unit = null) ->
    super()
    @min = floor @min
    @max = floor @max

  ###
  TODO this is buggy
  ###
  '.<<': (args...) ->
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

    return @

  convert: (unit) ->
    if unit isnt ''
      @unit = unit
    else
      @unit = null

    return @

  ###
  TODO this is buggy
  ###
  contains: (other) ->
    try
      other = other.convert @unit
      @min <= other.value <= @max
    catch
      no

  clone: (min = @min, max = @max, unit = @unit, etc...) ->
    super min, max, unit, etc...

  reprValue: -> "#{@min}..#{@max}"

  '.convert': (args...) -> @convert args...

  '.list': -> new List @items

  '.random': ->
    min = Math.min @max, @min
    max = Math.max @max, @min

    new Number min + (Math.floor Math.random() * (max - min + 1))

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
  supah = List::['.::']

  List::['.::'] = (other, etc...) ->
    if other instanceof Range
      slice = @clone []
      for idx in other.items
        slice.items.push @['.::'] idx
      slice
    else
      supah.call @, other, etc...

do ->
  {min, max} = Math

  supah = String::['.::']

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
      supah.call @, other, etc...

module.exports = Range
