Object = require '../object'
Null   = require './null'
Number = require './number'

class Enumerable extends Object

  length: -> @NOT_IMPLEMENTED

  get: (key) -> @NOT_IMPLEMENTED

  reset: -> @NOT_IMPLEMENTED

  next: -> @NOT_IMPLEMENTED

  currentValue: -> @get @currentKey()

  currentKey: -> @NOT_IMPLEMENTED

  firstKey: -> @NOT_IMPLEMENTED

  lastKey: -> @NOT_IMPLEMENTED

  randomKey: -> @NOT_IMPLEMENTED

  each: -> @NOT_IMPLEMENTED

  firstValue: -> @get @firstKey()

  lastValue: -> @get @lastKey()

  randomValue: -> @get @randomKey()

  minValue: ->
    min = null
    @each (item) ->
      min = item if min is null or (item.compare min) is 1
    min

  maxValue: ->
    max = null
    @each (item) ->
      max = item if max is null or (item.compare max) is -1
    max

  isEmpty: -> @length() is 0

  '.::': @::get

  '.length': -> new Number @length()

  '.first': -> @firstValue() or Null.null

  '.last': -> @lastValue() or Null.null

  '.random': -> @randomValue() or Null.null

  ###
  '.min': -> @minValue() or Null.null
  '.max': -> @maxValue() or Null.null
  ###

module.exports = Enumerable
