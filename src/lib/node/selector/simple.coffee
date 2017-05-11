Selector = require '../selector'

class SimpleSelector extends Selector

  constructor: (@name) -> super

  toJSON: ->
    json = super
    json.name = @name
    json

module.exports = SimpleSelector
