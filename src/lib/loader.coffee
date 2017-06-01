Plugin       = require './plugin'
IncludeError = require './error/include'


###
###
class Loader extends Plugin

  canLoad: (uri, context) -> no

  load: (uri, context) -> throw new IncludeError "Cannot load \"#{uri}\""

  use: (context) ->
    context.useLoader @


module.exports = Loader
