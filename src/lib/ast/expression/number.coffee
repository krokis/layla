Literal = require './literal'


###
###
class Number extends Literal

  constructor: (@value, @unit = null) ->
    super()


module.exports = Number
