Plugin = require '../../plugin'

PLUGINS = [
  require './functions'
]

###
###
class CSSColorPlugin extends Plugin

  use: (context) ->
    for plugin in PLUGINS
      context.use new plugin


module.exports = CSSColorPlugin
