Statement = require '../statement'

class Break extends Statement

  toJSON: ->
    json = super
    json.depth = @depth
    json

module.exports = Break
