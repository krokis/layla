Plugin   = require '../../lib/plugin'
RegExp   = require '../../lib/object/regexp'
Function = require '../../lib/object/function'


FUNCTIONS =
  regexp: new Function (context, source) ->
    new RegExp source.toString()

###
###
class CSSTypesPlugin extends Plugin

  use: (context) ->
    for f of FUNCTIONS
      context.set f, FUNCTIONS[f]


module.exports = CSSTypesPlugin
