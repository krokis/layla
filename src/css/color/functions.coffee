Plugin         = require '../../lib/plugin'
Function       = require '../../lib/object/function'
Color          = require '../../lib/object/color'
Number         = require '../../lib/object/number'
ReferenceError = require '../../lib/error/reference'
ValueError     = require '../../lib/error/value'


SPACES = [
  'rgb'
  'hsl'
  'hwb'
]

{max, min} = Math

FUNCTIONS = {}

SPACES.forEach (space) ->
  SPACE = Color.SPACES[space]

  clampChannel = (channel, value) ->
    if SPACE[channel].unit is 'deg'
      value %= SPACE[channel].max
      if value < 0
        value += SPACE[channel].max
    else
      value = min(value, SPACE[channel].max)
      value = max(value, 0)

    return value

  getChannel = (channel, val) ->
    unit = val.unit
    value = val.value

    if unit?
      if unit is '%'
        value = SPACE[channel].max * value / 100
      else if unit isnt SPACE[channel].unit
        if SPACE[channel].unit?
          try
            value = Number.convert value, unit, SPACE[channel].unit
          catch e
            throw new ValueError """
              Bad value for #{space} #{channel}: #{val.repr()}"
              """
        else
          throw new ValueError """
            Bad value for #{space} #{channel}: #{val.repr()}"
            """

    value = clampChannel channel, value

    return value

  getAlpha = (value) ->
    if not value?
      return 1

    if value.unit is '%'
      return value.value / 100

    if not value.isPure()
      throw new ValueError "Bad alpha value: #{value.repr()}"

    return value.value

  func = new Function (context, args...) ->
    if args.length < SPACE.length
      throw new ReferenceError "Too few arguments for #{space}()"
    else if args.length > SPACE.length
      throw new ReferenceError "Too many arguments for #{space}()"

    # TODO error handling
    # TODO optimize
    channels = []

    for channel in [0...SPACE.length]
      value = args.shift()
      unless value instanceof Number
        throw new ValueError "Bad argument for #{space}()"

      channels.push getChannel(channel, value)

    return new Color space, channels

  FUNCTIONS[space] = func

  func = new Function (context, args...) ->
    if args.length < SPACE.length
      throw new ReferenceError "Too few arguments for #{space}a()"
    else if args.length > SPACE.length + 1
      throw new ReferenceError "Too many arguments for #{space}a)()"

    # TODO error handling
    # TODO optimize
    channels = []

    for channel in [0...SPACE.length]
      value = args.shift()

      unless value instanceof Number
        throw new ValueError "Bad argument for #{space}()"

      channels.push getChannel(channel, value)

    alpha = args.pop()

    if alpha and not alpha.isNull()
      unless alpha instanceof Number
        throw new ValueError "Bad alpha value"

    alpha = getAlpha(alpha)

    return new Color space, channels, alpha

  FUNCTIONS["#{space}a"] = func


###
###
class CSSColorFunctionsPlugin extends Plugin

  use: (context) ->
    for func of FUNCTIONS
      context.set func, FUNCTIONS[func]


module.exports = CSSColorFunctionsPlugin
