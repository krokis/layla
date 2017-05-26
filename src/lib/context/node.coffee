CSSContext = require '../css/context'
FSLoader   = require '../loader/fs'

class NodeContext extends CSSContext

  constructor: ->
    super
    @use new FSLoader

module.exports = NodeContext
