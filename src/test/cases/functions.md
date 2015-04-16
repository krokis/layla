Functions
=========

- Are made with an argument list followed by a block

  ~~~ lay
  DO-NOTHING = () {};

  size = (w, h = null) {
    if not h {
      h = w
    }

    width: w
    height: h
  }

  div {
    size(22px)
    size(10%, 2em)
  }

  round-corners = ($r) {
    border-radius: $r
  }

  -box-sizing = ($v) {
    -webkit-box-sizing: $v
       -moz-box-sizing: $v
            box-sizing: $v
  }

  --box-sizing_border-box = () {
    -box-sizing(border-box)
  }

  -box-sizing_border-box = () { --box-sizing_border-box }

  make-button = (br) {
    round-corners(br)
    -box-sizing_border-box()
  }

  button {
    DO-NOTHING(2px red)
    make-button(5px)
    font-style: (() { return italic })()
    font-weight: (($weight = 400) { return $weight })(bolder)
  }
  ~~~

  ~~~ css
  div {
    width: 22px;
    height: 22px;
    width: 10%;
    height: 2em;
  }

  button {
    border-radius: 5px;
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
    box-sizing: border-box;
    font-style: italic;
    font-weight: bolder;
  }
  ~~~

- Can have an empty argument list

  ~~~ lay
  bar = ( ) { "dummy" }
  body{foo:dummy}
  ~~~

  ~~~ css
  body {
    foo: dummy;
  }
  ~~~

- Can have an empty body

  ~~~ lay
  bar = () {}
  ~~~

  ~~~ css
  ~~~

- May `return` a value

  ~~~ lay
  sum = ((a, b) {
    return a + b
  })

  font-size: sum(12px, 15px)
  ~~~

  ~~~ css
  font-size: 27px;
  ~~~

- When they not explicitly return a value, last evaluated statement is returned instead

- Return `null` if they don't return anything

  ~~~ lay
  NOOP = () {}

  border: NOOP
  ~~~

  ~~~ css
  border: null;
  ~~~

- Can have default arguments

  ~~~ lay
  sum = (a = 0, b = 1) {
    return a + b
  }

  font-size: (sum())px
  font-size: sum(12px,1)
  font-size: sum(12px)
  font-size: sum(14px,-1px)
  ~~~

  ~~~ css
  font-size: 1px;
  font-size: 13px;
  font-size: 13px;
  font-size: 13px;
  ~~~

- Arguments can refer to other leftmost arguments for their initialization

  ~~~ lay
  size = (w, h = w) {
    width: w
    height: h
  }

  foo = (a = 0, b = a + 1) { return a + b }

  a {
    size(20px)
    foo: foo()
  }

  b {
    size(20px, 30px)
    foo: foo(10px)
  }
  ~~~

  ~~~ css
  a {
    width: 20px;
    height: 20px;
    foo: 1;
  }

  b {
    width: 20px;
    height: 30px;
    foo: 21px;
  }
  ~~~

- Parentheses can be omitted when calling with no arguments

  ~~~ lay
  error = (text = 'error') {
    error: `{text}!`
  }

  error('warning')
  error()
  error
  ~~~

  ~~~ css
  error: warning!;
  error: error!;
  error: error!;
  ~~~

- Can be self-called

  ~~~ lay
  (($c) { color: $c })(red)
  ($i, $c = white) { background: $c $i }(url(background.jpg))
  ~~~

  ~~~ css
  color: red;
  background: white url(background.jpg);
  ~~~

- Trailing `?`  and `!` can me moved to the right of calling parentheses

  ~~~ lay
  warning = (text) {
    return `{text}`
  }

  warning! = (text) {
    return `{warning(text)} !warning`
  }

  foo: warning!('bar')
  foo: warning('bar')!
  ~~~

  ~~~ css
  foo: bar !warning;
  foo: bar !warning;
  ~~~

- Can have named arguments

## Splats

- Can be used on function definition

- Can be used on function calls
