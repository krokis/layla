Rule   = require './rule'
String = require './string'

class AtRule extends Rule

  constructor: (@name) ->
    super()
    @arguments = []

  clone: ->
    that = super
    that.name = @name
    that.arguments = @arguments
    that

  '.name': -> new String @name

module.exports = AtRule
