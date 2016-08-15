Statement = require '../statement'

class Import extends Statement

  toJSON: ->
    json = super

module.exports = Import
