Idents
======

- Can contain letters, numbers and `[$-_?!]`

  ~~~ lay
  color: red!
  colour: __light_green!!!
  colour: $-my-colour-?
  colour: --pale-white
  whisky: !please
  ~~~

  ~~~ css
  color: red!;
  colour: __light_green!!!;
  colour: $-my-colour-?;
  colour: --pale-white;
  whisky: !please;
  ~~~

- Are case-sensitive

  ~~~ lay
  foo = bar!
  __Baz = baz!

  body {
    foo: FOO foo
    bar: __baz __Baz
  }
  ~~~

  ~~~ css
  body {
    foo: FOO bar!;
    bar: __baz baz!;
  }
  ~~~

- Cannot start with a number or a hyphen followed by a number
