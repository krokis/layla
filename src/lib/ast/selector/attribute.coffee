ComplementarySelector = require './complementary'

class AttributeSelector extends ComplementarySelector

  constructor: (name, @namespace = null, @value = null, @operator = '',
    @flags = null) ->
    super name

  toJSON: ->
    json = super
    json.namespace = @namespace
    json.value = @value
    json.operator = @operator
    json.flags = @flags
    json

module.exports = AttributeSelector
