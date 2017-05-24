Object = require '../object'
Null   = require './null'


class Function extends Object

  constructor: (@func = ->) ->

  invoke: (context, args...) ->
    (@func.call this, context.block, args...) or Null.null

  toString: -> 'function'

  isEqual: (other) ->
    (other instanceof Function) and
    (other.func is @func) and
    (other.block is @block)

  clone: (func = @func, etc...) -> super func, etc...

  # TODO this should not use @block by default; instead, this should be executed
  # bound to the *calling block*.
  '.invoke': (context, args...) -> @invoke context, args...


module.exports = Function
