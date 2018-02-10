`calc()`
========

- Is supported

  ~~~ lay
  calc {
    i: calc(10% + 20px)
    ii: calc(  100em
     -
     1px
   )
   iii: calc(
    100%
    - 20px


  )}
  ~~~

  ~~~ css
  calc {
    i: calc(10% + 20px);
    ii: calc(100em - 1px);
    iii: calc(100% - 20px);
  }
  ~~~

- Supports `+`, `-`, `*` and `/` binary operations

  ~~~ lay
  calc {
    i: calc(10% + 20px)
    ii: calc(10rem - 20%)
    iii: calc(
      50% / 2 + 77px
    )
    iv: calc(2*2*50mm)
  }
  ~~~

  ~~~ css
  calc {
    i: calc(10% + 20px);
    ii: calc(10rem - 20%);
    iii: calc(50% / 2 + 77px);
    iv: calc(2 * 2 * 50mm);
  }
  ~~~

- Supports `+` and `-` unary operations

  ~~~ lay
  calc[unary] {
    i: calc(2px * (-1%))
  }
  ~~~

  ~~~ css
  calc[unary] {
    i: calc(2px * -1%);
  }
  ~~~

- Supports decimal numbers

  ~~~ lay
  calc {
    i: calc(10% + 20px - .75mm * 999.99q)
  }
  ~~~

  ~~~ css
  calc {
    i: calc(10% + 20px - 0.75mm * 999.99q);
  }
  ~~~

- Supports parentheses

  ~~~ lay
  calc {
    i: calc((2 + 3) * (1 + 4))
  }
  ~~~

  ~~~ css
  calc {
    i: calc((2 + 3) * (1 + 4));
  }
  ~~~

- Removes unnecessary parentheses

  ~~~ lay
  calc {
    i: calc(((2))+(3*(8)))
  }
  ~~~

  ~~~ css
  calc {
    i: calc(2 + 3 * 8);
  }
  ~~~

- Evaluates variables

  ~~~ lay
  calc[variables] {
    $half = 50%
    i: calc(1024px- $half)
  }
  ~~~

  ~~~ css
  calc[variables] {
    i: calc(1024px - 50%);
  }
  ~~~

- Supports interpolation

  ~~~ lay
  calc[interpolation] {
    i: calc(2px + #{2em - 1.5em})
  }
  ~~~

  ~~~ css
  calc[interpolation] {
    i: calc(2px + 0.5em);
  }
  ~~~

- Can be nested

  ~~~ lay
  calc[nested] {
    i: calc(  calc(2.25rem+2px) - 1px * 2)
    ii: calc(4rem * calc( 15em - 12% ))
    $c = calc(20px + 10%)
    iii: calc($c/2px)
  }
  ~~~

  ~~~ css
  calc[nested] {
    i: calc(2.25rem + 2px - 1px * 2);
    ii: calc(4rem * (15em - 12%));
    iii: calc((20px + 10%) / 2px);
  }
  ~~~

- Can be `-vendor-` prefixed

  ~~~ lay
  calc {
    $foo = 20px

    i: -ie-calc(10% + $foo)
    ii: -webkit-calc(10% + $foo)
    iii: -moz-calc(10% + $foo)
    iv: -ms-calc(10% + $foo)
    v: --foo-bar-calc(10% + $foo)
  }
  ~~~

  ~~~ css
  calc {
    i: -ie-calc(10% + 20px);
    ii: -webkit-calc(10% + 20px);
    iii: -moz-calc(10% + 20px);
    iv: -ms-calc(10% + 20px);
    v: --foo-bar-calc(10% + 20px);
  }
  ~~~

- Fails for invalid tokens

  ~~~ lay
  calc(1px { + 4%)
  ~~~

  ~~~ SyntaxError
  ~~~

  ~~~ lay
  calc(1px - this-is-an-unquoted-string)
  ~~~

  ~~~ ValueError
  ~~~

## Methods

### Operators

#### `+@`

- Returns a copy of the `Calc`

  ~~~ lay
  calc[operator="-@"] {
    i: +(calc(2px + 100%))
  }
  ~~~

  ~~~ css
  calc[operator="-@"] {
    i: calc(2px + 100%);
  }
  ~~~

#### `-@`

- Negates the `Calc`

  ~~~ lay
  calc[operator="-@"] {
    i: -(calc(2px + 100%))
  }
  ~~~

  ~~~ css
  calc[operator="-@"] {
    i: calc(-(2px + 100%));
  }
  ~~~

#### `+`

- Returns the `Calc` resulting from adding right `Calc` to left `Calc`

  ~~~ lay
  calc[operator='+'] {
    i: calc(1px) + calc(1%)
  }
  ~~~

  ~~~ css
  calc[operator="+"] {
    i: calc(1px + 1%);
  }
  ~~~

- Returns the `Calc` resulting from adding right `Number` to left `Calc`

  ~~~ lay
  calc[operator='+'] {
    i: calc(1px) + 1%
  }
  ~~~

  ~~~ css
  calc[operator="+"] {
    i: calc(1px + 1%);
  }
  ~~~

#### `-`

- Returns the `Calc` resulting from substracting right `Calc` to left `Calc`

  ~~~ lay
  calc[operator='-'] {
    i: calc(1px) - calc(1%)
  }
  ~~~

  ~~~ css
  calc[operator="-"] {
    i: calc(1px - 1%);
  }
  ~~~

- Returns the `Calc` resulting from substracting right `Number` to left `Calc`

  ~~~ lay
  calc[operator='-'] {
    i: calc(1px) - 1%
  }
  ~~~

  ~~~ css
  calc[operator="-"] {
    i: calc(1px - 1%);
  }
  ~~~

#### `*`

- Returns the `Calc` resulting from multiplying the `Calc` with another `Calc`

  ~~~ lay
  calc[operator='*'] {
    i: calc(1px) * calc(1%)
  }
  ~~~

  ~~~ css
  calc[operator="*"] {
    i: calc(1px * 1%);
  }
  ~~~

- Returns the `Calc` resulting from multiplying the `Calc` with a `Number`

  ~~~ lay
  calc[operator='*'] {
    i: calc(1px) * 1%
  }
  ~~~

  ~~~ css
  calc[operator="*"] {
    i: calc(1px * 1%);
  }
  ~~~

#### `/`

- Returns the `Calc` resulting from dividing the `Calc` by another `Calc`

  ~~~ lay
  calc[operator='/'] {
    i: calc(1px) / calc(1%)
  }
  ~~~

  ~~~ css
  calc[operator="/"] {
    i: calc(1px / 1%);
  }
  ~~~

- Returns the `Calc` resulting from dividing the `Calc` by a `Number`

  ~~~ lay
  calc[operator='/'] {
    i: calc(1px) / 1%
  }
  ~~~

  ~~~ css
  calc[operator="/"] {
    i: calc(1px / 1%);
  }
  ~~~
