SimpleSelector = require './simple'


###
###
class ElementalSelector extends SimpleSelector

  constructor: (@namespace = null) ->

  copy: (namespace = @namespace, etc...) ->
    super namespace, etc...

  toJSON: ->
    json = super
    json.namespace = @namespace
    json


module.exports = ElementalSelector
