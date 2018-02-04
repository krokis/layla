Statement = require '../statement'


###
###
class Conditional extends Statement

  condition: null
  block: null

  constructor: ->
    super()
    @elses = []


module.exports = Conditional
