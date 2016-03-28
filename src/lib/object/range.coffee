Indexed   = require './indexed'
Boolean   = require './boolean'
List      = require './list'
Number    = require './number'
String    = require './string'
TypeError = require '../error/type'

class Range extends Indexed

  { min, max, abs, floor } = Math

  @property 'items',
    get: -> ([@first..@last]).map (item) => new Number item, @unit

  @property 'resolution',
    get: -> if @first > @last then -1 else 1

  isReverse: -> @resolution < 0

  length: -> 1 + abs (@last - @first)

  minValue: -> new Number min @first, @last

  maxValue: -> new Number max @first, @last

  getByIndex: (index) -> new Number @first + index * @resolution

  constructor: (@first = 0, @last = 0, @unit = null) ->
    super()
    @first = floor @first
    @last = floor @last

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
      @minValue() <= other.value <= @maxValue()
    catch
      no

  clone: (first = @first, last = @last, unit = @unit, etc...) ->
    super first, last, unit, etc...

  reprValue: -> "#{@first}..#{@last}"

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

    @first = Math.min @first, vals...
    @last = Math.max @last, vals...

    return @

  '.convert': (args...) -> @convert args...

  '.reverse?': -> Boolean.new @isReverse()

  '.reverse': -> @clone @last, @first

  '.list': -> new List @items

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
  { min, max } = Math

  supah = String::['.::']

  String::['.::'] = (other, etc...) ->
    if other instanceof Range
      str = ''
      if @value isnt ''
        len = @value.length

        end = other.last + 1
        end += len if end < 0
        end = min end, (len - 1)

        idx = other.first
        idx += len if idx < 0
        idx = max -len, idx

        while idx isnt end
          str += @value.charAt idx
          idx = (idx + 1) % len
      @clone str
    else
      supah.call @, other, etc...

module.exports = Range
