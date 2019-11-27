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
    i: 5..(7px)
    ii: 1%..10
    iii: 1em..1em
    iv: -1rem..0
    v: 1mm..1cm
  }
  ~~~

  ~~~ css
  range[unit] {
    i: 5px 6px 7px;
    ii: 1% 2% 3% 4% 5% 6% 7% 8% 9% 10%;
    iii: 1em;
    iv: -1rem 0;
    v: 1mm 2mm 3mm 4mm 5mm 6mm 7mm 8mm 9mm 10mm;
  }
  ~~~

- Fail for incompatible units

  ~~~ lay
  1px..2s
  ~~~

  ~~~ ValueError
  ~~~

- Can be casted to any unit when they're pure

  ~~~ lay
  range[unit] {
    i: (1..2)px
    ii: (0..1)%
  }
  ~~~

  ~~~ css
  range[unit] {
    i: 1px 2px;
    ii: 0 1%;
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
    $r = $r / 3
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

#### `contains?`

- Tells if a number is in the range

  ~~~ lay
  $r = 1..2

  range.contains {
    i: $r.contains?(1)
    ii: $r.contains?(2)
    iii: not $r.contains?(3)
    iv: not $r.contains?(0)
    $r = 2..-1
    v: $r.contains?(1)
    vi: $r.contains?(-1)
    vii: $r.contains?(2)
    viii: $r.contains?(-2)
    ix: $r.contains?(3)
    x: $r.contains?(0)
  }
  ~~~

  ~~~ css
  range.contains {
    i: true;
    ii: true;
    iii: true;
    iv: true;
    v: true;
    vi: true;
    vii: true;
    viii: false;
    ix: false;
    x: true;
  }
  ~~~

- Checks units

  ~~~ lay
  range.contains {
    $r = 1..2px
    i: $r.contains?(1)
    ii: $r.contains?(2px)
    iii: not $r.contains?(2rm)
    iv: not $r.contains?(1%)
  }
  ~~~

  ~~~ css
  range.contains {
    i: true;
    ii: true;
    iii: true;
    iv: true;
  }
  ~~~

  ~~~ lay
  $r = 0..30mm

  range.contains {
    i: $r.contains?(2mm)
    ii: $r.contains?(3cm)
  }
  ~~~

  ~~~ css
  range.contains {
    i: true;
    ii: true;
  }
  ~~~

### Operators

#### `/`

- Makes a copy of the range with a different `step`

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
    i: (1..5).min
    ii: (-5..0).min
    iii: (5..-1).min
  }
  ~~~

  ~~~ css
  range.min {
    i: 1;
    ii: -5;
    iii: -1;
  }
  ~~~

- Works with units

  ~~~ lay
  range.min {
    i: (1cm..50mm).min
    ii: (50mm..0.2cm).min
  }
  ~~~

  ~~~ css
  range.min {
    i: 1cm;
    ii: 2mm;
  }
  ~~~

### `max`

- Returns the maximum value in the range

  ~~~ lay
  range.min {
    i: (1..5).max
    ii: (-5..0).max
    iii: (5..-1).max
  }
  ~~~

  ~~~ css
  range.min {
    i: 5;
    ii: 0;
    iii: 5;
  }
  ~~~

- Works with units

  ~~~ lay
  range.min {
    i: (1cm..50mm).max
    ii: (50mm..0.2cm).max
  }
  ~~~

  ~~~ css
  range.min {
    i: 5cm;
    ii: 50mm;
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
