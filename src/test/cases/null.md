Null
====

- Is always falsy

  ~~~ lay
  body {
    if not null {
      if null.false? {
        if not null { foo: bar! }
      }
    }
  }
  ~~~

  ~~~ css
  body {
    foo: bar\!;
  }
  ~~~

- Cannot be overwritten

  ~~~ lay
  null = true
  ~~~

  ~~~ ReferenceError
  ~~~

  ~~~ lay
  null = true
  ~~~

  ~~~ ReferenceError
  ~~~

## Operators

### `is`

- Returns `true` only if the right side is `null`

  ~~~ lay
  $objs = (null, 0, false, '', ``, {}, (), #fff, /.*/i, undefined)

  #null {
    for $i in 0..($objs.length) {
      foo: null is $objs::($i) null isnt $objs::($i)
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
