Literal = require './literal'

###
###
class String extends Literal

  constructor: (@value, @quote = null, @raw = no) -> super

  toJSON: ->
    json = super
    json.value = @value
    json.quote = @quote
    json.raw = @raw
    json


module.exports = String
