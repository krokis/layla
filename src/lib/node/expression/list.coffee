Literal = require './literal'


###
###
class List extends Literal

  constructor: (@body = [], @separator = ' ') ->
    super()


module.exports = List
