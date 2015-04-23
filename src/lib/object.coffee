Class     = require './class'

TypeError           = require './error/type'
NotImplementedError = require './error/not-implemented'

class Object extends Class

  @NOT_IMPLEMENTED: (name) -> throw new NotImplementedError

  @new: (args...) ->
    new (@bind.apply @, args)

  @reprType: -> @name

  callMethod: (name, args...) ->
    method = @[".#{name}"]

    if typeof method is 'function'
      method.call this, args...
    else
      throw new TypeError "Call to undefined method: `#{@type}.#{name}`"

  hasMethod: (name) -> typeof @[".#{name}"] is 'function'

  operate: (operator, other, etc...) ->
    operator += '@' unless other
    @callMethod operator, other, etc...

  reprValue: -> ''

  reprType: -> @constructor.reprType()

  repr: -> "[#{"#{@reprType()} #{@reprValue()}".trim()}]"

  isA: (other) -> @ instanceof other

  '.copy': -> @clone()

module.exports = Object
