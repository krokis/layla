Literal = require './literal'

class URL extends Literal

  value: null

  constructor: (@value) -> super

  toJSON: ->
    json = super
    json.value = @value
    json

module.exports = URL
