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

- May have a `resolution`

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

#### `+`

- Combines two ranges

#### `-`

- Substracts a range

#### `*`, `/`

- Make ranges with a different resolution

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
