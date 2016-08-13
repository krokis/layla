# Numbers

- Are declared with the usual decimal notation

  ~~~ lay
  number {
    foo: 5
    bar: 999
    baz: 000
  }
  ~~~

  ~~~ css
  number {
    foo: 5;
    bar: 999;
    baz: 0;
  }
  ~~~

- Can have a decimal part

  ~~~ lay
  PI = 3.14159265359

  number[decimal] {
    pi: PI
    pi: PI * 100000
  }
  ~~~

  ~~~ css
  number[decimal] {
    pi: 3.14;
    pi: 314159.27;
  }
  ~~~

- Do not need leading zeroes before the decimal point

  ~~~ lay
  number[decimal] {
    half: .50
  }
  ~~~

  ~~~ css
  number[decimal] {
    half: 0.5;
  }
  ~~~

- Can have a unit

  ~~~ lay
  number[units] {
    width: 940px
    height: 100%
    height: 101tweets
    height: 0fOOs
    height: 0%
    height: 0rem
    money: 100€
    money: 99.9£
  }
  ~~~

  ~~~ css
  number[units] {
    width: 940px;
    height: 100%;
    height: 101tweets;
    height: 0;
    height: 0;
    height: 0;
    money: 100€;
    money: 99.9£;
  }
  ~~~

- Can have both a unit and a decimal part

  ~~~ lay
  PI = 3.14159265359
  number[units][decimal] {
    width: .1%
    height: 99.9%
    pi: (PI)px
  }
  ~~~

  ~~~ css
  number[units][decimal] {
    width: 0.1%;
    height: 99.9%;
    pi: 3.14px;
  }
  ~~~

- Can be quite big

  ~~~ lay
  number[big] {
    height: 999999999999999%
  }
  ~~~

  ~~~ css
  number[big] {
    height: 999999999999999%;
  }
  ~~~

- Units may appear after parentheses for conversion

  ~~~ lay
  number::conversion {
    foo: (17/2)px
    foo: (100px)pc
    foo: ((100))em
    foo: (80cm + 20)in
    foo: (256%)``
  }
  ~~~

  ~~~ css
  number::conversion {
    foo: 8.5px;
    foo: 6.25pc;
    foo: 100em;
    foo: 39.37in;
    foo: 256;
  }
  ~~~

- Are always trueish

  ~~~ lay
  number::trueish {
    foo: 1.true? not (not (false or 0)) (-1.1).boolean
  }
  ~~~

  ~~~ css
  number::trueish {
    foo: true true true;
  }
  ~~~

## Methods

### `positive?`

- Returns `true` if the number is greater than `0`

  ~~~ lay
  number.positive {
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
  number.positive {
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
  number.negative {
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
  number.negative {
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
  number.even {
    foo: 0.even?
    foo: 2.even?
    foo: 7.even?
    foo: -10.even?
    foo: -1.even?
  }
  ~~~

  ~~~ css
  number.even {
    foo: true;
    foo: true;
    foo: false;
    foo: true;
    foo: false;
  }
  ~~~

### `odd?`

- Returns `true` if the number is not divisible by `2`

  ~~~ lay
  number.odd {
    foo: 0.odd?
    foo: 2.odd?
    foo: 7.odd?
    foo: -1.odd?
    foo: -4.odd?
  }
  ~~~

  ~~~ css
  number.odd {
    foo: false;
    foo: false;
    foo: true;
    foo: true;
    foo: false;
  }
  ~~~

### `divisible-by?`

- Checks if the number is divisible by another

  ~~~~ lay
  number.divisible-by {
    foo: 1.divisible-by?(1)
    foo: not 3.divisible-by?(2)
    foo: 3.4.divisible-by?(1.70)
    foo: 3.divisible-by?(1.5)
    foo: 4.divisible-by(-2)?
    foo: -49.divisible-by(7)?
    foo: 0.divisible-by(7)?
    foo: not 0.divisible-by(0)?
  }
  ~~~~

  ~~~~ css
  number.divisible-by {
    foo: true;
    foo: true;
    foo: true;
    foo: true;
    foo: true;
    foo: true;
    foo: true;
    foo: true;
  }
  ~~~~

- Has units in mind

  ~~~ lay
  number.divisible-by {
    i: 20cm.divisible-by(2)?
    ii: 20cm.divisible-by(2mm)?
    iii: 20cm.divisible-by(2in)?
    iv: 20cm.divisible-by(1s)?
  }
  ~~~

  ~~~ css
  number.divisible-by {
    i: true;
    ii: true;
    iii: false;
    iv: false;
  }
  ~~~

### `zero?`

- Returns `true` only if the number is exactly `0`

  ~~~ lay
  number.zero {
    foo: 0.zero?
    foo: (0.00001).zero?
    foo: (-1 * 0).zero?
    foo: .1.zero?
    foo: 0.00001.zero?
  }
  ~~~

  ~~~ css
  number.zero {
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
  number.empty {
    foo: 0.empty? -0.00001.empty? (-1 * 0).empty? .1.empty? 0.00001.empty?
  }
  ~~~

  ~~~ css
  number.empty {
    foo: true false true false false;
  }
  ~~~

### `negate`

- Negates the number

  ~~~ lay
  number.negate {
    foo: 0.negate
    foo: 1.negate
    foo: -1px.negate
    foo: (-1px * -1).negate
  }
  ~~~

  ~~~ css
  number.negate {
    foo: 0;
    foo: -1;
    foo: 1px;
    foo: -1px;
  }
  ~~~

### `positive`

- Returns a copy of the number with positive sign

  ~~~ lay
  number.positive {
    foo: 1px.positive (-2.01).positive 3.77%.positive (2 - 7)mm.positive 0.positive
  }
  ~~~

  ~~~ css
  number.positive {
    foo: 1px 2.01 3.77% 5mm 0;
  }
  ~~~

### `negative`

- Returns a copy of the number with negative sign

  ~~~ lay
  number.negative {
    foo: 1px.negative (2.01).negative -3.76%.negative (7 - 2)mm.negative 0.negative
  }
  ~~~

  ~~~ css
  number.negative {
    foo: -1px -2.01 -3.76% -5mm 0;
  }
  ~~~

### `abs`

- Is an alias of `positive`

  ~~~ lay
  number.abs {
    foo: 1px.abs (-2).abs -3%.abs (2 - 7)mm.abs 0.abs
  }
  ~~~

  ~~~ css
  number.abs {
    foo: 1px 2 3% 5mm 0;
  }
  ~~~

### `unit`

- Returns the unit of the number as an unquoted string, or `null` if the number has no unit.

  ~~~ lay
  number.unit {
    foo: 1px.unit 2.unit 3%.unit (2 + 7)mm.unit
  }
  ~~~

  ~~~ css
  number.unit {
    foo: px null % mm;
  }
  ~~~

### `unit?`

- Returns `true` if the number has a unit

  ~~~ lay
  number.unit {
    foo: 0.unit?
    foo: (24 + .3).unit?
    foo: (24px + 2).unit?
    foo: 100%.unit?
  }
  ~~~

  ~~~ css
  number.unit {
    foo: false;
    foo: false;
    foo: true;
    foo: true;
  }
  ~~~

### `pure?`

- Returns `true` if the number has no unit

  ~~~ lay
  number.pure {
    i: 0.pure?
    ii: (24 + .3).pure?
    iii: (24px + 2).pure?
    iv: 100%.pure?
    v: (22)``.pure?
    vi: (100px)` `.pure?
  }
  ~~~

  ~~~ css
  number.pure {
    i: true;
    ii: true;
    iii: false;
    iv: false;
    v: true;
    vi: true;
  }
  ~~~

### `pure`

- Returns a copy of the number without unit

  ~~~ lay
  number.pure {
    foo: 0.pure
    foo: 4px.pure
    foo: (100 + 25mm)cm.pure
  }
  ~~~

  ~~~ css
  number.pure {
    foo: 0;
    foo: 4;
    foo: 12.5;
  }
  ~~~

### `decimal?`

- Returns `true` if the number has a decimal part.

  ~~~ lay
  number.decimal {
    foo: 0.1.decimal? 0.decimal? 42.decimal? 0.00.decimal?
  }
  ~~~

  ~~~ css
  number.decimal {
    foo: true false false false;
  }
  ~~~

### `integer?`

- Returns `true` if the number has no decimal part.

  ~~~ lay
  number.integer {
    foo: 0.1.integer? 0.integer? 42.integer? 0.00.integer?
  }
  ~~~

  ~~~ css
  number.integer {
    foo: false true true true;
  }
  ~~~

### `round`

- Returns a copy of the number rounded to the closest integer

  ~~~ lay
  number.round {
    foo: 0.round 1.001.round .007.round (16/7).round()
  }
  ~~~

  ~~~ css
  number.round {
    foo: 0 1 0 2;
  }
  ~~~

- Has an optional `places` argument

  ~~~ lay
  number.round {
    foo: 0.round(99) 1.001.round(2) 3.141592653589793rad.round(6).unquoted
  }
  ~~~

  ~~~ css
  number.round {
    foo: 0 1 3.141593rad;
  }
  ~~~

### `ceil`

- Returns the smallest integer equal or greater than the number

  ~~~ lay
  a = .9
  b = 1.001

  number.ceil {
    foo: a.ceil b.ceil .5mm.ceil 2.ceil 0.ceil
  }
  ~~~

  ~~~ css
  number.ceil {
    foo: 1 2 1mm 2 0;
  }
  ~~~

### `floor`

- Returns the largest integer less than or equal to the number

  ~~~ lay
  a = .9
  b = 1.001

  number.floor {
    foo: a.floor b.floor -2.233mm.floor 2km.floor 0.floor
  }
  ~~~

  ~~~ css
  number.floor {
    foo: 0 1 -3mm 2km 0;
  }
  ~~~

### `mod`

- Returns the reminder of division of the number by another

  ~~~ lay
  number.mod {
    foo: 10px.mod(3)
    foo: 4.mod(2)
    foo: (-8%).mod(3)
    foo: 7.mod(-2)
  }
  ~~~

  ~~~ css
  number.mod {
    foo: 1px;
    foo: 0;
    foo: -2%;
    foo: 1;
  }
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
  number.pow {
    foo: 2px.pow(1)
    foo: (-7%).pow(3)
    foo: (-7%).pow(-1)
    foo: 700em.pow(0)
    foo: 0rem.pow(0)
  }
  ~~~

  ~~~ css
  number.pow {
    foo: 2px;
    foo: -343%;
    foo: -0.14%;
    foo: 1em;
    foo: 1rem;
  }
  ~~~

- Defaults to `2` when no exponent is given

  ~~~ lay
  number.pow {
    foo: 11px.pow
  }
  ~~~

  ~~~ css
  number.pow {
    foo: 121px;
  }
  ~~~

### `sq`

- Is an alias of `pow(2)`

  ~~~ lay
  number.sq {
    foo: 4.sq
  }
  ~~~

  ~~~ css
  number.sq {
    foo: 16;
  }
  ~~~

### `root`

- Calculates the n-th root of the number

  ~~~ lay
  number.root {
    foo: 27.root(3)
    foo: 121.root(2)
    foo: 279936.root(7)
    foo: 15.8.root(3)
  }
  ~~~

  ~~~ css
  number.root {
    foo: 3;
    foo: 11;
    foo: 6;
    foo: 2.51;
  }
  ~~~

- Defaults to `2` when no degree is given

  ~~~ lay
  number.root {
    foo: 121.root
    foo: 0px.root
  }
  ~~~

  ~~~ css
  number.root {
    foo: 11;
    foo: 0;
  }
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
  number.sqrt {
    foo: 81.sqrt
  }
  ~~~

  ~~~ css
  number.sqrt {
    foo: 9;
  }
  ~~~

  ~~~ lay
  (-2).sqrt
  ~~~

  ~~~ TypeError
  ~~~

### `base`

- Returns a string representation of the number in the given base

  ~~~ lay
  number.base {
    bin: 27.base(2)
    oct: 27px.base(8)
    hex: 27%.base(16).quoted
  }
  ~~~

  ~~~ css
  number.base {
    bin: 11011;
    oct: 33px;
    hex: "1b%";
  }
  ~~~

- Defaults to base `10`, returning a clone of the number

  ~~~ lay
  number.base {
    dec: 27.base
    dec: 27px.base()
  }
  ~~~

  ~~~ css
  number.base {
    dec: 27;
    dec: 27px;
  }
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

### `prime?`

- Returns `true` if the number is prime

  ~~~ lay
  number.prime {
    i: 0.prime?
    ii: 1.prime?
    iii: 2.prime?
    iv: 3.prime?
    v: 4.prime?
    vi: 5.prime?
    vii: 6.prime?
    viii: 7.prime?
    ix: 8.prime?
    x: 9.prime?
    xi: 10.prime?
    xii: -1.prime?
    xiii: -0.prime?
    xiv: 4.23.prime?
    xv: 2.00.prime?
  }
  ~~~

  ~~~ css
  number.prime {
    i: false;
    ii: false;
    iii: true;
    iv: true;
    v: false;
    vi: true;
    vii: false;
    viii: true;
    ix: false;
    x: false;
    xi: false;
    xii: false;
    xiii: false;
    xiv: false;
    xv: true;
  }
  ~~~

### `copy`

- Creates a copy of the number

  ~~~ lay
  number.copy {
    a = 12.5%.copy
    b = 27.copy
    c = 0px.copy
    a: a
    b: b
    c: c
  }
  ~~~

  ~~~ css
  number.copy {
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

  number.convert#in {
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
  number.convert#in {
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

  number.convert#cm {
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
  number.convert#cm {
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

  number.convert#mm {
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
  number.convert#mm {
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

  number.convert#pt {
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
  number.convert#pt {
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

  number.convert#pc {
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
  number.convert#pc {
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

  number.convert#q {
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
  number.convert#q {
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

  number.convert#px {
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
  number.convert#px {
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
  number.convert#s {
    s: 1s.convert(s)
    ms: 1s.convert(ms)
    ms: -.25s.convert(ms)
  }

  number.convert#ms {
    s: 1ms.convert(s)
    s: 138ms.convert(s)
    ms: 1ms.convert(ms)
  }
  ~~~

  ~~~ css
  number.convert#s {
    s: 1s;
    ms: 1000ms;
    ms: -250ms;
  }

  number.convert#ms {
    s: 0;
    s: 0.14s;
    ms: 1ms;
  }
  ~~~

##### Frequency

- `Hz`, `kHz`

  ~~~ lay
  number.convert#khz {
    khz: 1kHz.convert(kHz)
    hz: 1kHz.convert(Hz)
    hz: 0.078kHz.convert(Hz)
  }
  ~~~

  ~~~ css
  number.convert#khz {
    khz: 1kHz;
    hz: 1000Hz;
    hz: 78Hz;
  }
  ~~~

##### Angle

- `deg` -> `rad`, `turn`, `grad`

  ~~~ lay
  number.convert#deg {
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
  number.convert#deg {
    deg: 1deg;
    rad: 0.02rad, 3.14rad, 12.57rad;
    turn: 0, 0.5turn, 2turn;
    grad: 1.11grad, 200grad, 800grad;
  }
  ~~~

- `rad` -> `deg`, `turn`, `grad`

  ~~~ lay
  PI = 3.141592653589793

  number.convert#rad {
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
  number.convert#rad {
    deg: 57.3deg, 180deg, 720deg;
    rad: 1rad;
    turn: 0.16turn, 0.5turn, 2turn;
    grad: 63.66grad, 200grad, 800grad;
  }
  ~~~

- `turn` -> `deg`, `rad`, `grad`

  ~~~ lay
  number.convert#turn {
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
  number.convert#turn {
    deg: 360deg, 90deg, 720deg;
    rad: 6.28rad, 1.57rad, 12.57rad;
    turn: 1turn;
    grad: 400grad, 100grad, 800grad;
  }
  ~~~

- `grad` -> `deg`, `rad`, `turn`

  ~~~ lay
  number.convert#grad {
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
  number.convert#grad {
    deg: 0.9deg, 45deg, 540deg;
    rad: 0.02rad, 0.79rad, 9.42rad;
    turn: 0, 0.25turn, 1.5turn;
    grad: 1grad;
  }
  ~~~

##### Resolution

- `dpi` <-> `dppx` <-> `dpcm`

  ~~~ lay
  number.convert#dpi {
    dpi: 1dpi.convert(dpi)
    dppx: 1dpi.convert(dppx)
    dpcm: 1dpi.convert(dpcm)
  }

  number.convert#dppx {
    dpi:  1dppx.convert(dpi)
    dppx: 1dppx.convert(dppx)
    dpcm: 1dppx.convert(dpcm)
  }

  number.convert#dpcm {
    dpi:  1dpcm.convert(dpi)
    dppx: 1dpcm.convert(dppx)
    dpcm: 1dpcm.convert(dpcm)
  }
  ~~~

  ~~~ css
  number.convert#dpi {
    dpi: 1dpi;
    dppx: 0.01dppx;
    dpcm: 0.39dpcm;
  }

  number.convert#dppx {
    dpi: 96dpi;
    dppx: 1dppx;
    dpcm: 37.8dpcm;
  }

  number.convert#dpcm {
    dpi: 2.54dpi;
    dppx: 0.03dppx;
    dpcm: 1dpcm;
  }
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
  number.roman {
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
  }
  ~~~

  ~~~ css
  number.roman {
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
  }
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
  number.roman {
    foo: (1.0).roman
  }
  ~~~

  ~~~ css
  number.roman {
    foo: I;
  }
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
  number.roman {
    foo: 3000.roman
  }
  ~~~

  ~~~ css
  number.roman {
    foo: MMM;
  }
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
  number[op="+@"] {
    border-width: +2
  }
  ~~~

  ~~~ css
  number[op="+@"] {
    border-width: 2;
  }
  ~~~

- Can be nested

  ~~~ lay
  number[op="+@"] {
    foo: ++5px
  }
  ~~~

  ~~~ css
  number[op="+@"] {
    foo: 5px;
  }
  ~~~

#### `-`

- Negates a number

  ~~~ lay
  number[op="-@"] {
    margin-top: -11
  }
  ~~~

  ~~~ css
  number[op="-@"] {
    margin-top: -11;
  }
  ~~~

- Keeps the units

  ~~~ lay
  number[op="-@"] {
    border-width: +2px
  }
  number[op="-@"] {
    margin-top: -11%
  }
  ~~~

  ~~~ css
  number[op="-@"] {
    border-width: 2px;
  }

  number[op="-@"] {
    margin-top: -11%;
  }
  ~~~

- Can be used before parentheses

  ~~~ lay
  number[op="-@"] {
    border-width: -(2px * 3)
  }
  ~~~

  ~~~ css
  number[op="-@"] {
    border-width: -6px;
  }
  ~~~

- Can be nested

  ~~~ lay
  number[op="-@"] {
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
  number[op="-@"] {
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
  number[op="-@"] {
    margin: - m
    margin: -(m)
    margin: --m
  }
  ~~~

  ~~~ css
  number[op="-@"] {
    margin: -2px;
    margin: -2px;
    margin: --m;
  }
  ~~~

### Binary

#### `is`

- Returns `true` only if the right side is a number with the same value and compatible units

  ~~~ lay
  number[op="is"] {
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
  number[op="is"] {
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

  number[op="is"] {
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
  number[op="is"] {
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

#### `+`

- Sums numbers with compatible units

  ~~~ lay
  number[op="+"] {
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
  number[op="+"] {
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
  number[op="+"] {
    a: 1cm + 5mm, 5mm + 1cm
    b: 2kHz + 100Hz, 100Hz + 2kHz
  }
  ~~~

  ~~~ css
  number[op="+"] {
    a: 15mm, 1.5cm;
    b: 2100Hz, 2.1kHz;
  }
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

#### `-`

- Substracts numbers with compatible units

  ~~~ lay
  number[op="-"] {
    i: 3 - 2
    ii: 3 - 2.75
    iii: (3 - 2) - 1
    iv: 2 - 3%
    v: 2% - 3%
    vi: 27twips - 0.5twips
  }
  ~~~

  ~~~ css
  number[op="-"] {
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
  number[op="-"] {
    a: 1cm - 5mm, 15mm - 1cm
    b: 2kHz - 100Hz, 3000Hz - 2kHz
  }
  ~~~

  ~~~ css
  number[op="-"] {
    a: 5mm, 0.5cm;
    b: 1900Hz, 1kHz;
  }
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

#### `/`

- Divides numbers with compatible units

  ~~~ lay
  number[op="/"] {
    foo: 6 / 2
    foo: 18 / 9rem
  }
  ~~~

  ~~~ css
  number[op="/"] {
    foo: 3;
    foo: 2rem;
  }
  ~~~

- Fails for incompatible units

  ~~~ lay
  number[op="/"] {
    i: 2px / 4s
  }
  ~~~

  ~~~ TypeError
  ~~~

- Returns a pure number when both dividend and divisor are dimensions

  ~~~ lay
  number[op="/"] {
    i: 125px / 25px
    ii: 1cm / 10mm
    iii: 5in / 3px
  }
  ~~~

  ~~~ css
  number[op="/"] {
    i: 5;
    ii: 1;
    iii: 160;
  }
  ~~~

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

#### `*`

- Multiplies numbers with compatible units

  ~~~ lay
  number[op="*"] {
    foo: 8 * 7
    foo: 50% * 2
    foo: 2 * 50%
    foo: 1 * -1rem
  }
  ~~~

  ~~~ css
  number[op="*"] {
    foo: 56;
    foo: 100%;
    foo: 100%;
    foo: -1rem;
  }
  ~~~

- Fails when both factors are dimensions

  ~~~ lay
  number[op="*"] {
    foo: 8px * 8px
  }
  ~~~

  ~~~ TypeError
  ~~~

#### `>`, `>=`, `<` and `<=`

- Compare numbers with compatible units

  ~~~ lay
  number[comparations] {
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
  number[comparations] {
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
  number[comparations] {
    a: 1cm > 9mm, 1cm <= 9mm
    b: 10mm <= 1cm, 10mm > 1cm
    c: 1kHz < 1000Hz, 1000Hz >= 1kHz
    d: .5turn > 180deg, 200grad <= 180deg
  }
  ~~~

  ~~~ css
  number[comparations] {
    a: true, false;
    b: true, false;
    c: false, true;
    d: false, true;
  }
  ~~~

- Fails for incompatible units

  ~~~ lay
  foo: 8px > 7s
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  foo: 2cm >= 1dpi
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  foo: 1Hz < 4mm
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  foo: 360deg <= 4in
  ~~~

  ~~~ TypeError
  ~~~
