Operator precedence
===================

## Unary `+` and `-`

- Have the highest precedence

  ~~~ lay
  foo: -2.negative?
  ~~~

  ~~~ css
  foo: true;
  ~~~

  ~~~ lay
  foo: +'a'.length
  ~~~

  ~~~ !TypeError
  ~~~

  ~~~ lay
  foo: +('a'.length)
  ~~~

  ~~~ css
  foo: 1;
  ~~~

## `.`, `::` and `()`

- Have precedence over `*` and `/`

  ~~~ lay
  a = 2
  b = (3,)

  body {
    foo: a * b::0
    foo: a * "oh".length
  }
  ~~~

  ~~~ css
  body {
    foo: 6;
    foo: 4;
  }
  ~~~

- Have left associativity

  ~~~ lay
  a = ((1 2) (3 4))

  foo {
    bar: (a::0)::0
    bar: a::0::0
  }
  ~~~

  ~~~ css
  foo {
    bar: 1;
    bar: 1;
  }
  ~~~

## `*` and `/`

- Have precedence over `+` and `-`

  ~~~ lay
  body {
    foo: 24 / 2 + 1
    bar: 11px - 10 / 5
    baz: 'na' * 3 + '...'
  }

  body {
    foo: 3 + 4 * 5
    bar: 7 - 2 * 3 + 3
  }
  ~~~

  ~~~ css
  body {
    foo: 13;
    bar: 9px;
    baz: 'nanana...';
  }

  body {
    foo: 23;
    bar: 4;
  }
  ~~~

- Have left associativity

  ~~~ lay
  left: (20 / 7) / 3
  right: 20 / (7 / 3)
  actual: 20 / 7 / 3
  ~~~

  ~~~ css
  left: 0.95;
  right: 8.57;
  actual: 0.95;
  ~~~

## `+` and `-`

- Have precedence over `.`

  ~~~ lay
  body {
    foo: 0..1 + 1
  }
  ~~~

  ~~~ css
  body {
    foo: 0 1 2;
  }
  ~~~

- Have precedence over `>`, `>=`, `<` and `<=`

  ~~~ lay
  body {
    foo: 2 + 2 > 2
    foo: 2 + 2 < 2
    foo: 2 + 2 >= 1
    foo: 2 + 1 <= 3
  }
  ~~~

  ~~~ css
  body {
    foo: true;
    foo: false;
    foo: true;
    foo: true;
  }
  ~~~

- Have left associativity

  ~~~ lay
  left: (15 - 7) - 11
  right: 15 - (7 - 11)
  actual: 15 - 7 - 11
  ~~~

  ~~~ css
  left: -3;
  right: 19;
  actual: -3;
  ~~~

## `.`

- Has precedence over `>`, `>=`, `<` and `<=`

## `>`, `>=`, `<` and `<=`

- Have precedence over `is` and `isnt`

  ~~~ lay
  body {
    foo: 3 > 2 is true
  }
  ~~~

  ~~~ css
  body {
    foo: true;
  }
  ~~~

- Have precedence over `and` and `or`

  ~~~ lay
  body {
    foo: 2 > 1 and 3 < 2
  }
  ~~~

  ~~~ css
  body {
    foo: false;
  }
  ~~~

- Have left associativity

## `is` and `isnt`

- Have precedence over `~`

- Have left associativity

## `~`

- Has precedence over `and` and `or`

  ~~~ lay
  body {
    foo: /^\d+$/ ~ "12a" or 'abc' ~ /[a-z]{1,3}/
    foo: /\d+/ ~ "123" and 'abc' ~ /[a-z]{1,3}/
  }
  ~~~

  ~~~ css
  body {
    foo: 'abc';
    foo: 'abc';
  }
  ~~~

- Has left associativity

  ~~~ lay
  foo: /^\d+$/ ~ ("123" + "4")
  foo: /^\d+$/ ~ "123" + "4"
  ~~~

  ~~~ css
  foo: '1234';
  foo: '1234';
  ~~~

## `=` and `|=`

- Have precedence over `and` and `or`

  ~~~ lay
  body {
    foo: (a = 2) and 3
    foo: b = (2 and 3)
    foo: c |= 2 and 3
    bar: a
    bar: b
    bar: c
    baz: true or d = 3
    baz: 2 and a = 3
  }

  pi = 3.14

  body {
    foo: (aa = false) or pi
    foo: bb |= (false or pi)
    foo: cc = false or pi
    bar: aa
    bar: bb
    bar: cc
  }
  ~~~

  ~~~ css
  body {
    foo: 3;
    foo: 3;
    foo: 3;
    bar: 2;
    bar: 3;
    bar: 2;
    baz: true;
    baz: 3;
  }

  body {
    foo: 3.14;
    foo: 3.14;
    foo: 3.14;
    bar: false;
    bar: 3.14;
    bar: false;
  }
  ~~~

- Have right associativity

  ~~~ lay
  body {
    foo: a |= b = c = 3
    foo: a
    foo: b
    foo: c
  }
  ~~~

  ~~~ css
  body {
    foo: 3;
    foo: 3;
    foo: 3;
    foo: 3;
  }
  ~~~

## `and`

- Has precedence over `or`

  ~~~ lay
  body {
    foo: (true or false) and false
    foo: true or (false and false)
    foo: true or false and false
  }
  ~~~

  ~~~ css
  body {
    foo: false;
    foo: true;
    foo: true;
  }
  ~~~

- Has left associativity

## `or`

- Has precedence over `<<` and `>>`

  ~~~ lay
  foo {
    bar: ((1,) << a = 2) << b |= 3
  }
  ~~~

  ~~~ css
  foo {
    bar: 1, 2, 3;
  }
  ~~~

- Has left associativity

## `not`

- Has higher precedence than list separators

  ~~~ lay
  #foo {
    bar: not true false
    bar: not null, not (1 - 1)
  }
  ~~~

  ~~~ css
  #foo {
    bar: false false;
    bar: true, false;
  }
  ~~~

- Has higher precedence than `and` and `or`

  ~~~ lay
  body {
    foo: not true or true
    foo: not (true or true)
    bar: not true and false
    bar: not (true and false)
  }
  ~~~

  ~~~ css
  body {
    foo: true;
    foo: false;
    bar: false;
    bar: true;
  }
  ~~~

- Has right associativity

  ~~~ lay
  body {
    foo: not (not (not false))
    foo: not not not false
  }
  ~~~

  ~~~ css
  body {
    foo: true;
    foo: true;
  }
  ~~~

## ` `

- Has precedence over `,`

  ~~~ lay
  foo {
    foo: (1 2 (3, 4) 5 6)::0
    foo: ((1 2 3), (4 5 6))::0
    foo: (1 2 3, 4 5 6)::0
  }
  ~~~

  ~~~ css
  foo {
    foo: 1;
    foo: 1 2 3;
    foo: 1 2 3;
  }
  ~~~

## `,`

- Has precedence over `=` and `|=`

  ~~~ lay
  foo {
    a = 1
    foo: a, (b = 2), (c |= 3)
  }
  ~~~

  ~~~ css
  foo {
    foo: 1, 2, 3;
  }
  ~~~

## `>>` and `<<`

- Have left associativity

  ~~~ lay
  foo {
    bar: ((0, 1) << (1 2)) << 3
    bar: (0,1) << ((1 2) << 3)
    bar: (0, 1) << (1 2) << 3
  }

  bar {
    a = (0,)
    (3 >> (2 1)) >> a
    foo: a
    a = (0,)
    3 >> ((2 1) >> a)
    foo: a
    a = (0,)
    3 >> (2 1) >> a
    foo: a
  }
  ~~~

  ~~~ css
  foo {
    bar: 0, 1, 1 2, 3;
    bar: 0, 1, 1 2 3;
    bar: 0, 1, 1 2, 3;
  }

  bar {
    foo: 0, 2 1 3;
    foo: 0, 2 1, 3;
    foo: 0, 2 1 3;
  }
  ~~~
