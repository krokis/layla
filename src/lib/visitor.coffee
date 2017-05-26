Plugin = require './plugin'


###
###
class Visitor extends Plugin

  use: (context) ->
    context.useVisitor @

  visit: (node) ->
    method = "visit#{node.type}"

    unless method of this
      throw new Error "Don't know how visit node of type #{node.type}"

    this[method].call this, node


module.exports = Visitor
