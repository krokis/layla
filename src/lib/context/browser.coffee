CSSContext = require '../css/context'
XHRLoader  = require '../loader/xhr'

class BrowserContext extends CSSContext

  constructor: ->
    super
    @use new XHRLoader

module.exports = BrowserContext
