Literal = require './literal'

class String extends Literal

  constructor: (@value, @quote = null, @raw = no) -> super

  append: (str) ->
    if @value instanceof Array
      @value.push str
    else
      @value += str

  toJSON: ->
    json = super
    json.value = @value
    json.quote = @quote
    json.raw = @raw
    json

module.exports = String
