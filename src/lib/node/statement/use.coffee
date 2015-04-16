Statement = require '../statement'

class Use extends Statement

  arguments: null
  dont: false

  constructor: ->
    super
    @arguments = []

  toJSON: ->
    json = super
    json.arguments = @arguments
    json

module.exports = Use
