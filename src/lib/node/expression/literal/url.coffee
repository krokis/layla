Literal = require '../literal'

class LiteralURL extends Literal
  value: null

  toJSON: ->
    json = super
    json.value = @value
    json.unit = @unit
    json

module.exports = LiteralURL
