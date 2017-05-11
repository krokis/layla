Path = require 'path'
URL  = require 'url'

Importer = require '../importer'

ImportError = '../error/import'

class SourceImporter extends Importer

  @EXTENSIONS: []

  parse: (source) ->
    throw new ImportError "Don't know how to parse"

  canImport: (uri, context) ->
    url = URL.parse uri
    ext = Path.extname(url.pathname)

    if ext[0] is '.'
      ext = ext[1...]

    if ext.toLowerCase() in @class.EXTENSIONS
      return context.canLoad uri

    return no

  import: (uri, context) ->
    source = context.load uri
    ast = @parse source
    context.pushPath Path.dirname uri
    context.evaluate ast, context
    context.popPath()

module.exports = SourceImporter
