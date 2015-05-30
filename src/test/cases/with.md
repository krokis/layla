`with`
======

- Executes a block bound to another

  ~~~ lay
  with ({}) {
    foo: bar
  }

  style = {}

  with style {
    color: white
    font-family: "Helvetica"

    a {
      text-decoration: underline;
    }
  }

  body {
    with style {
      color: #666;
    }

    color: style::color
    font-family: style::font-family

    a {
      text-decoration: style::2::text-decoration
    }
  }
  ~~~

  ~~~ css
  body {
    color: #666666;
    font-family: "Helvetica";
  }

  body a {
    text-decoration: underline;
  }
  ~~~

- Can reference a rule set

  ~~~~ lay
  $r = null

  body {
    p {
      a {
        color: blue
        with & {
          text-decoration: underline
        }
      }
    }
  }
  ~~~~

  ~~~~ css
  body p a {
    color: blue;
    text-decoration: underline;
  }
  ~~~~

- Can only reference blocks

  ~~~~ lay
  $l = 1, 2, 3

  with $l {
    &.push(4)
  }

  foo: $l
  ~~~~

  ~~~~ RuntimeError
  ~~~~

  ~~~~ lay
  with 1 {
    foo: bar
  }
  ~~~~

  ~~~~ RuntimeError
  ~~~~

  ~~~~ lay
  with "foo" {
    foo: bar
  }
  ~~~~

  ~~~~ RuntimeError
  ~~~~

  ~~~~ lay
  with null {
    foo: bar
  }
  ~~~~

  ~~~~ RuntimeError
  ~~~~

  ~~~~ lay
  with true {
    foo: bar
  }
  ~~~~

  ~~~~ RuntimeError
  ~~~~

  ~~~~ lay
  with #fff {
    foo: bar
  }
  ~~~~

  ~~~~ RuntimeError
  ~~~~
