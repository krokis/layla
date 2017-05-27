Node = require '../ast/node'


###
###
class Root extends Node

  constructor: (@body = [], bom = no) ->
    super()


module.exports = Root
