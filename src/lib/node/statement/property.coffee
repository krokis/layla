Declaration = require './declaration'

class PropertyDeclaration extends Declaration

  constructor: (@names, @value, @conditional = no) ->

  toJSON: ->
    json = super
    json.names = @names
    json.value = @value
    json.conditional = @conditional
    json

module.exports = PropertyDeclaration
