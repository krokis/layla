Booleans
========

## `true`

- Is case sensitive

  ~~~ lay
  foo: true, not true, True, TRUE
  ~~~

  ~~~ css
  foo: true, false, True, TRUE;
  ~~~

## `false`

- Is case sensitive

  ~~~ lay
  foo: false, not false
  foo: False, not False
  foo: FALSE, not FALSE
  ~~~

  ~~~ css
  foo: false, true;
  foo: False, false;
  foo: FALSE, false;
  ~~~

## Operators

### Unary

#### `not`

- Negates a boolean

  ~~~ lay
  foo: not true
  foo: not (not true)
  foo: not (not false)
  foo: not false
  ~~~

  ~~~ css
  foo: false;
  foo: true;
  foo: false;
  foo: true;
  ~~~

- Evaluates any expression to a boolean and negates it

  ~~~ lay
  foo: not ""
  foo: not (0)
  foo: not (1,)
  foo: not (1..2)
  foo: not (1 - 1)
  foo: not bar
  foo: not ({ color: red; })
  foo: not ({})
  foo: not #666
  foo: not (not null)
  foo: not ((foo=null) { return false })
  ~~~

  ~~~ css
  foo: false;
  foo: false;
  foo: false;
  foo: false;
  foo: false;
  foo: false;
  foo: false;
  foo: false;
  foo: false;
  foo: false;
  foo: false;
  ~~~

- Can be nested

  ~~~ lay
  bar: not not not null
  ~~~

  ~~~ css
  bar: true;
  ~~~

### Binary

#### `is`

- Returns true only if the right side is a boolean with the same value

  ~~~ lay
  foo: true is true
  foo: true is 1
  foo: false is null
  foo: false is true
  ~~~

  ~~~ css
  foo: true;
  foo: false;
  foo: false;
  foo: false;
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
    foo: 'bar';
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
