Class     = require './class'

TypeError           = require './error/type'
NotImplementedError = require './error/not-implemented'

class Object extends Class

  @NOT_IMPLEMENTED: (name) -> throw new NotImplementedError

  @new: (args...) ->
    new (@bind.apply @, args)

  @reprType: -> @name

  @repr: -> "[#{@reprType()}]"

  hasMethod: (name) -> typeof @[".#{name}"] is 'function'

  operate: (operator, other, etc...) ->
    if @hasMethod operator
      @['.'] operator, other, etc...
    else
      repr =
        if other
          "#{@repr()} #{operator} #{other.repr()}"
        else
          "#{operator}#{@repr()}"

      throw new TypeError (
        """
        Cannot perform #{repr}: \
        #{@constructor.repr()} has no method [.#{operator}]
        """
      )

  reprValue: -> ''

  reprType: -> @constructor.reprType()

  repr: -> "[#{"#{@reprType()} #{@reprValue()}".trim()}]"

  isA: (other) -> @ instanceof other

  toString: -> throw new TypeError "Cannot convert #{@repr()} to string"

  '.': (name, etc...) ->
    method = @[".#{name}"]

    if typeof method is 'function'
      method.call this, etc...
    else
      throw new TypeError "Call to undefined method: [#{@type}.#{name}]"

  '.=': (name, etc...) -> @['.'] "#{name}=", etc...

  '.copy': -> @clone()

module.exports = Object
