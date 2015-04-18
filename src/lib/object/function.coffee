Object = require '../object'

class Function extends Object

  constructor: (@func = null, @self = null) ->

  invoke: (self, args...) -> @func.call this, self, args...

  bind: (self) -> @clone @func, self

  toString: -> 'function'

  reprValue: -> null

  isEqual: (other) -> other instanceof Function and (other.func is @func)

  clone: (func = @func, self = @self, etc...) -> super func, self, etc...

  '.bind': @::bind

  '.invoke': @::invoke

module.exports = Function
