Conditionals
============

## `if`

- Execute their body only if the condition is met

    ~~~ lay
    body {
      if ((true)) {
        border: 1px

        if not false {
          font-weight: bolder
        }
      }

      if (true == false) {
        border: none
        font-weight: normal
      }

      if ({}) {
        color: red
      }

      if not true {}
    }
    ~~~

    ~~~ css
    body {
      border: 1px;
      font-weight: bolder;
      color: red;
    }
    ~~~

- Can have one or more `else if` blocks

  ~~~ lay
  body {
    if false {
      border: none
    } else if 'yeah' {
      border: 1px
    }

    if false {
      color: transparent
    } else if not true {
      color: white
    } else if null or not false {
      color: #666
    } else if true {
      color: yellow
    }

    if false {
      color: red
    } else if true {
    }
  }
  ~~~

  ~~~ css
  body {
    border: 1px;
    color: #666666;
  }
  ~~~

- Can have one `else` block

  ~~~ lay
  body {
    if false {
      border: none
    } else {
      border: 1px
    }

    if false {
      color: transparent
    } else if not true or null or black == white {
      color: white
    } else {
      color: black
    }

    if false {
      color: red
    } else if not true{
      color: green
    } else if not true{
    } else {

    }
  }
  ~~~

  ~~~ css
  body {
    border: 1px;
    color: black;
  }
  ~~~

- Cannot have any other `else (if)` blocks after the `else`

  ~~~ lay
  if false {
    foo: bar
  } else if not true {
    foo: bar
  } else {
    foo: bar
  } else if true {
    foo: bar
  }
  ~~~

  ~~~~ SyntaxError
  ~~~~

  ~~~ lay
  if false {
    foo: bar
  } else if not true {
    foo: bar
  } else {
    foo: bar
  } else {
    foo: bar
  }
  ~~~

  ~~~~ SyntaxError
  ~~~~
