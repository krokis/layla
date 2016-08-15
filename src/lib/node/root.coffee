Node = require '../node'

class Root extends Node
  bom: no

  toJSON: ->
    json = super
    json.bom = @bom
    json.body = @body
    json

module.exports = Root
