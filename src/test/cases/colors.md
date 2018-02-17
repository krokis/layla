# Colors

- Are expressed with hexadecimal notation

  ~~~ lay
  color[hex] {
    color: #a2f
    color: #666
    color: #fefefe
  }
  ~~~

  ~~~ css
  color[hex] {
    color: #aa22ff;
    color: #666666;
    color: #fefefe;
  }
  ~~~

- Can have 6 digits

  ~~~ lay
  color[hex="6"] {
    six: #000000
    six: #ffffff
    six: #a7cb82
  }
  ~~~

  ~~~ css
  color[hex="6"] {
    six: #000000;
    six: #ffffff;
    six: #a7cb82;
  }
  ~~~

- Can have 3 digits

  ~~~ lay
  color[hex="3"] {
    three: #000
    three: #fff
    three: #7ab
  }
  ~~~

  ~~~ css
  color[hex="3"] {
    three: #000000;
    three: #ffffff;
    three: #77aabb;
  }
  ~~~

- Can have 8 digits

  ~~~ lay
  color[hex="8"] {
    eight: #00000000
    eight: #ffffffff
    eight: #a7cb82ab
  }
  ~~~

  ~~~ css
  color[hex="8"] {
    eight: rgba(0, 0, 0, 0);
    eight: #ffffff;
    eight: rgba(167, 203, 130, 0.67);
  }
  ~~~

- Can have 4 digits

  ~~~ lay
  color[hex="4"] {
    four: #0000
    four: #000a
    four: #ffff
    four: #b78c
  }
  ~~~

  ~~~ css
  color[hex="4"] {
    four: rgba(0, 0, 0, 0);
    four: rgba(0, 0, 0, 0.67);
    four: #ffffff;
    four: rgba(187, 119, 136, 0.8);
  }
  ~~~

- Can have 2 digits

  ~~~ lay
  color[hex="2"] {
    two: #00
    two: #ff
    two: #3a
  }
  ~~~

  ~~~ css
  color[hex="2"] {
    two: #000000;
    two: #ffffff;
    two: #3a3a3a;
  }
  ~~~

- Can have 1 single digit

  ~~~ lay
  color[hex="1"] {
    one: #0
    one: #f
    one: #3
  }
  ~~~

  ~~~ css
  color[hex="1"] {
    one: #000000;
    one: #ffffff;
    one: #333333;
  }
  ~~~

- Are always trueish

  ~~~ lay
  color.true {
    foo: #f.true? (#a7 and true) (#0000 or true) #000.true? #fff0.true? #00000000.true?
  }
  ~~~

  ~~~ css
  color.true {
    foo: true true rgba(0, 0, 0, 0) true true true;
  }
  ~~~

## Operators

### `==`

- Returns `true` only for colors with the same channels

  ~~~ lay
  color.equal {
    i: #000 == #000
    ii: #000 == #000000
    iii: #000 == red
    iv: #f02 == #ff0022
    vi: #f02 == #ff0022ff
    vi: #f02e == #ff0022ff
    vii: not (#f02 == #ff0022)
  }
  ~~~

  ~~~ css
  color.equal {
    i: true;
    ii: true;
    iii: false;
    iv: true;
    vi: true;
    vi: false;
    vii: false;
  }
  ~~~

### `!=`

- Returns `false` only for colors with the same channels

  ~~~ lay
  color.not-equal {
    i: #000 != #000
    ii: #000 != #000000
    iii: #000 != red
    iv: #f02 != #ff0022
    vi: #f02 != #ff0022ff
    vi: #f02e != #ff0022ff
    vii: not (#f02 != #ff0022)
  }
  ~~~

  ~~~ css
  color.not-equal {
    i: false;
    ii: false;
    iii: true;
    iv: false;
    vi: false;
    vi: true;
    vii: true;
  }
  ~~~

## Methods

### `transparent?`

- Returns `true` if the color is fully transparent

  ~~~ lay
  color.transparent {
    i: #000.transparent?
    ii: #0.transparent?
    iii: #000f.transparent?
    iv: #0000.transparent?
    v: not #000f.transparent?
    vi: #0000.transparent?
    vii: #aabbcc01.transparent?
    viii: #aabbccfe.transparent?
  }
  ~~~

  ~~~ css
  color.transparent {
    i: false;
    ii: false;
    iii: false;
    iv: true;
    v: true;
    vi: true;
    vii: false;
    viii: false;
  }
  ~~~

### `transparent`

- Returns a fully transparent version of the color

  ~~~ lay
  color.transparent {
    i: #000.transparent
    ii: #000d.transparent
    iii: #000f.transparent
    iv: #fa2a.transparent
    v: #b271acf2.transparent
  }
  ~~~

  ~~~ css
  color.transparent {
    i: rgba(0, 0, 0, 0);
    ii: rgba(0, 0, 0, 0);
    iii: rgba(0, 0, 0, 0);
    iv: rgba(255, 170, 34, 0);
    v: rgba(178, 113, 172, 0);
  }
  ~~~

### `empty?`

- Is an alias of `transparent?`

  ~~~ lay
  color.empty {
    foo: (not #000f.empty?) #0000.empty?
  }
  ~~~

  ~~~ css
  color.empty {
    foo: true true;
  }
  ~~~

### `opaque?`

- Returns `true` if the color is fully opaque

  ~~~ lay
  color.opaque {
    i: #000.opaque?
    ii: #000d.opaque?
    iii: #0000.opaque?
    iv: #000f.opaque?
    v: #aabbcc01.opaque?
    vi: #aabbccfe.opaque?
  }
  ~~~

  ~~~ css
  color.opaque {
    i: true;
    ii: false;
    iii: false;
    iv: true;
    v: false;
    vi: false;
  }
  ~~~

### `opaque`

- Returns a fully opaque version of the color

  ~~~ lay
  color.opaque {
    foo: #000.opaque
    foo: #000d.opaque
    foo: #fa2a.opaque
    foo: #b271acf2.opaque
  }
  ~~~

  ~~~ css
  color.opaque {
    foo: #000000;
    foo: #000000;
    foo: #ffaa22;
    foo: #b271ac;
  }
  ~~~

### `grey?`

- Return `true` if the color is white, black or a shade of grey

  ~~~ lay
  color.grey {
    foo: #000.grey?
    foo: #666.grey?
    foo: #f07.grey?
    foo: #ffffff.grey?
  }
  ~~~

  ~~~ css
  color.grey {
    foo: true;
    foo: true;
    foo: false;
    foo: true;
  }
  ~~~

### `gray?`

- Is an alias of `grey?`

  ~~~ lay
  color.gray {
    foo: #000.gray? #666.gray? #f07.gray? #ffffff.gray?
  }
  ~~~

  ~~~ css
  color.gray {
    foo: true true false true;
  }
  ~~~

### `saturate`

- Returns a saturated copy of the color

  ~~~ lay
  color.saturate {
    i: #29332f.saturate(20%)
  }
  ~~~

  ~~~ css
  color.saturate {
    i: #203c31;
  }
  ~~~

### `desaturate`

- Returns a desaturated copy of the color

  ~~~ lay
  color.desaturate {
    i: #203c31.desaturate(20%)
    ii: #203c31.desaturate
    iii: #203c31.desaturate(100%)
  }
  ~~~

  ~~~ css
  color.desaturate {
    i: #29332f;
    ii: #2e2e2e;
    iii: #2e2e2e;
  }
  ~~~

### `light?`

- Tells if the color is light (ie: its lightness is >= 50%)

  ~~~ lay
  color.light {
    foo: #000.light?
    foo: #ffff.light?
    foo: #00ff40.light?
    foo: #333.light?
  }
  ~~~

  ~~~ css
  color.light {
    foo: false;
    foo: true;
    foo: true;
    foo: false;
  }
  ~~~

### `dark?`

- Tells if the color is dark (ie: its lightness is < 50%)

  ~~~ lay
  color.dark {
    foo: #000.dark?
    foo: #ffff.dark?
    foo: #00ff40.dark?
    foo: #333.dark?
  }
  ~~~

  ~~~ css
  color.dark {
    foo: true;
    foo: false;
    foo: false;
    foo: true;
  }
  ~~~

### `luminance`

- Returns the relative luminance of the color as a percentage

  ~~~ lay
  color.luminance {
    i: #fff.luminance
    ii: #000.luminance
    iii: #f00.luminance
    iv: #f00a.luminance
    v: #00ff00.luminance
    vi: #0000ff.luminance
    vii: #ffff00.luminance
    viii: #00ffff.luminance
    ix: #ff0000.luminance
  }
  ~~~

  ~~~ css
  color.luminance {
    i: 100%;
    ii: 0;
    iii: 21.26%;
    iv: 21.26%;
    v: 71.52%;
    vi: 7.22%;
    vii: 92.78%;
    viii: 78.74%;
    ix: 21.26%;
  }
  ~~~

### `luminance?`

- Returns `true` if the color has any luminance (ie: its luminance is > 0%)

  ~~~ lay
  color.luminance {
    i: #fff.luminance?
    ii: #000.luminance?
    iii: #f00.luminance?
    iv: #f00a.luminance?
    v: #00ff00.luminance?
    vi: #0000ff.luminance?
    vii: #ffff00.luminance?
    viii: #00ffff.luminance?
    ix: #ff0000.luminance?
    x: #0000.luminance?
    xi: #000f.luminance?
  }
  ~~~

  ~~~ css
  color.luminance {
    i: true;
    ii: false;
    iii: true;
    iv: true;
    v: true;
    vi: true;
    vii: true;
    viii: true;
    ix: true;
    x: false;
    xi: false;
  }
  ~~~

### `contrast-ratio`

- Returns the contrast ratio with another color, as a number

  ~~~ lay
  color.contrast-ratio {
    // Borrowed from Stylus
    i: #fff.contrast-ratio(#fff)
    ii: #f00.contrast-ratio(#0f0)
  }
  ~~~

  ~~~ css
  color.contrast-ratio {
    i: 1;
    ii: 2.91;
  }
  ~~~

### `contrast`

- Picks the color with the maximum contrast ratio

  ~~~ lay
  // Borrowed from Less
  color.contrast {
    // Borrowed from Less
    contrast-light: #fff.contrast(#111111, #eeeeee)
    contrast-dark: #000.contrast(#111111, #eeeeee)
  }
  ~~~

  ~~~ css
  color.contrast {
    contrast-light: #111111;
    contrast-dark: #eeeeee;
  }
  ~~~

### `lighten`

- Returns a copy of the color with increased lightness

  ~~~ lay
  color.lighten {
    i: #ff0000.lighten(40%)
    ii: #ff0000.lighten
    iii: #000.lighten(200%)
  }
  ~~~

  ~~~ css
  color.lighten {
    i: #ffcccc;
    ii: #ff3333;
    iii: #ffffff;
  }
  ~~~

### `darken`

- Returns a copy of the color with decreased lightnes

  ~~~ lay
  color.darken {
    i: #ff0000.darken(40%)
    ii: #ff0000.darken
    iii: #fff.darken(200%)
  }
  ~~~

  ~~~ css
  color.darken {
    i: #330000;
    ii: #cc0000;
    iii: #000000;
  }
  ~~~

### `rotate`

- Rotates the hue angle of the color

  ~~~ lay
  color.rotate {
    i: #bf406a.rotate(40)
    ii: #ff0000.rotate(90deg)
    iii: #bf406a.rotate(180)
  }
  ~~~

  ~~~ css
  color.rotate {
    i: #bf6b40;
    ii: #80ff00;
    iii: #40bf95;
  }
  ~~~

### `spin`

- Is an alias of `rotate`

  ~~~ lay
  color.spin {
    i: #bf406a.spin(40)
    ii: #ff0000.spin(90deg)
  }
  ~~~

  ~~~ css
  color.spin {
    i: #bf6b40;
    ii: #80ff00;
  }
  ~~~

### `opposite`

- Returns a copy of the color, rotated 180 degrees

  ~~~ lay
  color.opposite {
    i: #bf406a.opposite
    ii: #000.opposite
    iii: #fff.opposite
  }
  ~~~

  ~~~ css
  color.opposite {
    i: #40bf95;
    ii: #000000;
    iii: #ffffff;
  }
  ~~~

### `invert`

- Returns the invert color

  ~~~ lay
  color.invert {
    i: #437a86.invert
    ii: #0.invert
    iii: #f.invert
    iv: #000d.invert
    v: #ffff.invert
  }
  ~~~

  ~~~ css
  color.invert {
    i: #bc8579;
    ii: #ffffff;
    iii: #000000;
    iv: rgba(255, 255, 255, 0.87);
    v: #000000;
  }
  ~~~

### `tint`

- Mixes the color with pure white

  ~~~ lay
  color.tint {
    i: #777777.tint(13)
    ii: #777777.tint(100)
    iii: #777777.tint(13%)
    iv: #777777.tint(-13%)
  }
  ~~~

  ~~~ css
  color.tint {
    i: #898989;
    ii: #ffffff;
    iii: #898989;
    iv: #656565;
  }
  ~~~

### `shade`

- Mixes the color with pure black

  ~~~ lay
  color.shade {
    i: #777777.shade(13)
    ii: #777777.shade(100)
    iii: #777777.shade(13%)
    iv: #777777.shade(-13%)
  }
  ~~~

  ~~~ css
  color.shade {
    i: #686868;
    ii: #000000;
    iii: #686868;
    iv: #868686;
  }
  ~~~

### `whiten`

- Changes the color `whiteness` on the HWB color space

  ~~~ lay
  color.whiten {
    i: #f01d93.whiten(20%)
    ii: #adff2f1d.whiten(-8%)
    iii: #000.whiten(100%)
    iv: #f00.whiten
  }
  ~~~

  ~~~ css
  color.whiten {
    i: #f050a9;
    ii: rgba(165, 255, 27, 0.11);
    iii: #808080;
    iv: #ff8080;
  }
  ~~~

### `blacken`

- Changes the color `blackness` on the HWB color space

  ~~~ lay
  color.blacken {
    i: #f01d93.blacken(20%)
    ii: #adff2f1d.blacken(-8%)
    iii: #fff.blacken(100%)
    iv: #f00.blacken
  }
  ~~~

  ~~~ css
  color.blacken {
    i: #bd1d76;
    ii: rgba(173, 255, 47, 0.11);
    iii: #808080;
    iv: #800000;
  }
  ~~~

### `safe?`

- Returns `true` if the color is a web safe color

  ~~~ lay
  color.safe {
    i: #000.safe?
    ii: #fff.safe?
    iii: #32cc00.safe?
  }
  ~~~

  ~~~ css
  color.safe {
    i: true;
    ii: true;
    iii: false;
  }
  ~~~

- Returns `false` for non-opaque colors

  ~~~ lay
  color.safe {
    i: #66cc00da.safe?
    ii: #0000.safe?
  }
  ~~~

  ~~~ css
  color.safe {
    i: false;
    ii: false;
  }
  ~~~

### `safe`

- Returns the closest web safe color

  ~~~ lay
  color.safe {
    i: #020d63.safe
    ii: #fff.safe
    iii: #32bc06.safe
  }
  ~~~

  ~~~ css
  color.safe {
    i: #000066;
    ii: #ffffff;
    iii: #33cc00;
  }
  ~~~

### Channel accessors

#### `alpha`

- Returns the `alpha` channel of the color

  ~~~ lay
  color.alpha {
    i: #000000.alpha.round(2)
    ii: #ffffff.alpha.round(2)
    iii: #f01d93.alpha.round(2)
    iv: #008b8b99.alpha.round(2)
    v: #adff2f1c.alpha.round(2)
  }
  ~~~

  ~~~ css
  color.alpha {
    i: 1;
    ii: 1;
    iii: 1;
    iv: 0.6;
    v: 0.11;
  }
  ~~~

- Adjusts the `alpha` channel of the color

  ~~~ lay
  color.alpha {
    $i = #000000
    $i = $i.alpha(0)
    i: $i.alpha.round(2)

    $i = $i.alpha(.1)
    ii: $i.alpha.round(2)

    $i = $i.alpha(99%)
    iii: $i.alpha.round(2)

    $i = $i.alpha(100%)
    iv: $i.alpha.round(2)

    $i = $i.alpha(1)
    v: $i.alpha.round(2)

    $ii = #ffffff
    $ii = $ii.alpha(0)
    vi: $ii.alpha.round(2)

    $ii = $ii.alpha(.1)
    vii: $ii.alpha.round(2)

    $ii = $ii.alpha(99%)
    viii: $ii.alpha.round(2)

    $ii = $ii.alpha(100%)
    ix: $ii.alpha.round(2)

    $ii = $ii.alpha(1)
    x: $ii.alpha.round(2)

    $iii = #f01d93
    $iii = $iii.alpha(0)
    xi: $iii.alpha.round(2)

    $iii = $iii.alpha(.1)
    xii: $iii.alpha.round(2)

    $iii = $iii.alpha(99%)
    xiii: $iii.alpha.round(2)

    $iii = $iii.alpha(100%)
    xiv: $iii.alpha.round(2)

    $iii = $iii.alpha(1)
    xv: $iii.alpha.round(2)

    $iv = #008b8b99
    $iv = $iv.alpha(0)
    xvi: $iv.alpha.round(2)

    $iv = $iv.alpha(.1)
    xvii: $iv.alpha.round(2)

    $iv = $iv.alpha(99%)
    xviii: $iv.alpha.round(2)

    $iv = $iv.alpha(100%)
    xix: $iv.alpha.round(2)

    $iv = $iv.alpha(1)
    xx: $iv.alpha.round(2)

    $v = #adff2f1c
    $v = $v.alpha(0)
    xxi: $v.alpha.round(2)

    $v = $v.alpha(.1)
    xxii: $v.alpha.round(2)

    $v = $v.alpha(99%)
    xxiii: $v.alpha.round(2)

    $v = $v.alpha(100%)
    xxiv: $v.alpha.round(2)

    $v = $v.alpha(1)
    xxv: $v.alpha.round(2)
  }
  ~~~

  ~~~ css
  color.alpha {
    i: 0;
    ii: 0.1;
    iii: 0.99;
    iv: 1;
    v: 1;
    vi: 0;
    vii: 0.1;
    viii: 0.99;
    ix: 1;
    x: 1;
    xi: 0;
    xii: 0.1;
    xiii: 0.99;
    xiv: 1;
    xv: 1;
    xvi: 0;
    xvii: 0.1;
    xviii: 0.99;
    xix: 1;
    xx: 1;
    xxi: 0;
    xxii: 0.1;
    xxiii: 0.99;
    xxiv: 1;
    xxv: 1;
  }
  ~~~

#### `red`

- Returns the `red` channel of the color

  ~~~ lay
  color.red {
    i: #000000.red.round
    ii: #ffffff.red.round
    iii: #f01d93.red.round
    iv: #008b8b99.red.round
    v: #adff2f1c.red.round
  }
  ~~~

  ~~~ css
  color.red {
    i: 0;
    ii: 255;
    iii: 240;
    iv: 0;
    v: 173;
  }
  ~~~

- Adjusts the `red` channel of the color

  ~~~ lay
  color.red {
    $i = #000000
    $i = $i.red(0)
    i: $i.red.round

    $i = $i.red(127.50)
    ii: $i.red.round

    $i = $i.red(255)
    iii: $i.red.round

    $i = $i.red(100%)
    iv: $i.red.round

    $i = $i.red(33.33%)
    v: $i.red.round

    $ii = #ffffff
    $ii = $ii.red(0)
    vi: $ii.red.round

    $ii = $ii.red(127.50)
    vii: $ii.red.round

    $ii = $ii.red(255)
    viii: $ii.red.round

    $ii = $ii.red(100%)
    ix: $ii.red.round

    $ii = $ii.red(33.33%)
    x: $ii.red.round

    $iii = #f01d93
    $iii = $iii.red(0)
    xi: $iii.red.round

    $iii = $iii.red(127.50)
    xii: $iii.red.round

    $iii = $iii.red(255)
    xiii: $iii.red.round

    $iii = $iii.red(100%)
    xiv: $iii.red.round

    $iii = $iii.red(33.33%)
    xv: $iii.red.round

    $iv = #008b8b99
    $iv = $iv.red(0)
    xvi: $iv.red.round

    $iv = $iv.red(127.50)
    xvii: $iv.red.round

    $iv = $iv.red(255)
    xviii: $iv.red.round

    $iv = $iv.red(100%)
    xix: $iv.red.round

    $iv = $iv.red(33.33%)
    xx: $iv.red.round

    $v = #adff2f1c
    $v = $v.red(0)
    xxi: $v.red.round

    $v = $v.red(127.50)
    xxii: $v.red.round

    $v = $v.red(255)
    xxiii: $v.red.round

    $v = $v.red(100%)
    xxiv: $v.red.round

    $v = $v.red(33.33%)
    xxv: $v.red.round
  }
  ~~~

  ~~~ css
  color.red {
    i: 0;
    ii: 128;
    iii: 255;
    iv: 255;
    v: 85;
    vi: 0;
    vii: 128;
    viii: 255;
    ix: 255;
    x: 85;
    xi: 0;
    xii: 128;
    xiii: 255;
    xiv: 255;
    xv: 85;
    xvi: 0;
    xvii: 128;
    xviii: 255;
    xix: 255;
    xx: 85;
    xxi: 0;
    xxii: 128;
    xxiii: 255;
    xxiv: 255;
    xxv: 85;
  }
  ~~~

#### `green`

- Returns the `green` channel of the color

  ~~~ lay
  color.green {
    i: #000000.green.round
    ii: #ffffff.green.round
    iii: #f01d93.green.round
    iv: #008b8b99.green.round
    v: #adff2f1c.green.round
  }
  ~~~

  ~~~ css
  color.green {
    i: 0;
    ii: 255;
    iii: 29;
    iv: 139;
    v: 255;
  }
  ~~~

- Adjusts the `green` channel of the color

  ~~~ lay
  color.green {
    $i = #000000
    $i = $i.green(0)
    i: $i.green.round

    $i = $i.green(127.50)
    ii: $i.green.round

    $i = $i.green(255)
    iii: $i.green.round

    $i = $i.green(100%)
    iv: $i.green.round

    $i = $i.green(33.33%)
    v: $i.green.round

    $ii = #ffffff
    $ii = $ii.green(0)
    vi: $ii.green.round

    $ii = $ii.green(127.50)
    vii: $ii.green.round

    $ii = $ii.green(255)
    viii: $ii.green.round

    $ii = $ii.green(100%)
    ix: $ii.green.round

    $ii = $ii.green(33.33%)
    x: $ii.green.round

    $iii = #f01d93
    $iii = $iii.green(0)
    xi: $iii.green.round

    $iii = $iii.green(127.50)
    xii: $iii.green.round

    $iii = $iii.green(255)
    xiii: $iii.green.round

    $iii = $iii.green(100%)
    xiv: $iii.green.round

    $iii = $iii.green(33.33%)
    xv: $iii.green.round

    $iv = #008b8b99
    $iv = $iv.green(0)
    xvi: $iv.green.round

    $iv = $iv.green(127.50)
    xvii: $iv.green.round

    $iv = $iv.green(255)
    xviii: $iv.green.round

    $iv = $iv.green(100%)
    xix: $iv.green.round

    $iv = $iv.green(33.33%)
    xx: $iv.green.round

    $v = #adff2f1c
    $v = $v.green(0)
    xxi: $v.green.round

    $v = $v.green(127.50)
    xxii: $v.green.round

    $v = $v.green(255)
    xxiii: $v.green.round

    $v = $v.green(100%)
    xxiv: $v.green.round

    $v = $v.green(33.33%)
    xxv: $v.green.round
  }
  ~~~

  ~~~ css
  color.green {
    i: 0;
    ii: 128;
    iii: 255;
    iv: 255;
    v: 85;
    vi: 0;
    vii: 128;
    viii: 255;
    ix: 255;
    x: 85;
    xi: 0;
    xii: 128;
    xiii: 255;
    xiv: 255;
    xv: 85;
    xvi: 0;
    xvii: 128;
    xviii: 255;
    xix: 255;
    xx: 85;
    xxi: 0;
    xxii: 128;
    xxiii: 255;
    xxiv: 255;
    xxv: 85;
  }
  ~~~

#### `blue`

- Returns the `blue` channel of the color

  ~~~ lay
  color.blue {
    i: #000000.blue.round
    ii: #ffffff.blue.round
    iii: #f01d93.blue.round
    iv: #008b8b99.blue.round
    v: #adff2f1c.blue.round
  }
  ~~~

  ~~~ css
  color.blue {
    i: 0;
    ii: 255;
    iii: 147;
    iv: 139;
    v: 47;
  }
  ~~~

- Adjusts the `blue` channel of the color

  ~~~ lay
  color.blue {
    $i = #000000
    $i = $i.blue(0)
    i: $i.blue.round

    $i = $i.blue(127.50)
    ii: $i.blue.round

    $i = $i.blue(255)
    iii: $i.blue.round

    $i = $i.blue(100%)
    iv: $i.blue.round

    $i = $i.blue(33.33%)
    v: $i.blue.round

    $ii = #ffffff
    $ii = $ii.blue(0)
    vi: $ii.blue.round

    $ii = $ii.blue(127.50)
    vii: $ii.blue.round

    $ii = $ii.blue(255)
    viii: $ii.blue.round

    $ii = $ii.blue(100%)
    ix: $ii.blue.round

    $ii = $ii.blue(33.33%)
    x: $ii.blue.round

    $iii = #f01d93
    $iii = $iii.blue(0)
    xi: $iii.blue.round

    $iii = $iii.blue(127.50)
    xii: $iii.blue.round

    $iii = $iii.blue(255)
    xiii: $iii.blue.round

    $iii = $iii.blue(100%)
    xiv: $iii.blue.round

    $iii = $iii.blue(33.33%)
    xv: $iii.blue.round

    $iv = #008b8b99
    $iv = $iv.blue(0)
    xvi: $iv.blue.round

    $iv = $iv.blue(127.50)
    xvii: $iv.blue.round

    $iv = $iv.blue(255)
    xviii: $iv.blue.round

    $iv = $iv.blue(100%)
    xix: $iv.blue.round

    $iv = $iv.blue(33.33%)
    xx: $iv.blue.round

    $v = #adff2f1c
    $v = $v.blue(0)
    xxi: $v.blue.round

    $v = $v.blue(127.50)
    xxii: $v.blue.round

    $v = $v.blue(255)
    xxiii: $v.blue.round

    $v = $v.blue(100%)
    xxiv: $v.blue.round

    $v = $v.blue(33.33%)
    xxv: $v.blue.round
  }
  ~~~

  ~~~ css
  color.blue {
    i: 0;
    ii: 128;
    iii: 255;
    iv: 255;
    v: 85;
    vi: 0;
    vii: 128;
    viii: 255;
    ix: 255;
    x: 85;
    xi: 0;
    xii: 128;
    xiii: 255;
    xiv: 255;
    xv: 85;
    xvi: 0;
    xvii: 128;
    xviii: 255;
    xix: 255;
    xx: 85;
    xxi: 0;
    xxii: 128;
    xxiii: 255;
    xxiv: 255;
    xxv: 85;
  }
  ~~~

#### `hue`

- Returns the `hue` channel of the color

  ~~~ lay
  color.hue {
    i: #000000.hue.round
    ii: #ffffff.hue.round
    iii: #f01d93.hue.round
    iv: #008b8b99.hue.round
    v: #adff2f1c.hue.round
  }
  ~~~

  ~~~ css
  color.hue {
    i: 0;
    ii: 0;
    iii: 326deg;
    iv: 180deg;
    v: 84deg;
  }
  ~~~

- Adjusts the `hue` channel of the color

  ~~~ lay
  color.hue {
    $i = #000000
    $i = $i.hue(0)
    i: $i.hue.round

    $i = $i.hue(90)
    ii: $i.hue.round

    $i = $i.hue(360)
    iii: $i.hue.round

    $i = $i.hue(736)
    iv: $i.hue.round

    $ii = #ffffff
    $ii = $ii.hue(0)
    v: $ii.hue.round

    $ii = $ii.hue(90)
    vi: $ii.hue.round

    $ii = $ii.hue(360)
    vii: $ii.hue.round

    $ii = $ii.hue(736)
    viii: $ii.hue.round

    $iii = #f01d93
    $iii = $iii.hue(0)
    ix: $iii.hue.round

    $iii = $iii.hue(90)
    x: $iii.hue.round

    $iii = $iii.hue(360)
    xi: $iii.hue.round

    $iii = $iii.hue(736)
    xii: $iii.hue.round

    $iv = #008b8b99
    $iv = $iv.hue(0)
    xiii: $iv.hue.round

    $iv = $iv.hue(90)
    xiv: $iv.hue.round

    $iv = $iv.hue(360)
    xv: $iv.hue.round

    $iv = $iv.hue(736)
    xvi: $iv.hue.round

    $v = #adff2f1c
    $v = $v.hue(0)
    xvii: $v.hue.round

    $v = $v.hue(90)
    xviii: $v.hue.round

    $v = $v.hue(360)
    xix: $v.hue.round

    $v = $v.hue(736)
    xx: $v.hue.round
  }
  ~~~

  ~~~ css
  color.hue {
    i: 0;
    ii: 90deg;
    iii: 0;
    iv: 16deg;
    v: 0;
    vi: 90deg;
    vii: 0;
    viii: 16deg;
    ix: 0;
    x: 90deg;
    xi: 0;
    xii: 16deg;
    xiii: 0;
    xiv: 90deg;
    xv: 0;
    xvi: 16deg;
    xvii: 0;
    xviii: 90deg;
    xix: 0;
    xx: 16deg;
  }
  ~~~

#### `saturation`

- Returns the `saturation` channel of the color

  ~~~ lay
  color.saturation {
    i: #000000.saturation.round
    ii: #ffffff.saturation.round
    iii: #f01d93.saturation.round
    iv: #008b8b99.saturation.round
    v: #adff2f1c.saturation.round
  }
  ~~~

  ~~~ css
  color.saturation {
    i: 0;
    ii: 0;
    iii: 88%;
    iv: 100%;
    v: 100%;
  }
  ~~~

- Adjusts the `saturation` channel of the color

  ~~~ lay
  color.saturation {
    $i = #000000
    $i = $i.saturation(0)
    i: $i.saturation.round

    $i = $i.saturation(0%)
    ii: $i.saturation.round

    $i = $i.saturation(17.98%)
    iii: $i.saturation.round

    $i = $i.saturation(100%)
    iv: $i.saturation.round

    $ii = #ffffff
    $ii = $ii.saturation(0)
    v: $ii.saturation.round

    $ii = $ii.saturation(0%)
    vi: $ii.saturation.round

    $ii = $ii.saturation(17.98%)
    vii: $ii.saturation.round

    $ii = $ii.saturation(100%)
    viii: $ii.saturation.round

    $iii = #f01d93
    $iii = $iii.saturation(0)
    ix: $iii.saturation.round

    $iii = $iii.saturation(0%)
    x: $iii.saturation.round

    $iii = $iii.saturation(17.98%)
    xi: $iii.saturation.round

    $iii = $iii.saturation(100%)
    xii: $iii.saturation.round

    $iv = #008b8b99
    $iv = $iv.saturation(0)
    xiii: $iv.saturation.round

    $iv = $iv.saturation(0%)
    xiv: $iv.saturation.round

    $iv = $iv.saturation(17.98%)
    xv: $iv.saturation.round

    $iv = $iv.saturation(100%)
    xvi: $iv.saturation.round

    $v = #adff2f1c
    $v = $v.saturation(0)
    xvii: $v.saturation.round

    $v = $v.saturation(0%)
    xviii: $v.saturation.round

    $v = $v.saturation(17.98%)
    xix: $v.saturation.round

    $v = $v.saturation(100%)
    xx: $v.saturation.round
  }
  ~~~

  ~~~ css
  color.saturation {
    i: 0;
    ii: 0;
    iii: 18%;
    iv: 100%;
    v: 0;
    vi: 0;
    vii: 18%;
    viii: 100%;
    ix: 0;
    x: 0;
    xi: 18%;
    xii: 100%;
    xiii: 0;
    xiv: 0;
    xv: 18%;
    xvi: 100%;
    xvii: 0;
    xviii: 0;
    xix: 18%;
    xx: 100%;
  }
  ~~~

#### `lightness`

- Returns the `lightness` channel of the color

  ~~~ lay
  color.lightness {
    i: #000000.lightness.round
    ii: #ffffff.lightness.round
    iii: #f01d93.lightness.round
    iv: #008b8b99.lightness.round
    v: #adff2f1c.lightness.round
  }
  ~~~

  ~~~ css
  color.lightness {
    i: 0;
    ii: 100%;
    iii: 53%;
    iv: 27%;
    v: 59%;
  }
  ~~~

- Adjusts the `lightness` channel of the color

  ~~~ lay
  color.lightness {
    $i = #000000
    $i = $i.lightness(0)
    i: $i.lightness.round

    $i = $i.lightness(0%)
    ii: $i.lightness.round

    $i = $i.lightness(17.98%)
    iii: $i.lightness.round

    $i = $i.lightness(100%)
    iv: $i.lightness.round

    $ii = #ffffff
    $ii = $ii.lightness(0)
    v: $ii.lightness.round

    $ii = $ii.lightness(0%)
    vi: $ii.lightness.round

    $ii = $ii.lightness(17.98%)
    vii: $ii.lightness.round

    $ii = $ii.lightness(100%)
    viii: $ii.lightness.round

    $iii = #f01d93
    $iii = $iii.lightness(0)
    ix: $iii.lightness.round

    $iii = $iii.lightness(0%)
    x: $iii.lightness.round

    $iii = $iii.lightness(17.98%)
    xi: $iii.lightness.round

    $iii = $iii.lightness(100%)
    xii: $iii.lightness.round

    $iv = #008b8b99
    $iv = $iv.lightness(0)
    xiii: $iv.lightness.round

    $iv = $iv.lightness(0%)
    xiv: $iv.lightness.round

    $iv = $iv.lightness(17.98%)
    xv: $iv.lightness.round

    $iv = $iv.lightness(100%)
    xvi: $iv.lightness.round

    $v = #adff2f1c
    $v = $v.lightness(0)
    xvii: $v.lightness.round

    $v = $v.lightness(0%)
    xviii: $v.lightness.round

    $v = $v.lightness(17.98%)
    xix: $v.lightness.round

    $v = $v.lightness(100%)
    xx: $v.lightness.round
  }
  ~~~

  ~~~ css
  color.lightness {
    i: 0;
    ii: 0;
    iii: 18%;
    iv: 100%;
    v: 0;
    vi: 0;
    vii: 18%;
    viii: 100%;
    ix: 0;
    x: 0;
    xi: 18%;
    xii: 100%;
    xiii: 0;
    xiv: 0;
    xv: 18%;
    xvi: 100%;
    xvii: 0;
    xviii: 0;
    xix: 18%;
    xx: 100%;
  }
  ~~~

#### `blackness`

- Returns the `blackness` channel of the color

  ~~~ lay
  color.blackness {
    i: #000000.blackness.round
    ii: #ffffff.blackness.round
    iii: #f01d93.blackness.round
    iv: #008b8b99.blackness.round
    v: #adff2f1c.blackness.round
  }
  ~~~

  ~~~ css
  color.blackness {
    i: 100%;
    ii: 0;
    iii: 6%;
    iv: 45%;
    v: 0;
  }
  ~~~

- Adjusts the `blackness` channel of the color

  ~~~ lay
  color.blackness {
    $i = #000000
    $i = $i.blackness(0)
    i: $i.blackness.round

    $i = $i.blackness(0%)
    ii: $i.blackness.round

    $i = $i.blackness(17.98%)
    iii: $i.blackness.round

    $i = $i.blackness(100%)
    iv: $i.blackness.round

    $ii = #ffffff
    $ii = $ii.blackness(0)
    v: $ii.blackness.round

    $ii = $ii.blackness(0%)
    vi: $ii.blackness.round

    $ii = $ii.blackness(17.98%)
    vii: $ii.blackness.round

    $ii = $ii.blackness(100%)
    viii: $ii.blackness.round

    $iii = #f01d93
    $iii = $iii.blackness(0)
    ix: $iii.blackness.round

    $iii = $iii.blackness(0%)
    x: $iii.blackness.round

    $iii = $iii.blackness(17.98%)
    xi: $iii.blackness.round

    $iii = $iii.blackness(100%)
    xii: $iii.blackness.round

    $iv = #008b8b99
    $iv = $iv.blackness(0)
    xiii: $iv.blackness.round

    $iv = $iv.blackness(0%)
    xiv: $iv.blackness.round

    $iv = $iv.blackness(17.98%)
    xv: $iv.blackness.round

    $iv = $iv.blackness(100%)
    xvi: $iv.blackness.round

    $v = #adff2f1c
    $v = $v.blackness(0)
    xvii: $v.blackness.round

    $v = $v.blackness(0%)
    xviii: $v.blackness.round

    $v = $v.blackness(17.98%)
    xix: $v.blackness.round

    $v = $v.blackness(100%)
    xx: $v.blackness.round
  }
  ~~~

  ~~~ css
  color.blackness {
    i: 0;
    ii: 0;
    iii: 18%;
    iv: 100%;
    v: 0;
    vi: 0;
    vii: 18%;
    viii: 100%;
    ix: 0;
    x: 0;
    xi: 18%;
    xii: 100%;
    xiii: 0;
    xiv: 0;
    xv: 18%;
    xvi: 100%;
    xvii: 0;
    xviii: 0;
    xix: 18%;
    xx: 100%;
  }
  ~~~

#### `whiteness`

- Returns the `whiteness` channel of the color

  ~~~ lay
  color.whiteness {
    i: #000000.whiteness.round
    ii: #ffffff.whiteness.round
    iii: #f01d93.whiteness.round
    iv: #008b8b99.whiteness.round
    v: #adff2f1c.whiteness.round
  }
  ~~~

  ~~~ css
  color.whiteness {
    i: 0;
    ii: 100%;
    iii: 11%;
    iv: 0;
    v: 18%;
  }
  ~~~

- Adjusts the `whiteness` channel of the color

  ~~~ lay
  color.whiteness {
    $i = #000000
    $i = $i.whiteness(0)
    i: $i.whiteness.round

    $i = $i.whiteness(0%)
    ii: $i.whiteness.round

    $i = $i.whiteness(17.98%)
    iii: $i.whiteness.round

    $i = $i.whiteness(100%)
    iv: $i.whiteness.round

    $ii = #ffffff
    $ii = $ii.whiteness(0)
    v: $ii.whiteness.round

    $ii = $ii.whiteness(0%)
    vi: $ii.whiteness.round

    $ii = $ii.whiteness(17.98%)
    vii: $ii.whiteness.round

    $ii = $ii.whiteness(100%)
    viii: $ii.whiteness.round

    $iii = #f01d93
    $iii = $iii.whiteness(0)
    ix: $iii.whiteness.round

    $iii = $iii.whiteness(0%)
    x: $iii.whiteness.round

    $iii = $iii.whiteness(17.98%)
    xi: $iii.whiteness.round

    $iii = $iii.whiteness(100%)
    xii: $iii.whiteness.round

    $iv = #008b8b99
    $iv = $iv.whiteness(0)
    xiii: $iv.whiteness.round

    $iv = $iv.whiteness(0%)
    xiv: $iv.whiteness.round

    $iv = $iv.whiteness(17.98%)
    xv: $iv.whiteness.round

    $iv = $iv.whiteness(100%)
    xvi: $iv.whiteness.round

    $v = #adff2f1c
    $v = $v.whiteness(0)
    xvii: $v.whiteness.round

    $v = $v.whiteness(0%)
    xviii: $v.whiteness.round

    $v = $v.whiteness(17.98%)
    xix: $v.whiteness.round

    $v = $v.whiteness(100%)
    xx: $v.whiteness.round
  }
  ~~~

  ~~~ css
  color.whiteness {
    i: 0;
    ii: 0;
    iii: 18%;
    iv: 100%;
    v: 0;
    vi: 0;
    vii: 18%;
    viii: 100%;
    ix: 0;
    x: 0;
    xi: 18%;
    xii: 100%;
    xiii: 0;
    xiv: 0;
    xv: 18%;
    xvi: 100%;
    xvii: 0;
    xviii: 0;
    xix: 18%;
    xx: 100%;
  }
  ~~~

#### `cyan`

- Returns the `cyan` channel of the color

  ~~~ lay
  color.cyan {
    i: #000000.cyan.round
    ii: #ffffff.cyan.round
    iii: #f01d93.cyan.round
    iv: #008b8b99.cyan.round
    v: #adff2f1c.cyan.round
  }
  ~~~

  ~~~ css
  color.cyan {
    i: 0;
    ii: 0;
    iii: 0;
    iv: 100%;
    v: 32%;
  }
  ~~~

- Adjusts the `cyan` channel of the color

  ~~~ lay
  color.cyan {
    $i = #000000
    $i = $i.cyan(0)
    i: $i.cyan.round

    $i = $i.cyan(0%)
    ii: $i.cyan.round

    $i = $i.cyan(17.98%)
    iii: $i.cyan.round

    $i = $i.cyan(100%)
    iv: $i.cyan.round

    $ii = #ffffff
    $ii = $ii.cyan(0)
    v: $ii.cyan.round

    $ii = $ii.cyan(0%)
    vi: $ii.cyan.round

    $ii = $ii.cyan(17.98%)
    vii: $ii.cyan.round

    $ii = $ii.cyan(100%)
    viii: $ii.cyan.round

    $iii = #f01d93
    $iii = $iii.cyan(0)
    ix: $iii.cyan.round

    $iii = $iii.cyan(0%)
    x: $iii.cyan.round

    $iii = $iii.cyan(17.98%)
    xi: $iii.cyan.round

    $iii = $iii.cyan(100%)
    xii: $iii.cyan.round

    $iv = #008b8b99
    $iv = $iv.cyan(0)
    xiii: $iv.cyan.round

    $iv = $iv.cyan(0%)
    xiv: $iv.cyan.round

    $iv = $iv.cyan(17.98%)
    xv: $iv.cyan.round

    $iv = $iv.cyan(100%)
    xvi: $iv.cyan.round

    $v = #adff2f1c
    $v = $v.cyan(0)
    xvii: $v.cyan.round

    $v = $v.cyan(0%)
    xviii: $v.cyan.round

    $v = $v.cyan(17.98%)
    xix: $v.cyan.round

    $v = $v.cyan(100%)
    xx: $v.cyan.round
  }
  ~~~

  ~~~ css
  color.cyan {
    i: 0;
    ii: 0;
    iii: 18%;
    iv: 100%;
    v: 0;
    vi: 0;
    vii: 18%;
    viii: 100%;
    ix: 0;
    x: 0;
    xi: 18%;
    xii: 100%;
    xiii: 0;
    xiv: 0;
    xv: 18%;
    xvi: 100%;
    xvii: 0;
    xviii: 0;
    xix: 18%;
    xx: 100%;
  }
  ~~~

#### `magenta`

- Returns the `magenta` channel of the color

  ~~~ lay
  color.magenta {
    i: #000000.magenta.round
    ii: #ffffff.magenta.round
    iii: #f01d93.magenta.round
    iv: #008b8b99.magenta.round
    v: #adff2f1c.magenta.round
  }
  ~~~

  ~~~ css
  color.magenta {
    i: 0;
    ii: 0;
    iii: 88%;
    iv: 0;
    v: 0;
  }
  ~~~

- Adjusts the `magenta` channel of the color

  ~~~ lay
  color.magenta {
    $i = #000000
    $i = $i.magenta(0)
    i: $i.magenta.round

    $i = $i.magenta(0%)
    ii: $i.magenta.round

    $i = $i.magenta(17.98%)
    iii: $i.magenta.round

    $i = $i.magenta(100%)
    iv: $i.magenta.round

    $ii = #ffffff
    $ii = $ii.magenta(0)
    v: $ii.magenta.round

    $ii = $ii.magenta(0%)
    vi: $ii.magenta.round

    $ii = $ii.magenta(17.98%)
    vii: $ii.magenta.round

    $ii = $ii.magenta(100%)
    viii: $ii.magenta.round

    $iii = #f01d93
    $iii = $iii.magenta(0)
    ix: $iii.magenta.round

    $iii = $iii.magenta(0%)
    x: $iii.magenta.round

    $iii = $iii.magenta(17.98%)
    xi: $iii.magenta.round

    $iii = $iii.magenta(100%)
    xii: $iii.magenta.round

    $iv = #008b8b99
    $iv = $iv.magenta(0)
    xiii: $iv.magenta.round

    $iv = $iv.magenta(0%)
    xiv: $iv.magenta.round

    $iv = $iv.magenta(17.98%)
    xv: $iv.magenta.round

    $iv = $iv.magenta(100%)
    xvi: $iv.magenta.round

    $v = #adff2f1c
    $v = $v.magenta(0)
    xvii: $v.magenta.round

    $v = $v.magenta(0%)
    xviii: $v.magenta.round

    $v = $v.magenta(17.98%)
    xix: $v.magenta.round

    $v = $v.magenta(100%)
    xx: $v.magenta.round
  }
  ~~~

  ~~~ css
  color.magenta {
    i: 0;
    ii: 0;
    iii: 18%;
    iv: 100%;
    v: 0;
    vi: 0;
    vii: 18%;
    viii: 100%;
    ix: 0;
    x: 0;
    xi: 18%;
    xii: 100%;
    xiii: 0;
    xiv: 0;
    xv: 18%;
    xvi: 100%;
    xvii: 0;
    xviii: 0;
    xix: 18%;
    xx: 100%;
  }
  ~~~

#### `yellow`

- Returns the `yellow` channel of the color

  ~~~ lay
  color.yellow {
    i: #000000.yellow.round
    ii: #ffffff.yellow.round
    iii: #f01d93.yellow.round
    iv: #008b8b99.yellow.round
    v: #adff2f1c.yellow.round
  }
  ~~~

  ~~~ css
  color.yellow {
    i: 0;
    ii: 0;
    iii: 39%;
    iv: 0;
    v: 82%;
  }
  ~~~

- Adjusts the `yellow` channel of the color

  ~~~ lay
  color.yellow {
    $i = #000000
    $i = $i.yellow(0)
    i: $i.yellow.round

    $i = $i.yellow(0%)
    ii: $i.yellow.round

    $i = $i.yellow(17.98%)
    iii: $i.yellow.round

    $i = $i.yellow(100%)
    iv: $i.yellow.round

    $ii = #ffffff
    $ii = $ii.yellow(0)
    v: $ii.yellow.round

    $ii = $ii.yellow(0%)
    vi: $ii.yellow.round

    $ii = $ii.yellow(17.98%)
    vii: $ii.yellow.round

    $ii = $ii.yellow(100%)
    viii: $ii.yellow.round

    $iii = #f01d93
    $iii = $iii.yellow(0)
    ix: $iii.yellow.round

    $iii = $iii.yellow(0%)
    x: $iii.yellow.round

    $iii = $iii.yellow(17.98%)
    xi: $iii.yellow.round

    $iii = $iii.yellow(100%)
    xii: $iii.yellow.round

    $iv = #008b8b99
    $iv = $iv.yellow(0)
    xiii: $iv.yellow.round

    $iv = $iv.yellow(0%)
    xiv: $iv.yellow.round

    $iv = $iv.yellow(17.98%)
    xv: $iv.yellow.round

    $iv = $iv.yellow(100%)
    xvi: $iv.yellow.round

    $v = #adff2f1c
    $v = $v.yellow(0)
    xvii: $v.yellow.round

    $v = $v.yellow(0%)
    xviii: $v.yellow.round

    $v = $v.yellow(17.98%)
    xix: $v.yellow.round

    $v = $v.yellow(100%)
    xx: $v.yellow.round
  }
  ~~~

  ~~~ css
  color.yellow {
    i: 0;
    ii: 0;
    iii: 18%;
    iv: 100%;
    v: 0;
    vi: 0;
    vii: 18%;
    viii: 100%;
    ix: 0;
    x: 0;
    xi: 18%;
    xii: 100%;
    xiii: 0;
    xiv: 0;
    xv: 18%;
    xvi: 100%;
    xvii: 0;
    xviii: 0;
    xix: 18%;
    xx: 100%;
  }
  ~~~

#### `black`

- Returns the `black` channel of the color

  ~~~ lay
  color.black {
    i: #000000.black.round
    ii: #ffffff.black.round
    iii: #f01d93.black.round
    iv: #008b8b99.black.round
    v: #adff2f1c.black.round
  }
  ~~~

  ~~~ css
  color.black {
    i: 100%;
    ii: 0;
    iii: 6%;
    iv: 45%;
    v: 0;
  }
  ~~~

- Adjusts the `black` channel of the color

  ~~~ lay
  color.black {
    $i = #000000
    $i = $i.black(0)
    i: $i.black.round

    $i = $i.black(0%)
    ii: $i.black.round

    $i = $i.black(17.98%)
    iii: $i.black.round

    $i = $i.black(100%)
    iv: $i.black.round

    $ii = #ffffff
    $ii = $ii.black(0)
    v: $ii.black.round

    $ii = $ii.black(0%)
    vi: $ii.black.round

    $ii = $ii.black(17.98%)
    vii: $ii.black.round

    $ii = $ii.black(100%)
    viii: $ii.black.round

    $iii = #f01d93
    $iii = $iii.black(0)
    ix: $iii.black.round

    $iii = $iii.black(0%)
    x: $iii.black.round

    $iii = $iii.black(17.98%)
    xi: $iii.black.round

    $iii = $iii.black(100%)
    xii: $iii.black.round

    $iv = #008b8b99
    $iv = $iv.black(0)
    xiii: $iv.black.round

    $iv = $iv.black(0%)
    xiv: $iv.black.round

    $iv = $iv.black(17.98%)
    xv: $iv.black.round

    $iv = $iv.black(100%)
    xvi: $iv.black.round

    $v = #adff2f1c
    $v = $v.black(0)
    xvii: $v.black.round

    $v = $v.black(0%)
    xviii: $v.black.round

    $v = $v.black(17.98%)
    xix: $v.black.round

    $v = $v.black(100%)
    xx: $v.black.round
  }
  ~~~

  ~~~ css
  color.black {
    i: 0;
    ii: 0;
    iii: 18%;
    iv: 100%;
    v: 0;
    vi: 0;
    vii: 18%;
    viii: 100%;
    ix: 0;
    x: 0;
    xi: 18%;
    xii: 100%;
    xiii: 0;
    xiv: 0;
    xv: 18%;
    xvi: 100%;
    xvii: 0;
    xviii: 0;
    xix: 18%;
    xx: 100%;
  }
  ~~~

### `blend`

- Blends a color onto another

  ~~~ lay
  color.blend {
    multiply: #f60000.blend(#f60000, multiply)
    screen: #f60000.blend(#0000f6, screen)
    overlay: #f60000.blend(#0000f6, 'overlay')
    soft-light: #f60000.blend(#ffffff, soft-light)
    hard-light: #f60000.blend(#0000f6, hard-light)
    difference: #f60000.blend(#0000f6, "difference")
    exclusion: #f60000.blend(#0000f6, `exclusion`)
  }
  ~~~

  ~~~ css
  color.blend {
    multiply: #ed0000;
    screen: #f600f6;
    overlay: #0000ed;
    soft-light: #ffffff;
    hard-light: #ed0000;
    difference: #f600f6;
    exclusion: #f600f6;
  }
  ~~~

#### Modes

- `normal`

  ~~~ lay
  color.blend[normal] {
    i: #000000.blend(#000000.blend(#fff), 'normal')
    ii: #ffffff.blend(#000000.blend(#fff), 'normal')
    iii: #f01d93.blend(#000000.blend(#fff), 'normal')
    iv: #008b8b99.blend(#000000.blend(#fff), 'normal')
    v: #adff2f1d.blend(#000000.blend(#fff), 'normal')
    vi: #000000.blend(#ffffff.blend(#fff), 'normal')
    vii: #ffffff.blend(#ffffff.blend(#fff), 'normal')
    viii: #f01d93.blend(#ffffff.blend(#fff), 'normal')
    ix: #008b8b99.blend(#ffffff.blend(#fff), 'normal')
    x: #adff2f1d.blend(#ffffff.blend(#fff), 'normal')
    xi: #000000.blend(#f01d93.blend(#fff), 'normal')
    xii: #ffffff.blend(#f01d93.blend(#fff), 'normal')
    xiii: #f01d93.blend(#f01d93.blend(#fff), 'normal')
    xiv: #008b8b99.blend(#f01d93.blend(#fff), 'normal')
    xv: #adff2f1d.blend(#f01d93.blend(#fff), 'normal')
    xvi: #000000.blend(#008b8b99.blend(#fff), 'normal')
    xvii: #ffffff.blend(#008b8b99.blend(#fff), 'normal')
    xviii: #f01d93.blend(#008b8b99.blend(#fff), 'normal')
    xix: #008b8b99.blend(#008b8b99.blend(#fff), 'normal')
    xx: #adff2f1d.blend(#008b8b99.blend(#fff), 'normal')
    xxi: #000000.blend(#adff2f1d.blend(#fff), 'normal')
    xxii: #ffffff.blend(#adff2f1d.blend(#fff), 'normal')
    xxiii: #f01d93.blend(#adff2f1d.blend(#fff), 'normal')
    xxiv: #008b8b99.blend(#adff2f1d.blend(#fff), 'normal')
    xxv: #adff2f1d.blend(#adff2f1d.blend(#fff), 'normal')
  }
  ~~~

  ~~~ css
  color.blend[normal] {
    i: #000000;
    ii: #ffffff;
    iii: #f01d93;
    iv: #005353;
    v: #141d05;
    vi: #000000;
    vii: #ffffff;
    viii: #f01d93;
    ix: #66b9b9;
    x: #f6ffe7;
    xi: #000000;
    xii: #ffffff;
    xiii: #f01d93;
    xiv: #605f8e;
    xv: #e83788;
    xvi: #000000;
    xvii: #ffffff;
    xviii: #f01d93;
    xix: #299e9e;
    xx: #6ec1aa;
    xxi: #000000;
    xxii: #ffffff;
    xxiii: #f01d93;
    xxiv: #62b9b0;
    xxv: #edffd2;
  }
  ~~~

- `multiply`

  ~~~ lay
  color.blend[multiply] {
    i: #000000.blend(#000000.blend(#fff), 'multiply')
    ii: #ffffff.blend(#000000.blend(#fff), 'multiply')
    iii: #f01d93.blend(#000000.blend(#fff), 'multiply')
    iv: #008b8b99.blend(#000000.blend(#fff), 'multiply')
    v: #adff2f1d.blend(#000000.blend(#fff), 'multiply')
    vi: #000000.blend(#ffffff.blend(#fff), 'multiply')
    vii: #ffffff.blend(#ffffff.blend(#fff), 'multiply')
    viii: #f01d93.blend(#ffffff.blend(#fff), 'multiply')
    ix: #008b8b99.blend(#ffffff.blend(#fff), 'multiply')
    x: #adff2f1d.blend(#ffffff.blend(#fff), 'multiply')
    xi: #000000.blend(#f01d93.blend(#fff), 'multiply')
    xii: #ffffff.blend(#f01d93.blend(#fff), 'multiply')
    xiii: #f01d93.blend(#f01d93.blend(#fff), 'multiply')
    xiv: #008b8b99.blend(#f01d93.blend(#fff), 'multiply')
    xv: #adff2f1d.blend(#f01d93.blend(#fff), 'multiply')
    xvi: #000000.blend(#008b8b99.blend(#fff), 'multiply')
    xvii: #ffffff.blend(#008b8b99.blend(#fff), 'multiply')
    xviii: #f01d93.blend(#008b8b99.blend(#fff), 'multiply')
    xix: #008b8b99.blend(#008b8b99.blend(#fff), 'multiply')
    xx: #adff2f1d.blend(#008b8b99.blend(#fff), 'multiply')
    xxi: #000000.blend(#adff2f1d.blend(#fff), 'multiply')
    xxii: #ffffff.blend(#adff2f1d.blend(#fff), 'multiply')
    xxiii: #f01d93.blend(#adff2f1d.blend(#fff), 'multiply')
    xxiv: #008b8b99.blend(#adff2f1d.blend(#fff), 'multiply')
    xxv: #adff2f1d.blend(#adff2f1d.blend(#fff), 'multiply')
  }
  ~~~

  ~~~ css
  color.blend[multiply] {
    i: #000000;
    ii: #000000;
    iii: #000000;
    iv: #000000;
    v: #000000;
    vi: #000000;
    vii: #ffffff;
    viii: #f01d93;
    ix: #66b9b9;
    x: #f6ffe7;
    xi: #000000;
    xii: #f01d93;
    xiii: #e20355;
    xiv: #60156b;
    xv: #e71d85;
    xvi: #000000;
    xvii: #66b9b9;
    xviii: #60156b;
    xix: #298787;
    xx: #62b9a8;
    xxi: #000000;
    xxii: #f6ffe7;
    xxiii: #e71d85;
    xxiv: #62b9a8;
    xxv: #edffd2;
  }
  ~~~

- `screen`

  ~~~ lay
  color.blend[screen] {
    i: #000000.blend(#000000.blend(#fff), 'screen')
    ii: #ffffff.blend(#000000.blend(#fff), 'screen')
    iii: #f01d93.blend(#000000.blend(#fff), 'screen')
    iv: #008b8b99.blend(#000000.blend(#fff), 'screen')
    v: #adff2f1d.blend(#000000.blend(#fff), 'screen')
    vi: #000000.blend(#ffffff.blend(#fff), 'screen')
    vii: #ffffff.blend(#ffffff.blend(#fff), 'screen')
    viii: #f01d93.blend(#ffffff.blend(#fff), 'screen')
    ix: #008b8b99.blend(#ffffff.blend(#fff), 'screen')
    x: #adff2f1d.blend(#ffffff.blend(#fff), 'screen')
    xi: #000000.blend(#f01d93.blend(#fff), 'screen')
    xii: #ffffff.blend(#f01d93.blend(#fff), 'screen')
    xiii: #f01d93.blend(#f01d93.blend(#fff), 'screen')
    xiv: #008b8b99.blend(#f01d93.blend(#fff), 'screen')
    xv: #adff2f1d.blend(#f01d93.blend(#fff), 'screen')
    xvi: #000000.blend(#008b8b99.blend(#fff), 'screen')
    xvii: #ffffff.blend(#008b8b99.blend(#fff), 'screen')
    xviii: #f01d93.blend(#008b8b99.blend(#fff), 'screen')
    xix: #008b8b99.blend(#008b8b99.blend(#fff), 'screen')
    xx: #adff2f1d.blend(#008b8b99.blend(#fff), 'screen')
    xxi: #000000.blend(#adff2f1d.blend(#fff), 'screen')
    xxii: #ffffff.blend(#adff2f1d.blend(#fff), 'screen')
    xxiii: #f01d93.blend(#adff2f1d.blend(#fff), 'screen')
    xxiv: #008b8b99.blend(#adff2f1d.blend(#fff), 'screen')
    xxv: #adff2f1d.blend(#adff2f1d.blend(#fff), 'screen')
  }
  ~~~

  ~~~ css
  color.blend[screen] {
    i: #000000;
    ii: #ffffff;
    iii: #f01d93;
    iv: #005353;
    v: #141d05;
    vi: #ffffff;
    vii: #ffffff;
    viii: #ffffff;
    ix: #ffffff;
    x: #ffffff;
    xi: #f01d93;
    xii: #ffffff;
    xiii: #fe37d1;
    xiv: #f067b6;
    xv: #f13795;
    xvi: #66b9b9;
    xvii: #ffffff;
    xviii: #f6c1e2;
    xix: #66d0d0;
    xx: #72c1bb;
    xxi: #f6ffe7;
    xxii: #ffffff;
    xxiii: #fefff5;
    xxiv: #f6ffef;
    xxv: #f6ffe8;
  }
  ~~~

- `overlay`

  ~~~ lay
  color.blend[overlay] {
    i: #000000.blend(#000000.blend(#fff), 'overlay')
    ii: #ffffff.blend(#000000.blend(#fff), 'overlay')
    iii: #f01d93.blend(#000000.blend(#fff), 'overlay')
    iv: #008b8b99.blend(#000000.blend(#fff), 'overlay')
    v: #adff2f1d.blend(#000000.blend(#fff), 'overlay')
    vi: #000000.blend(#ffffff.blend(#fff), 'overlay')
    vii: #ffffff.blend(#ffffff.blend(#fff), 'overlay')
    viii: #f01d93.blend(#ffffff.blend(#fff), 'overlay')
    ix: #008b8b99.blend(#ffffff.blend(#fff), 'overlay')
    x: #adff2f1d.blend(#ffffff.blend(#fff), 'overlay')
    xi: #000000.blend(#f01d93.blend(#fff), 'overlay')
    xii: #ffffff.blend(#f01d93.blend(#fff), 'overlay')
    xiii: #f01d93.blend(#f01d93.blend(#fff), 'overlay')
    xiv: #008b8b99.blend(#f01d93.blend(#fff), 'overlay')
    xv: #adff2f1d.blend(#f01d93.blend(#fff), 'overlay')
    xvi: #000000.blend(#008b8b99.blend(#fff), 'overlay')
    xvii: #ffffff.blend(#008b8b99.blend(#fff), 'overlay')
    xviii: #f01d93.blend(#008b8b99.blend(#fff), 'overlay')
    xix: #008b8b99.blend(#008b8b99.blend(#fff), 'overlay')
    xx: #adff2f1d.blend(#008b8b99.blend(#fff), 'overlay')
    xxi: #000000.blend(#adff2f1d.blend(#fff), 'overlay')
    xxii: #ffffff.blend(#adff2f1d.blend(#fff), 'overlay')
    xxiii: #f01d93.blend(#adff2f1d.blend(#fff), 'overlay')
    xxiv: #008b8b99.blend(#adff2f1d.blend(#fff), 'overlay')
    xxv: #adff2f1d.blend(#adff2f1d.blend(#fff), 'overlay')
  }
  ~~~

  ~~~ css
  color.blend[overlay] {
    i: #000000;
    ii: #000000;
    iii: #000000;
    iv: #000000;
    v: #000000;
    vi: #ffffff;
    vii: #ffffff;
    viii: #ffffff;
    ix: #ffffff;
    x: #ffffff;
    xi: #e10027;
    xii: #ff3aff;
    xiii: #fd07a4;
    xiv: #e71f99;
    xv: #f1208b;
    xvi: #007474;
    xvii: #ccffff;
    xviii: #c084c4;
    xix: #29bdbd;
    xx: #6ac1b4;
    xxi: #ecffd0;
    xxii: #ffffff;
    xxiii: #feffeb;
    xxiv: #f0ffe9;
    xxv: #f6ffe6;
  }
  ~~~

- `darken`

  ~~~ lay
  color.blend[darken] {
    i: #000000.blend(#000000.blend(#fff), 'darken')
    ii: #ffffff.blend(#000000.blend(#fff), 'darken')
    iii: #f01d93.blend(#000000.blend(#fff), 'darken')
    iv: #008b8b99.blend(#000000.blend(#fff), 'darken')
    v: #adff2f1d.blend(#000000.blend(#fff), 'darken')
    vi: #000000.blend(#ffffff.blend(#fff), 'darken')
    vii: #ffffff.blend(#ffffff.blend(#fff), 'darken')
    viii: #f01d93.blend(#ffffff.blend(#fff), 'darken')
    ix: #008b8b99.blend(#ffffff.blend(#fff), 'darken')
    x: #adff2f1d.blend(#ffffff.blend(#fff), 'darken')
    xi: #000000.blend(#f01d93.blend(#fff), 'darken')
    xii: #ffffff.blend(#f01d93.blend(#fff), 'darken')
    xiii: #f01d93.blend(#f01d93.blend(#fff), 'darken')
    xiv: #008b8b99.blend(#f01d93.blend(#fff), 'darken')
    xv: #adff2f1d.blend(#f01d93.blend(#fff), 'darken')
    xvi: #000000.blend(#008b8b99.blend(#fff), 'darken')
    xvii: #ffffff.blend(#008b8b99.blend(#fff), 'darken')
    xviii: #f01d93.blend(#008b8b99.blend(#fff), 'darken')
    xix: #008b8b99.blend(#008b8b99.blend(#fff), 'darken')
    xx: #adff2f1d.blend(#008b8b99.blend(#fff), 'darken')
    xxi: #000000.blend(#adff2f1d.blend(#fff), 'darken')
    xxii: #ffffff.blend(#adff2f1d.blend(#fff), 'darken')
    xxiii: #f01d93.blend(#adff2f1d.blend(#fff), 'darken')
    xxiv: #008b8b99.blend(#adff2f1d.blend(#fff), 'darken')
    xxv: #adff2f1d.blend(#adff2f1d.blend(#fff), 'darken')
  }
  ~~~

  ~~~ css
  color.blend[darken] {
    i: #000000;
    ii: #000000;
    iii: #000000;
    iv: #000000;
    v: #000000;
    vi: #000000;
    vii: #ffffff;
    viii: #f01d93;
    ix: #66b9b9;
    x: #f6ffe7;
    xi: #000000;
    xii: #f01d93;
    xiii: #f01d93;
    xiv: #601d8e;
    xv: #e81d88;
    xvi: #000000;
    xvii: #66b9b9;
    xviii: #661d93;
    xix: #299e9e;
    xx: #66b9aa;
    xxi: #000000;
    xxii: #f6ffe7;
    xxiii: #f01d93;
    xxiv: #62b9b0;
    xxv: #edffd2;
  }
  ~~~

- `lighten`

  ~~~ lay
  color.blend[lighten] {
    i: #000000.blend(#000000.blend(#fff), 'lighten')
    ii: #ffffff.blend(#000000.blend(#fff), 'lighten')
    iii: #f01d93.blend(#000000.blend(#fff), 'lighten')
    iv: #008b8b99.blend(#000000.blend(#fff), 'lighten')
    v: #adff2f1d.blend(#000000.blend(#fff), 'lighten')
    vi: #000000.blend(#ffffff.blend(#fff), 'lighten')
    vii: #ffffff.blend(#ffffff.blend(#fff), 'lighten')
    viii: #f01d93.blend(#ffffff.blend(#fff), 'lighten')
    ix: #008b8b99.blend(#ffffff.blend(#fff), 'lighten')
    x: #adff2f1d.blend(#ffffff.blend(#fff), 'lighten')
    xi: #000000.blend(#f01d93.blend(#fff), 'lighten')
    xii: #ffffff.blend(#f01d93.blend(#fff), 'lighten')
    xiii: #f01d93.blend(#f01d93.blend(#fff), 'lighten')
    xiv: #008b8b99.blend(#f01d93.blend(#fff), 'lighten')
    xv: #adff2f1d.blend(#f01d93.blend(#fff), 'lighten')
    xvi: #000000.blend(#008b8b99.blend(#fff), 'lighten')
    xvii: #ffffff.blend(#008b8b99.blend(#fff), 'lighten')
    xviii: #f01d93.blend(#008b8b99.blend(#fff), 'lighten')
    xix: #008b8b99.blend(#008b8b99.blend(#fff), 'lighten')
    xx: #adff2f1d.blend(#008b8b99.blend(#fff), 'lighten')
    xxi: #000000.blend(#adff2f1d.blend(#fff), 'lighten')
    xxii: #ffffff.blend(#adff2f1d.blend(#fff), 'lighten')
    xxiii: #f01d93.blend(#adff2f1d.blend(#fff), 'lighten')
    xxiv: #008b8b99.blend(#adff2f1d.blend(#fff), 'lighten')
    xxv: #adff2f1d.blend(#adff2f1d.blend(#fff), 'lighten')
  }
  ~~~

  ~~~ css
  color.blend[lighten] {
    i: #000000;
    ii: #ffffff;
    iii: #f01d93;
    iv: #005353;
    v: #141d05;
    vi: #ffffff;
    vii: #ffffff;
    viii: #ffffff;
    ix: #ffffff;
    x: #ffffff;
    xi: #f01d93;
    xii: #ffffff;
    xiii: #f01d93;
    xiv: #f05f93;
    xv: #f03793;
    xvi: #66b9b9;
    xvii: #ffffff;
    xviii: #f0b9b9;
    xix: #66b9b9;
    xx: #6ec1b9;
    xxi: #f6ffe7;
    xxii: #ffffff;
    xxiii: #f6ffe7;
    xxiv: #f6ffe7;
    xxv: #f6ffe7;
  }
  ~~~

- `hard-light`

  ~~~ lay
  color.blend[hard-light] {
    i: #000000.blend(#000000.blend(#fff), 'hard-light')
    ii: #ffffff.blend(#000000.blend(#fff), 'hard-light')
    iii: #f01d93.blend(#000000.blend(#fff), 'hard-light')
    iv: #008b8b99.blend(#000000.blend(#fff), 'hard-light')
    v: #adff2f1d.blend(#000000.blend(#fff), 'hard-light')
    vi: #000000.blend(#ffffff.blend(#fff), 'hard-light')
    vii: #ffffff.blend(#ffffff.blend(#fff), 'hard-light')
    viii: #f01d93.blend(#ffffff.blend(#fff), 'hard-light')
    ix: #008b8b99.blend(#ffffff.blend(#fff), 'hard-light')
    x: #adff2f1d.blend(#ffffff.blend(#fff), 'hard-light')
    xi: #000000.blend(#f01d93.blend(#fff), 'hard-light')
    xii: #ffffff.blend(#f01d93.blend(#fff), 'hard-light')
    xiii: #f01d93.blend(#f01d93.blend(#fff), 'hard-light')
    xiv: #008b8b99.blend(#f01d93.blend(#fff), 'hard-light')
    xv: #adff2f1d.blend(#f01d93.blend(#fff), 'hard-light')
    xvi: #000000.blend(#008b8b99.blend(#fff), 'hard-light')
    xvii: #ffffff.blend(#008b8b99.blend(#fff), 'hard-light')
    xviii: #f01d93.blend(#008b8b99.blend(#fff), 'hard-light')
    xix: #008b8b99.blend(#008b8b99.blend(#fff), 'hard-light')
    xx: #adff2f1d.blend(#008b8b99.blend(#fff), 'hard-light')
    xxi: #000000.blend(#adff2f1d.blend(#fff), 'hard-light')
    xxii: #ffffff.blend(#adff2f1d.blend(#fff), 'hard-light')
    xxiii: #f01d93.blend(#adff2f1d.blend(#fff), 'hard-light')
    xxiv: #008b8b99.blend(#adff2f1d.blend(#fff), 'hard-light')
    xxv: #adff2f1d.blend(#adff2f1d.blend(#fff), 'hard-light')
  }
  ~~~

  ~~~ css
  color.blend[hard-light] {
    i: #000000;
    ii: #ffffff;
    iii: #e10027;
    iv: #000e0e;
    v: #0a1d00;
    vi: #000000;
    vii: #ffffff;
    viii: #ff3aff;
    ix: #66ffff;
    x: #ffffed;
    xi: #000000;
    xii: #ffffff;
    xiii: #fd07a4;
    xiv: #602999;
    xv: #f13788;
    xvi: #000000;
    xvii: #ffffff;
    xviii: #ed2ac4;
    xix: #29bdbd;
    xx: #6cc1ac;
    xxi: #000000;
    xxii: #ffffff;
    xxiii: #fe3aeb;
    xxiv: #62ffe9;
    xxv: #f6ffd7;
  }
  ~~~

- `soft-light`

  ~~~ lay
  color.blend[soft-light] {
    i: #000000.blend(#000000.blend(#fff), 'soft-light')
    ii: #ffffff.blend(#000000.blend(#fff), 'soft-light')
    iii: #f01d93.blend(#000000.blend(#fff), 'soft-light')
    iv: #008b8b99.blend(#000000.blend(#fff), 'soft-light')
    v: #adff2f1d.blend(#000000.blend(#fff), 'soft-light')
    vi: #000000.blend(#ffffff.blend(#fff), 'soft-light')
    vii: #ffffff.blend(#ffffff.blend(#fff), 'soft-light')
    viii: #f01d93.blend(#ffffff.blend(#fff), 'soft-light')
    ix: #008b8b99.blend(#ffffff.blend(#fff), 'soft-light')
    x: #adff2f1d.blend(#ffffff.blend(#fff), 'soft-light')
    xi: #000000.blend(#f01d93.blend(#fff), 'soft-light')
    xii: #ffffff.blend(#f01d93.blend(#fff), 'soft-light')
    xiii: #f01d93.blend(#f01d93.blend(#fff), 'soft-light')
    xiv: #008b8b99.blend(#f01d93.blend(#fff), 'soft-light')
    xv: #adff2f1d.blend(#f01d93.blend(#fff), 'soft-light')
    xvi: #000000.blend(#008b8b99.blend(#fff), 'soft-light')
    xvii: #ffffff.blend(#008b8b99.blend(#fff), 'soft-light')
    xviii: #f01d93.blend(#008b8b99.blend(#fff), 'soft-light')
    xix: #008b8b99.blend(#008b8b99.blend(#fff), 'soft-light')
    xx: #adff2f1d.blend(#008b8b99.blend(#fff), 'soft-light')
    xxi: #000000.blend(#adff2f1d.blend(#fff), 'soft-light')
    xxii: #ffffff.blend(#adff2f1d.blend(#fff), 'soft-light')
    xxiii: #f01d93.blend(#adff2f1d.blend(#fff), 'soft-light')
    xxiv: #008b8b99.blend(#adff2f1d.blend(#fff), 'soft-light')
    xxv: #adff2f1d.blend(#adff2f1d.blend(#fff), 'soft-light')
  }
  ~~~

  ~~~ css
  color.blend[soft-light] {
    i: #000000;
    ii: #000000;
    iii: #000000;
    iv: #000000;
    v: #000000;
    vi: #ffffff;
    vii: #ffffff;
    viii: #ffffff;
    ix: #ffffff;
    x: #ffffff;
    xi: #e20355;
    xii: #f752c2;
    xiii: #f7099a;
    xiv: #e82096;
    xv: #f0238f;
    xvi: #298787;
    xvii: #a1d9d9;
    xviii: #9a92be;
    xix: #41bbbb;
    xx: #68bdb6;
    xxi: #edffd2;
    xxii: #fafff3;
    xxiii: #faffe9;
    xxiv: #f0ffe8;
    xxv: #f6ffe6;
  }
  ~~~

- `difference`

  ~~~ lay
  color.blend[difference] {
    i: #000000.blend(#000000.blend(#fff), 'difference')
    ii: #ffffff.blend(#000000.blend(#fff), 'difference')
    iii: #f01d93.blend(#000000.blend(#fff), 'difference')
    iv: #008b8b99.blend(#000000.blend(#fff), 'difference')
    v: #adff2f1d.blend(#000000.blend(#fff), 'difference')
    vi: #000000.blend(#ffffff.blend(#fff), 'difference')
    vii: #ffffff.blend(#ffffff.blend(#fff), 'difference')
    viii: #f01d93.blend(#ffffff.blend(#fff), 'difference')
    ix: #008b8b99.blend(#ffffff.blend(#fff), 'difference')
    x: #adff2f1d.blend(#ffffff.blend(#fff), 'difference')
    xi: #000000.blend(#f01d93.blend(#fff), 'difference')
    xii: #ffffff.blend(#f01d93.blend(#fff), 'difference')
    xiii: #f01d93.blend(#f01d93.blend(#fff), 'difference')
    xiv: #008b8b99.blend(#f01d93.blend(#fff), 'difference')
    xv: #adff2f1d.blend(#f01d93.blend(#fff), 'difference')
    xvi: #000000.blend(#008b8b99.blend(#fff), 'difference')
    xvii: #ffffff.blend(#008b8b99.blend(#fff), 'difference')
    xviii: #f01d93.blend(#008b8b99.blend(#fff), 'difference')
    xix: #008b8b99.blend(#008b8b99.blend(#fff), 'difference')
    xx: #adff2f1d.blend(#008b8b99.blend(#fff), 'difference')
    xxi: #000000.blend(#adff2f1d.blend(#fff), 'difference')
    xxii: #ffffff.blend(#adff2f1d.blend(#fff), 'difference')
    xxiii: #f01d93.blend(#adff2f1d.blend(#fff), 'difference')
    xxiv: #008b8b99.blend(#adff2f1d.blend(#fff), 'difference')
    xxv: #adff2f1d.blend(#adff2f1d.blend(#fff), 'difference')
  }
  ~~~

  ~~~ css
  color.blend[difference] {
    i: #000000;
    ii: #ffffff;
    iii: #f01d93;
    iv: #005353;
    v: #141d05;
    vi: #ffffff;
    vii: #000000;
    viii: #0fe26c;
    ix: #ffacac;
    x: #ebe2fa;
    xi: #f01d93;
    xii: #0fe26c;
    xiii: #000000;
    xiv: #f04e40;
    xv: #dc338e;
    xvi: #66b9b9;
    xvii: #994646;
    xviii: #8a9c26;
    xix: #666666;
    xx: #62acb4;
    xxi: #f6ffe7;
    xxii: #090018;
    xxiii: #06e254;
    xxiv: #f6ac94;
    xxv: #e2e2e2;
  }
  ~~~

- `exclusion`

  ~~~ lay
  color.blend[exclusion] {
    i: #000000.blend(#000000.blend(#fff), 'exclusion')
    ii: #ffffff.blend(#000000.blend(#fff), 'exclusion')
    iii: #f01d93.blend(#000000.blend(#fff), 'exclusion')
    iv: #008b8b99.blend(#000000.blend(#fff), 'exclusion')
    v: #adff2f1d.blend(#000000.blend(#fff), 'exclusion')
    vi: #000000.blend(#ffffff.blend(#fff), 'exclusion')
    vii: #ffffff.blend(#ffffff.blend(#fff), 'exclusion')
    viii: #f01d93.blend(#ffffff.blend(#fff), 'exclusion')
    ix: #008b8b99.blend(#ffffff.blend(#fff), 'exclusion')
    x: #adff2f1d.blend(#ffffff.blend(#fff), 'exclusion')
    xi: #000000.blend(#f01d93.blend(#fff), 'exclusion')
    xii: #ffffff.blend(#f01d93.blend(#fff), 'exclusion')
    xiii: #f01d93.blend(#f01d93.blend(#fff), 'exclusion')
    xiv: #008b8b99.blend(#f01d93.blend(#fff), 'exclusion')
    xv: #adff2f1d.blend(#f01d93.blend(#fff), 'exclusion')
    xvi: #000000.blend(#008b8b99.blend(#fff), 'exclusion')
    xvii: #ffffff.blend(#008b8b99.blend(#fff), 'exclusion')
    xviii: #f01d93.blend(#008b8b99.blend(#fff), 'exclusion')
    xix: #008b8b99.blend(#008b8b99.blend(#fff), 'exclusion')
    xx: #adff2f1d.blend(#008b8b99.blend(#fff), 'exclusion')
    xxi: #000000.blend(#adff2f1d.blend(#fff), 'exclusion')
    xxii: #ffffff.blend(#adff2f1d.blend(#fff), 'exclusion')
    xxiii: #f01d93.blend(#adff2f1d.blend(#fff), 'exclusion')
    xxiv: #008b8b99.blend(#adff2f1d.blend(#fff), 'exclusion')
    xxv: #adff2f1d.blend(#adff2f1d.blend(#fff), 'exclusion')
  }
  ~~~

  ~~~ css
  color.blend[exclusion] {
    i: #000000;
    ii: #ffffff;
    iii: #f01d93;
    iv: #005353;
    v: #141d05;
    vi: #ffffff;
    vii: #000000;
    viii: #0fe26c;
    ix: #ffacac;
    x: #ebe2fa;
    xi: #f01d93;
    xii: #0fe26c;
    xiii: #1c337d;
    xiv: #f05d86;
    xv: #df3392;
    xvi: #66b9b9;
    xvii: #994646;
    xviii: #96ac77;
    xix: #669494;
    xx: #6aacb7;
    xxi: #f6ffe7;
    xxii: #090018;
    xxiii: #17e270;
    xxiv: #f6aca3;
    xxv: #e3e2e3;
  }
  ~~~
