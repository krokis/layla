Loops
=====

## `While` loops

- Repeat their body while the condition is falsy

  ~~~ lay
  $i = 0

  body {
    while $i <= 5 {
      foo: $i
      $i = $i + 1
    }

    $i = $i - 1

    while not $i.zero? {
      foo: $i = $i - 1
    }
  }
  ~~~

  ~~~ css
  body {
    foo: 0;
    foo: 1;
    foo: 2;
    foo: 3;
    foo: 4;
    foo: 5;
    foo: 4;
    foo: 3;
    foo: 2;
    foo: 1;
    foo: 0;
  }
  ~~~

## `Until` loops

- Repeat their body until the condition is trueish

  ~~~ lay
  $i = 1

  body {
    until $i > 7 {
      foo: $i
      $i = $i + 2
    }
  }
  ~~~

  ~~~ css
  body {
    foo: 1;
    foo: 3;
    foo: 5;
    foo: 7;
  }
  ~~~

## `for ... in` loops

- Can iterate lists keys and values

  ~~~ lay
  letters = a b c d

  body {
    for l in letters {
      foo: l.quoted
    }
    l: l
    for k, l in letters {
      foo: k l.quoted
    }
    l: l
    k: k
  }
  ~~~

  ~~~ css
  body {
    foo: "a";
    foo: "b";
    foo: "c";
    foo: "d";
    l: d;
    foo: 0 "a";
    foo: 1 "b";
    foo: 2 "c";
    foo: 3 "d";
    l: d;
    k: 3;
  }
  ~~~

- Can iterate ranges

  ~~~ lay
  $nums = one two three

  * [foo] {
    for $i in 1..3 {
      foo: $i $nums::($i - 1)
    }

    for $i, $l in -1..1 {
      foo: $i, $l
    }
  }
  ~~~

  ~~~ css
  * [foo] {
    foo: 1 one;
    foo: 2 two;
    foo: 3 three;
    foo: 0, -1;
    foo: 1, 0;
    foo: 2, 1;
  }
  ~~~

- Can iterate blocks elements

  ~~~ lay
  doc = {
    body {
      background: yellow
    }

    a:hover > span {
      color: green
      font-weight: bold
    }
  }

  props = {
    border: red
    background: pink
  }

  #foo {
    for i, node in doc {
      foo: i node.selector.quoted
    }

    for prop in props {
      prop: prop.name, prop.value
    }
  }

  ~~~

  ~~~ css
  #foo {
    foo: 0 "body";
    foo: 1 "a:hover > span";
    prop: border, red;
    prop: background, pink;
  }
  ~~~

- Can iterate blocks rules

## `break`

- Can be used to escape a loop

  ~~~ lay
  $i = 1

  body {
    until null {
      foo: $i
      if ($i = $i + 1) > 5 {
        break
      }
    }

    while true {
      foo: $i
      if ($i = $i + 1) > 10 {
        break
      }
    }

    for $i in 1..10 {
      if $i > 3 {
        break
      }
      foo: $i;
    }
  }
  ~~~

  ~~~ css
  body {
    foo: 1;
    foo: 2;
    foo: 3;
    foo: 4;
    foo: 5;
    foo: 6;
    foo: 7;
    foo: 8;
    foo: 9;
    foo: 10;
    foo: 1;
    foo: 2;
    foo: 3;
  }
  ~~~

- Has an optional `depth` argument

  ~~~ lay
  body {
    for $i in 1..3 {
      for $l in 1..3 {
        if $l > 2 {
          break
        }
        foo: $i $l
      }
    }
    for $i in 1..3 {
      for $l in 1..3 {
        if $l > 2 {
          if $i > 1 {
            break 2
          } else {
            break 1
          }
        }
        bar: $i $l
      }
    }
  }
  ~~~

  ~~~ css
  body {
    foo: 1 1;
    foo: 1 2;
    foo: 2 1;
    foo: 2 2;
    foo: 3 1;
    foo: 3 2;
    bar: 1 1;
    bar: 1 2;
    bar: 2 1;
    bar: 2 2;
  }
  ~~~

- `depth` must be a number

## `continue`

- Jumps to next iteration

  ~~~ lay
  body {
    $i = 0

    while true {
      $i = $i + 1

      if $i > 10 {
        break
      }

      unless $i.odd? {
        continue
      }

      foo: $i
    }

    for $k in 1..10 {
      if $k.odd? {
        continue
      }

      foo: $k
    }
  }
  ~~~

  ~~~ css
  body {
    foo: 1;
    foo: 3;
    foo: 5;
    foo: 7;
    foo: 9;
    foo: 2;
    foo: 4;
    foo: 6;
    foo: 8;
    foo: 10;
  }
  ~~~

- Has an optional `depth` argument

  ~~~ lay
  ::foo {
    for $i in 1..3 {
      for $j in 1..5 {
        if $j > $i {
          continue (1 + 1)
        }
        foo: $i, $j
      }
    }
  }
  ~~~

  ~~~ css
  ::foo {
    foo: 1, 1;
    foo: 2, 1;
    foo: 2, 2;
    foo: 3, 1;
    foo: 3, 2;
    foo: 3, 3;
  }
  ~~~
