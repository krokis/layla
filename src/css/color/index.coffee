Plugin = require '../../lib/plugin'


PLUGINS = [
  require './functions'
  require './names'
]


###
###
class CSSColorPlugin extends Plugin

  use: (context) ->
    for plugin in PLUGINS
      context.use new plugin


module.exports = CSSColorPlugin
