Literal = require './literal'


###
###
class Call extends Literal

  constructor: (@name, @arguments = []) ->
    super()


module.exports = Call
