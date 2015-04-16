Object = require '../object'
Null   = require './null'
Number = require './number'

NotImplementedError = require '../../error/not-implemented'

class Enumerable extends Object

  length: -> throw new NotImplementedError

  get: (key) -> throw new NotImplementedError

  reset: -> throw new NotImplementedError

  next: -> throw new NotImplementedError

  currentValue: -> @get @currentKey()

  currentKey: -> throw new NotImplementedError

  firstKey: -> throw new NotImplementedError

  lastKey: -> throw new NotImplementedError

  each: -> throw new NotImplementedError

  firstValue: ->
    @get @firstKey()

  lastValue: -> @get @lastKey()

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

  ###
  '.min': -> @minValue() or Null.null

  '.max': -> @maxValue() or Null.null

  ###

module.exports = Enumerable
