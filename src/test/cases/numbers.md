Numbers
=======

- Are declared with the usual decimal notation

  ~~~ lay
  body {
    foo: 5
    bar: 999
    baz: 000
  }
  ~~~

  ~~~ css
  body {
    foo: 5;
    bar: 999;
    baz: 0;
  }
  ~~~

- Can have a decimal part

  ~~~ lay
  PI = 3.14159265359
  body {
    pi: PI
    pi: PI * 100000
  }
  ~~~

  ~~~ css
  body {
    pi: 3.14;
    pi: 314159.27;
  }
  ~~~

- Do not need leading zeroes before the decimal point

  ~~~ lay
  body {
    half: .50
  }
  ~~~

  ~~~ css
  body {
    half: 0.5;
  }
  ~~~

- Can have a unit

  ~~~ lay
  body {
    width: 940px
    height: 100%
    height: 101tweets
    height: 0fOOs
    height: 0%
    height: 0rem
  }
  ~~~

  ~~~ css
  body {
    width: 940px;
    height: 100%;
    height: 101tweets;
    height: 0;
    height: 0;
    height: 0;
  }
  ~~~

- Can have both a unit and a decimal part

  ~~~ lay
  PI = 3.14159265359
  body {
    width: .1%
    height: 99.9%
    pi: (PI)px
  }
  ~~~

  ~~~ css
  body {
    width: 0.1%;
    height: 99.9%;
    pi: 3.14px;
  }
  ~~~

- Can be quite big

  ~~~ lay
  body {
    height: 999999999999999%
  }
  ~~~

  ~~~ css
  body {
    height: 999999999999999%;
  }
  ~~~

- Units may appear after parentheses for conversion

  ~~~ lay
  body {
    foo: (17/2)px
    foo: (100px)pc
    foo: ((100))em
    foo: (80cm + 20)in
    foo: (256%)``
  }
  ~~~

  ~~~ css
  body {
    foo: 8.5px;
    foo: 6.25pc;
    foo: 100em;
    foo: 39.37in;
    foo: 256;
  }
  ~~~

- Are always trueish

  ~~~ lay
  bar {
    foo: 1.true? not (not (false or 0)) (-1.1).boolean
  }
  ~~~

  ~~~ css
  bar {
    foo: true true true;
  }
  ~~~

## User defined units

- Are made by assigning a number to another number literal

  ~~~ lay
  1dm = 10cm
  1m = 10dm

  foo: 1m
  bar: 1m = 1000mm
  ~~~

  ~~~ css
  foo: 100cm;
  bar: 1000mm;
  ~~~

  ~~~ lay
  12col = 100%

  .row {
    .col-1 {
      width: 1col
    }
    .col-12 {
      width: 12col
    }
  }
  ~~~

  ~~~ css
  .row .col-1 {
    width: 8.33%;
  }

  .row .col-12 {
    width: 100%;
  }
  ~~~

- Can be re-defined

  ~~~ lay
  1m = 100cm
  height: 2.5m

  1m = 1000mm
  height: 2.5m

  1m = 100cm
  height: 2.5m
  ~~~

  ~~~ css
  height: 250cm;
  height: 2500mm;
  height: 250cm;
  ~~~

- Can also be defined with the `|=` operator

  ~~~ lay
  1m = 99cm
  foo: 2m
  foo: 2m |= 200cm
  foo: 2m
  ~~~

  ~~~ css
  foo: 198cm;
  foo: 198cm;
  foo: 198cm;
  ~~~

- Are scoped

## Methods

### `positive?`

- Returns `true` if the number is greater than `0`

  ~~~ lay
  body {
    foo: 999.positive?
    foo: 0.5.positive?
    foo: ( 0 ).positive?
    a = 0.001
    foo: a.positive?
    a = a * (-1)
    foo: not a.positive?
  }
  ~~~

  ~~~ css
  body {
    foo: true;
    foo: true;
    foo: false;
    foo: true;
    foo: true;
  }
  ~~~

### `negative?`

- Returns `true` if the number is lower than `0`

  ~~~ lay
  body {
    foo: 0.5.negative?
    foo: 0.negative?
    foo: 0.0000.negative?
    a = 0.001
    foo: a.negative?
    a = a * (-1)
    foo: not a.negative?
  }
  ~~~

  ~~~ css
  body {
    foo: false;
    foo: false;
    foo: false;
    foo: false;
    foo: false;
  }
  ~~~

### `even?`

- Returns true if the number is divisible by `2`

  ~~~ lay
  foo: 0.even?
  foo: 2.even?
  foo: 7.even?
  foo: -10.even?
  foo: -1.even?
  ~~~

  ~~~ css
  foo: true;
  foo: true;
  foo: false;
  foo: true;
  foo: false;
  ~~~

### `odd?`

- Returns `true` if the number is not divisible by `2`

  ~~~ lay
  foo: 0.odd?
  foo: 2.odd?
  foo: 7.odd?
  foo: -1.odd?
  foo: -4.odd?
  ~~~

  ~~~ css
  foo: false;
  foo: false;
  foo: true;
  foo: true;
  foo: false;
  ~~~

### `divisible-by?`

- Checks if the number is divisible by another

  ~~~~ lay
  foo: 1.divisible-by?(1)
  foo: not 3.divisible-by?(2)
  foo: 3.4.divisible-by?(1.70)
  foo: 3.divisible-by?(1.5)
  foo: 4.divisible-by(-2)?
  foo: -49.divisible-by(7)?
  foo: 0.divisible-by(7)?
  foo: not 0.divisible-by(0)?
  ~~~~

  ~~~~ css
  foo: true;
  foo: true;
  foo: true;
  foo: true;
  foo: true;
  foo: true;
  foo: true;
  foo: true;
  ~~~~

- Fails for incompatible units

### `zero?`

- Returns `true` only if the number is exactly `0`

  ~~~ lay
  body {
    foo: 0.zero?
    foo: (0.00001).zero?
    foo: (-1 * 0).zero?
    foo: .1.zero?
    foo: 0.00001.zero?
  }
  ~~~

  ~~~ css
  body {
    foo: true;
    foo: false;
    foo: true;
    foo: false;
    foo: false;
  }
  ~~~

### `empty?`

- Is an alias of `zero?`

  ~~~ lay
  body {
    foo: 0.empty? -0.00001.empty? (-1 * 0).empty? .1.empty? 0.00001.empty?
  }
  ~~~

  ~~~ css
  body {
    foo: true false true false false;
  }
  ~~~

### `negate`

- Negates the number

  ~~~ lay
  body {
    foo: 0.negate
    foo: 1.negate
    foo: -1px.negate
    foo: (-1px * -1px).negate
  }
  ~~~

  ~~~ css
  body {
    foo: 0;
    foo: -1;
    foo: 1px;
    foo: -1px;
  }
  ~~~

### `positive`

- Returns a copy of the number with positive sign

  ~~~ lay
  body {
    foo: 1px.positive (-2.01).positive 3.77%.positive (2 - 7)mm.positive 0.positive
  }
  ~~~

  ~~~ css
  body {
    foo: 1px 2.01 3.77% 5mm 0;
  }
  ~~~

### `negative`

- Returns a copy of the number with negative sign

  ~~~ lay
  body {
    foo: 1px.negative (2.01).negative -3.76%.negative (7 - 2)mm.negative 0.negative
  }
  ~~~

  ~~~ css
  body {
    foo: -1px -2.01 -3.76% -5mm 0;
  }
  ~~~

### `abs`

- Is an alias of `positive`

  ~~~ lay
  body {
    foo: 1px.abs (-2).abs -3%.abs (2 - 7)mm.abs 0.abs
  }
  ~~~

  ~~~ css
  body {
    foo: 1px 2 3% 5mm 0;
  }
  ~~~

### `unit`

- Returns the unit of the number as an unquoted string, or `null` if the number has no unit.

  ~~~ lay
  body {
    foo: 1px.unit 2.unit 3%.unit (2 + 7)mm.unit
  }
  ~~~

  ~~~ css
  body {
    foo: px null % mm;
  }
  ~~~

### `unit?`

- Returns `true` if the number has a unit

  ~~~ lay
  body {
    foo: 0.unit?
    foo: (24 + .3).unit?
    foo: (24px + 2).unit?
    foo: 100%.unit?
  }
  ~~~

  ~~~ css
  body {
    foo: false;
    foo: false;
    foo: true;
    foo: true;
  }
  ~~~

### `pure?`

- Returns `true` if the number has no unit

  ~~~ lay
  body {
    foo: 0.pure?
    foo: (24 + .3).pure?
    foo: (24px + 2).pure?
    foo: 100%.pure?
    foo: (22)``.pure?
    foo: (100px)` `.pure?
  }
  ~~~

  ~~~ css
  body {
    foo: true;
    foo: true;
    foo: false;
    foo: false;
    foo: true;
    foo: true;
  }
  ~~~

### `pure`

- Returns a copy of the number without unit

  ~~~ lay
  body {
    foo: 0.pure
    foo: 4px.pure
    foo: (100 + 25mm)cm.pure
  }
  ~~~

  ~~~ css
  body {
    foo: 0;
    foo: 4;
    foo: 12.5;
  }
  ~~~

### `decimal?`

- Returns `true` if the number has a decimal part.

  ~~~ lay
  body {
    foo: 0.1.decimal? 0.decimal? 42.decimal? 0.00.decimal?
  }
  ~~~

  ~~~ css
  body {
    foo: true false false false;
  }
  ~~~

### `integer?`

- Returns `true` if the number has no decimal part.

  ~~~ lay
  body {
    foo: 0.1.integer? 0.integer? 42.integer? 0.00.integer?
  }
  ~~~

  ~~~ css
  body {
    foo: false true true true;
  }
  ~~~

### `round`

- Returns a copy of the number rounded to the closest integer

  ~~~ lay
  body {
    foo: 0.round 1.001.round .007.round (16/7).round()
  }
  ~~~

  ~~~ css
  body {
    foo: 0 1 0 2;
  }
  ~~~

- Has an optional `places` argument

  ~~~ lay
  foo: 0.round(99) 1.001.round(2) 3.141592653589793rad.round(6).unquoted
  ~~~

  ~~~ css
  foo: 0 1 3.141593rad;
  ~~~

### `ceil`

- Returns the smallest integer equal or greater than the number

  ~~~ lay
  a = .9
  b = 1.001

  body {
    foo: a.ceil b.ceil .5mm.ceil 2.ceil 0.ceil
  }
  ~~~

  ~~~ css
  body {
    foo: 1 2 1mm 2 0;
  }
  ~~~

### `floor`

- Returns the largest integer less than or equal to the number

  ~~~ lay
  a = .9
  b = 1.001

  body {
    foo: a.floor b.floor -2.233mm.floor 2km.floor 0.floor
  }
  ~~~

  ~~~ css
  body {
    foo: 0 1 -3mm 2km 0;
  }
  ~~~

- Returns the reminder of division of the number by another

  ~~~ lay
  foo: 10px.mod(3)
  foo: 4.mod(2)
  foo: (-8%).mod(3)
  foo: 7.mod(-2)
  ~~~

  ~~~ css
  foo: 1px;
  foo: 0;
  foo: -2%;
  foo: 1;
  ~~~

- Fails if `0` is passed

  ~~~ lay
  foo: 17.mod(0)
  ~~~

  ~~~ TypeError
  Cannot divide by 0
  ~~~

### `pow`

- Makes a pow of the number

  ~~~ lay
  foo: 2px.pow(1)
  foo: (-7%).pow(3)
  foo: (-7%).pow(-1)
  foo: 700em.pow(0)
  foo: 0rem.pow(0)
  ~~~

  ~~~ css
  foo: 2px;
  foo: -343%;
  foo: -0.14%;
  foo: 1em;
  foo: 1rem;
  ~~~

- Defaults to `2` when no exponent is given

  ~~~ lay
  foo: 11px.pow
  ~~~

  ~~~ css
  foo: 121px;
  ~~~

### `sq`

- Is an alias of `pow(2)`

  ~~~ lay
  foo: 4.sq
  ~~~

  ~~~ css
  foo: 16;
  ~~~

### `root`

- Calculates the n-th root of the number

  ~~~ lay
  foo: 27.root(3)
  foo: 121.root(2)
  foo: 279936.root(7)
  foo: 15.8.root(3)
  ~~~

  ~~~ css
  foo: 3;
  foo: 11;
  foo: 6;
  foo: 2.51;
  ~~~

- Defaults to `2` when no degree is given

  ~~~ lay
  foo: 121.root
  foo: 0px.root
  ~~~

  ~~~ css
  foo: 11;
  foo: 0;
  ~~~

- Fails for negative bases

  ~~~ lay
  (-1mm).root
  ~~~

  ~~~ TypeError
  ~~~

### `sqrt`

- Is an alias of `root(2)`

  ~~~ lay
  foo: 81.sqrt
  ~~~

  ~~~ css
  foo: 9;
  ~~~

  ~~~ lay
  (-2).sqrt
  ~~~

  ~~~ TypeError
  ~~~

### `sin`

- Returns the sine of the number

### `cos`

- Returns the cosine of the number

### `tan`

- Returns the tangent of the number

### `asin`

- Returns the arcsine of the number

### `acos`

- Returns the arccosine of the number

### `atan`

- Returns the arctangent of the number

### `base`

- Returns a string representation of the number in the given base

  ~~~ lay
  bin: 27.base(2)
  oct: 27px.base(8)
  hex: 27%.base(16).quoted
  ~~~

  ~~~ css
  bin: 11011;
  oct: 33px;
  hex: "1b%";
  ~~~

- Defaults to base `10`, returning a clone of the number

  ~~~ lay
  dec: 27.base
  dec: 27px.base()
  ~~~

  ~~~ css
  dec: 27;
  dec: 27px;
  ~~~

- Fails for non integer bases

  ~~~ lay
  27.base(2.3)
  ~~~

  ~~~ TypeError
  ~~~

- Fails for any base lower than 2

  ~~~ lay
  27.base(-1.6)
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  27.base(0)
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  27.base(1)
  ~~~

  ~~~ TypeError
  ~~~

- Fails for any base higher than 16

  ~~~ lay
  27.base(17)
  ~~~

  ~~~ TypeError
  ~~~

### `copy`

- Creates a copy of the number

  ~~~ lay
  body {
    a = 12.5%.copy
    b = 27.copy
    c = 0px.copy
    a: a
    b: b
    c: c
  }
  ~~~

  ~~~ css
  body {
    a: 12.5%;
    b: 27;
    c: 0;
  }
  ~~~

### `convert`

#### Performs unit conversions

##### Length

- `in` -> `px`, `pc`, `pt`, `mm`, `cm`, `q`

  ~~~ lay
  c = (n, u) { return n.convert(u) }

  #in {
    in: c(1in,in)
    px: c(1in,px)
    cm: c(1in,cm)
    mm: c(1in,mm)
    pt: c(1in,pt)
    pc: c(1in,pc)
    q:  c(1in,q)
  }
  ~~~

  ~~~ css
  #in {
    in: 1in;
    px: 96px;
    cm: 2.54cm;
    mm: 25.4mm;
    pt: 72pt;
    pc: 6pc;
    q: 101.6q;
  }
  ~~~

- `cm` -> `in`, `px`, `pc`, `pt`, `mm`, `q`

  ~~~ lay
  c = (n, u) { return n.convert(u) }

  #cm {
    in: c(1cm,in)
    px: c(1cm,px)
    cm: c(1cm,cm)
    mm: c(1cm,mm)
    pt: c(1cm,pt)
    pc: c(1cm,pc)
    q:  c(1cm,q)
  }
  ~~~

  ~~~ css
  #cm {
    in: 0.39in;
    px: 37.8px;
    cm: 1cm;
    mm: 10mm;
    pt: 28.35pt;
    pc: 2.36pc;
    q: 40q;
  }
  ~~~

- `mm` -> `in`, `px`, `pc`, `pt`, `cm`, `q`

  ~~~ lay
  c = (n, u) { return n.convert(u) }

  #mm {
    in: c(1mm,in)
    px: c(1mm,px)
    cm: c(1mm,cm)
    mm: c(1mm,mm)
    pt: c(1mm,pt)
    pc: c(1mm,pc)
    q:  c(1mm,q)
  }
  ~~~

  ~~~ css
  #mm {
    in: 0.04in;
    px: 3.78px;
    cm: 0.1cm;
    mm: 1mm;
    pt: 2.83pt;
    pc: 0.24pc;
    q: 4q;
  }
  ~~~

- `pt` -> `in`, `px`, `pc`, `mm`, `cm`, `q`

  ~~~ lay
  c = (n, u) { return n.convert(u) }

  #pt {
    in: c(1pt,in)
    px: c(1pt,px)
    cm: c(1pt,cm)
    mm: c(1pt,mm)
    pt: c(1pt,pt)
    pc: c(1pt,pc)
    q:  c(1pt,q)
  }
  ~~~

  ~~~ css
  #pt {
    in: 0.01in;
    px: 1.33px;
    cm: 0.04cm;
    mm: 0.35mm;
    pt: 1pt;
    pc: 0.08pc;
    q: 1.41q;
  }
  ~~~

- `pc` -> `in`, `px`, `pt`, `mm`, `cm`, `q`

  ~~~ lay
  c = (n, u) { return n.convert(u) }

  #pc {
    in: c(1pc,in)
    px: c(1pc,px)
    cm: c(1pc,cm)
    mm: c(1pc,mm)
    pt: c(1pc,pt)
    pc: c(1pc,pc)
    q:  c(1pc,q)
  }
  ~~~

  ~~~ css
  #pc {
    in: 0.17in;
    px: 16px;
    cm: 0.42cm;
    mm: 4.23mm;
    pt: 12pt;
    pc: 1pc;
    q: 16.93q;
  }
  ~~~

- `q` -> `in`, `px`, `pc`, `pt`, `mm`, `cm`

  ~~~ lay
  c = (n, u) { return n.convert(u) }

  #q {
    in: c(1q,in)
    px: c(1q,px)
    cm: c(1q,cm)
    mm: c(1q,mm)
    pt: c(1q,pt)
    pc: c(1q,pc)
    q:  c(1q,q)
  }
  ~~~

  ~~~ css
  #q {
    in: 0.01in;
    px: 0.94px;
    cm: 0.03cm;
    mm: 0.25mm;
    pt: 0.71pt;
    pc: 0.06pc;
    q: 1q;
  }
  ~~~

- `px` -> `in`, `pc`, `pt`, `mm`, `cm`, `q`

  ~~~ lay
  c = (n, u) { return n.convert(u) }

  #px {
    in: c(1px,in)
    px: c(1px,px)
    cm: c(1px,cm)
    mm: c(1px,mm)
    pt: c(1px,pt)
    pc: c(1px,pc)
    q:  c(1px,q)
  }
  ~~~

  ~~~ css
  #px {
    in: 0.01in;
    px: 1px;
    cm: 0.03cm;
    mm: 0.26mm;
    pt: 0.75pt;
    pc: 0.06pc;
    q: 1.06q;
  }
  ~~~

##### Time

- `ms` <-> `s`

  ~~~ lay
  #s {
    s: 1s.convert(s)
    ms: 1s.convert(ms)
    ms: -.25s.convert(ms)
  }

  #ms {
    s: 1ms.convert(s)
    s: 138ms.convert(s)
    ms: 1ms.convert(ms)
  }
  ~~~

  ~~~ css
  #s {
    s: 1s;
    ms: 1000ms;
    ms: -250ms;
  }

  #ms {
    s: 0;
    s: 0.14s;
    ms: 1ms;
  }
  ~~~

##### Frequency

- `Hz`, `kHz`

  ~~~ lay
  #khz {
    khz: 1kHz.convert(kHz)
    hz: 1kHz.convert(Hz)
    hz: 0.078kHz.convert(Hz)
  }
  ~~~

  ~~~ css
  #khz {
    khz: 1kHz;
    hz: 1000Hz;
    hz: 78Hz;
  }
  ~~~

##### Angle

- `deg` -> `rad`, `turn`, `grad`

  ~~~ lay
  #deg {
    deg:  1deg.convert(deg)
    rad:  1deg.convert(rad),
          180deg.convert(rad),
          720deg.convert(rad)
    turn: 1deg.convert(turn),
          180deg.convert(turn),
          720deg.convert(turn)
    grad: 1deg.convert(grad),
          180deg.convert(grad),
          720deg.convert(grad)
  }
  ~~~

  ~~~ css
  #deg {
    deg: 1deg;
    rad: 0.02rad, 3.14rad, 12.57rad;
    turn: 0, 0.5turn, 2turn;
    grad: 1.11grad, 200grad, 800grad;
  }
  ~~~

- `rad` -> `deg`, `turn`, `grad`

  ~~~ lay
  PI = 3.141592653589793

  #rad {
    deg:  1rad.convert(deg),
          (PI)rad.convert(deg),
          (4 * PI)rad.convert(deg)
    rad:  1rad.convert(rad)
    turn: 1rad.convert(turn),
          (PI)rad.convert(turn),
          (4 * PI)rad.convert(turn)
    grad: 1rad.convert(grad),
          (PI)rad.convert(grad),
          (4 * PI)rad.convert(grad)
  }
  ~~~

  ~~~ css
  #rad {
    deg: 57.3deg, 180deg, 720deg;
    rad: 1rad;
    turn: 0.16turn, 0.5turn, 2turn;
    grad: 63.66grad, 200grad, 800grad;
  }
  ~~~

- `turn` -> `deg`, `rad`, `grad`

  ~~~ lay
  #turn {
    deg:  1turn.convert(deg),
          .25turn.convert(deg),
          2turn.convert(deg)
    rad:  1turn.convert(rad),
          .25turn.convert(rad),
          2turn.convert(rad)
    turn: 1turn.convert(turn)
    grad: 1turn.convert(grad),
          .25turn.convert(grad),
          2turn.convert(grad)
  }
  ~~~

  ~~~ css
  #turn {
    deg: 360deg, 90deg, 720deg;
    rad: 6.28rad, 1.57rad, 12.57rad;
    turn: 1turn;
    grad: 400grad, 100grad, 800grad;
  }
  ~~~

- `grad` -> `deg`, `rad`, `turn`

  ~~~ lay
  #grad {
    deg:  1grad.convert(deg),
          50grad.convert(deg),
          600grad.convert(deg)
    rad:  1grad.convert(rad),
          50grad.convert(rad),
          600grad.convert(rad)
    turn: 1grad.convert(turn),
          100grad.convert(turn),
          600grad.convert(turn)
    grad: 1grad.convert(grad)
  }
  ~~~

  ~~~ css
  #grad {
    deg: 0.9deg, 45deg, 540deg;
    rad: 0.02rad, 0.79rad, 9.42rad;
    turn: 0, 0.25turn, 1.5turn;
    grad: 1grad;
  }
  ~~~

##### Resolution

- `dpi` <-> `dppx` <-> `dpcm`

  ~~~ lay
  #dpi {
    dpi: 1dpi.convert(dpi)
    dppx: 1dpi.convert(dppx)
    dpcm: 1dpi.convert(dpcm)
  }

  #dppx {
    dpi:  1dppx.convert(dpi)
    dppx: 1dppx.convert(dppx)
    dpcm: 1dppx.convert(dpcm)
  }

  #dpcm {
    dpi:  1dpcm.convert(dpi)
    dppx: 1dpcm.convert(dppx)
    dpcm: 1dpcm.convert(dpcm)
  }
  ~~~

  ~~~ css
  #dpi {
    dpi: 1dpi;
    dppx: 0.01dppx;
    dpcm: 0.39dpcm;
  }

  #dppx {
    dpi: 96dpi;
    dppx: 1dppx;
    dpcm: 37.8dpcm;
  }

  #dpcm {
    dpi: 2.54dpi;
    dppx: 0.03dppx;
    dpcm: 1dpcm;
  }
  ~~~

##### User defined units

- Also work

  ~~~ lay
  1ft = 12in
  1yard = 3ft
  1m = 100cm

  foo: 1m.convert(yard)
  foo: 1yard.convert(mm)
  foo: 1ft.convert(m)

  1dm = 10cm
  1m = 10dm
  foo: 1ft.convert(m)
  foo: 1ft.convert(dm)
  ~~~

  ~~~ css
  foo: 39.37in;
  foo: 914.4mm;
  foo: 30.48cm;
  foo: 30.48cm;
  foo: 30.48cm;
  ~~~

##### Incompatible units

- Makes it fail

  ~~~ lay
  1mm + 1kHz
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  1deg + 1ms
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  1dpcm + 1cm
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  1foo + 1bar
  ~~~

  ~~~ TypeError
  ~~~

### `roman`

- Converts a number to roman notation

  ~~~ lay
  for n in 1..9 {
    `{n.roman.lower-case}`: n
  }

  for n in 1..5 {
    `{(n * 10).roman.lower-case}`: n * 10
    `{(n * 10 + 1).roman.lower-case}`: n * 10 + 1
    `{(n * 10 + 5).roman.lower-case}`: n * 10 + 5
    `{(n * 10 + 9).roman.lower-case}`: n * 10 + 9
  }

  for n in 1..10 {
    `{(n * 100).roman.lower-case}`: n * 100
  }

  for n in 2000, 3000 {
    `{n.roman.lower-case}`: n
  }
  ~~~

  ~~~ css
  i: 1;
  ii: 2;
  iii: 3;
  iv: 4;
  v: 5;
  vi: 6;
  vii: 7;
  viii: 8;
  ix: 9;
  x: 10;
  xi: 11;
  xv: 15;
  xix: 19;
  xx: 20;
  xxi: 21;
  xxv: 25;
  xxix: 29;
  xxx: 30;
  xxxi: 31;
  xxxv: 35;
  xxxix: 39;
  xl: 40;
  xli: 41;
  xlv: 45;
  xlix: 49;
  l: 50;
  li: 51;
  lv: 55;
  lix: 59;
  c: 100;
  cc: 200;
  ccc: 300;
  cd: 400;
  d: 500;
  dc: 600;
  dcc: 700;
  dccc: 800;
  cm: 900;
  m: 1000;
  mm: 2000;
  mmm: 3000;
  ~~~

- Fails for zero

  ~~~ lay
  0.roman
  ~~~

  ~~~ TypeError
  ~~~

- Fails for negative numbers

  ~~~ lay
  -2.roman
  ~~~

  ~~~ TypeError
  ~~~

- Fails for non integers

  ~~~ lay
  foo: (1.0).roman
  ~~~

  ~~~ css
  foo: I;
  ~~~

  ~~~ lay
  0.2.roman
  ~~~

  ~~~ TypeError
  ~~~

- Fails for numbers over 3000

  ~~~ lay
  foo: 3001.roman
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  foo: 3000.roman
  ~~~

  ~~~ css
  foo: MMM;
  ~~~

- Fails for non-pure numbers

  ~~~ lay
  5px.roman
  ~~~

  ~~~ TypeError
  ~~~

## Operators

### Unary

#### `+`

- Does actually nothing

  ~~~ lay
  body {
    border-width: +2
  }
  ~~~

  ~~~ css
  body {
    border-width: 2;
  }
  ~~~

- Can be nested

  ~~~ lay
  body {
    foo: ++5px
  }
  ~~~

  ~~~ css
  body {
    foo: 5px;
  }
  ~~~

#### `-`

- Negates a number

  ~~~ lay
  body {
    margin-top: -11
  }
  ~~~

  ~~~ css
  body {
    margin-top: -11;
  }
  ~~~

- Keeps the units

  ~~~ lay
  body {
    border-width: +2px
  }
  body {
    margin-top: -11%
  }
  ~~~

  ~~~ css
  body {
    border-width: 2px;
  }

  body {
    margin-top: -11%;
  }
  ~~~

- Can be used before parentheses

  ~~~ lay
  body {
    border-width: -(2px * 3)
  }
  ~~~

  ~~~ css
  body {
    border-width: -6px;
  }
  ~~~

- Can be nested

  ~~~ lay
  body {
    foo: --5px
    foo: +--3px
    foo: ---7px
    foo: --+-7px
    foo: ---+7px
    foo: +---7px
    baz: not -1
  }
  ~~~

  ~~~ css
  body {
    foo: 5px;
    foo: 3px;
    foo: -7px;
    foo: -7px;
    foo: -7px;
    foo: -7px;
    baz: false;
  }
  ~~~

- Is not recognised before an ident without parentheses or whitespace separation

  ~~~ lay
  m = 2px
  body {
    margin: - m
    margin: -(m)
    margin: --m
  }
  ~~~

  ~~~ css
  body {
    margin: -2px;
    margin: -2px;
    margin: --m;
  }
  ~~~

### Binary

#### `is`

- Returns `true` only if the right side is a number with the same value and compatible units

  ~~~ lay
  #numbers {
    i: 1px is 1px
    ii: 1 is 1px
    iii: 1px isnt 1rem
    iv: 1 isnt "1"
    v: 1px isnt (3em - 2)
    vi: 0 isnt null
    vii: 0 isnt false
    viii: 1Hz isnt 1cm
  }
  ~~~

  ~~~ css
  #numbers {
    i: true;
    ii: true;
    iii: true;
    iv: true;
    v: true;
    vi: true;
    vii: true;
    viii: true;
  }
  ~~~

- Converts units as necessary

  ~~~ lay
  PI = 3.141592653589793

  #numbers {
        i: 1cm is 10mm
       ii: 10mm is 1cm
      iii: 1turn is 360deg
       iv: 1turn is (2 * PI)rad
        v: (PI)rad is .5turn
       vi: 360deg is 1turn
      vii: 360deg is (2 * PI)rad
     viii: (PI)rad is 180deg
       ix: 1s is 1000ms
        x: 77ms is 0.077s
       xi: 1000ms is 1s
      xii: 400grad is 1turn
     xiii: 100grad is 90deg
      xiv: (PI)rad is 200grad
       xv: 1kHz is 1000Hz
      xvi: 96px is 1in
     xvii: 96px is 25.4mm
    xviii: 96px is 1in
      xix: 1in is 2.54cm
       xx: .5turn is 200grad
      xxi: 1mm is 0.24pc
  }
  ~~~

  ~~~ css
  #numbers {
    i: true;
    ii: true;
    iii: true;
    iv: true;
    v: true;
    vi: true;
    vii: true;
    viii: true;
    ix: true;
    x: true;
    xi: true;
    xii: true;
    xiii: true;
    xiv: true;
    xv: true;
    xvi: true;
    xvii: true;
    xviii: true;
    xix: true;
    xx: true;
    xxi: true;
  }
  ~~~

### `+`

- Sums numbers with compatible units

  ~~~ lay
  body {
    foo: 2 + 3
    foo: 1 + 2 + 7
    foo: 2.57 + 01.4300 + 7.00
    foo: 2px + 3
    foo: 0 + 67%
    foo: 67% + 0
    foo: 0.0 + 39
    foo: 50em + -2em
  }
  ~~~

  ~~~ css
  body {
    foo: 5;
    foo: 10;
    foo: 11;
    foo: 5px;
    foo: 67%;
    foo: 67%;
    foo: 39;
    foo: 48em;
  }
  ~~~

- Converts units as necessary

  ~~~ lay
  a: 1cm + 5mm, 5mm + 1cm
  b: 2kHz + 100Hz, 100Hz + 2kHz
  ~~~

  ~~~ css
  a: 15mm, 1.5cm;
  b: 2100Hz, 2.1kHz;
  ~~~

- Fails for incompatible units

  ~~~ lay
  1cm + 2kHz
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  foo: 32px + 10%
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  foo: 10% + 32px
  ~~~

  ~~~ TypeError
  ~~~

- Fails for non-numbers

  ~~~ lay
  1cm + #777
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  1cm + "0"
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  1cm + null
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  1cm + false
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  1cm + ()
  ~~~

  ~~~ TypeError
  ~~~

### `-`

- Substracts numbers with compatible units

  ~~~ lay
  body {
    i: 3 - 2
    ii: 3 - 2.75
    iii: (3 - 2) - 1
    iv: 2 - 3%
    v: 2% - 3%
    vi: 27twips - 0.5twips
  }
  ~~~

  ~~~ css
  body {
    i: 1;
    ii: 0.25;
    iii: 0;
    iv: -1%;
    v: -1%;
    vi: 26.5twips;
  }
  ~~~

- Converts units as necessary

  ~~~ lay
  a: 1cm - 5mm, 15mm - 1cm
  b: 2kHz - 100Hz, 3000Hz - 2kHz
  ~~~

  ~~~ css
  a: 5mm, 0.5cm;
  b: 1900Hz, 1kHz;
  ~~~

- Fails for incompatible units

  ~~~ lay
  1cm - 2W
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  foo: 50% - 102px
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  foo: 32px - 10%
  ~~~

  ~~~ TypeError
  ~~~

- Fails for non-numbers

  ~~~ lay
  1px - #777
  ~~~

  ~~~ TypeError
  ~~~

### `/`

- Divides numbers with compatible units

  ~~~ lay
  body {
    foo: 6 / 2
    foo: 18 / 9rem
  }
  ~~~

  ~~~ css
  body {
    foo: 3;
    foo: 2rem;
  }
  ~~~

- Fails for incompatible units

- Cannot divide by zero

  ~~~ lay
  17 / 0px
  ~~~

  ~~~ TypeError
  Cannot divide by 0
  ~~~

  ~~~ lay
  17 / -(0%)
  ~~~

  ~~~ TypeError
  Cannot divide by 0
  ~~~

  ~~~ lay
  0 / (1 - 1)
  ~~~

  ~~~ TypeError
  Cannot divide by 0
  ~~~

### `*`

- Multiplies numbers with compatible units

  ~~~ lay
  body {
    foo: 8 * 7
    foo: 50% * 2
    foo: 2 * 50%
    foo: 1 * -1rem
  }
  ~~~

  ~~~ css
  body {
    foo: 56;
    foo: 100%;
    foo: 100%;
    foo: -1rem;
  }
  ~~~

- Converts units as necessary

- Fails for incompatible units

### `>`, `>=`, `<` and `<=`

- Compare numbers with compatible units

  ~~~ lay
  body {
    a: 8 > 7
    b: 8 >= 7
    c: 8 < 7
    d: 8 <= 7
    e: 1 > 2
    f: 1 >= 2
    g: 1 < 2
    h: 1 <= 2
    i: 1 > 1
    j: 1 >= 1
    k: 1 < 1
    l: 1 <= 1
  }
  ~~~

  ~~~ css
  body {
    a: true;
    b: true;
    c: false;
    d: false;
    e: false;
    f: false;
    g: true;
    h: true;
    i: false;
    j: true;
    k: false;
    l: true;
  }
  ~~~

- Converts units if necessary

  ~~~ lay
  a: 1cm > 9mm, 1cm <= 9mm
  b: 10mm <= 1cm, 10mm > 1cm
  c: 1kHz < 1000Hz, 1000Hz >= 1kHz
  d: .5turn > 180deg, 200grad <= 180deg
  ~~~

  ~~~ css
  a: true, false;
  b: true, false;
  c: false, true;
  d: false, true;
  ~~~

- Fails for incompatible units
