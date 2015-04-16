Expression = require '../expression'

class Operation extends Expression

  constructor: (@operator, @left = null, @right = null) ->

  @property 'unary',
    get: -> not (@left and @right)

  @property 'binary',
    get: -> @left and @right and yes

  toJSON: ->
    json = super
    json.left = @left
    json.right = @right
    json.operator = @operator
    json

module.exports = Operation
