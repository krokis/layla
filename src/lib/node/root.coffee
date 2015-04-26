Node = require '../node'

class Root extends Node
  toJSON: ->
    json = super
    json.body = @body
    json

module.exports = Root
