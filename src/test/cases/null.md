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

### `==`

- Returns `true` only if the right side is `null`

  ~~~ lay
  $objs = (null, 0, false, '', ``, {}, (), #fff, /.*/i, undefined)

  #null {
    for $i in 0..($objs.length - 1) {
      #{($i + 1).roman.lower-case}: null == $objs::($i)
    }
  }
  ~~~

  ~~~ css
  #null {
    i: true;
    ii: false;
    iii: false;
    iv: false;
    v: false;
    vi: false;
    vii: false;
    viii: false;
    ix: false;
    x: false;
  }
  ~~~

### `!=`

- Returns `false` only if the right side is `null`

  ~~~ lay
  $objs = (null, 0, false, '', ``, {}, (), #fff, /.*/i, undefined)

  #null {
    for $i in 0..($objs.length - 1) {
      #{($i + 1).roman.lower-case}: null != $objs::($i)
    }
  }
  ~~~

  ~~~ css
  #null {
    i: false;
    ii: true;
    iii: true;
    iv: true;
    v: true;
    vi: true;
    vii: true;
    viii: true;
    ix: true;
    x: true;
  }
  ~~~

