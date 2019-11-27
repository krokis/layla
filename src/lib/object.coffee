Class               = require './class'
NotImplementedError = require './error/not-implemented'
ReferenceError      = require './error/reference'
ValueError          = require './error/value'


###
###
class Object extends Class

  important = no

  @NOT_IMPLEMENTED: (name) -> throw new NotImplementedError

  @new: (args...) -> new @ args...

  @repr: -> "<#{@reprType()}>"

  @reprType: -> @name

  compare: (other) ->
    throw new ValueError (
      "Cannot compare #{@reprType()} with #{other.reprType()}"
    )

  copy: (etc...) ->
    copy = super etc...
    copy.important = @important

    return copy

  hasMethod: (name) -> typeof @[".#{name}"] is 'function'

  set: (properties) ->
    for k of properties
      @[k] = properties[k]

    return @

  toImportance: (important) ->
    if @important is important
      return @clone()

    copy = @copy()
    copy.important = important

    return copy

  toImportant: -> @toImportance yes

  toUnimportant: -> @toImportance no

  reprValue: -> ''

  reprType: -> @class.repr()

  repr: -> "<#{"#{@class.reprType()} #{@reprValue()}".trim()}>"

  reprMethod: (method) -> "#{@class.name}.#{method}"

  @reprOp: (self, op, other = null) ->
    repr = ''

    if '@' in op
      repr += op.replace '@', self
    else
      repr += self + ' ' + op
      repr += ' ' + other if other

    return repr

  reprOpType: (op, other) ->
    @class.reprOp @reprType(), op, other?.reprType()

  reprOp: (op, other) ->
    @class.reprOp @.repr(), op, other?.repr()

  toString: -> throw new ValueError "Cannot convert #{@repr()} to string"

  '.': (context, name, etc...) ->
    method = @[".#{name}"]

    unless typeof method is 'function'
      throw new ReferenceError "Call to undefined method #{@reprMethod(name)}"

    return method.call this, context, etc...

  '.=': (context, name, etc...) -> @['.'] context, "#{name}=", etc...

  do ->
    UNDEFINED_OPERATIONS = [
      '::'
      '::='
      '..'
      '*'
      '/'
      '+'
      '-'
      '<'
      '<='
      '>'
      '>='
      '~'
      'and'
      'or'
      '!'
      '+@'
      '-@'
      'not@'
    ]

    UNDEFINED_OPERATIONS.forEach (op) ->
      Object::[".#{op}"] = (context, other = null) ->
        throw new ValueError "Undefined operation: `#{@reprOpType op, other}`"

  '.!important': -> @toImportant()

  '.!unimportant': -> @toUnimportant()

  '.important': -> @toImportant()

  '.unimportant': -> @toUnimportant()

  '.copy': -> @clone()


module.exports = Object
