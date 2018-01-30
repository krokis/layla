Plugin = require '../../lib/plugin'


PLUGINS = [ ]

###
###
class CSSColorPlugin extends Plugin

  use: (context) ->
    for plugin in PLUGINS
      context.use new plugin


module.exports = CSSColorPlugin
