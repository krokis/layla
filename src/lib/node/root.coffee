Node = require '../node'

class Root extends Node

  constructor: (@body = [], bom = no) -> super

  toJSON: ->
    json = super
    json.body = @body
    json.bom = @bom
    json

module.exports = Root
