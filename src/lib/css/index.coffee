Plugin = require '../plugin'

MODULES = [
  require './color'
]

###
###
class CSSPlugin extends Plugin

  use: (context) ->
    for plugin in MODULES
      context.use new plugin


module.exports = CSSPlugin
