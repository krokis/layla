Regular expressions
===================

- Are made with `/.../`

  ~~~ lay
  a = /[a-z]+/
  ~~~

  ~~~ css
  ~~~

- Cannot be empty

- Cannot contain only whitespace

- Must have a correct syntax

  ~~~ lay
  a = /(.*/i
  ~~~

  ~~~ TypeError
  Invalid regular expression: /(.*/: Unterminated group
  ~~~

- Are always trueish

  ~~~ lay
  body {
    foo: /\s+/.true?
  }
  ~~~

  ~~~ css
  body {
    foo: true;
  }
  ~~~

## Flags

- Are specified as `/.../flags`

  ~~~ lay
  a = /.*/mgi
  ~~~

  ~~~ css
  ~~~

- Cannot be other than `[mgi]`

  ~~~ lay
  a = /.*/mij
  ~~~

  ~~~ TypeError
  Bad flag for RegExp: "j"
  ~~~

- Are case-sensitive

  ~~~ lay
  a = /.*/I
  ~~~

  ~~~ TypeError
  Bad flag for RegExp: "I"
  ~~~

  ~~~ lay
  a = /.*/gMi
  ~~~

  ~~~ TypeError
  Bad flag for RegExp: "M"
  ~~~

  ~~~ lay
  a = /.*/miG
  ~~~

  ~~~ TypeError
  Bad flag for RegExp: "G"
  ~~~

- Can be repeated

  ~~~ lay
  a = /.*/imgiiigmmgi
  ~~~

  ~~~ css
  ~~~

### `m` (multiline)

- Activates the multiline mode

  ~~~ lay
  body {
    foo: 'lorem\nipsum\ndolor'.unquoted ~ /^[a-z]+$/m
  }
  ~~~

  ~~~ css
  body {
    foo: lorem;
  }
  ~~~

### `g` (global)

- Activates the global mode

  ~~~ lay
  body {
    foo: 'lorem\nipsum\ndolor'.unquoted ~ /^[a-z]*$/mg
  }
  ~~~

  ~~~ css
  body {
    foo: lorem ipsum dolor;
  }
  ~~~

### `i` (insensitive)

- Sets the case insensitive mode on

  ~~~ lay
  body {
    foo: 'Lorem\nipsum\nDOLOR\nsit'.unquoted ~ /^[a-z]*$/mg
    foo: 'Lorem\nipsum\nDOLOR\nsit'.unquoted ~ /^[a-z]*$/mgi
  }
  ~~~

  ~~~ css
  body {
    foo: ipsum sit;
    foo: Lorem ipsum DOLOR sit;
  }
  ~~~

## Methods

### `string`

- Returns the expression source as a string

  ~~~ lay
  foo {
    bar: /^[a-zA-Z-_\d]+$/.string.quoted
  }
  ~~~

  ~~~ css
  foo {
    bar: "^[a-zA-Z-_\d]+$";
  }
  ~~~

### `global?`

- Tells if the regular expression has the 'global' flag on

  ~~~ lay
  foo {
    bar: /.*/gi.global?
    baz: not /.*/iiim.global?
  }
  ~~~

  ~~~ css
  foo {
    bar: true;
    baz: true;
  }
  ~~~

### `global`

- Returns a copy of the regular expression with the `global` flag on

  ~~~ lay
  $s = 'lorem\nipsum\ndolor'.unquoted
  $r = /^[a-z]*$/m

  regexp.global {
    i: $s ~ $r
    ii: $s ~ $r.global
  }
  ~~~

  ~~~ css
  regexp.global {
    i: lorem;
    ii: lorem ipsum dolor;
  }
  ~~~


### `insensitive?`

- Tells if the regular expression has the 'insensitive' flag on

  ~~~ lay
  foo {
    bar: /.*/gi.insensitive?
    baz: /\d/.insensitive?
  }
  ~~~

  ~~~ css
  foo {
    bar: true;
    baz: false;
  }
  ~~~

### `insensitive`

- Returns a copy of the regular expression with the `insensitive` flag on

  ~~~ lay
  regexp.insensitive {
    i: /.*/g.insensitive.insensitive?
    ii: /.*/gi.insensitive.insensitive?
    $re = /[a-z]+/
    iii: $re ~ "FOO"
    iv: $re.insensitive ~ "FOO"
  }
  ~~~

  ~~~ css
  regexp.insensitive {
    i: true;
    ii: true;
    iii: null;
    iv: "FOO";
  }
  ~~~

### `sensitive?`

- Tells if the regular expression has the 'insensitive' flag off

  ~~~ lay
  foo {
    bar: /.*/gi.sensitive?
    baz: not /.*/.sensitive?
  }
  ~~~

  ~~~ css
  foo {
    bar: false;
    baz: false;
  }
  ~~~

### `sensitive`

- Returns a copy of the regular expression with the `insensitive` flag off

  ~~~ lay
  regexp.sensitive {
    i: /.*/g.sensitive.sensitive?
    ii: /.*/gi.sensitive.sensitive?
    $re = /[a-z]+/i
    iii: $re ~ "FOO"
    iv: $re.sensitive ~ "FOO"
  }
  ~~~

  ~~~ css
  regexp.sensitive {
    i: true;
    ii: true;
    iii: "FOO";
    iv: null;
  }
  ~~~

### `multiline?`

- Tells if the regular expression has the 'multiline' flag on

  ~~~ lay
  foo {
    bar: /.*/gi.multiline?
    baz: not /.*/m.multiline?
  }
  ~~~

  ~~~ css
  foo {
    bar: false;
    baz: false;
  }
  ~~~

### `multiline`

- Returns a copy of the regular expression with the `multiline` flag on

  ~~~ lay
  $r = /^[a-z]+$/
  $s = 'lorem\nipsum\ndolor'

  regexp.multiline {
    i: $r ~ $s
    ii: $r.multiline ~ $s
  }
  ~~~

  ~~~ css
  regexp.multiline {
    i: null;
    ii: 'lorem';
  }
  ~~~

### Operators

### `is`

- Returns `true` only if the right side is a `RegExp` with the same source and flags

  ~~~ lay
  foo: /\d+/ is /\d*/
  foo: /\d+/i is /\d+/gi
  foo: /\d+/iggm is /\d+/mgi
  ~~~

  ~~~ css
  foo: false;
  foo: false;
  foo: true;
  ~~~

### `~`

- Matches a string against the regular expression

  ~~~ lay
  #foo {
      `i`: /\d+/ ~ '123px' /\d+/ ~ 'abc'
     `ii`: /(\d+)(px|rem)/ ~ `100px`
    `iii`: /(\d+)(px|rem)/ ~ "99rem"
     `iv`: border-color ~ /([a-z]+)-([a-z]+)/
  }
  ~~~

  ~~~ css
  #foo {
    i: '123' null;
    ii: 100px 100 px;
    iii: "99rem" "99" "rem";
    iv: border-color border color;
  }
  ~~~
