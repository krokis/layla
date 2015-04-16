Statement = require '../statement'

class With extends Statement
  reference: null

  toJSON: ->
    json = super
    json.reference = @reference
    json

  clone: -> @

module.exports = With
