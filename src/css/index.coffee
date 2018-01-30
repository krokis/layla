Plugin = require '../lib/plugin'
CSSIncluder = require './includer'


MODULES = [
  CSSIncluder
]


###
###
class CSSPlugin extends Plugin

  use: (context) ->
    for plugin in MODULES
      context.use new plugin


module.exports = CSSPlugin
