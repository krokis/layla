Object    = require '../object'
Boolean   = require './boolean'
Number    = require './number'

TypeError = require '../../error/type'

class Color extends Object

  {max, min} = Math

  COMPONENTS = ['red', 'green', 'blue', 'alpha']

  # http://git.io/ot_KMg
  # http://stackoverflow.com/questions/2353211/
  RGB2HSL = (r, g, b, a) ->
    M = max r, g, b
    m = min r, g, b
    l = (M + m) / 2

    if m is M
      h = s = 0 # achromatic
    else
      d = M - m
      s = if l > .5 then d / (2 - M - m) else d / (M + m)
      h = (switch M
        when r
          (g - b) / d + if g < b then 6 else 0
        when g
          (b - r) / d + 2
        when b
          (r - g) / d + 4
      ) / 6

    [h, s, l, a]

  H2RGB = (p, q, t) ->
    if t < 0
      t++
    else if t > 1
      t--

    if t < 1 / 6
      p + (q - p) * 6 * t
    else if t < 1 / 2
      q
    else if t < 2 / 3
      p + (q - p) * (2 / 3 - t) * 6
    else
      p

  ###
  ###
  HSL2RGB = (h, s, l, a) ->
    if s is 0
      r = g = b = l # achromatic
    else
      q = if l < .5 then l * (1 + s) else l + s - l * s
      p = 2 * l - q
      r = H2RGB p, q, (h + 1 / 3)
      g = H2RGB p, q, (h)
      b = H2RGB p, q, (h - 1 / 3)

    [r, g, b, a]

  @property 'rgba',
    get: -> [@red, @green, @blue, @alpha]
    set: (rgba) ->
      @red   = rgba[0]
      @green = rgba[1]
      @blue  = rgba[2]
      @alpha = rgba[3]

  @property 'hsla',
    get: -> RGB2HSL @rgba...
    set: (hsla) -> @rgba = HSL2RGB hsla...

  @property 'hue',
    get: -> @hsla[0]
    set: (hue) ->
      hsla = @hsla
      hsla[0] = hue
      @hsla = hsla

  @property 'saturation',
    get: -> @hsla[1]
    set: (sat) ->
      hsla = @hsla
      hsla[1] = sat
      @hsla = hsla

  @property 'lightness',
    get: -> @hsla[2]
    set: (light) ->
      hsla = @hsla
      hsla[2] = light
      @hsla = hsla

  @property 'hsva',
    get: ->
    set: ->

  @property 'hwba',
    get: ->
    set: ->

  constructor: (@red = 0, @green = 0, @blue = 0, @alpha = 1) ->

  isEqual: (other) ->
    other instanceof Color and
    other.red is @red and
    other.green is @green and
    other.blue is @blue and
    other.alpha is @alpha

  isEmpty: -> @alpha is 0

  clone: (red = @red, green = @green, blue = @blue, alpha = @alpha, etc...) ->
    super red, green, blue, alpha, etc...

  '.component': (comp) ->
    unless comp in COMPONENTS
      throw "Cannot get component #{comp} of color"

    new Number 100 * @[comp], '%'

  '.component=': (comp, value) ->
    unless comp in COMPONENTS
      throw "Cannot get component #{comp} of color"

    if value instanceof Number
      if value.unit is '%'
        @[comp] = value.value / 100
      else if value.isPure()
        @[comp] = value.value / 255
      else
        throw "Bad #{comp} component value: #{value.repr()}"

      @['.component'] comp

  '.component?': (comp) ->
    if comp in COMPONENTS
      Boolean.new @[comp] > 0
    else
      throw "Cannot check component #{comp} of color"

  COMPONENTS.forEach (comp) =>
    @::[".#{comp}"]  = -> @['.component'] comp
    @::[".#{comp}?"] = -> @['.component?'] comp
    @::[".#{comp}="] = (etc...) -> @['.component='] comp, etc...

  '.transparent?': -> Boolean.new @isEmpty()

  '.transparent': -> @clone null, null, null, 0

  '.opaque?': -> Boolean.new @alpha is 1

  '.opaque': -> @clone null, null, null, 1

  '.hue': -> new Number @hue * 360, 'deg'

  '.saturation': -> new Number @saturation * 100, '%'

  '.saturation=': (sat) -> @saturation = sat.value / 100

  '.saturate': (amount) ->
    unless amount?
      amount = 1
    else
      unless amount instanceof Number and amount.unit is '%'
        throw new TypeError "Bad value for Color.saturate"
      amount = amount.value / 100

    that = @clone()

    unless amount is 0
      that.saturation = min 1, (max 0, @saturation * (1 + amount))

    that

  '.lightness': -> new Number @lightness * 100, '%'

  '.light?': -> Boolean.new @lightness >= .5

  '.dark?': -> Boolean.new @lightness < .5

  '.grey?': -> Boolean.new (@red is @blue and @blue is @green)

  '.gray?': @::['.grey?']

  # TODO
  # http://dev.w3.org/csswg/css-color/#hsl-hwb-adjusters
  '.whiteness': ->
  '.whiteness=': ->
  '.blackness': ->
  '.blackness=': ->

  # TODO
  # http://dev.w3.org/csswg/css-color/#tint-shade-adjusters
  '.tint': ->
  '.shade': ->
  '.contrast': ->

module.exports = Color
