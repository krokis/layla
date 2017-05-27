Expression = require '../expression'


###
###
class Operation extends Expression

  constructor: (@operator, @left = null, @right = null) ->
    super()

  @property 'unary', ->
    not (@left and @right)

  @property 'binary', ->
    if @left and @right then yes else no


module.exports = Operation
