Object        = require '../object'
Null          = require './null'
Boolean       = require './boolean'
Number        = require './number'
String        = require './string'
ValueError    = require '../error/value'
InternalError = require '../error/value'


###
###
class Color extends Object

  {round, max, min, abs, sqrt, pow} = Math

  RED         = name: 'red',        max: 255
  GREEN       = name: 'green',      max: 255
  BLUE        = name: 'blue',       max: 255
  HUE         = name: 'hue',        max: 360, unit: 'deg'
  SATURATION  = name: 'saturation', max: 100, unit: '%'
  LIGHTNESS   = name: 'lightness',  max: 100, unit: '%'
  WHITENESS   = name: 'whiteness',  max: 100, unit: '%'
  BLACKNESS   = name: 'blackness',  max: 100, unit: '%'
  CYAN        = name: 'cyan',       max: 100, unit: '%'
  MAGENTA     = name: 'magenta',    max: 100, unit: '%'
  YELLOW      = name: 'yellow',     max: 100, unit: '%'
  BLACK       = name: 'black',      max: 100, unit: '%'

  @SPACES = SPACES =
    rgb:  [ RED, GREEN, BLUE ]
    hsl:  [ HUE, SATURATION, LIGHTNESS ]
    hwb:  [ HUE, WHITENESS, BLACKNESS ]
    cmyk: [ CYAN, MAGENTA, YELLOW, BLACK ]

  RE_HEX_COLOR  = /#([\da-f]+)/i
  RE_FUNC_COLOR = /([a-z_-][a-z\d_-]*)\s*\((.*)\)/i

  CONVERTORS =

    ###
    http://git.io/ot_KMg
    http://stackoverflow.com/questions/2353211/
    ###
    rgb2hsl: (rgb) ->
      r = rgb[0] / 255
      g = rgb[1] / 255
      b = rgb[2] / 255

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
            (g - b) / d + (if g < b then 6 else 0)
          when g
            (b - r) / d + 2
          when b
            (r - g) / d + 4
        ) / 6

      [h * 360, s * 100, l * 100]

    ###
    https://git.io/vVWUt
    ###
    rgb2hwb: (rgb) ->
      h = (@rgb2hsl rgb)[0]
      w = min rgb...
      b = 255 - (max rgb...)

      [h, 100 * w / 255, 100 * b / 255]

    ###
    https://drafts.csswg.org/css-color/#cmyk-rgb
    ###
    rgb2cmyk: (rgb) ->
      r = rgb[0] / 255
      g = rgb[1] / 255
      b = rgb[2] / 255

      k = 1 - max r, g, b

      if k is 1
        c = m = y = 0
      else
        w = 1 - k
        c = (1 - r - k) / w
        m = (1 - g - k) / w
        y = (1 - b - k) / w

      [c * 100, m * 100, y * 100, k * 100]

    ###
    ###
    hsl2rgb: (hsl) ->
      s = hsl[1] / 100
      l = hsl[2] / 100

      if s is 0
        r = g = b = l # achromatic
      else
        h = hsl[0] / 360
        q = if l <= .5 then l * (1 + s) else l + s - l * s
        p = 2 * l - q

        h2rgb = (t) ->
          if t < 0
            t++
          else if t > 1
            t--

          if t * 6 < 1
            p + (q - p) * 6 * t
          else if t * 2 < 1
            q
          else if t * 3 < 2
            p + (q - p) * (2 / 3 - t) * 6
          else
            p

        r = h2rgb (h + 1 / 3)
        g = h2rgb h
        b = h2rgb (h - 1 / 3)

      [r * 255, g * 255, b * 255]

    ###
    https://drafts.csswg.org/css-color/#cmyk-rgb
    ###
    cmyk2rgb: (cmyk) ->
      c = cmyk[0] / 100
      m = cmyk[1] / 100
      y = cmyk[2] / 100
      k = cmyk[3] / 100

      w = 1 - k
      r = 1 - min(1, (c * w + k))
      g = 1 - min(1, (m * w + k))
      b = 1 - min(1, (y * w + k))

      [r * 255, g * 255, b * 255]

    ###
    https://drafts.csswg.org/css-color/#hwb-to-rgb
    ###
    hwb2rgb: (hwb) ->
      [h, w, b] = hwb

      # Normalize w + b
      r = w / 100 + b / 100

      if r > 1
        w /= r
        b /= r

      rgb = @hsl2rgb [h, 100, 50]

      for i in [0..2]
        rgb[i] *= (1 - w / 100 - b / 100)
        rgb[i] += 255 * w / 100

      rgb

  BLEND_METHODS =

    ###
    The no-blending mode. This simply selects the source color.
    ###
    'normal': (source,  backdrop) ->
      source

    ###
    The source color is multiplied by the backdrop.

    The result color is always at least as dark as either the source or backdrop
    color. Multiplying any color with black produces black. Multiplying any
    color with white leaves the color unchanged.
    ###
    'multiply': (source,  backdrop) ->
      source * backdrop

    ###
    Multiplies the complements of the backdrop and source color values, then
    complements the result.

    The result color is always at least as light as either of the two
    constituent colors. Screening any color with white produces white; screening
    with black leaves the original color unchanged. The effect is similar to
    projecting multiple photographic slides simultaneously onto a single screen.
    ###
    'screen': (source,  backdrop) ->
      backdrop + source - backdrop * source

    ###
    Multiplies or screens the colors, depending on the backdrop color value.
    Source colors overlay the backdrop while preserving its highlights and
    shadows. The backdrop color is not replaced but is mixed with the source
    color to reflect the lightness or darkness of the backdrop.

    Overlay is the inverse of the `hard-light` blend mode.
    ###
    'overlay': (source,  backdrop) ->
      @['hard-light'] backdrop, source

    ###
    Multiplies or screens the colors, depending on the source color value. The
    effect is similar to shining a harsh spotlight on the backdrop.
    ###
    'hard-light': (source,  backdrop) ->
      if source <= .5
        @multiply backdrop, 2 * source
      else
        @screen backdrop, 2 * source - 1

    ###
    Darkens or lightens the colors, depending on the source color value. The
    effect is similar to shining a diffused spotlight on the backdrop
    ###
    'soft-light': (source,  backdrop) ->
      if source <= .5
        backdrop - (1 - 2 * source) * backdrop * (1 - backdrop)
      else
        if backdrop <= .25
          d = ((16 * backdrop - 12) * backdrop + 4) * backdrop
        else
          d = sqrt backdrop

        backdrop + (2 * source - 1) * (d - backdrop)

    ###
    Selects the darker of the backdrop and source colors.

    The backdrop is replaced with the source where the source is darker;
    otherwise, it is left unchanged.
    ###
    'darken': (source,  backdrop) ->
      min source, backdrop

    ###
    Selects the lighter of the backdrop and source colors.

    The backdrop is replaced with the source where the source is lighter;
    otherwise, it is left unchanged.
    ###
    'lighten': (source,  backdrop) ->
      max backdrop, source

    ###
    Subtracts the darker of the two constituent colors from the lighter color.

    Painting with white inverts the backdrop color; painting with black produces
    no change.
    ###
    'difference': (source,  backdrop) ->
      abs backdrop - source

    ###
    Produces an effect similar to that of the `difference` mode but lower in
    contrast. Painting with white inverts the backdrop color; painting with
    black produces no change.
    ###
    'exclusion': (source,  backdrop) ->
      source + backdrop - 2 * source * backdrop

  @blend: (source, backdrop, mode = 'normal') ->
    if not mode of BLEND_METHODS
      throw new ValueError "Bad mode for Color.blend: #{mode}"

    srgb = source.rgb.map (ch) -> ch / 255
    brgb = backdrop.rgb.map (ch) -> ch / 255

    blent = (BLEND_METHODS[mode] srgb[i], brgb[i] for i of srgb)

    blent = blent.map (ch, i) ->
      ch = (1 - backdrop.alpha) * (source.rgb[i] / 255) + backdrop.alpha * ch
      ch = source.alpha * ch + (1 - source.alpha) * backdrop.alpha *
           (backdrop.rgb[i] / 255)
      ch *= 255

    alpha = source.alpha + backdrop.alpha * (1 - source.alpha)

    return source.copy 'rgb', blent, alpha

  @parseHexString: (str) ->
    if m = str.match RE_HEX_COLOR
      str = m[1]
      l = str.length
      alpha = 1

      switch l
        when 1
          red = green = blue = 17 * parseInt str, 16
        when 2
          red = green = blue = parseInt str, 16
        when 3, 4
          red   = 17 * parseInt str[0], 16
          green = 17 * parseInt str[1], 16
          blue  = 17 * parseInt str[2], 16
          if l > 3
            alpha = (17 * parseInt str[3], 16) / 255
        when 6, 8
          red   = parseInt str[0..1], 16
          green = parseInt str[2..3], 16
          blue  = parseInt str[4..5], 16
          if l > 6
            alpha = (parseInt str[6..7], 16) / 255
        else
          throw new Error "Bad hex color: #{str}"

      return new @('rgb', [red, green, blue], alpha)

  @parseFuncString: (str) ->
    if m = str.match RE_FUNC_COLOR
      space = m[1].toLowerCase()

      if space[-1..] is 'a'
        space = space[...-1]

      args = m[2].toLowerCase().split /(?:\s*,\s*)+/

      # TODO UNITS!
      if space of SPACES
        channels = []

        for channel in SPACES[space]
          channels.push parseFloat args.shift()

        if args.length
          alpha = parseFloat args.shift()
        else
          alpha = 1

        if args.length
          throw new Error "Too many values passed to `#{space}()`"

        return new @(space, channels, alpha)
      else
        throw new Error "Bad color space: #{space}"

  @parse: (color) ->
    @parseHexString(color) or
    @parseFuncString(color) or
    throw new Error "Bad color string: #{color}"

  constructor: (space = 'rgb', channels, @alpha = 1) ->
    super()

    if not space in SPACES
      throw new ValueError "Unknown color space: #{space}"

    if channels?
      @channels = channels.slice()
    else
      @channels = (0 for c in SPACES[space])

    @space = space
    @alpha = min(1, max(@alpha, 0))

  do ->
    make_space_accessors = (space) ->
      Color.property space, ->
        if @space is space
          return @channels.slice()

        convertor = "#{@space}2#{space}"

        if not convertor of CONVERTORS
          throw new ValueError(
            "Cannot convert color from `#{@space}` to `#{space}`"
          )

        return CONVERTORS[convertor] @channels

    make_channel_accessors = (space, index, name) ->
      unless name of Color::
        Color.property name, -> @[space][index]

    for space of SPACES
      make_space_accessors space

      for channel, index in SPACES[space]
        make_channel_accessors space, index, channel.name

  clampChannel: (space, channel, value) ->
    if SPACES[space][channel].unit is 'deg'
      value %= SPACES[space][channel].max
      if value < 0
        value += SPACES[space][channel].max
    else
      value = min value, SPACES[space][channel].max
      value = max value, 0

    return value

  adjustChannel: (space, channel, amount, unit) ->
    if unit?
      if unit is '%'
        amount = SPACES[space][channel].max * amount / 100
      else if unit isnt SPACES[space][channel].unit
        throw new Error "Bad value for #{space} #{channel}: #{amount}#{unit}"

    channels = @[space]
    value = channels[channel] + amount
    channels[channel] = @clampChannel(space, channel, value)

    return @copy space, channels

  ###
  https://drafts.csswg.org/css-color-4/#luminance
  ###
  @property 'luminance', ->
    [r, g, b] = [@red, @green, @blue].map (channel, i) ->
      channel /= 255

      if channel <= .03928
        channel / 12.92
      else
        pow (channel + .055) / 1.055, 2.4

    return .2126 * r + .7152 * g + .0722 * b

  blend: (backdrop, mode) -> @class.blend @, backdrop, mode

  ###
  https://www.w3.org/TR/2008/REC-WCAG20-20081211/#contrast-ratiodef
  https://www.w3.org/TR/css-color-4/#contrast-ratio

  (L1 + 0.05) / (L2 + 0.05), where
  L1 is the relative luminance of the lighter of the colors, and
  L2 is the relative luminance of the darker of the colors.

  TODO This method does *not* care about alpha.
  ###
  contrastRatio: (other) ->
    l1 = @luminance + .05
    l2 = other.luminance + .05
    ratio = l1 / l2

    if ratio < 1
      ratio = 1 / ratio

    return ratio

  ###
  TODO At least an argument is required.
  ###
  contrast: (others...) ->
    winner = null
    record = 0

    for other in others
      # TODO This @blending is an assumption about how alpha should be handled.
      # Throw an exception when passing non full opaque colors?
      ratio = @contrastRatio other.blend(@)

      if ratio > record
        record = ratio
        winner = other

    return Null.ifNull winner

  isEqual: (other) ->
    if other instanceof Color
      other_channels = other[@space]

      for i in [0..SPACES[@space].length]
        if @channels[i] isnt other_channels[i]
          return no

      return @alpha is other.alpha

    return no

  isTransparent: -> @alpha is 0

  isOpaque: -> @alpha >= 1

  isEmpty: Color::isTransparent

  toRGBAString: ->
    comps = @['rgb'].map (c) -> round c

    if @alpha < 1
      comps.push round(@alpha * 100) / 100

    return "rgba(" + (comps.join ', ') + ')'

  toHexString: ->
    comps = @['rgb'].map round

    alpha = @alpha * 255

    if round(alpha) < 255
      comps.push alpha

    hex = '#'

    if comps.every((c) -> 0 is c % 17)
      hex += (comps.map((c) -> (c / 17).toString 16)).join ''
    else
      for c in comps
        c = (round c).toString 16

        if c.length < 2
          hex += '0'

        hex += c

    return hex

  ###
  TODO Wow. I defaulted to 'rgb' color space not to break the tests, but I think
  it should default to current color space (`@space`), which should be the "most
  accurate" when a color has been converted through color spaces. It affects
  cloning the colors.

  But it breaks the tests. For instance, with 'space = rgb':

    `#bf406a.rotate(40)` is `#bf6b40`

  While, with `space = @space`:

    `#bf406a.rotate(40)` is `#bf6a40`

  The first result **matches** Stylus and Less results, but even it could be
  wrong.

  PS: Note this does not break tests anymore because cloning is doing properly
  -better-, but it's still relevant.

  TODO Output channel decimals?
  ###
  toString: (space = @space) ->
    if space of SPACES
      channels = @[space].map (c) -> round c

      str = space
      str += 'a' if @alpha < 1
      str += '('
      str += channels.join ', '
      str += ", #{round(@alpha * 100) / 100}"
      str += ')'

      return str

    throw new InternalError

  reprValue: @::toString

  ###
  ###
  copy: (space = @space, channels = @channels, alpha = @alpha, etc...) ->
    super space, channels, alpha, etc...

  clone: -> @

  '.transparent?': -> Boolean.new @isTransparent()

  '.transparent': -> @copy undefined, undefined, 0

  '.opaque?': -> Boolean.new @isOpaque()

  '.opaque': -> @copy undefined, undefined, 1

  '.saturate': (context, amount) ->
    unless amount instanceof Number
      throw new ValueError "Bad argument for #{@reprType()}.saturate"

    return @adjustChannel 'hsl', 1, amount.value, amount.unit

  '.desaturate': (context, amount = Number.ONE_HUNDRED_PERCENT) ->
    unless amount instanceof Number
      throw new ValueError "Bad argument for #{@reprType()}.saturate"

    return @adjustChannel 'hsl', 1, -1 * amount.value, amount.unit

  '.whiten': (context, amount = Number.FIFTY_PERCENT) ->
    unless amount instanceof Number
      throw new ValueError "Bad argument for #{@reprType()}.whiten"

    return @adjustChannel 'hwb', 1, amount.value, amount.unit

  '.blacken': (context, amount = Number.FIFTY_PERCENT) ->
    unless amount instanceof Number
      throw new ValueError "Bad argument for #{@reprType()}.blacken"

    return @adjustChannel 'hwb', 2, amount.value, amount.unit

  '.darken': (context, amount = Number.TEN_PERCENT) ->
    unless amount instanceof Number
      throw new ValueError "Bad argument for #{@reprType()}.darken"

    return @adjustChannel 'hsl', 2, -1 * amount.value, amount.unit

  '.lighten': (context, amount = Number.TEN_PERCENT) ->
    unless amount instanceof Number
      throw new ValueError "Bad argument for #{@reprType()}.lighten"

    return @adjustChannel 'hsl', 2, amount.value, amount.unit

  # TODO: Use @luminance instead of @lightness? It seems more logical, but
  # it would be even more confusing: `light?` and `dark?` use luminance, but
  # `darken` and `lighten` use HSL lightness???
  '.light?': -> Boolean.new @lightness >= 50

  '.dark?': -> Boolean.new @lightness < 50

  '.grey?': ->
    Boolean.new (@red is @blue and @blue is @green)

  @::['.gray?'] = @::['.grey?']

  '.rotate': (context, amount) ->
    unless amount instanceof Number
      throw new ValueError "Bad argument for #{@reprType()}.rotate"

    amount = amount.convert('deg')

    return @adjustChannel 'hsl', 0, amount.value, amount.unit

  @::['.spin'] = @::['.rotate']

  '.opposite': -> @adjustChannel 'hsl', 0, 180

  # https://www.w3.org/TR/WCAG20/#relativeluminancedef
  '.luminance': -> new Number 100 * @luminance, '%'

  '.luminance?': -> Boolean.new @luminance > 0

  '.invert': ->
    @copy 'rgb', (255 - channel for channel in @rgb)

  # http://dev.w3.org/csswg/css-color/#tint-shade-adjusters
  '.tint': (context, amount = Number.FIFTY_PERCENT) ->
    white = @class.parse '#fff'
    white.alpha = amount.value / 100
    white.blend @

  '.shade': (context, amount = Number.FIFTY_PERCENT) ->
    black = @class.parse '#000'
    black.alpha = amount.value / 100
    black.blend @

  '.contrast-ratio': (context, other) ->
    new Number @contrastRatio other

  '.contrast': (context, others...) -> @contrast others...

  '.blend': (context, backdrop, mode = undefined) ->
    unless backdrop instanceof Color
      throw new ValueError "Bad `mode` argument for [#{@reprType()}.blend]"

    if mode?
      unless mode instanceof String
        throw new ValueError (
          "Bad `mode` argument for [#{@reprType()}.blend]"
        )

      mode = mode.value

    return @blend backdrop, mode

  '.safe?': ->
    if @alpha < 1
      return Boolean.FALSE

    for channel in @rgb
      if channel % 51
        return Boolean.FALSE

    return Boolean.TRUE

  '.safe': ->
    if @alpha < 1
      throw new Error "Cannot make safe a non-opaque color"

    channels = @rgb.map (channel) -> 51 * round(channel / 51)

    return @copy 'rgb', channels

  # Individual channel accessors
  '.alpha': (context, value) ->
    if not value?
      return new Number @alpha

    unless value instanceof Number
      throw new Error "Bad alpha value: #{value}"

    if value.unit is '%'
      value = value.value / 100
    else if value.isPure()
      value = value.value
    else
      throw new Error "Bad alpha value: #{value}"

    return @copy undefined, undefined, value

  do ->
    make_accessors = (space, index, channel) ->
      name = channel.name

      Color::[".#{name}"] ?= (context, value) ->
        if not value?
          return new Number @[space][index], channel.unit

        unless value instanceof Number
          throw new Error "Bad `#{name}` channel value: #{value.repr()}"

        if value.unit is '%'
          value = channel.max * value.value / 100
        else
          if channel.unit and not value.isPure()
            value = value.convert channel.unit

          value = @clampChannel space, index, value.value

        channels = @[space].slice()
        channels[index] = value

        return @copy space, channels

    for space of SPACES
      for channel, index in SPACES[space]
        make_accessors space, index, channel


module.exports = Color
