Literal = require '../literal'

class LiteralRegExp extends Literal
  value: null
  flags: null

  toJSON: ->
    json = super
    json.value = @value
    json.flags = @flags
    json

module.exports = LiteralRegExp
