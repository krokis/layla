Literal = require './literal'

class RegExp extends Literal

  constructor: (@value, @flags = '') -> super

  toJSON: ->
    json = super
    json.value = @value
    json.flags = @flags
    json

module.exports = RegExp
