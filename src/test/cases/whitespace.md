# Whitespace

- Is correctly ignored

  ~~~ lay
  .whitespace
    { color: white; }

  .whitespace
  {
    color: white;
  }
    .whitespace
  { color: white; }

  .whitespace{color:white;}
  .whitespace { color : white ; }

  .white,
  .space,
  .mania
  { color: white; }

  .no-semi-column { color: white }
  .no-semi-column {
    color: white;
    white-space: pre
  }
  .no-semi-column {border: 2px solid white}
  .newline_ws .tab_ws {
  color:
  white;
  background-position:
  45 -23;
  }
  body {
    foo:bar
  }

  body { foo: bar }
  body {
  foo: bar
  }


  body {
  foo: bar
  }
  body
  {
  foo: bar
  }
  body
  {


                                foo:                  bar        ;


  }
  body
  {foo: bar}
  ~~~

  ~~~ css
  .whitespace {
    color: white;
  }

  .whitespace {
    color: white;
  }

  .whitespace {
    color: white;
  }

  .whitespace {
    color: white;
  }

  .whitespace {
    color: white;
  }

  .white,
  .space,
  .mania {
    color: white;
  }

  .no-semi-column {
    color: white;
  }

  .no-semi-column {
    color: white;
    white-space: pre;
  }

  .no-semi-column {
    border: 2px solid white;
  }

  .newline_ws .tab_ws {
    color: white;
    background-position: 45 -23;
  }

  body {
    foo: bar;
  }

  body {
    foo: bar;
  }

  body {
    foo: bar;
  }

  body {
    foo: bar;
  }

  body {
    foo: bar;
  }

  body {
    foo: bar;
  }

  body {
    foo: bar;
  }
  ~~~

- New lines are significant

## Line endings

- Can be of any type

  + LF

    ~~~ lay
    import 'whitespace/lf.lay'
    ~~~

    ~~~ css
    @lf {
      is: ok;
    }
    ~~~

  + CR

    ~~~ lay
    import 'whitespace/cr.lay'
    ~~~

    ~~~ css
    @cr {
      is: ok;
    }
    ~~~

  + CRLF

    ~~~ lay
    import 'whitespace/crlf.lay'
    ~~~

    ~~~ css
    @crlf {
      is: ok;
    }
    ~~~

## UTF-8 BOM's

- Are stripped

  ~~~ lay
  import 'whitespace/bom.lay'
  ~~~

  ~~~ css
  @bom {
    is: ok;
  }
  ~~~
