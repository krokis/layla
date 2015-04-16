Statement = require '../statement'

class Loop extends Statement

  condition: null
  negate: no
  block: null

  toJSON: ->
    json = super
    json.condition = @condition
    json.negate = @negate
    json.block = @block
    json

  clone: -> @

module.exports = Loop
