Statement = require '../statement'

class Directive extends Statement

  constructor: (@name, @arguments = []) ->

  toJSON: ->
    json = super
    json.name = @name
    json.arguments = @arguments

module.exports = Directive
