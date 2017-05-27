Literal = require './literal'

class Number extends Literal

  constructor: (@value, @unit = null) -> super

  toJSON: ->
    json = super
    json.value = @value
    json.unit = @unit
    json

module.exports = Number
