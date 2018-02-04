Literal = require './literal'

###
###
class String extends Literal

  constructor: (@value, @quote = null, @raw = no) ->
    super()


module.exports = String
