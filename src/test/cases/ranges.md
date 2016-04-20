Ranges
======

- Are made with the `..` operator between two numbers

  ~~~ lay
  foo: 1..3
  foo: 0..(1 + 1)
  foo: -1..1
  foo: ((2 - 1 * 1)..(17 / 2 - .5 - 7))
  ~~~

  ~~~ css
  foo: 1 2 3;
  foo: 0 1 2;
  foo: -1 0 1;
  foo: 1;
  ~~~

- Can be reverse

  ~~~ lay
  #foo {
    bar: 3..0
    $baz = 999..-999
    baz: $baz.first $baz.last
  }
  ~~~

  ~~~ css
  #foo {
    bar: 3 2 1 0;
    baz: 999 -999;
  }
  ~~~

- Decimals are floored

  ~~~ lay
  foo: (.9)..1.99
  foo: (-.75)..(1.0001)
  ~~~

  ~~~ css
  foo: 0 1;
  foo: -1 0 1;
  ~~~

- May have units

  ~~~ lay
  body {
    foo: 5..(7px)
    foo: 1%..10
    foo: 1em..1em
    foo: -1rem..0
    foo: 1mm..1cm
  }
  ~~~

  ~~~ css
  body {
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
  foo: $r
  foo: $r << 1cm
  foo: $r << .5in
  ~~~

  ~~~ css
  foo: 1mm 2mm 3mm 4mm 5mm;
  foo: 1mm 2mm 3mm 4mm 5mm 6mm 7mm 8mm 9mm 10mm;
  foo: 1mm 2mm 3mm 4mm 5mm 6mm 7mm 8mm 9mm 10mm 11mm 12mm;
  ~~~

- Fail for incompatible units

- Can be casted to any unit when they're pure

  ~~~ lay
  #foo {
    foo: (1..2)px
    foo: (0..1)%
  }
  ~~~

  ~~~ css
  #foo {
    foo: 1px 2px;
    foo: 0 1%;
  }
  ~~~

- Can be converted to another unit

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
  ~~~

  ~~~ css
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
  ~~~

- Checks units

  ~~~ lay
  r = 1..2px
  foo: 1 in r
  foo: 2px in r
  foo: r hasnt 2rm
  foo: not 1% in r
  ~~~

  ~~~ css
  foo: true;
  foo: true;
  foo: true;
  foo: true;
  ~~~

  ~~~ lay
  $r = 0..30mm

  foo: 2mm in $r
  foo: 3cm in $r
  ~~~

  ~~~ css
  foo: true;
  foo: true;
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
  body {
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
  body {
    foo: 1 2 3;
    foo: 1 2 3;
    foo: 0 1 2 3;
    foo: 0 1 2 3 4 5;
  }
  ~~~

- Adds units to pure ranges when a dimension is passed

  ~~~ lay
  .foo {
    foo: 1..3 << 1px
    foo: 0 >> 1..3 << 4% << 5
  }
  ~~~

  ~~~ css
  .foo {
    foo: 1px 2px 3px;
    foo: 0 1% 2% 3% 4% 5%;
  }
  ~~~

- Check units are compatible

- Always return the receiver

  ~~~ lay
  .foo {
    foo: (1..3) << 1px
    foo: 1px >> 1..3
  }
  ~~~

  ~~~ css
  .foo {
    foo: 1px 2px 3px;
    foo: 1px 2px 3px;
  }
  ~~~

### `min`

- Returns the minimum value in the range

  ~~~ lay
  foo: (1..5).min
  bar: (-5..0).min
  baz: (5..-1).min
  ~~~

  ~~~ css
  foo: 1;
  bar: -5;
  baz: -1;
  ~~~

### `reverse?`

- Returns `true` if the range is reversed.

  ~~~ lay
  foo: (1..5).reverse?
  foo: (-1..5).reverse?
  foo: (-1..-5).reverse?
  foo: (0..0).reverse?
  ~~~

  ~~~ css
  foo: false;
  foo: false;
  foo: true;
  foo: false;
  ~~~

### `reverse`

- Reverses a range

  ~~~ lay
  foo: (1..5).reverse
  foo: (-1..5).reverse
  foo: (-1..-5).reverse
  foo: (0..0).reverse
  ~~~

  ~~~ css
  foo: 5 4 3 2 1;
  foo: 5 4 3 2 1 0 -1;
  foo: -5 -4 -3 -2 -1;
  foo: 0;
  ~~~
