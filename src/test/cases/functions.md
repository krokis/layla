Functions
=========

- Are made with an argument list followed by a block

  ~~~ lay
  DO-NOTHING = () {};

  size = ($w, $h: null) {
    if not $h {
      $h = $w
    }

    width: $w
    height: $h
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

  -box-sizing_border-box = () { --box-sizing_border-box() }

  make-button = (br) {
    round-corners(br)
    -box-sizing_border-box()
  }

  button {
    DO-NOTHING(2px #f00)
    make-button(5px)
    font-style: (() { return italic })()
    font-weight: (($weight: 400) { return $weight })(bolder)
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

- Can `return` with no arguments

  ~~~ lay
  bar = () {
    return
  }

  FOO = () {
    return
    foo: bar
  }

  foo: bar()
  bar: FOO()
  ~~~

  ~~~ css
  foo: null;
  bar: null;
  ~~~

- Return `null` if they don't return anything

  ~~~ lay
  NOOP = () {}

  functions#no-return {
    border: NOOP()
  }
  ~~~

  ~~~ css
  functions#no-return {
    border: null;
  }
  ~~~

- Can have default arguments

  ~~~ lay
  sum = (a: 0, b: 1) {
    return a + b
  }

  functions#default-arguments {
    font-size: (sum())px
    font-size: sum(12px,1)
    font-size: sum(12px)
    font-size: sum(14px,-1px)
  }
  ~~~

  ~~~ css
  functions#default-arguments {
    font-size: 1px;
    font-size: 13px;
    font-size: 13px;
    font-size: 13px;
  }
  ~~~

- Can receive "rest" arguments

  ~~~ lay
  sum = ($nums...) {
    $sum = 0

    for $n in $nums {
      $sum = $sum + $n
    }

    return $sum
  }

  functions#rest-arguments {
    font-size: (sum())px
    font-size: sum(12px,1)
    font-size: sum(12px)
    font-size: sum(14px,-1px)
  }
  ~~~

  ~~~ css
  functions#rest-arguments {
    font-size: 0;
    font-size: 13px;
    font-size: 12px;
    font-size: 13px;
  }
  ~~~

- Arguments are evaluated at call-time

  ~~~ lay
  size = (w, h: w) {
    width: w
    height: h
  }

  foo = (a: 0, b: a + 1) { return a + b }

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

- Can call themselves

  ~~~ lay
  factorial = (n) {
    if n <= 1 {
      return 1
    } else {
      return n * factorial(n - 1)
    }
  }

  #factorial-of {
      one: factorial(1)
      two: factorial(2)
    three: factorial(3)
     four: factorial(4)
     five: factorial(5)
  }
  ~~~

  ~~~ css
  #factorial-of {
    one: 1;
    two: 2;
    three: 6;
    four: 24;
    five: 120;
  }
  ~~~

- Can be self-called

  ~~~ lay
  (($c) { color: $c })(#f00)
  ($i, $c: #fff) { background: $c $i }(url(background.jpg))
  ~~~

  ~~~ css
  color: #f00;
  background: #fff url("background.jpg");
  ~~~

## `return`

- Can be used inside a function to return a value

  ~~~ lay
  sum = ((a, b) {
    return a + b
  })

  font-size: sum(12px, 15px)
  ~~~

  ~~~ css
  font-size: 27px;
  ~~~

- Can be called with no arguments

  ~~~ lay
  bar = () {
    return
  }

  FOO = () {
    return
    foo: bar
  }

  foo: bar()
  bar: FOO()
  ~~~

  ~~~ css
  foo: null;
  bar: null;
  ~~~

- Defaults to `null` when it's not present

  ~~~ lay
  NOOP = () {}

  border: NOOP()
  ~~~

  ~~~ css
  border: null;
  ~~~

- Cannot be called outside a function

  ~~~ lay
  return
  ~~~

  ~~~ RuntimeError
  Uncaught `return`
  ~~~

  ~~~ lay
  @media print {
    body .foo {
      return 2
    }
  }
  ~~~

  ~~~ RuntimeError
  Uncaught `return`
  ~~~

## Methods

### `invoke`

- Calls the function with given arguments

  ~~~ lay
  foo: ((a,b) { return a + b}).invoke(2,3)
  ~~~

  ~~~ css
  foo: 5;
  ~~~
