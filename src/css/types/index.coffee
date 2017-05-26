Plugin   = require '../../lib/plugin'
RegExp   = require '../../lib/object/regexp'
Function = require '../../lib/object/function'


FUNCTIONS = [
  ['regexp', RegExp]
]

FUNCTIONS = FUNCTIONS.map ([name, cls]) ->
  [name, new Function (context, args...) ->
    return new cls args...
  ]

###
###
class CSSTypesPlugin extends Plugin

  use: (context) ->
    for f in FUNCTIONS
      [name, func] = f
      context.set name, func


module.exports = CSSTypesPlugin
