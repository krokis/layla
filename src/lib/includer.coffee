Plugin       = require './plugin'
IncludeError = require './error/include'


###
###
class Includer extends Plugin

  canInclude: (uri, context) -> no

  include: (uri, context) ->
    throw new IncludeError "Cannot include \"#{uri}\""

  use: (context) ->
    context.useIncluder @


module.exports = Includer
