Path = require 'path'

Importer = require '../importer'

ImportError = '../error/import'

class SourceImporter extends Importer

  parse: (source) ->
    throw new ImportError  "Don't know how to parse"

  canImport: (uri, context) -> context.canLoad uri

  import: (uri, context) ->
    source = context.load uri
    ast = @parse source
    context.pushPath Path.dirname uri
    context.evaluate ast, context
    context.popPath()

module.exports = SourceImporter
