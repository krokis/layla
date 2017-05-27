Expression = require '../expression'

class Operation extends Expression

  constructor: (@operator, @left = null, @right = null) -> super

  @property 'unary',
    get: -> not (@left and @right)

  @property 'binary',
    get: -> global.Boolean(@left and @right)

  toJSON: ->
    json = super
    json.operator = @operator
    json.left = @left
    json.right = @right
    json

module.exports = Operation
