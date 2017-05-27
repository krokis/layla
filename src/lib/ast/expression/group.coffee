Expression = require '../expression'

class Group extends Expression

  constructor: (@expression) ->

  toJSON: ->
    json = super
    json.expression = @expression
    json

module.exports = Group
