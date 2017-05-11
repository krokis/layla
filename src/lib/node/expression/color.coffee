Literal = require './literal'

class Color extends Literal

  constructor: (@value) ->

  toJSON: ->
    json = super
    json.value = @value
    json

module.exports = Color
