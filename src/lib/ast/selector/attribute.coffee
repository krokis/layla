ComplementarySelector = require './complementary'


###
###
class AttributeSelector extends ComplementarySelector

  constructor: (name, @namespace = null, @value = null, @operator = '',
    @flags = null) ->
    super name


module.exports = AttributeSelector
