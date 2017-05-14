Object = require '../object'
Null   = require './null'


###
###
class Function extends Object

  constructor: (@func = ->) ->
    super()

  invoke: (context, args...) ->
    (@func.call this, context, args...) or Null.null

  toString: -> 'function'

  isEqual: (other) ->
    (other instanceof Function) and
    (other.func is @func) and
    (other.block is @block)

  copy: (func = @func, etc...) -> super func, etc...

  clone: -> @

  '.call': (context, args...) -> @invoke context, args...


module.exports = Function
