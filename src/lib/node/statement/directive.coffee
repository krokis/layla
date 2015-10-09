Statement = require '../statement'

class Directive extends Statement

  toJSON: ->
    json = super
    json.name = @name
    json.arguments = @arguments

module.exports = Directive
