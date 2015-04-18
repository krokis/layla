Class     = require './class'

TypeError = require './error/type'

class Object extends Class

  @new: (args...) ->
    new (@bind.apply @, args)

  @reprType: -> @name

  method: (name) ->
    method = @[".#{name}"]

    if typeof method is 'function'
      method
    else
      throw new TypeError "No such method: `#{@type}.#{name}`"

  callMethod: (name, args...) ->
    (@method name).call this, args...

  hasMethod: (name) -> typeof @[".#{name}"] is 'function'

  operate: (operator, other, etc...) ->
    operator += '@' unless other
    @callMethod operator, other, etc...

  reprValue: -> null

  reprType: -> @constructor.reprType()

  repr: -> "[#{"#{@reprType()} #{@reprValue()}".trim()}]"

  isA: (other) -> @ instanceof other

  '.copy': -> @clone()

module.exports = Object
