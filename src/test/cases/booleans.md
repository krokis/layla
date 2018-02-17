Booleans
========

## `true`

- Is case sensitive

  ~~~ lay
  boolean#true {
    i: true, not true, True, TRUE
  }
  ~~~

  ~~~ css
  boolean#true {
    i: true, false, True, TRUE;
  }
  ~~~

- Cannot be overwritten

  ~~~ lay
  true = false
  ~~~

  ~~~ ReferenceError
  ~~~

  ~~~ lay
  boolean#false:not-overwritable {
     i: true |= false
  }
  ~~~

  ~~~ css
  boolean#false:not-overwritable {
    i: true;
  }
  ~~~

## `false`

- Is case sensitive

  ~~~ lay
  boolean#true {
    i: false, not false
    ii: False, not False
    iii: FALSE, not FALSE
  }
  ~~~

  ~~~ css
  boolean#true {
    i: false, true;
    ii: False, false;
    iii: FALSE, false;
  }
  ~~~

- Cannot be overwritten

  ~~~ lay
  false = false
  ~~~

  ~~~ ReferenceError
  ~~~

  ~~~ lay
  boolean#false:not-overwritable {
    i: false |= null
  }
  ~~~

  ~~~ css
  boolean#false:not-overwritable {
    i: false;
  }
  ~~~

## Operators

### Unary

#### `not`

- Negates a boolean

  ~~~ lay
  boolean.not {
    i: not true
    ii: not (not true)
    iii: not (not false)
    iv: not false
  }
  ~~~

  ~~~ css
  boolean.not {
    i: false;
    ii: true;
    iii: false;
    iv: true;
  }
  ~~~

- Evaluates any expression to a boolean and negates it

  ~~~ lay
  object.not {
    i: not ""
    ii: not (0)
    iii: not (1,)
    iv: not (1..2)
    v: not (1 - 1)
    vi: not bar
    vi: not ({ color: red; })
    vii: not ({})
    viii: not #666
    ix: not (not null)
    x: not ((foo: null) { return false })
  }
  ~~~

  ~~~ css
  object.not {
    i: false;
    ii: false;
    iii: false;
    iv: false;
    v: false;
    vi: false;
    vi: false;
    vii: false;
    viii: false;
    ix: false;
    x: false;
  }
  ~~~

- Can be nested

  ~~~ lay
  object.not {
    bar: not not not null
  }
  ~~~

  ~~~ css
  object.not {
    bar: true;
  }
  ~~~

### Binary

#### `==`

- Returns true only if the right side is a boolean with the same value

  ~~~ lay
  boolean.equal {
    i: true == true
    ii: true == 1
    iii: false == null
    iv: false == true
  }
  ~~~

  ~~~ css
  boolean.equal {
    i: true;
    ii: false;
    iii: false;
    iv: false;
  }
  ~~~

#### `!=`

- Returns true only if the right side is a boolean with the same value

  ~~~ lay
  boolean.not-equal {
    i: true != true
    ii: true != 1
    iii: false != null
    iv: false != true
  }
  ~~~

  ~~~ css
  boolean.not-equal {
    i: false;
    ii: true;
    iii: true;
    iv: true;
  }
  ~~~

#### `and`

- Returns the left operand, if it's falsy, or the right one otherwise

  ~~~ lay
  a {
    foo: true and true
    foo: true and false
    foo: false and true
    foo: false and false
  }

  b {
    foo: false and 2
    foo: 2 and false
    foo: 2 and "foo"
    foo: 2 and 3

    foo: null or true
  }
  ~~~

  ~~~ css
  a {
    foo: true;
    foo: false;
    foo: false;
    foo: false;
  }

  b {
    foo: false;
    foo: false;
    foo: "foo";
    foo: 3;
    foo: true;
  }
  ~~~

- Is case sensitive

  ~~~ lay
  foo: johnny and mary
  foo: johnny AND mary
  foo: johnny And mary
  ~~~

  ~~~ css
  foo: mary;
  foo: johnny AND mary;
  foo: johnny And mary;
  ~~~

#### `or`

- Returns the left operand, if it is trueish, or the right one otherwise

  ~~~ lay
  a {
    foo: true or true
    foo: true or false
    foo: false or true
    foo: false or false
  }

  b {
    foo: false or 2
    foo: 2 or false
    foo: 2 or "foo"
    foo: 2 or 3
    foo: false or 'bar'
  }
  ~~~

  ~~~ css
  a {
    foo: true;
    foo: true;
    foo: true;
    foo: false;
  }

  b {
    foo: 2;
    foo: 2;
    foo: 2;
    foo: 2;
    foo: "bar";
  }
  ~~~

- Is case sensitive

  ~~~ lay
  a: johnny or mary
  b: johnny OR mary
  c: johnny Or mary
  ~~~

  ~~~ css
  a: johnny;
  b: johnny OR mary;
  c: johnny Or mary;
  ~~~
