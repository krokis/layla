Expression = require '../expression'

class Ident extends Expression
  value: null
  name: null
  arguments: null

  toJSON: ->
    json = super
    json.name = @name
    json.arguments = @arguments
    json

module.exports = Ident
