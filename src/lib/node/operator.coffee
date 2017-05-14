Node = require '../node'


###
###
class Operator extends Node

  constructor: (@value) ->
    super()

  toString: -> @value

  toJSON: ->
    json = super()
    json.value = @value

    return json


module.exports = Operator
