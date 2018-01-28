SimpleSelector = require './simple'


###
###
class ComplementarySelector extends SimpleSelector

  constructor: (@name = null) ->

  copy: (name = @name, etc...) ->
    super name, etc...

  toJSON: ->
    json = super
    json.name = @name
    json

module.exports = ComplementarySelector
