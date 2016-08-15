Plugin = require './plugin'

ImportError = './error/import'

class Importer extends Plugin

  canImport: (uri, context) -> no

  import: (uri, context) ->
    throw new ImportError "Cannot import \"#{uri}\""

  use: (context) ->
    context.useImporter @

module.exports = Importer
