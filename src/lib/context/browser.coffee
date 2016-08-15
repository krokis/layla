BaseContext = require './base'
XHRLoader   = require '../loader/xhr'

class BrowserContext extends BaseContext

  constructor: ->
    super
    @use new XHRLoader

module.exports = BrowserContext
