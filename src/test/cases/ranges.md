Ranges
======

- Are made with the `..` operator between two numbers

  ~~~ lay
  range {
    foo: 1..3
    foo: 0..(1 + 1)
    foo: -1..1
    foo: ((2 - 1 * 1)..(17 / 2 - .5 - 7))
  }
  ~~~

  ~~~ css
  range {
    foo: 1 2 3;
    foo: 0 1 2;
    foo: -1 0 1;
    foo: 1;
  }
  ~~~

- Can be reverse

  ~~~ lay
  range[reverse] {
    bar: 3..0
    $baz = 999..-999
    baz: $baz.first $baz.last
  }
  ~~~

  ~~~ css
  range[reverse] {
    bar: 3 2 1 0;
    baz: 999 -999;
  }
  ~~~

- Decimals are allowed

  ~~~ lay
  range[decimal] {
    foo: (.9)..1.99
    foo: (-.75)..(3.2501)
  }
  ~~~

  ~~~ css
  range[decimal] {
    foo: 0.9 1.9;
    foo: -0.75 0.25 1.25 2.25 3.25;
  }
  ~~~

- May have units

  ~~~ lay
  range[unit] {
    foo: 5..(7px)
    foo: 1%..10
    foo: 1em..1em
    foo: -1rem..0
    foo: 1mm..1cm
  }
  ~~~

  ~~~ css
  range[unit] {
    foo: 5px 6px 7px;
    foo: 1% 2% 3% 4% 5% 6% 7% 8% 9% 10%;
    foo: 1em;
    foo: -1rem 0;
    foo: 1mm 2mm 3mm 4mm 5mm 6mm 7mm 8mm 9mm 10mm;
  }
  ~~~

- Converts units of added objects as necessary

  ~~~ lay
  $r = 1..5mm

  range[unit] {
    foo: $r
    foo: $r << 1cm
    foo: $r << .5in
  }
  ~~~

  ~~~ css
  range[unit] {
    foo: 1mm 2mm 3mm 4mm 5mm;
    foo: 1mm 2mm 3mm 4mm 5mm 6mm 7mm 8mm 9mm 10mm;
    foo: 1mm 2mm 3mm 4mm 5mm 6mm 7mm 8mm 9mm 10mm 11mm 12mm;
  }
  ~~~

- Fail for incompatible units

- Can be casted to any unit when they're pure

  ~~~ lay
  range[unit] {
    foo: (1..2)px
    foo: (0..1)%
  }
  ~~~

  ~~~ css
  range[unit] {
    foo: 1px 2px;
    foo: 0 1%;
  }
  ~~~

- Can be converted to another unit

  ~~~ lay
  range[unit] {
    i: (1..2cm)mm
  }
  ~~~

  ~~~ css
  range[unit] {
    i: 10mm 20mm;
  }
  ~~~

- May have a `step` different than `1`

  ~~~ lay
  range[step] {
    $r = 0..10
    i: $r
    ii: ($r / 2).list.commas
    $r.step = 3
    iii: $r
    $r = 1..-1cm
    iv: $r
    v: $r / 5mm
  }
  ~~~

  ~~~ css
  range[step] {
    i: 0 1 2 3 4 5 6 7 8 9 10;
    ii: 0, 2, 4, 6, 8, 10;
    iii: 0 3 6 9;
    iv: 1cm 0 -1cm;
    v: 1cm 0.5cm 0 -0.5cm -1cm;
  }
  ~~~

## Methods

### Operators

#### `has`, `in`

- Tells if a number is in the range

  ~~~ lay
  r = 1..2

  range.has, range.in {
    foo: r has 1
    foo: 2 in r
    foo: r hasnt 3
    foo: not 0 in r
    r = 2..-1
    bar: r has 1
    bar: r has -1
    bar: r has 2
    bar: r has -2
    bar: r has 3
    bar: r has 0
  }
  ~~~

  ~~~ css
  range.has,
  range.in {
    foo: true;
    foo: true;
    foo: true;
    foo: true;
    bar: true;
    bar: true;
    bar: true;
    bar: false;
    bar: false;
    bar: true;
  }
  ~~~

- Checks units

  ~~~ lay
  range.has, range.in {
    $r = 1..2px
    foo: 1 in $r
    foo: 2px in $r
    foo: $r hasnt 2rm
    foo: not 1% in $r
  }
  ~~~

  ~~~ css
  range.has,
  range.in {
    foo: true;
    foo: true;
    foo: true;
    foo: true;
  }
  ~~~

  ~~~ lay
  $r = 0..30mm

  range.has, range.in {
    foo: 2mm in $r
    foo: 3cm in $r
  }
  ~~~

  ~~~ css
  range.has,
  range.in {
    foo: true;
    foo: true;
  }
  ~~~

#### `/`

- Make a copy of the range with a different `step`

  ~~~ lay
  range[op="/"] {
    i: (1..5) / 2
    ii: (1..-1)mm / 1px
  }
  ~~~

  ~~~ css
  range[op="/"] {
    i: 1 3 5;
    ii: 1mm 0.74mm 0.47mm 0.21mm -0.06mm -0.32mm -0.59mm -0.85mm;
  }
  ~~~

#### `<<` and `>>`

- Extend a range with a number

  ~~~ lay
  range[op="<<"], range[op=">>"] {
    $r = 1..3
    foo: $r
    2 >> $r
    foo: $r
    0 >> $r
    foo: $r
    $r << 5
    foo: $r
  }
  ~~~

  ~~~ css
  range[op="<<"],
  range[op=">>"] {
    foo: 1 2 3;
    foo: 1 2 3;
    foo: 0 1 2 3;
    foo: 0 1 2 3 4 5;
  }
  ~~~

- Adds units to pure ranges when a dimension is passed

  ~~~ lay
  range[op="<<"], range[op=">>"] {
    foo: 1..3 << 1px
    foo: 0 >> 1..3 << 4% << 5
  }
  ~~~

  ~~~ css
  range[op="<<"],
  range[op=">>"] {
    foo: 1px 2px 3px;
    foo: 0 1% 2% 3% 4% 5%;
  }
  ~~~

- Check units are compatible

- Always return the receiver

  ~~~ lay
  range[op="<<"], range[op=">>"] {
    foo: (1..3) << 1px
    foo: 1px >> 1..3
  }
  ~~~

  ~~~ css
  range[op="<<"],
  range[op=">>"] {
    foo: 1px 2px 3px;
    foo: 1px 2px 3px;
  }
  ~~~

### `unit`

- Returns the range unit or `null` if it's pure

  ~~~ lay
  range.unit {
    i: (1..2).unit
    ii: (1..2px).unit
    iii: (1cm..10)``.unit
  }
  ~~~

  ~~~ css
  range.unit {
    i: null;
    ii: px;
    iii: null;
  }
  ~~~

### `unit?`

- Returns `true` if the range has a unit

  ~~~ lay
  range.unit {
    i: (1..2).unit?
    ii: (1..2px).unit?
    iii: (1cm..10)``.unit?
    iv: (0..5)mm.unit?
  }
  ~~~

  ~~~ css
  range.unit {
    i: false;
    ii: true;
    iii: false;
    iv: true;
  }
  ~~~

### `pure?`

- Returns `true` if the range has no units

  ~~~ lay
  range.pure {
    i: (1..2).pure?
    ii: (1..2px).pure?
    iii: (1cm..10)``.pure?
    iv: (0..5)mm.pure?
  }
  ~~~

  ~~~ css
  range.pure {
    i: true;
    ii: false;
    iii: true;
    iv: false;
  }
  ~~~

### `pure`

- Returns a copy of the range without units

  ~~~ lay
  range.pure {
    i: (1..2).pure
    ii: (1..2px).pure
    iii: (1cm..10)``.pure
    iv: (0..5)mm.pure
  }
  ~~~

  ~~~ css
  range.pure {
    i: 1 2;
    ii: 1 2;
    iii: 1 2 3 4 5 6 7 8 9 10;
    iv: 0 1 2 3 4 5;
  }
  ~~~

### `min`

- Returns the minimum value in the range

  ~~~ lay
  range.min {
    foo: (1..5).min
    bar: (-5..0).min
    baz: (5..-1).min
  }
  ~~~

  ~~~ css
  range.min {
    foo: 1;
    bar: -5;
    baz: -1;
  }
  ~~~

### `reverse?`

- Returns `true` if the range is reversed.

  ~~~ lay
  range.reverse {
    foo: (1..5).reverse?
    foo: (-1..5).reverse?
    foo: (-1..-5).reverse?
    foo: (0..0).reverse?
  }
  ~~~

  ~~~ css
  range.reverse {
    foo: false;
    foo: false;
    foo: true;
    foo: false;
  }
  ~~~

### `reverse`

- Reverses a range

  ~~~ lay
  range.reverse {
    foo: (1..5).reverse
    foo: (-1..5).reverse
    foo: (-1..-5).reverse
    foo: (0..0).reverse
  }
  ~~~

  ~~~ css
  range.reverse {
    foo: 5 4 3 2 1;
    foo: 5 4 3 2 1 0 -1;
    foo: -5 -4 -3 -2 -1;
    foo: 0;
  }
  ~~~
