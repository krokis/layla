Class      = require '../class'
ValueError = require '../error/value'


###
###
class Object extends Class

  important = no

  @new: (args...) ->
    new (@bind.apply @, args)

  @reprType: -> @name

  @repr: -> "[#{@reprType()}]"

  clone: (args...) ->
    copy = super
    copy.important = @important

    return copy

  hasMethod: (name) -> typeof @[".#{name}"] is 'function'

  operate: (context, operator, other, etc...) ->
    if @hasMethod operator
      @['.'] context, operator, other, etc...
    else
      repr =
        if other
          "#{@repr()} #{operator} #{other.repr()}"
        else
          "#{operator}#{@repr()}"

      throw new ValueError (
        """
        Cannot perform #{repr}: \
        #{@class.repr()} has no method [.#{operator}]
        """
      )

  set: (properties) ->
    for k of properties
      @[k] = properties[k]

    return @

  toImportant: ->
    copy = @clone()
    copy.important = yes

    return copy

  toUnimportant: ->
    copy = @clone()
    copy.important = no

    return copy

  reprValue: -> ''

  reprType: -> @class.reprType()

  repr: -> "<#{"#{@reprType()} #{@reprValue()}".trim()}>"

  toString: -> throw new Error "Cannot convert #{@repr()} to string"

  '.': (context, name, etc...) ->
    method = @[".#{name}"]

    if typeof method is 'function'
      method.call this, context, etc...
    else
      throw new ValueError "Call to undefined method: [#{@type}.#{name}]"

  '.=': (context, name, etc...) -> @['.'] context, "#{name}=", etc...

  '.!important': -> @toImportant()

  '.important': -> @toImportant()

  '.unimportant': -> @toUnimportant()

  '.copy': -> @clone()


module.exports = Object
