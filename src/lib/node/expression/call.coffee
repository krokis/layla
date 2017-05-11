Literal = require './literal'

class Call extends Literal

  constructor: (@name, @arguments = []) -> super()

  toJSON: ->
    json = super
    json.name = @name
    json.arguments = @arguments
    json

module.exports = Call
