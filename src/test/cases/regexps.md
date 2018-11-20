Regular expressions
===================

- Are made with `/.../`

  ~~~ lay
  a = /[a-z]+/
  b = /./
  ~~~

  ~~~ css
  ~~~

- Cannot be empty

  ~~~ lay
  regexp[empty] {
    i: foo // This is interpreted as a comment
  }
  ~~~

  ~~~ css
  regexp[empty] {
    i: foo;
  }
  ~~~

- Cannot start with whitespace

  ~~~ lay
  $re = /  /
  ~~~

  ~~~ SyntaxError
  ~~~

  ~~~ lay
  $re = /  .*/
  ~~~

  ~~~ SyntaxError
  ~~~

  ~~~ lay
  $re = /.*
  /
  ~~~

  ~~~ SyntaxError
  ~~~

  ~~~ lay
  foo = 1

  regexp::whitespace{
    i: 3 / foo/ 2
    ii: 3 /foo/ 2
  }
  ~~~

  ~~~ css
  regexp::whitespace {
    i: 1.5;
    ii: 3 regexp("foo") 2;
  }
  ~~~

- Must have a correct syntax

  ~~~ lay
  a = /(.*/i
  ~~~

  ~~~ ValueError
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

  ~~~ ValueError
  Invalid RegExp flag: "j"
  ~~~

- Are case-sensitive

  ~~~ lay
  a = /.*/I
  ~~~

  ~~~ ValueError
  Invalid RegExp flag: "I"
  ~~~

  ~~~ lay
  a = /.*/gMi
  ~~~

  ~~~ ValueError
  Invalid RegExp flag: "M"
  ~~~

  ~~~ lay
  a = /.*/miG
  ~~~

  ~~~ ValueError
  Invalid RegExp flag: "G"
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
  regexp[multiline] {
    foo: 'lorem\nipsum\ndolor'.unquoted ~ /^[a-z]+$/m
  }
  ~~~

  ~~~ css
  regexp[multiline] {
    foo: lorem;
  }
  ~~~

### `g` (global)

- Activates the global mode

  ~~~ lay
  regexp[global] {
    foo: 'lorem\nipsum\ndolor'.unquoted ~ /^[a-z]*$/mg
  }
  ~~~

  ~~~ css
  regexp[global] {
    foo: lorem ipsum dolor;
  }
  ~~~

### `i` (insensitive)

- Sets the case insensitive mode on

  ~~~ lay
  regexp[insensitive] {
    foo: 'Lorem\nipsum\nDOLOR\nsit'.unquoted ~ /^[a-z]*$/mg
    foo: 'Lorem\nipsum\nDOLOR\nsit'.unquoted ~ /^[a-z]*$/mgi
  }
  ~~~

  ~~~ css
  regexp[insensitive] {
    foo: ipsum sit;
    foo: Lorem ipsum DOLOR sit;
  }
  ~~~

## Methods

### `string`

- Returns the expression source as a string

  ~~~ lay
  regexp.string {
    bar: /^[a-zA-Z-_\d]+$/.string.quoted
  }
  ~~~

  ~~~ css
  regexp.string {
    bar: "^[a-zA-Z-_\\d]+$";
  }
  ~~~

### `global?`

- Tells if the regular expression has the 'global' flag on

  ~~~ lay
  regexp.global {
    bar: /.*/gi.global?
    baz: not /.*/iiim.global?
  }
  ~~~

  ~~~ css
  regexp.global {
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
  regexp.insensitive {
    bar: /.*/gi.insensitive?
    baz: /\d/.insensitive?
  }
  ~~~

  ~~~ css
  regexp.insensitive {
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
  regexp.sensitive {
    bar: /.*/gi.sensitive?
    baz: not /.*/.sensitive?
  }
  ~~~

  ~~~ css
  regexp.sensitive {
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
  regexp.multiline {
    bar: /.*/gi.multiline?
    baz: not /.*/m.multiline?
  }
  ~~~

  ~~~ css
  regexp.multiline {
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
    ii: "lorem";
  }
  ~~~

### `flags`

- Returns the regular expression flags as a sequence of characters

  ~~~ lay
  regexp.flags {
    i: /.*/.flags
    ii: /.*/i.flags
    iii: /.*/mgi.flags
    iv: /.*/mi.flags
    v: /.*/gm.flags
    vi: /.*/iiimmgmgi.flags
  }
  ~~~

  ~~~ css
  regexp.flags {
    i: "";
    ii: "i";
    iii: "gim";
    iv: "im";
    v: "gm";
    vi: "gim";
  }
  ~~~

### Operators

#### `==`

- Returns `true` only if the right side is a `RegExp` with the same source and flags

  ~~~ lay
  regexp[operator="is"] {
    i: /\d+/ == /\d*/
    ii: /\d+/i == /\d+/gi
    iii: /\d+/iggm == /\d+/mgi
  }
  ~~~

  ~~~ css
  regexp[operator="is"] {
    i: false;
    ii: false;
    iii: true;
  }
  ~~~

#### `!=`

- Returns `false` only if the right side is a `RegExp` with the same source and flags

  ~~~ lay
  regexp[operator="is"] {
    i: /\d+/ != /\d*/
    ii: /\d+/i != /\d+/gi
    iii: /\d+/iggm != /\d+/mgi
  }
  ~~~

  ~~~ css
  regexp[operator="is"] {
    i: true;
    ii: true;
    iii: false;
  }
  ~~~

#### `~`

- Matches a string against the regular expression

  ~~~ lay
  regexp[operator="~"] {
      i: /\d+/ ~ '123px' /\d+/ ~ 'abc'
    ii: /(\d+)(px|rem)/ ~ `100px`
    iii: /(\d+)(px|rem)/ ~ "99rem"
    iv: border-color ~ /([a-z]+)-([a-z]+)/
  }
  ~~~

  ~~~ css
  regexp[operator="~"] {
    i: "123" null;
    ii: 100px 100 px;
    iii: "99rem" "99" "rem";
    iv: border-color border color;
  }
  ~~~
