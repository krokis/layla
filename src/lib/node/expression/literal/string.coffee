Literal = require '../literal'

class LiteralString extends Literal

  constructor: (@value = '', @quote = null) ->

  toJSON: ->
    json = super
    json.quote = @quote
    json.value = @value
    json

module.exports = LiteralString
