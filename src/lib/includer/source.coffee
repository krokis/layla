Path = require 'path'
URL  = require 'url'

Includer     = require '../includer'
IncludeError = require '../error/include'


###
###
class SourceIncluder extends Includer

  @EXTENSIONS: []

  parse: (source) ->
    throw new IncludeError "Don't know how to parse"

  canInclude: (uri, context) ->
    url = URL.parse uri
    ext = Path.extname(url.pathname)

    if ext[0] is '.'
      ext = ext[1...]

    if ext.toLowerCase() in @class.EXTENSIONS
      return context.canLoad uri

    return no

  include: (uri, context) ->
    source = context.load uri
    ast = @parse source
    context.pushPath Path.dirname uri
    context.evaluate ast, context
    context.popPath()


module.exports = SourceIncluder
