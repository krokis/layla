ComplementarySelector = require './complementary'


###
###
class AttributeSelector extends ComplementarySelector

  # coffeelint: disable=indentation
  constructor: (name, @value = null, @operator = null,
    @flags = null, @namespace = null) ->
    super name

  copy: (name = @name, value = @value, operator = @operator,
    flags = @flags, namespace = @namespace, etc...) ->
    super name, value, operator, flags, namespace, etc...

  toString: ->
    str = '['
    str += "#{@escape @namespace}|" if @namespace?
    str += @escape @name
    str += @operator if @operator
    str += @value.reprValue() if @value? # TODO `reprValue()`? here?
    str += " #{@escape @flags}" if @flags
    str += ']'

    return str


module.exports = AttributeSelector
