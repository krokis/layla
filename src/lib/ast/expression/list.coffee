Literal = require './literal'

class List extends Literal

  constructor: (@body = [], @separator = ' ') -> super

  toJSON: ->
    json = super
    json.body = @body
    json.separator = @separator
    json

module.exports = List
