SimpleSelector = require './simple'


###
###
class ElementalSelector extends SimpleSelector

  constructor: (@namespace = null) ->
    super()

  copy: (namespace = @namespace, etc...) ->
    super namespace, etc...


module.exports = ElementalSelector
