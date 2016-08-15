Plugin = require './plugin'

ImportError = './error/import'

class Loader extends Plugin

  canLoad: (uri, context) -> no

  load: (uri, context) -> throw new ImportError "Cannot load \"#{uri}\""

  use: (context) ->
    context.useLoader @

module.exports = Loader
