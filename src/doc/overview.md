#  Overview

## Rule blocks

You can write rule-sets the usual way:

~~~ lay
html body {
  margin: 0;
  padding: 0;
  background-color: white;
  color: #666;
}
~~~

~~~ css
html body {
  margin: 0;
  padding: 0;
  background-color: white;
  color: #666666;
}
~~~

Generally, you can omit the semicolon at the end of a line, if it ends with a valid statement. This means you can forget about semicolons if you write each declaration in a separate line:

~~~ lay
html body {
  margin: 0
  padding: 0
  background-color: white
  color: #666
}
~~~

~~~ css
html body {
  margin: 0;
  padding: 0;
  background-color: white;
  color: #666666;
}
~~~

Layla allows you to declare multiple properties with the same value at once. Just write a list of names separated with commas at the left of a property declaration:

~~~ lay
html > body {
  margin, padding: 0
}

img.avatar {
  width, height: 80px
}
~~~

~~~ css
html > body {
  margin: 0;
  padding: 0;
}

img.avatar {
  height: 80px;
  height: 80px;
}
~~~

You can of course nest your rule-sets and use `&` to reference a parent selector:

~~~ lay
html {
  body {
    margin, padding: 0
    background-color: white

    p, & {
      color: #666
    }

    a {
      p & {
        color: blue

        &:link,
        &:active,
        &:visited,
        &:active {
          text-decoration: underline
        }
      }
    }
  }
}

~~~

~~~ css
html body {
  margin: 0;
  padding: 0;
  background-color: white;
}

html body p,
html body {
  color: #666666;
}

html body p a {
  color: blue;
}

html body p a:link,
html body p a:active,
html body p a:visited,
html body p a:active {
  text-decoration: underline;
}
~~~

At-rules work the same way. You can nest your `@media` rules inside rule sets or other at-rules:

## Comments

## Variables and expressions

Layla supports booleans, quoted and unquoted strings, numbers, colors, URL's, regular expresssions, lists, blocks, ranges and `null`. You can create any instance of these types, assign to variables and operate them to produce your style sheets.

You define variables with the `=` operator and use them all around. Variable names may contain letters, numbers and even any of the following symbols: `-_$!?`.

~~~ lay
$family = 'Helvetica'
$size = 13px
$weight = normal
$_font = $size $family $weight

could-you-please? = !important

body {
  font: $_font

  a {
    font-size: $size + 2px could-you-please?
  }
}
~~~

~~~ css
body {
  font: 13px 'Helvetica' normal;
}

body a {
  font-size: 15px !important;
}
~~~

The `|=` operator performs the assignment only if the left side has not been defined before or if it's `null`:

~~~ lay
$size = 14px
$family = null

body {
  $size   |= 12px
  $family |= 'Helvetica'
  $weight |= normal

  font: $size $family $weight
}
~~~

~~~ css
body {
  font: 14px 'Helvetica' normal;
}
~~~

### Strings

### Numbers

### Lists and ranges

### Blocks

Blocks, like those in rule sets and at-rules, are first-class types in Layla and are written within braces `{ ... }`. You can use them to group properties and other blocks and access them with the `::` operator just as you would do with a dictionary or a hash object:

~~~ lay
$bg = {
  color: white
  image: url(/background.png)
  repeat: no-repeat
  position: center
}

body {
  background: $bg::color $bg::image $bg::repeat $bg::position
}
~~~

~~~ css
body {
  background: white url(/background.png) no-repeat center;
}
~~~

Inside a block definition, any arbitrary code is allowed. Only declarations (properties, rule sets and at-rules) are added to the block, and thus output:

~~~ lay-todo
$center = true
$white = true

body {
  $bg = {
    if $white {
      color: white
    } else {
      color: black
    }
    image: url(/img/background.png)
    repeat: no-repeat
    position: top left
  }

  if $center {
    $bg::position = center
  }

  background: $bg::color $bg::image $bg::repeat $bg::position
}
~~~

~~~ css-todo
body {
  background: white url(/img/background.png) no-repeat center;
}
~~~

Blocks make scopes.

### Other types

### Methods and operators

~~~ lay
Number {

  $num = 27.45cm

  methods {
    zero:        $num.zero?
    odd:         $num.odd?
    even:        $num.even?
    decimal:     $num.decimal?
    integer:     $num.integer?
    round:       $num.round
    ceil:        $num.ceil
    floor:       $num.floor
    positive:    $num.positive?
    negative:    $num.negative?
    pure:        $num.pure?,
                 $num.pure
    unit:        $num.unit,
                 $num.pure.unit
  }

  operators {
    unary:       +$num,
                 -($num)
    sum:         $num + 17
    substract:   $num - 27
    divide:      $num / 2
    multiply:    $num * 2
    comparison:  $num is 27.45,
                 $num isnt 27.45em,
                 $num > 20,
                 $num < 20,
                 $num >= 27,
                 $num <= 30
    cast:       ($num)mm
  }
}

String {

  $str = "  Lorem ipsum dolor sit  "

  methods {
    length:      $str.length
    empty:       $str.empty?
    white:       $str.blank?
    trim:        $str.trim
    quoted:      $str.quoted?,
                 $str.trim.quoted
    unquoted:    $str.unquoted?,
                 $str.unquoted
  }

  operators {
  }
}

RegExp {
  $reg-exp = /.*/gi

  methods {
    global:      $reg-exp.global?
    multiline:   $reg-exp.multiline?
    insensitive: $reg-exp.insensitive?
    sensitive:   $reg-exp.sensitive?
  }

  operators {
  }
}

Color {
  methods {}

  operators {}
}

Range {
  methods {
  }

  operators {
  }
}

List {
  $list = 1 2 3

  methods {
    length:       $list.length
    empty:        $list.empty?,
                  $list.copy.empty.length
    push:         $list.copy.push(4)
    first:        $list.first
    last:         $list.last
  }

  operators {
  }
}

Block {
  methods {
  }

  operators {
  }
}

URL {
  $url = url('http://example.org/search?q=foo#top')

  methods {
    absolute: $url.absolute?
    relative: $url.relative?
    http:     $url.http?,
              $url.http
    https:    $url.https?,
              $url.https
    scheme:   $url.scheme,
              $url.protocol
    host:     $url.host
    port:     $url.port
    path:     $url.path
    query:    $url.query
    hash:     $url.hash
  }

  operators {
    sum:      $url + '/home'
  }
}

Boolean {
  methods {
    true:        true.true?,
                 false.true?,
                 null.true?,
                 0.true?,
                 ''.true?,
                 #0000.true?,
                 ().true?,
                 {}.true?,
                 (0..0).true?
    false:       true.false?,
                 false.false?,
                 null.false?,
                 0.false?,
                 ''.false?,
                 #0000.false?,
                 ().false?,
                 {}.false?,
                 (0..0).false?
  }

  operators {
    unary:       not false
    and:         true and true
    or:          false or true
  }
}

Null {
  methods {
    null:        true.null?,
                 false.null?,
                 null.null?,
                 0.null?,
                 ''.null?,
                 #0000.null?,
                 ().null?,
                 {}.null?,
                 (0..0).null?
  }
}
~~~

~~~ css
Number methods {
  zero: false;
  odd: true;
  even: false;
  decimal: true;
  integer: false;
  round: 27cm;
  ceil: 28cm;
  floor: 27cm;
  positive: true;
  negative: false;
  pure: false, 27.45;
  unit: cm, null;
}

Number operators {
  unary: 27.45cm, -27.45cm;
  sum: 44.45cm;
  substract: 0.45cm;
  divide: 13.73cm;
  multiply: 54.9cm;
  comparison: true, true, true, false, true, true;
  cast: 274.5mm;
}

String methods {
  length: 25;
  empty: false;
  white: false;
  trim: 'Lorem ipsum dolor sit';
  quoted: true, 'Lorem ipsum dolor sit';
  unquoted: false, Lorem ipsum dolor sit;
}

RegExp methods {
  global: true;
  multiline: false;
  insensitive: true;
  sensitive: false;
}

List methods {
  length: 3;
  empty: false, 0;
  push: 1 2 3 4;
  first: 1;
  last: 3;
}

URL methods {
  absolute: true;
  relative: false;
  http: true, url('http://example.org/search?q=foo#top');
  https: false, url('https://example.org/search?q=foo#top');
  scheme: 'http', 'http';
  host: 'example.org';
  port: null;
  path: '/search';
  query: 'q=foo';
  hash: 'top';
}

URL operators {
  sum: url('http://example.org/home');
}

Boolean methods {
  true: true, false, false, true, true, true, true, true, true;
  false: false, true, true, false, false, false, false, false, false;
}

Boolean operators {
  unary: true;
  and: true;
  or: true;
}

Null methods {
  null: false, false, true, false, false, false, false, false, false;
}
~~~

## Conditionals

## Loops

## `&`

## Functions

## Imports

## Plugins
