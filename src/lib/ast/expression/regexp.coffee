Literal = require './literal'


###
###
class RegExp extends Literal

  constructor: (@value, @flags = '') ->
    super()


module.exports = RegExp
