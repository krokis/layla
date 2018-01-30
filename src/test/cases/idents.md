Idents
======

- Can contain letters, numbers, `[$-_]` and end with `?`

  ~~~ lay
  idents {
    color: red
    colour: __light_green__\_
    $-my-colour- = #f00
    colour: $-my-colour-
    colour: --pale-white
    whisky: please?
  }
  ~~~

  ~~~ css
  idents {
    color: #f00;
    colour: __light_green___;
    colour: #f00;
    colour: --pale-white;
    whisky: please\?;
  }
  ~~~

- Are case-sensitive

  ~~~ lay
  foo = bar
  __Baz = baz

  body {
    foo: FOO foo
    bar: __baz __Baz
  }
  ~~~

  ~~~ css
  body {
    foo: FOO bar;
    bar: __baz baz;
  }
  ~~~

- Can contain unicode characters

  ~~~ lay
  #triangle {

    &:before {
      content: ‣
    }

    ‣ = ▷

    &:after {
      content: ‣
    }
  }

  @counter-style box-corner {
    system: fixed
    symbols: ◰ ◳ ◲ ◱
  }
  ~~~

  ~~~ css
  #triangle:before {
    content: ‣;
  }

  #triangle:after {
    content: ▷;
  }

  @counter-style box-corner {
    system: fixed;
    symbols: ◰ ◳ ◲ ◱;
  }
  ~~~
