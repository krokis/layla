Literal = require '../literal'

class LiteralNumber extends Literal
  constructor: (@value, @unit = null) -> super()

  toJSON: ->
    json = super
    json.value = @value
    json.unit = @unit
    json

module.exports = LiteralNumber
