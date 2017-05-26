Loops
=====

## `while` loops

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
    prop: "border", red;
    prop: "background", pink;
  }
  ~~~

- Can iterate the document

- Can iterate blocks rules

  ~~~ lay
  doc = {
    font-weight: 700
    body {
      background: yellow
    }

    border: red
    background: pink

    a:hover > span {
      color: green
      font-weight: bold
    }

    color: yellow
  }

  #foo {
    for i, rule in doc.rules {
      rule-#{(i + 1).roman.lower-case}: rule.selector.quoted, rule.length
    }
  }
  ~~~

  ~~~ css
  #foo {
    rule-i: "body", 1;
    rule-ii: "a:hover > span", 2;
  }
  ~~~

- Can iterate blocks properties

  ~~~ lay
  doc = {
    font-weight: 700
    body {
      background: yellow
    }

    border: red
    background: pink

    a:hover > span {
      color: green
      font-weight: bold
    }

    color: yellow
  }

  #foo {
    for prop in doc.properties {
      &.push(prop)
    }
  }
  ~~~

  ~~~ css
  #foo {
    font-weight: 700;
    border: red;
    background: pink;
    color: yellow;
  }
  ~~~

### Cannot iterate non-enumerable objects

- Numbers

  ~~~ lay
  for $i in 5 {
    foo: $i
  }
  ~~~

  ~~~ TypeError
  ~~~

- Strings

  ~~~ lay
  for $i in "Lorem ipsum" {
    foo: $i
  }
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  for $i in LoremIpsum {
    foo: $i
  }
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  for $i in `Lorem ipsum` {
    foo: $i
  }
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  for $i in "" {
    foo: $i
  }
  ~~~

  ~~~ TypeError
  ~~~

- URLs

  ~~~ lay
  for $i in url(example.org) {
    foo: $i
  }
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  for $i in url("http://www.example.org") {
    foo: $i
  }
  ~~~

  ~~~ TypeError
  ~~~

- Data URIs

  ~~~ lay
  for $i in url(data:text/html,<h1>Hello%20World</h1>) {
    foo: $i
  }
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  for $i in url("data:text/plain,Hello%20World") {
    foo: $i
  }
  ~~~

  ~~~ TypeError
  ~~~

- Booleans

  ~~~ lay
  for $i in true {
    foo: $i
  }
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  for $i in false {
    foo: $i
  }
  ~~~

  ~~~ TypeError
  ~~~

- Null

  ~~~ lay
  for $i in null {
    foo: $i
  }
  ~~~

  ~~~ TypeError
  ~~~

- Colors

  ~~~ lay
  for $i in #f00 {
    foo: $i
  }
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  for $i in #fffa {
    foo: $i
  }
  ~~~

  ~~~ TypeError
  ~~~

- Functions

  ~~~ lay
  for $i in (() {}) {
    foo: $i
  }
  ~~~

  ~~~ TypeError
  ~~~

- Regular expressions

  ~~~ lay
  for $i in /.*/ {
    foo: $i
  }
  ~~~

  ~~~ TypeError
  ~~~

## `break`

- Can be used to escape a loop

  ~~~ lay
  $i = 1

  body {
    while not null {
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

- Fails for non-numeric `depth`s

  ~~~ lay
  for $i in 1..10 {
    break "foo"
  }
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  for $i in 1..10 {
    break null
  }
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  for $i in 1..10 {
    break true
  }
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  for $i in 1..10 {
    break url('http://example.org')
  }
  ~~~

  ~~~ TypeError
  ~~~

- Fails for non-positive `depth`s

  ~~~ lay
  for $i in 1..10 {
    break 0
  }
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  while true {
    while not false {
      break -1
    }
  }
  ~~~

  ~~~ TypeError
  ~~~

- Fails for non-integer `depth`s

  ~~~ lay
  for $i in 1..10 {
    break .1
  }
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  while true {
    while not false {
      break 2.0
    }
  }
  ~~~

  ~~~ css
  ~~~

- Fails for too high `depth`s

  ~~~ lay
  for $i in 1..10 {
    break 2
  }
  ~~~

  ~~~ RuntimeError
  Uncaught `break`
  ~~~

  ~~~ lay
  while true {
    while not false {
      break 3
    }
  }
  ~~~

  ~~~ RuntimeError
  Uncaught `break`
  ~~~

- Cannot be used outside a loop

  ~~~ lay
  break 2
  ~~~

  ~~~ RuntimeError
  Uncaught `break`
  ~~~

  ~~~ lay
  .break[illegal] {
    break
  }
  ~~~

  ~~~ RuntimeError
  Uncaught `break`
  ~~~

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

      if not $i.odd? {
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

- Fails for non-numeric `depth`s

  ~~~ lay
  for $i in 1..10 {
    continue "foo"
  }
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  for $i in 1..10 {
    continue null
  }
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  for $i in 1..10 {
    continue true
  }
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  for $i in 1..10 {
    continue url('http://example.org')
  }
  ~~~

  ~~~ TypeError
  ~~~

- Fails for too high `depth`s

  ~~~ lay
  for $i in 1..10 {
    continue 2
  }
  ~~~

  ~~~ RuntimeError
  Uncaught `continue`
  ~~~

  ~~~ lay
  while true {
    while not false {
      continue 3
    }
  }
  ~~~

  ~~~ RuntimeError
  Uncaught `continue`
  ~~~

- Fails for non-positive `depth`s

  ~~~ lay
  for $i in 1..10 {
    continue 0
  }
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  while true {
    while not false {
      continue -1
    }
  }
  ~~~

  ~~~ TypeError
  ~~~

- Fails for non-integer `depth`s

  ~~~ lay
  for $i in 1..10 {
    continue .1
  }
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  $i = 0

  while $i < 100 {
    $i = $i + 1

    while not false {
      continue 2.0
    }

    foo: bar
  }
  ~~~

  ~~~ css
  ~~~

- Cannot be used outside a loop

  ~~~ lay
  continue 2
  ~~~

  ~~~ RuntimeError
  Uncaught `continue`
  ~~~

  ~~~ lay
  .continue[illegal] {
    continue
  }
  ~~~

  ~~~ RuntimeError
  Uncaught `continue`
  ~~~
