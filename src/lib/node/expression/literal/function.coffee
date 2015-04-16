Literal = require '../literal'

class LiteralFunction extends Literal

  arguments: null
  block: null

  toJSON: ->
    json = super
    json.block = @block
    json.arguments = @arguments
    json

module.exports = LiteralFunction
