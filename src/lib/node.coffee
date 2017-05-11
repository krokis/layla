Class = require './class'

class Node extends Class

  start: null
  end: null
  block: no

  toJSON: ->
    json = super
    json.kind = @type
    json.start = @start
    json.end = @end
    json

module.exports = Node
