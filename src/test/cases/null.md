Null
====

- Is always falsy

  ~~~ lay
  body {
    unless null {
      if null.false? {
        unless null { foo: bar! }
      }
    }
  }
  ~~~

  ~~~ css
  body {
    foo: bar!;
  }
  ~~~

## Operators

### `is`

- Returns `true` only if the right side is `null`

  ~~~ lay
  $objs = (null, 0, false, '', ``, {}, (), #fff, /.*/i, undefined)

  #null {
    for $i in 0..($objs.length) {
      foo: null is $objs::$i null isnt $objs::$i
    }
  }
  ~~~

  ~~~ css
  #null {
    foo: true false;
    foo: false true;
    foo: false true;
    foo: false true;
    foo: false true;
    foo: false true;
    foo: false true;
    foo: false true;
    foo: false true;
    foo: false true;
    foo: true false;
  }
  ~~~
