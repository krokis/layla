SimpleSelector = require './simple'

class ElementalSelector extends SimpleSelector

  constructor: (name, @namespace = null) -> super name

  toJSON: ->
    json = super
    json.namespace = @namespace
    json

module.exports = ElementalSelector
