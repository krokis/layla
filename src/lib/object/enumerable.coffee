Object = require '../object'
Null   = require './null'
Number = require './number'

###
###
class Enumerable extends Object

  length: -> @NOT_IMPLEMENTED

  get: (key) -> @NOT_IMPLEMENTED

  reset: -> @NOT_IMPLEMENTED

  next: -> @NOT_IMPLEMENTED

  currentValue: -> @get @currentKey()

  currentKey: -> @NOT_IMPLEMENTED

  firstKey: -> @NOT_IMPLEMENTED

  lastKey: -> @NOT_IMPLEMENTED

  hasKey: (key) -> @NOT_IMPLEMENTED

  randomKey: -> @NOT_IMPLEMENTED

  each: -> @NOT_IMPLEMENTED

  firstValue: -> @get @firstKey()

  lastValue: -> @get @lastKey()

  randomValue: -> @get @randomKey()

  minValue: ->
    min = null
    @each (i, item) ->
      min = item if min is null or (item.compare min) is 1

    return min

  maxValue: ->
    max = null
    @each (i, item) ->
      max = item if max is null or (item.compare max) is -1

    return max

  isEmpty: -> @length() is 0

  isEnumerable: -> yes

  '.::': @::get

  '.length': -> new Number @length()

  '.first': -> @firstValue() or Null.NULL

  '.last': -> @lastValue() or Null.NULL

  '.random': -> @randomValue() or Null.NULL

  '.min': -> @minValue() or Null.NULL

  '.max': -> @maxValue() or Null.NULL

Object::isEnumerable = -> no


module.exports = Enumerable
