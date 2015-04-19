Enumerable = require './enumerable'
Null       = require './null'
Number     = require './number'

class Indexed extends Enumerable

  reset: -> @index = 0

  firstKey: -> if @length() then 0 else null

  lastKey: -> if 0 < (length = @length()) then length - 1 else null

  currentKey: ->
    if 0 <= @index < @length()
      @index
    else
      null

  next: ->
    if 0 <= @index <= @length()
      @index++

  getByIndex: @NOT_IMPLEMENTED

  get: (key) ->
    if ('number' is typeof (key + 0)) and (0 <= key < @length())
      @getByIndex key
    else
      null

  each: (cb) ->
    @reset()

    while null isnt (key = @currentKey())
      index = new Number key
      value = (@get key) or Null.null
      return no if no is cb.call @, index, value
      @next()

  '.index': -> @currentKey() or Null.null

  '.first-index': -> @firstKey() or Null.null

  '.last-index': -> @lastKey() or Null.null

  '.::': (other) ->
    if other instanceof Number
      len = @length()
      idx = other.value
      idx += len if idx < 0

      (@get idx) or Null.null
    else
      throw new TypeError

module.exports = Indexed