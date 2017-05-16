Class     = require './class'

TypeError = require './error/type'

class Object extends Class

  @new: (args...) ->
    new (@bind.apply @, args)

  @reprType: -> @name

  @repr: -> "[#{@reprType()}]"

  @clone: -> @

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
        #{@class.repr()} has no method [.#{operator}]
        """
      )

  set: (properties) ->
    for k of properties
      @[k] = properties[k]

    return @

  reprValue: -> ''

  reprType: -> @class.reprType()

  repr: -> "<#{"#{@reprType()} #{@reprValue()}".trim()}>"

  toString: -> throw new Error "Cannot convert #{@repr()} to string"

  '.': (name, etc...) ->
    method = @[".#{name}"]

    if typeof method is 'function'
      method.call this, etc...
    else
      throw new TypeError "Call to undefined method: [#{@type}.#{name}]"

  '.=': (name, etc...) -> @['.'] "#{name}=", etc...

  '.copy': -> @clone()

module.exports = Object
