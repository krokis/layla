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

  '.length': -> Number.new @length()

  '.first': -> Null.ifNull @firstValue()

  '.last': -> Null.ifNull @lastValue()

  '.random': -> Null.ifNull @randomValue()

  '.min': -> Null.ifNull @minValue()

  '.max': -> Null.ifNull @maxValue()

Object::isEnumerable = -> no


module.exports = Enumerable
