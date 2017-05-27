SimpleSelector = require './simple'


###
###
class ElementalSelector extends SimpleSelector

  constructor: (name, @namespace = null) ->
    super name


module.exports = ElementalSelector
