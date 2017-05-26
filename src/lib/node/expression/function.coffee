Literal = require './literal'


###
###
class Function extends Literal

  constructor: (@block, @arguments = []) ->
    super()


module.exports = Function
