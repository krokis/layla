ComplementarySelector = require './complementary'

class AttributeSelector extends ComplementarySelector

  # coffeelint: disable=indentation
  constructor: (name = null, @value = null, @operator = null, \
                @flags = null, @namespace = null) ->
    super name

  clone: (name = @name, value = @value, operator = @operator, \
          flags = @flags, namespace = @namespace, etc...) ->
    super name, value, operator, flags, namespace, etc...

  toString: ->
    str = '['
    str += "#{@namespace}|" if @namespace?
    str += @name
    str += @operator if @operator
    str += @value.reprValue() if @value? # TODO `reprValue()`? here?
    str += " #{@flags}" if @flags
    str += ']'

  toJSON: ->
    json = super
    json.value = @value
    json.operator = @operator
    json.namespace = namespace
    json.flags = @flags
    json

module.exports = AttributeSelector
