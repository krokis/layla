Statement = require '../statement'


###
###
class Directive extends Statement

  constructor: (@name, @arguments = []) ->
    super()


module.exports = Directive
