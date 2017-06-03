Statement = require '../statement'

class Conditional extends Statement
  condition: null
  block: null
  elses: null

  constructor: ->
    @elses = []

  toJSON: ->
    json = super
    json.condition = @condition
    json.block = @block
    json.elses = @elses
    json

  clone: -> @

module.exports = Conditional
