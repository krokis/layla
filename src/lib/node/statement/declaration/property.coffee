Declaration = require '../declaration'

class PropertyDeclaration extends Declaration
  value: null

  constructor: ->
    @names = []

  toJSON: ->
    json = super
    json.names = @names
    json.value = @value
    json

module.exports = PropertyDeclaration
