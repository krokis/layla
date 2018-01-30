BaseContext = require '../lib/context/base'
FSLoader    = require './fs-loader'


###
###
class NodeContext extends BaseContext

  constructor: ->
    super()

    @use new FSLoader


module.exports = NodeContext
