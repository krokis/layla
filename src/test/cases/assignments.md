Assignments
===========

- `=` performs a "regular" assignment

  ~~~ lay
  helvetica = 'Helvetica'

  body {
    font-family: helvetica
  }

  $font = helvetica

  p {
    font-family: $font
  }

  $font = $font + ', Arial'
  $font-size = 13px - 2

  if true { $font-size = $font-size * 2 }

  p {
    font-family: $font
    font-size: $font-size
  }
  ~~~

  ~~~ css
  body {
    font-family: "Helvetica";
  }

  p {
    font-family: "Helvetica";
  }

  p {
    font-family: "Helvetica, Arial";
    font-size: 22px;
  }
  ~~~

- `|=` performs the assignment only if the left side is undefined or is `null`

  ~~~ lay
  body {
    a |= 1
    a |= 2
    b = null
    b |= 1
    foo: a
    bar: b
  }
  ~~~

  ~~~ css
  body {
    foo: 1;
    bar: 1;
  }
  ~~~

- Return the final left side value

  ~~~ lay
  body {
    font: $font = 'Helvetica'

    if comic = (
      false or
    1)
    {
      font: 'Comic Sans'
    }

    unless monospace = false {
      font: 'Monospaced'
    } else {
      font: serif
    }

    big = null
    if big |= true {
      font-size: large
    }

    bigger = false
    if bigger |= true {
      font-size: larger
    }
  }
  ~~~

  ~~~ css
  body {
    font: "Helvetica";
    font: "Comic Sans";
    font: "Monospaced";
    font-size: large;
  }
  ~~~
