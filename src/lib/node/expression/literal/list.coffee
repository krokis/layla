Literal = require '../literal'

class LiteralList extends Literal

  constructor: (@body = [], @separator = ' ') -> super

  toJSON: ->
    json = super
    json.body = @block
    json

module.exports = LiteralList
