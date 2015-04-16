Literal = require '../literal'

class LiteralBlock extends Literal

  body: null

  toJSON: ->
    json = super
    json.body = @body
    json

module.exports = LiteralBlock
