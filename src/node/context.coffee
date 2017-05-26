CSSContext = require '../css/context'
FSLoader   = require './fs-loader'

###
###
class NodeContext extends CSSContext

  constructor: ->
    super
    @use new FSLoader


module.exports = NodeContext
