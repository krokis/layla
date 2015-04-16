Statement = require '../statement'

class Import extends Statement
  from: null
  symbols: '*'
  as: null

  toJSON: ->
    json = super

module.exports = Import
