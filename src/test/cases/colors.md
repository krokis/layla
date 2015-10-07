Colors
======

- Are expressed with hexadecimal notation

  ~~~ lay
  color: #a2f
  color: #666
  color: #fefefe
  ~~~

  ~~~ css
  color: #aa22ff;
  color: #666666;
  color: #fefefe;
  ~~~

- Can have 6 digits

  ~~~ lay
  six: #000000
  six: #ffffff
  six: #a7cb82
  ~~~

  ~~~ css
  six: #000000;
  six: #ffffff;
  six: #a7cb82;
  ~~~

- Can have 3 digits

  ~~~ lay
  three: #000
  three: #fff
  three: #7ab
  ~~~

  ~~~ css
  three: #000000;
  three: #ffffff;
  three: #77aabb;
  ~~~

- Can have 8 digits

  ~~~ lay
  eight: #00000000
  eight: #ffffffff
  eight: #a7cb82ab
  ~~~

  ~~~ css
  eight: #00000000;
  eight: #ffffff;
  eight: #a7cb82ab;
  ~~~

- Can have 4 digits

  ~~~ lay
  four: #0000
  four: #000a
  four: #ffff
  four: #b78c
  ~~~

  ~~~ css
  four: #00000000;
  four: #000000aa;
  four: #ffffff;
  four: #bb7788cc;
  ~~~

- Can have 2 digits

  ~~~ lay
  two: #00
  two: #ff
  two: #3a
  ~~~

  ~~~ css
  two: #000000;
  two: #ffffff;
  two: #3a3a3a;
  ~~~

- Can have 1 single digit

  ~~~ lay
  one: #0
  one: #f
  one: #3
  ~~~

  ~~~ css
  one: #000000;
  one: #ffffff;
  one: #333333;
  ~~~

- Are always trueish

  ~~~ lay
  foo: #f.true? (#a7 and true) #000.true? #fff0.true? #00000000.true?
  ~~~

  ~~~ css
  foo: true true true true true;
  ~~~

## Methods

### `transparent?`

- Returns `true` if the color is fully transparent

  ~~~ lay
  foo: #000.transparent?
  foo: #0.transparent?
  foo: #000f.transparent?
  foo: #0000.transparent?
  foo: not #000f.transparent?
  foo: #0000.transparent?
  ~~~

  ~~~ css
  foo: false;
  foo: false;
  foo: false;
  foo: true;
  foo: true;
  foo: true;
  ~~~

### `transparent`

- Returns a fully transparent version of the color

  ~~~ lay
  foo: #000.transparent
  foo: #000d.transparent
  foo: #000f.transparent
  foo: #fa2a.transparent
  foo: #b271acf2.transparent
  ~~~

  ~~~ css
  foo: #00000000;
  foo: #00000000;
  foo: #00000000;
  foo: #ffaa2200;
  foo: #b271ac00;
  ~~~

### `empty?`

- Is an alias of `transparent?`

  ~~~ lay
  foo: (not #000f.empty?) #0000.empty?
  ~~~

  ~~~ css
  foo: true true;
  ~~~

### `opaque?`

- Returns `true` if the color is fully opaque

  ~~~ lay
  foo: #000.opaque?
  foo: #000d.opaque?
  foo: #0000.opaque?
  foo: #000f.opaque?
  ~~~

  ~~~ css
  foo: true;
  foo: false;
  foo: false;
  foo: true;
  ~~~

### `opaque`

- Returns a fully opaque version of the color

  ~~~ lay
  foo: #000.opaque
  foo: #000d.opaque
  foo: #fa2a.opaque
  foo: #b271acf2.opaque
  ~~~

  ~~~ css
  foo: #000000;
  foo: #000000;
  foo: #ffaa22;
  foo: #b271ac;
  ~~~

### `alpha`

- Returns the alpha component of the color as a percentage

  ~~~ lay
  transparency: #f000.alpha #000000b3.alpha #fc3ad0.alpha #ad0fb101.alpha
  ~~~

  ~~~ css
  transparency: 0 70.2% 100% 0.39%;
  ~~~

### `apha=`

- Sets the alpha component of the color

  ~~~ lay
  a = #f000
  b = #000000b3
  c = #fc3ad0
  d = #ad0fb101

  I: a a.alpha, b b.alpha, c c.alpha, d d.alpha

  a.alpha = 100%
  b.alpha = 0%
  c.alpha = 27%
  d.alpha = 99%

  II: a a.alpha, b b.alpha, c c.alpha, d d.alpha
  ~~~

  ~~~ css
  I: #ff000000 0, #000000b3 70.2%, #fc3ad0 100%, #ad0fb101 0.39%;
  II: #ff0000 100%, #00000000 0, #fc3ad045 27%, #ad0fb1fc 99%;
  ~~~

- Only accepts a percentage or a pure number in the 0..255 range

### `alpha?`

- Returns `true` if the alpha of the color is greater than `0`

  ~~~ lay
  foo: #000.alpha?
  foo: not #fa76cc.alpha?
  ~~~

  ~~~ css
  foo: true;
  foo: false;
  ~~~

### `red`

- Returns the red component of the color as a percentage

  ~~~ lay
  red: #f000.red #000.red #fc3ad0.red
  ~~~

  ~~~ css
  red: 100% 0 98.82%;
  ~~~

### `red=`

- Sets the red component of the color

  ~~~ lay
  a = #f000
  b = #000
  c = #fc3ad0
  I: a a.red, b  b.red, c c.red
  a.red = 50%
  b.red = 100%
  c.red = 128
  II: a a.red, b b.red, c c.red
  ~~~

  ~~~ css
  I: #ff000000 100%, #000000 0, #fc3ad0 98.82%;
  II: #80000000 50%, #ff0000 100%, #803ad0 50.2%;
  ~~~

- Only accepts a percentage or a pure number in the 0..255 range

### `red?`

- Returns `true` if the red component of the color is not `0`

  ~~~ lay
  foo: #000.red?
  foo: #110.red?
  foo: #ffffff.red?
  ~~~

  ~~~ css
  foo: false;
  foo: true;
  foo: true;
  ~~~

### `green`

- Returns the green component of the color as a percentage

  ~~~ lay
  green: #0f0.green #000.green #fc3ad0.green
  ~~~

  ~~~ css
  green: 100% 0 22.75%;
  ~~~

### `green=`

- Sets the green component of the color

  ~~~ lay
  a = #0f00
  b = #000
  c = #fc3ad0
  I: a a.green, b  b.green, c c.green
  a.green = 50%
  b.green = 100%
  c.green = 128
  II: a a.green, b b.green, c c.green
  ~~~

  ~~~ css
  I: #00ff0000 100%, #000000 0, #fc3ad0 22.75%;
  II: #00800000 50%, #00ff00 100%, #fc80d0 50.2%;
  ~~~

- Only accepts a percentage or a pure number in the 0..255 range

### `green?`

- Returns `true` if the green component of the color is not `0`

  ~~~ lay
  foo: #000.green?
  foo: #010.green?
  foo: #ffffff.green?
  ~~~

  ~~~ css
  foo: false;
  foo: true;
  foo: true;
  ~~~

### `blue`

- Returns the blue component of the color as a percentage

  ~~~ lay
  blue: #00f.blue #000.blue #fc3ad0.blue
  ~~~

  ~~~ css
  blue: 100% 0 81.57%;
  ~~~

### `blue=`

- Sets the blue component of the color

  ~~~ lay
  a = #00f0
  b = #000
  c = #fc3ad0
  I: a a.blue, b  b.blue, c c.blue
  a.blue = 50%
  b.blue = 100%
  c.blue = 128
  II: a a.blue, b b.blue, c c.blue
  ~~~

  ~~~ css
  I: #0000ff00 100%, #000000 0, #fc3ad0 81.57%;
  II: #00008000 50%, #0000ff 100%, #fc3a80 50.2%;
  ~~~

- Only accepts a percentage or a pure number in the 0..255 range

### `blue?`

- Returns `true` if the blue component of the color is not `0`

  ~~~ lay
  foo: #000.blue?
  foo: #7a0.blue?
  foo: #70a.blue?
  foo: #ffffff.blue?
  ~~~

  ~~~ css
  foo: false;
  foo: false;
  foo: true;
  foo: true;
  ~~~

### `grey?`

- Return `true` if the color is it's white, black or a shade of grey

  ~~~ lay
  foo: #000.grey?
  foo: #666.grey?
  foo: #f07.grey?
  foo: #ffffff.grey?
  ~~~

  ~~~ css
  foo: true;
  foo: true;
  foo: false;
  foo: true;
  ~~~

### `gray?`

- Is an alias of `grey?`

  ~~~ lay
  foo: #000.gray? #666.gray? #f07.gray? #ffffff.gray?
  ~~~

  ~~~ css
  foo: true true false true;
  ~~~

### `hue`

- Returns the hue component of the color in degrees

  ~~~ lay
  hue: #fa20.hue
  hue: #000.hue
  hue: #fff.hue
  hue: #db0.hue
  ~~~

  ~~~ css
  hue: 36.92deg;
  hue: 0;
  hue: 0;
  hue: 50.77deg;
  ~~~

### `hue=`

- Sets the hue of the color

- Only accepts a pure number, a percentage or an angle

### `saturation`

- Returns the saturation component of the color as a percentage

  ~~~ lay
  sat: #fa20.saturation
  sat: #000.saturation
  sat: #fff.saturation
  sat: #22b.saturation
  sat: #FF4500.saturation
  sat: #57220fdd.saturation.round
  sat: #a6e548.saturation.round
  ~~~

  ~~~ css
  sat: 100%;
  sat: 0;
  sat: 0;
  sat: 69.23%;
  sat: 100%;
  sat: 71%;
  sat: 75%;
  ~~~

### `saturation=`

- Sets the saturation of the color

- Only accepts a percentage or a pure number in the 0..255 range

### `lightness`

- Returns the lightness of the color as a percentage

  ~~~ lay
  light: #fa20.lightness
  light: #000.lightness
  light: #fff.lightness
  light: #22b.lightness
  ~~~

  ~~~ css
  light: 56.67%;
  light: 0;
  light: 100%;
  light: 43.33%;
  ~~~

### `lightness=`

- Sets the lightness of the color

- Only accepts a percentage or a pure number in the 0..255 range

### `light?`

- Tells if the color is light (ie: it's lightness is >= 50%)

  ~~~ lay
  foo: #000.light?
  foo: #ffff.light?
  foo: #00ff40.light?
  foo: #333.light?
  ~~~

  ~~~ css
  foo: false;
  foo: true;
  foo: true;
  foo: false;
  ~~~

### `dark?`

- Tells if the color is dark (ie: it's lightness is < 50%)

  ~~~ lay
  foo: #000.dark?
  foo: #ffff.dark?
  foo: #00ff40.dark?
  foo: #333.dark?
  ~~~

  ~~~ css
  foo: true;
  foo: false;
  foo: false;
  foo: true;
  ~~~

### `luma`

- Returns the luma (perceptual brightness) of the color as a percentage

### `luma=`

- Sets the luma of the color

- Only accepts...

### `luminance`

- Returns the luminance of the color as a percentage

### `luminance=`

- Sets the luminance of the color

- Only accepts...

### `lighten`

- Returns a copy of the color with increased lightness

- Only accepts...

### `darken`

- Returns a copy of the color with decreased lightnes

- Only accepts...

### `saturate`

- Returns a saturated copy of the color

- Only accepts...

### `desaturate`

- Returns a desaturated copy of the color

- Only accepts...

### `grey`/`gray`

- Are alias of `desaturate`

### `spin`

- Rotates the hue angle of the color

- Only accepts...

### `whiteness`

### `whiteness=`

### `blackness`

### `blackness=`

### `tint`

### `shade`

### `contrast`

### `blend`

- Blends two colors

## Operators

### `is`

- Returns `true` only for colors with the same components

  ~~~ lay
  foo: #000 is #000
  foo: #000 is #000000
  foo: #000 isnt red
  foo: #f02 is #ff0022
  foo: #f02 is #ff0022ff
  foo: #f02e isnt #ff0022ff
  foo: not (#f02 isnt #ff0022)
  ~~~

  ~~~ css
  foo: true;
  foo: true;
  foo: true;
  foo: true;
  foo: true;
  foo: true;
  foo: true;
  ~~~

### `+`

- Mixes two colors

### `-`
