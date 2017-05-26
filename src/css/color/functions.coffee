Plugin         = require '../../lib/plugin'
Function       = require '../../lib/object/function'
Color          = require '../../lib/object/color'
Number         = require '../../lib/object/number'
ReferenceError = require '../../lib/error/reference'


SPACES = [
  'rgb'
  'hsl'
  'hwb'
]

FUNCTIONS = {}

SPACES.forEach (space) ->
  channels = Color.SPACES[space]

  func = new Function (context, args...) ->
    comps = args.splice 0, channels.length

    if comps < channels.length
      throw new ReferenceError "Too few arguments for #{space}(a)()"

    # TODO error handling
    # TODO optimize
    color = new Color

    for channel in channels
      comp = comps.shift()
      color[".#{channel.name}="](context, comp)

    alpha = args.pop() or Number.ONE_HUNDRED_PERCENT

    color['.alpha='](context, alpha)

    return color

  FUNCTIONS[space] = FUNCTIONS["#{space}a"] = func


###
###
class CSSColorFunctionsPlugin extends Plugin

  use: (context) ->
    for func of FUNCTIONS
      context.set func, FUNCTIONS[func]


module.exports = CSSColorFunctionsPlugin
