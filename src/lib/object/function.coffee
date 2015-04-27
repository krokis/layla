Object = require '../object'

class Function extends Object

  constructor: (@func = null, @self = @) ->

  invoke: (self, args...) -> @func.call this, self, args...

  bind: (self) -> @clone @func, self

  toString: -> 'function'

  isEqual: (other) -> other instanceof Function and (other.func is @func)

  clone: (func = @func, self = @self, etc...) -> super func, self, etc...

  '.bind': @::bind

  # TODO this should not use @self by default; instead, this should be executed
  # bound to the *calling block*.
  '.invoke': (args...) -> @invoke @self, args...

module.exports = Function
