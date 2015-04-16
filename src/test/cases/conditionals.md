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

      if (true is false) {
        border: none
        font-weight: normal
      }

      if ({}) {
        color: red
      }
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
    } else if not true or null or black is white {
      color: white
    } else {
      color: black
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

## Unless

- Is the negated version of `if`

  ~~~ lay
  body {
    unless ((false or 1))  { border:1px; }
    unless black is white  { border:none;
      unless (not (false)) { font-weight:bolder;font-style:italic; }
      else                 { font-weight:normal;font-style:normal; }
    }
  }
  ~~~

  ~~~ css
  body {
    border: none;
    font-weight: normal;
    font-style: normal;
  }
  ~~~

- Is also allowed as `else unless`

  ~~~ lay
  body
  {
    if false
    {
      color: transparent
    } else unless not true {
      color: black
    } else {
      color: white
    }

    unless true
    {
      color: transparent
    }
    else unless false or true
    {
      color: white
    }
    else
    {
      color: black
    }
  }
  ~~~

  ~~~ css
  body {
    color: black;
    color: black;
  }
  ~~~
