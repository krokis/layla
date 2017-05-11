Literal = require './literal'

class Function extends Literal

  block: yes

  constructor: (@block, @arguments = []) ->

  toJSON: ->
    json = super
    json.block = @block
    json.arguments = @arguments
    json

module.exports = Function
