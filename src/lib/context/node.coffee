BaseContext = require './base'
FSLoader    = require '../loader/fs'

class NodeContext extends BaseContext

  constructor: ->
    super
    @use new FSLoader

module.exports = NodeContext
