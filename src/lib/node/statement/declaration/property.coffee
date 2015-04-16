Declaration = require '../declaration'

class PropertyDeclaration extends Declaration

  value: null
  conditional: no

  constructor: ->
    @names = []

  toJSON: ->
    json = super
    json.names = @names
    json.value = @value
    json

module.exports = PropertyDeclaration
