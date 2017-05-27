Literal = require './literal'


###
###
class Block extends Literal

  constructor: (@body = []) ->
    super()


module.exports = Block
