Class = require './class'

class Emitter extends Class

  emit: (node) ->
    if node isnt undefined
      method = "emit#{node.type}"

      unless method of this
        throw new Error (
          "Don't know how to emit node of type #{node.type} (with #{method}?)"
        )

      this[method].call this, node

module.exports = Emitter
