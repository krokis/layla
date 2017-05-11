Literal = require './literal'

class Block extends Literal

  block: yes

  constructor: (@body = []) ->

  toJSON: ->
    json = super
    json.body = @body
    json

module.exports = Block
