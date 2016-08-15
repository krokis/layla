Class = require './class'

class Node extends Class

  parent: null

  @property 'root',
    get: ->
      p = @
      while p.parent
        p = p.parent
      p

  start: null
  end: null

  toJSON: ->
    json = super
    json.start = @start
    json.end = @end
    json

module.exports = Node
