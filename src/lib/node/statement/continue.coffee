Statement = require '../statement'

class Continue extends Statement

  toJSON: ->
    json = super
    json.depth = @depth
    json

module.exports = Continue
