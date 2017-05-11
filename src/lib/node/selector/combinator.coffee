Selector = require '../selector'

class Combinator extends Selector

  constructor: (@value) -> super

  toString: -> @value

  toJSON: ->
    json = super
    json.value = @value
    json

module.exports = Combinator
