CSS Color
=========

## Functions

### `rgb()`

- Creates a color from `rgb` channels

  ~~~ lay
  rgb {
    i:  rgb(255,0,0)
    ii:  rgb(0, 255, 0)
    iii: rgb(
        0
       ,0
       ,255
    )
  }
  ~~~

  ~~~ css
  rgb {
    i: #f00;
    ii: #0f0;
    iii: #00f;
  }
  ~~~

- Fails if called with less than 3 arguments

  ~~~ lay
  rgb(0,0)
  ~~~

  ~~~ ReferenceError
  ~~~

  ~~~ lay
  rgb(0)
  ~~~

  ~~~ ReferenceError
  ~~~

  ~~~ lay
  rgb()
  ~~~

  ~~~ ReferenceError
  ~~~

- Fails if called with more than 3 arguments

  ~~~ lay
  rgb(0,0,0,0)
  ~~~

  ~~~ ReferenceError
  ~~~

  ~~~ lay
  rgb(0,0,0,0,0,0,0,0,0)
  ~~~

  ~~~ ReferenceError
  ~~~

- Accepts percentages as channels

  ~~~ lay
  rgb[percentages] {
    i:  rgb(100%,0,0)
    ii:  rgb(0%,100%,0%)
    iii: rgb(0,0,(100)%)
  }
  ~~~

  ~~~ css
  rgb[percentages] {
    i: #f00;
    ii: #0f0;
    iii: #00f;
  }
  ~~~

- Fails if an argument is not a number

    ~~~ lay
    rgb('foobar',0,0)
    ~~~

    ~~~ ValueError
    ~~~

    ~~~ lay
    rgb(100%,null,0)
    ~~~

    ~~~ ValueError
    ~~~

- Fails if an argument has wrong unit

  ~~~ lay
  rgb(100px,0,0)
  ~~~

  ~~~ ValueError
  ~~~

- Clips channels in the 0..255 range

  ~~~ lay
  rgb[clipping] {
    i:  rgb(256,0,0)
    ii:  rgb(-1,9999,0)
    iii: rgb(0,-100%,200%);
  }
  ~~~

  ~~~ css
  rgb[clipping] {
    i: #f00;
    ii: #0f0;
    iii: #00f;
  }
  ~~~

### `rgba()`

- Creates a color from `rgb` channels and optional `alpha` value

  ~~~ lay
  rgba {
    i:  rgba(255,0,0,1)
  }
  ~~~

  ~~~ css
  rgba {
    i: #f00;
  }
  ~~~

- Accepts a decimal number in the 0..1 range as `alpha`

  ~~~ lay
  rgba {
    i:    rgba(255,0,0,0).alpha
    ii:   rgba(0,255,0,.2).alpha
    iii:  rgba(0,0,255,.99).alpha
  }
  ~~~

  ~~~ css
  rgba {
    i: 0;
    ii: 0.2;
    iii: 0.99;
  }
  ~~~

- Accepts a percentage as `alpha`

  ~~~ lay
  rgba {
    i:    rgba(255,0,0,0%).alpha
    ii:   rgba(0,255,0,20%).alpha
    iii:  rgba(0,0,255,99%).alpha
  }
  ~~~

  ~~~ css
  rgba {
    i: 0;
    ii: 0.2;
    iii: 0.99;
  }
  ~~~

- Clips alpha values

  ~~~ lay
  rgba {
    i:   rgba(255,0,0,-1%).alpha
    ii:  rgba(255,0,0,-.5%).alpha
    iii: rgba(255,0,0,-2).alpha
    iv:  rgba(255,0,0,2).alpha
    v:   rgba(255,0,0,1.001).alpha
  }
  ~~~

  ~~~ css
  rgba {
    i: 0;
    ii: 0;
    iii: 0;
    iv: 1;
    v: 1;
  }
  ~~~

- Fails if called with less than 3 arguments

  ~~~ lay
  rgba(0,0)
  ~~~

  ~~~ ReferenceError
  ~~~

  ~~~ lay
  rgba(0)
  ~~~

  ~~~ ReferenceError
  ~~~

  ~~~ lay
  rgba()
  ~~~

  ~~~ ReferenceError
  ~~~

- Fails if called with more than 4 arguments

  ~~~ lay
  rgba(0,0,0,0,1)
  ~~~

  ~~~ ReferenceError
  ~~~

  ~~~ lay
  rgba(0,0,0,0,0,0,0,0,0)
  ~~~

  ~~~ ReferenceError
  ~~~

- Fails for non-numeric `alpha` values

  ~~~ lay
  rgba(100%,0,0, 'foobar')
  ~~~

  ~~~ ValueError
  ~~~

  ~~~ lay
  rgba(100%,0,0, #f00)
  ~~~

  ~~~ ValueError
  ~~~

- Fails for `alpha` values with wrong unit

  ~~~ lay
  rgba(100%,0,0, 1px)
  ~~~

  ~~~ ValueError
  ~~~

  ~~~ lay
  rgba(100%,0,0, .5deg)
  ~~~

  ~~~ ValueError
  ~~~

### `hsl()`

- Creates a color from `hsl` channels

  ~~~ lay
  #color.hsl {
    i: hsl(0deg, 100%, 50%)  // red
    ii: hsl(0, 100%, 50%)    // red
    iii: hsl(120, 100%, 50%) // lime green
    iv: hsl(120, 100%, 25%)  // dark green
    v: hsl(120, 100%, 75%)   // light green
    vi: hsl(120, 75%, 85%)   // pastel green
    vii: hsl(30deg, 75%, 50%)
  }
  ~~~

  ~~~ css
  #color.hsl {
    i: #f00;
    ii: #f00;
    iii: #0f0;
    iv: #008000;
    v: #80ff80;
    vi: #bcf5bc;
    vii: #df8020;
  }
  ~~~

- Fails if called with less than 3 arguments

  ~~~ lay
  hsl(0,0)
  ~~~

  ~~~ ReferenceError
  ~~~

  ~~~ lay
  hsl(0)
  ~~~

  ~~~ ReferenceError
  ~~~

  ~~~ lay
  hsl()
  ~~~

  ~~~ ReferenceError
  ~~~

- Fails if called with more than 3 arguments

  ~~~ lay
  hsl(0,0,0,0)
  ~~~

  ~~~ ReferenceError
  ~~~

  ~~~ lay
  hsl(0,0,0,0,0,0,0,0,0)
  ~~~

  ~~~ ReferenceError
  ~~~

- Accepts any angle as `hue`

  ~~~ lay
  #color.hsl {
    i: hsl(90deg, 100%, 50%)
    ii: hsl(.25turn, 100%, 50%)
    iii: hsl((PI/2)rad, 100%, 50%)
    iv: hsl(100grad, 100%, 50%)
  }
  ~~~

  ~~~ css
  #color.hsl {
    i: #80ff00;
    ii: #80ff00;
    iii: #80ff00;
    iv: #80ff00;
  }
  ~~~

- Assumes `hue` is an angle in degrees if a pure number is passed

  ~~~ lay
  #color.hsl {
    i: hsl(90, 100%, 50%)
  }
  ~~~

  ~~~ css
  #color.hsl {
    i: #80ff00;
  }
  ~~~

- Accepts a percentage as `hue`

  ~~~ lay
  #color.hsl {
    i: hsl(25%, 100%, 50%)
  }
  ~~~

  ~~~ css
  #color.hsl {
    i: #80ff00;
  }
  ~~~

- Clips `hue` angle

  ~~~ lay
  #color.hsl {
    i: hsl(360deg, 100%, 50%)
    ii: hsl(450deg, 100%, 50%)
    iii: hsl(1.25turn, 100%, 50%)
    iv: hsl(200%, 100%, 50%)
  }
  ~~~

  ~~~ css
  #color.hsl {
    i: #f00;
    ii: #80ff00;
    iii: #80ff00;
    iv: #f00;
  }
  ~~~

- Fails if `hue` is not an angle, a percentage or a pure number

  ~~~ lay
  hsl(90px, 50%, 100%)
  ~~~

  ~~~ ValueError
  ~~~

  ~~~ lay
  hsl(`10`, 50%, 100%)
  ~~~

  ~~~ ValueError
  ~~~

- Assumes `saturation` is a percentage if a pure number is passed

  ~~~ lay
  #color.hsl {
    i: hsl(0deg, 100, 50%)  // red
  }
  ~~~

  ~~~ css
  #color.hsl {
    i: #f00;
  }
  ~~~

- Fails if `saturation` is not a percentage or a pure number

  ~~~ lay
  hsl(90deg, 1px, 100%)
  ~~~

  ~~~ ValueError
  ~~~

  ~~~ lay
  hsl(90deg, '100%', 100%)
  ~~~

  ~~~ ValueError
  ~~~

  ~~~ lay
  hsl(90deg, #f00, 100%)
  ~~~

  ~~~ ValueError
  ~~~

- Clips `saturation` value

  ~~~ lay
  #color.hsl {
    i: hsl(360deg, 110%, 50%)
  }
  ~~~

  ~~~ css
  #color.hsl {
    i: #f00;
  }
  ~~~


- Assumes `lightness` is a percentage if a pure number is passed

  ~~~ lay
  #color.hsl {
    i: hsl(0deg, 100%, 50)
    ii: hsl(120, 100%, 25.0)
  }
  ~~~

  ~~~ css
  #color.hsl {
    i: #f00;
    ii: #008000;
  }
  ~~~

- Fails if `lightness` is not a percentage or a pure number

  ~~~ lay
  hsl(90deg, 100%, 1px)
  ~~~

  ~~~ ValueError
  ~~~

  ~~~ lay
  hsl(90deg, 100%, '100%')
  ~~~

  ~~~ ValueError
  ~~~

  ~~~ lay
  hsl(90deg, 100%, #f00)
  ~~~

  ~~~ ValueError
  ~~~

- Clips `lightness` value

  ~~~ lay
  #color.hsl {
    i: hsl(90deg, 0, 100.999)
    ii: hsl(90deg, 0, 300%)
  }
  ~~~

  ~~~ css
  #color.hsl {
    i: #fff;
    ii: #fff;
  }
  ~~~

### `hsla()`

- Creates a color from `hsl` channels and optional `alpha` value

  ~~~ lay
  #color.hsla {
    i: hsla(170, 50%, 45%, 1)
  }
  ~~~

  ~~~ css
  #color.hsla {
    i: #39ac99;
  }
  ~~~

- Fails if called with less than 3 arguments

  ~~~ lay
  hsla(0,0)
  ~~~

  ~~~ ReferenceError
  ~~~

  ~~~ lay
  hsla(0)
  ~~~

  ~~~ ReferenceError
  ~~~

  ~~~ lay
  hsla()
  ~~~

  ~~~ ReferenceError
  ~~~

- Fails if called with more than 4 arguments

  ~~~ lay
  hsla(0,0,0,0,0)
  ~~~

  ~~~ ReferenceError
  ~~~

- Accepts a decimal number in the 0..1 range as `alpha`

  ~~~ lay
  hsla {
    i:    hsla(255,0,0,0).alpha
    ii:   hsla(0,255,0,.2).alpha
    iii:  hsla(0,0,255,.99).alpha
  }
  ~~~

  ~~~ css
  hsla {
    i: 0;
    ii: 0.2;
    iii: 0.99;
  }
  ~~~

- Accepts a percentage as `alpha`

  ~~~ lay
  hsla {
    i:    hsla(255,0,0,0%).alpha
    ii:   hsla(0,255,0,20%).alpha
    iii:  hsla(0,0,255,99%).alpha
  }
  ~~~

  ~~~ css
  hsla {
    i: 0;
    ii: 0.2;
    iii: 0.99;
  }
  ~~~

- Clips alpha values

  ~~~ lay
  hsla {
    i:   hsla(255,0,0,-1%).alpha
    ii:  hsla(255,0,0,-.5%).alpha
    iii: hsla(255,0,0,-2).alpha
    iv:  hsla(255,0,0,2).alpha
    v:   hsla(255,0,0,1.001).alpha
  }
  ~~~

  ~~~ css
  hsla {
    i: 0;
    ii: 0;
    iii: 0;
    iv: 1;
    v: 1;
  }
  ~~~

- Fails for non-numeric `alpha` values

  ~~~ lay
  hsla(100%,0,0, (1,2,3))
  ~~~

  ~~~ ValueError
  ~~~

  ~~~ lay
  hsla(100%,0,0, /.*/)
  ~~~

  ~~~ ValueError
  ~~~

- Fails for `alpha` values with wrong unit

  ~~~ lay
  hsla(100%,0,0, 100mm)
  ~~~

  ~~~ ValueError
  ~~~

### `hwb()`

- Creates a color from `hwb` channels

  ~~~ lay
  #color.hwb {
    i: hwb(0, 0, 0)
    i: hwb(0, 100%, 0)
  }
  ~~~

  ~~~ css
  #color.hwb {
    i: #f00;
    i: #fff;
  }
  ~~~

- Fails if called with less than 3 arguments

  ~~~ lay
  hwb(0,0)
  ~~~

  ~~~ ReferenceError
  ~~~

  ~~~ lay
  hwb(0)
  ~~~

  ~~~ ReferenceError
  ~~~

  ~~~ lay
  hwb()
  ~~~

  ~~~ ReferenceError
  ~~~

- Fails if called with more than 3 arguments

  ~~~ lay
  hwb(0,0,0,0)
  ~~~

  ~~~ ReferenceError
  ~~~

  ~~~ lay
  hwb(0,0,0,0,0,0,0,0,0)
  ~~~

  ~~~ ReferenceError
  ~~~

- Accepts any angle as `hue`

  ~~~ lay
  #color.hwb {
    i: hwb(90deg, 0, 0)
    ii: hwb(1.25turn, 0, 0)
    iii: hwb(100grad, 0, 0)
  }
  ~~~

  ~~~ css
  #color.hwb {
    i: #80ff00;
    ii: #80ff00;
    iii: #80ff00;
  }
  ~~~

- Assumes `hue` is an angle in degrees if a pure number is passed

  ~~~ lay
  #color.hwb {
    i: hwb(90, 0, 0)
  }
  ~~~

  ~~~ css
  #color.hwb {
    i: #80ff00;
  }
  ~~~

- Accepts a percentage as `hue`

  ~~~ lay
  #color.hwb {
    i: hwb(25%, 0, 0)
  }
  ~~~

  ~~~ css
  #color.hwb {
    i: #80ff00;
  }
  ~~~

- Clips `hue` angle

  ~~~ lay
  #color.hwb {
    i: hwb(360deg, 0, 0)
    ii: hwb(450deg, 0, 0)
    iii: hwb(1.25turn, 0, 0)
    iv: hwb(200%, 0, 0)
  }
  ~~~

  ~~~ css
  #color.hwb {
    i: #f00;
    ii: #80ff00;
    iii: #80ff00;
    iv: #f00;
  }
  ~~~

- Fails if `hue` is not an angle or a percentage

  ~~~ lay
  hwb(90px, 50%, 100%)
  ~~~

  ~~~ ValueError
  ~~~

  ~~~ lay
  hwb(`10`, 50%, 100%)
  ~~~

  ~~~ ValueError
  ~~~

   ~~~ lay
  hwb((0,), 50%, 100%)
  ~~~

  ~~~ ValueError
  ~~~

- Assumes `whiteness` is a percentage is a pure number is passed

  ~~~ lay
  #color.hwb {
    i: hwb(180, 17, 17%)
  }
  ~~~

  ~~~ css
  #color.hwb {
    i: #2bd4d4;
  }
  ~~~

- Fails if `whiteness` is not a percentage or a pure number

  ~~~ lay
  hwb(120deg, 'foobar', 0)
  ~~~

  ~~~ ValueError
  ~~~

  ~~~ lay
  hwb(120deg, 100px, 0)
  ~~~

  ~~~ ValueError
  ~~~

  ~~~ lay
  hwb(120deg, '100', 0)
  ~~~

  ~~~ ValueError
  ~~~

- Clips `whiteness` value

  ~~~ lay
  #color.hwb {
    i: hwb(0, 101, 0)
    ii: hwb(0, 200%, 0)
  }
  ~~~

  ~~~ css
  #color.hwb {
    i: #fff;
    ii: #fff;
  }
  ~~~

- Assumes `blackness` is a percentage is a pure number is passed

  ~~~ lay
  #color.hwb {
    i: hwb(180, 17%, 17)
  }
  ~~~

  ~~~ css
  #color.hwb {
    i: #2bd4d4;
  }
  ~~~

- Fails if `blackness` is not a a percentage or a pure number

  ~~~ lay
  hwb(120deg, 0, #f00)
  ~~~

  ~~~ ValueError
  ~~~

  ~~~ lay
  hwb(120deg, 0, 100px)
  ~~~

  ~~~ ValueError
  ~~~

  ~~~ lay
  hwb(120deg, 0, '0')
  ~~~

  ~~~ ValueError
  ~~~

- Clips `blackness` value

  ~~~ lay
  #color.hwb {
    i: hwb(0, 0, 100.9)
    ii: hwb(0, 0, 1000%)
  }
  ~~~

  ~~~ css
  #color.hwb {
    i: #000;
    ii: #000;
  }
  ~~~

### `hwba()`

- Creates a color from `hwb` channels and optional `alpha` value

  ~~~ lay
  #color.hwba {
    i: hwba(0, 100%, 0)
    ii: hwba(0, 100%, 0, 1)
  }
  ~~~

  ~~~ css
  #color.hwba {
    i: #fff;
    ii: #fff;
  }
  ~~~

- Fails if called with less than 3 arguments

  ~~~ lay
  hwba(0,0)
  ~~~

  ~~~ ReferenceError
  ~~~

  ~~~ lay
  hwba(0)
  ~~~

  ~~~ ReferenceError
  ~~~

  ~~~ lay
  hwba()
  ~~~

  ~~~ ReferenceError
  ~~~

- Fails if called with more than 4 arguments

  ~~~ lay
  hwba(0,0,0,0,0)
  ~~~

  ~~~ ReferenceError
  ~~~

- Accepts a decimal number in the 0..1 range as `alpha`

  ~~~ lay
  hwba {
    i:    hwba(255,0,0,0).alpha
    ii:   hwba(0,255,0,.2).alpha
    iii:  hwba(0,0,255,.99).alpha
  }
  ~~~

  ~~~ css
  hwba {
    i: 0;
    ii: 0.2;
    iii: 0.99;
  }
  ~~~

- Accepts a percentage as `alpha`

  ~~~ lay
  hwba {
    i:    hwba(255,0,0,0%).alpha
    ii:   hwba(0,255,0,20%).alpha
    iii:  hwba(0,0,255,99%).alpha
  }
  ~~~

  ~~~ css
  hwba {
    i: 0;
    ii: 0.2;
    iii: 0.99;
  }
  ~~~

- Clips alpha values

  ~~~ lay
  hwba {
    i:   hwba(255,0,0,-1%).alpha
    ii:  hwba(255,0,0,-.5%).alpha
    iii: hwba(255,0,0,-2).alpha
    iv:  hwba(255,0,0,2).alpha
    v:   hwba(255,0,0,1.001).alpha
  }
  ~~~

  ~~~ css
  hwba {
    i: 0;
    ii: 0;
    iii: 0;
    iv: 1;
    v: 1;
  }
  ~~~

- Fails for non-numeric `alpha` values

  ~~~ lay
  hwba(100%,0,0, false)
  ~~~

  ~~~ ValueError
  ~~~

  ~~~ lay
  hwba(100%,0,0, url(//example.org))
  ~~~

  ~~~ ValueError
  ~~~

- Fails for `alpha` values with wrong unit

  ~~~ lay
  hwba(100%,0,0, 100hz)
  ~~~

  ~~~ ValueError
  ~~~

## Names

- All X11/CSS4 color names are defined

  ~~~ lay
  color::names {
    aliceblue: aliceblue
    antiquewhite: antiquewhite
    aqua: aqua
    aquamarine: aquamarine
    azure: azure
    beige: beige
    bisque: bisque
    black: black
    blanchedalmond: blanchedalmond
    blue: blue
    blueviolet: blueviolet
    brown: brown
    burlywood: burlywood
    cadetblue: cadetblue
    chartreuse: chartreuse
    chocolate: chocolate
    coral: coral
    cornflowerblue: cornflowerblue
    cornsilk: cornsilk
    crimson: crimson
    cyan: cyan
    darkblue: darkblue
    darkcyan: darkcyan
    darkgoldenrod: darkgoldenrod
    darkgray: darkgray
    darkgreen: darkgreen
    darkgrey: darkgrey
    darkkhaki: darkkhaki
    darkmagenta: darkmagenta
    darkolivegreen: darkolivegreen
    darkorange: darkorange
    darkorchid: darkorchid
    darkred: darkred
    darksalmon: darksalmon
    darkseagreen: darkseagreen
    darkslateblue: darkslateblue
    darkslategray: darkslategray
    darkslategrey: darkslategrey
    darkturquoise: darkturquoise
    darkviolet: darkviolet
    deeppink: deeppink
    deepskyblue: deepskyblue
    dimgray: dimgray
    dimgrey: dimgrey
    dodgerblue: dodgerblue
    firebrick: firebrick
    floralwhite: floralwhite
    forestgreen: forestgreen
    fuchsia: fuchsia
    gainsboro: gainsboro
    ghostwhite: ghostwhite
    gold: gold
    goldenrod: goldenrod
    gray: gray
    green: green
    greenyellow: greenyellow
    grey: grey
    honeydew: honeydew
    hotpink: hotpink
    indianred: indianred
    indigo: indigo
    ivory: ivory
    khaki: khaki
    lavender: lavender
    lavenderblush: lavenderblush
    lawngreen: lawngreen
    lemonchiffon: lemonchiffon
    lightblue: lightblue
    lightcoral: lightcoral
    lightcyan: lightcyan
    lightgoldenrodyellow: lightgoldenrodyellow
    lightgray: lightgray
    lightgreen: lightgreen
    lightgrey: lightgrey
    lightpink: lightpink
    lightsalmon: lightsalmon
    lightseagreen: lightseagreen
    lightskyblue: lightskyblue
    lightslategray: lightslategray
    lightslategrey: lightslategrey
    lightsteelblue: lightsteelblue
    lightyellow: lightyellow
    lime: lime
    limegreen: limegreen
    linen: linen
    magenta: magenta
    maroon: maroon
    mediumaquamarine: mediumaquamarine
    mediumblue: mediumblue
    mediumorchid: mediumorchid
    mediumpurple: mediumpurple
    mediumseagreen: mediumseagreen
    mediumslateblue: mediumslateblue
    mediumspringgreen: mediumspringgreen
    mediumturquoise: mediumturquoise
    mediumvioletred: mediumvioletred
    midnightblue: midnightblue
    mintcream: mintcream
    mistyrose: mistyrose
    moccasin: moccasin
    navajowhite: navajowhite
    navy: navy
    oldlace: oldlace
    olive: olive
    olivedrab: olivedrab
    orange: orange
    orangered: orangered
    orchid: orchid
    palegoldenrod: palegoldenrod
    palegreen: palegreen
    paleturquoise: paleturquoise
    palevioletred: palevioletred
    papayawhip: papayawhip
    peachpuff: peachpuff
    peru: peru
    pink: pink
    plum: plum
    powderblue: powderblue
    purple: purple
    rebeccapurple: rebeccapurple
    red: red
    rosybrown: rosybrown
    royalblue: royalblue
    saddlebrown: saddlebrown
    salmon: salmon
    sandybrown: sandybrown
    seagreen: seagreen
    seashell: seashell
    sienna: sienna
    silver: silver
    skyblue: skyblue
    slateblue: slateblue
    slategray: slategray
    slategrey: slategrey
    snow: snow
    springgreen: springgreen
    steelblue: steelblue
    tan: tan
    teal: teal
    thistle: thistle
    tomato: tomato
    turquoise: turquoise
    violet: violet
    wheat: wheat
    white: white
    whitesmoke: whitesmoke
    yellow: yellow
    yellowgreen: yellowgreen
  }
  ~~~

  ~~~ css
  color::names {
    aliceblue: #f0f8ff;
    antiquewhite: #faebd7;
    aqua: #0ff;
    aquamarine: #7fffd4;
    azure: #f0ffff;
    beige: #f5f5dc;
    bisque: #ffe4c4;
    black: #000;
    blanchedalmond: #ffebcd;
    blue: #00f;
    blueviolet: #8a2be2;
    brown: #a52a2a;
    burlywood: #deb887;
    cadetblue: #5f9ea0;
    chartreuse: #7fff00;
    chocolate: #d2691e;
    coral: #ff7f50;
    cornflowerblue: #6495ed;
    cornsilk: #fff8dc;
    crimson: #dc143c;
    cyan: #0ff;
    darkblue: #00008b;
    darkcyan: #008b8b;
    darkgoldenrod: #b8860b;
    darkgray: #a9a9a9;
    darkgreen: #006400;
    darkgrey: #a9a9a9;
    darkkhaki: #bdb76b;
    darkmagenta: #8b008b;
    darkolivegreen: #556b2f;
    darkorange: #ff8c00;
    darkorchid: #9932cc;
    darkred: #8b0000;
    darksalmon: #e9967a;
    darkseagreen: #8fbc8f;
    darkslateblue: #483d8b;
    darkslategray: #2f4f4f;
    darkslategrey: #2f4f4f;
    darkturquoise: #00ced1;
    darkviolet: #9400d3;
    deeppink: #ff1493;
    deepskyblue: #00bfff;
    dimgray: #696969;
    dimgrey: #696969;
    dodgerblue: #1e90ff;
    firebrick: #b22222;
    floralwhite: #fffaf0;
    forestgreen: #228b22;
    fuchsia: #f0f;
    gainsboro: #dcdcdc;
    ghostwhite: #f8f8ff;
    gold: #ffd700;
    goldenrod: #daa520;
    gray: #808080;
    green: #008000;
    greenyellow: #adff2f;
    grey: #808080;
    honeydew: #f0fff0;
    hotpink: #ff69b4;
    indianred: #cd5c5c;
    indigo: #4b0082;
    ivory: #fffff0;
    khaki: #f0e68c;
    lavender: #e6e6fa;
    lavenderblush: #fff0f5;
    lawngreen: #7cfc00;
    lemonchiffon: #fffacd;
    lightblue: #add8e6;
    lightcoral: #f08080;
    lightcyan: #e0ffff;
    lightgoldenrodyellow: #fafad2;
    lightgray: #d3d3d3;
    lightgreen: #90ee90;
    lightgrey: #d3d3d3;
    lightpink: #ffb6c1;
    lightsalmon: #ffa07a;
    lightseagreen: #20b2aa;
    lightskyblue: #87cefa;
    lightslategray: #789;
    lightslategrey: #789;
    lightsteelblue: #b0c4de;
    lightyellow: #ffffe0;
    lime: #0f0;
    limegreen: #32cd32;
    linen: #faf0e6;
    magenta: #f0f;
    maroon: #800000;
    mediumaquamarine: #66cdaa;
    mediumblue: #0000cd;
    mediumorchid: #ba55d3;
    mediumpurple: #9370db;
    mediumseagreen: #3cb371;
    mediumslateblue: #7b68ee;
    mediumspringgreen: #00fa9a;
    mediumturquoise: #48d1cc;
    mediumvioletred: #c71585;
    midnightblue: #191970;
    mintcream: #f5fffa;
    mistyrose: #ffe4e1;
    moccasin: #ffe4b5;
    navajowhite: #ffdead;
    navy: #000080;
    oldlace: #fdf5e6;
    olive: #808000;
    olivedrab: #6b8e23;
    orange: #ffa500;
    orangered: #ff4500;
    orchid: #da70d6;
    palegoldenrod: #eee8aa;
    palegreen: #98fb98;
    paleturquoise: #afeeee;
    palevioletred: #db7093;
    papayawhip: #ffefd5;
    peachpuff: #ffdab9;
    peru: #cd853f;
    pink: #ffc0cb;
    plum: #dda0dd;
    powderblue: #b0e0e6;
    purple: #800080;
    rebeccapurple: #639;
    red: #f00;
    rosybrown: #bc8f8f;
    royalblue: #4169e1;
    saddlebrown: #8b4513;
    salmon: #fa8072;
    sandybrown: #f4a460;
    seagreen: #2e8b57;
    seashell: #fff5ee;
    sienna: #a0522d;
    silver: #c0c0c0;
    skyblue: #87ceeb;
    slateblue: #6a5acd;
    slategray: #708090;
    slategrey: #708090;
    snow: #fffafa;
    springgreen: #00ff7f;
    steelblue: #4682b4;
    tan: #d2b48c;
    teal: #008080;
    thistle: #d8bfd8;
    tomato: #ff6347;
    turquoise: #40e0d0;
    violet: #ee82ee;
    wheat: #f5deb3;
    white: #fff;
    whitesmoke: #f5f5f5;
    yellow: #ff0;
    yellowgreen: #9acd32;
  }
  ~~~

- Are not overwritable

  ~~~ lay
  green = #f00
  ~~~

  ~~~ ReferenceError
  ~~~

- Are case sensitive

  ~~~ lay
  color::names {
    i: steelblue
    ii: STEELBLUE
    iii: steelBlue
    iv: SteelBlue
  }
  ~~~

  ~~~ css
  color::names {
    i: #4682b4;
    ii: STEELBLUE;
    iii: steelBlue;
    iv: SteelBlue;
  }
  ~~~
