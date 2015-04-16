Class = require './class'

class Visitor extends Class

  visit: (node) ->
    method = "visit#{node.type}"

    unless method of this
      throw new Error "Don't know how visit node of type #{node.type} (with #{method}?)"

    this[method].call this, node

module.exports = Visitor
