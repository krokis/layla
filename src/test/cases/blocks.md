Blocks
======

- Are declared with `{ ... }`

  ~~~ lay
  blck = {
    foo: bar
  }
  ~~~

  ~~~ css
  ~~~

- Can be empty

  ~~~ lay
  blck = {}
  ~~~

  ~~~ css
  ~~~

- Are always trueish

  ~~~ lay
  a = { p { color: white } }

  bar {
    foo: {}.true? ({ border: red}).true? (not a.false?) a::0.true? a.empty.true?
  }
  ~~~

  ~~~ css
  bar {
    foo: true true true true true;
  }
  ~~~

## Declarations

- Add properties to a block

  ~~~ lay
  hey {
    been-tryin: "to meet you!"
  }
  ~~~

  ~~~ css
  hey {
    been-tryin: "to meet you!";
  }
  ~~~

- Support interpolation on the name

  ~~~ lay
  $border = {
    radius: 4px
    color: red
    width: 1px
    style: solid
  }

  $vendors = -moz- -webkit-

  div {
    $prop = 'border'

    for $p in $border.properties {
      $name = "#{$prop}-#{$p.name}"

      for $v in $vendors {
        #{$v}#{$name}: $p.value
      }
      #{$name}: $p.value
    }
  }
  ~~~

  ~~~ css
  div {
    -moz-border-radius: 4px;
    -webkit-border-radius: 4px;
    border-radius: 4px;
    -moz-border-color: red;
    -webkit-border-color: red;
    border-color: red;
    -moz-border-width: 1px;
    -webkit-border-width: 1px;
    border-width: 1px;
    -moz-border-style: solid;
    -webkit-border-style: solid;
    border-style: solid;
  }
  ~~~

- Can be used to set multiple properties at once

  ~~~ lay
  $border-color = 'border-color'
  body {
    margin, padding: 0
    background-color,
    color,
    #{$border-color}: black
    width,height: 20px

    p { background-color: white; color, border-color, decoration-color: #666 }
  }
  ~~~

  ~~~ css
  body {
    margin: 0;
    padding: 0;
    background-color: black;
    color: black;
    border-color: black;
    width: 20px;
    height: 20px;
  }

  body p {
    background-color: white;
    color: #666666;
    border-color: #666666;
    decoration-color: #666666;
  }
  ~~~

- Can have any value, even other blocks

  ~~~ lay
  a = {
    border: {
      left: 1px
      top: 2px
      right: 1px
      bottom: 2px
    }

    hey: {
      been: "tryin'"
      to: {
        meet: you!
      }
    }
    {
      bare: block
    }
  }

  hey {
    been: a::hey::been `to meet` a::hey::to::meet
  }
  ~~~

  ~~~ css
  hey {
    been: "tryin'" to meet you!;
  }
  ~~~

- When their content is a block, they are expanded with the block properties

  ~~~~ lay
  body {
    background: {
      color: white
      image: url('/back.png')
    }

    margin: {
      left: 1px
      top: 2px
      right: 3px
      bottom: 4px
    }
  }
  ~~~~

  ~~~~ css
  body {
    background-color: white;
    background-image: url("/back.png");
    margin-left: 1px;
    margin-top: 2px;
    margin-right: 3px;
    margin-bottom: 4px;
  }
  ~~~~

- Can use `|:` to conditionally set the property only a property with the same name has not been already or if it's `null`

  ~~~ lay
  body {
    color: red
    border-left-width, border-right-width|: 1px
    font|: null
    color|: blue
    border-left-width|: 2px
    border-top-width|: 2px
    font|: 'Arial'
    margin: 0
    margin, padding|: 20px
  }
  ~~~

  ~~~ css
  body {
    color: red;
    border-left-width: 1px;
    border-right-width: 1px;
    font: null;
    border-top-width: 2px;
    font: "Arial";
    margin: 0;
    padding: 20px;
  }
  ~~~

- Empty properties are not output

## Methods

### `properties`

- Returns all properties as a list

  ~~~ lay
  $b = {
    border: 1px solid red

    p {
      color: white
      border: none
    }
    color: #666
    font-size: 14px
    font-size: 14px

    @media screen {
      color: white
    }
  }

  body {
    for $p in $b.properties {
      -foo-#{$p.name}: $p.value
    }

    .unique {
      for $p in $b.properties.unique {
        -foo-#{$p.name}: $p.value
      }
    }
  }
  ~~~

  ~~~ css
  body {
    -foo-border: 1px solid red;
    -foo-color: #666666;
    -foo-font-size: 14px;
    -foo-font-size: 14px;
  }

  body .unique {
    -foo-border: 1px solid red;
    -foo-color: #666666;
    -foo-font-size: 14px;
  }
  ~~~

### `.has-property?`

- Returns `true` if the block has a property with given name, and it's not `null`.

  ~~~~ lay
  body {
    color: red
    has-color: &.has-property?(color)
    has-background-color: &.has-property?(background-color)
    background-color: white
    has-background-color: &.has-property?(background-color)
  }
  ~~~~

  ~~~~ css
  body {
    color: red;
    has-color: true;
    has-background-color: false;
    background-color: white;
    has-background-color: true;
  }
  ~~~~

- Is case sensitive

  ~~~~ lay
  body {
    color: red
    has-color: &.has-property?(color)
    has-Color: &.has-property?(Color)
  }
  ~~~~

  ~~~~ css
  body {
    color: red;
    has-color: true;
    has-Color: false;
  }
  ~~~~

### `rules`

- Returns child rules as a list

  ~~~~ lay
  $b = {
    color: #666
    a {
      color:  #00f
    }
    font-family: Helvetica
    b {
      font-weight: 700
    }
    font-size: 14px
  }

  * {
    for prop in $b.properties {
      &.push(prop)
    }
  }

  for rule in $b.rules {
    &.push(rule)
  }
  ~~~~

  ~~~~ css
  * {
    color: #666666;
    font-family: Helvetica;
    font-size: 14px;
  }

  a {
    color: #0000ff;
  }

  b {
    font-weight: 700;
  }
  ~~~~

## Operators

### `::`

- Returns items of the block by their index

  ~~~ lay
  $hey = {
    been: "tryin' to meet you!"
    must: 'be a devil between us'
  }

  #hey {
    been: $hey::0.value
    must: $hey::1.value
  }
  ~~~

  ~~~ css
  #hey {
    been: "tryin' to meet you!";
    must: "be a devil between us";
  }
  ~~~

- Returns properties values by their name

  ~~~ lay
  $hey = {
    been: "tryin' to meet you!"
    must: 'be a devil between us'
  }

  #hey {
    been: $hey::been
    must: $hey::(`must`)
  }

  foo = { color: red }

  color: foo::color
  color: foo::`color`
  color = white
  color: foo::color
  color: foo::`color`
  ~~~

  ~~~ css
  #hey {
    been: "tryin' to meet you!";
    must: "be a devil between us";
  }

  color: red;
  color: red;
  color: red;
  color: red;
  ~~~

- If the passed property name has been defined more than once, returns the latest value

  ~~~ lay
  $hey = {
    been: "tryin' to meet you!"
    but: `eh...`
    must: 'be a devil between us'
    but: hey
    or: {
      whores: 'in my head'
      whores: 'at the door'
    }
    but: hey?
    but: hey!
  }

  #hey {
    been: $hey::been
    must: $hey::`must`
    or: whores $hey::or::whores
    or: whores $hey::or::0.value
    but: $hey::(but)
  }
  ~~~

  ~~~ css
  #hey {
    been: "tryin' to meet you!";
    must: "be a devil between us";
    or: whores "at the door";
    or: whores "in my head";
    but: hey!;
  }
  ~~~

- Returns `null` for indices or names which have not been set

  ~~~ lay
  obj = {
    border: red
    div {
      color: white
    }
  }

  body {
    foo: obj::border.null?
    foo: (obj::0).null?
    foo: (obj::1).null?
    foo: (obj::1::0).null?
    foo: (obj::1::1).null?
    foo: obj::border-color.null?
    foo: obj::(-8).null?
  }
  ~~~

  ~~~ css
  body {
    foo: false;
    foo: false;
    foo: false;
    foo: false;
    foo: true;
    foo: true;
    foo: true;
  }
  ~~~

### `::=`

- Updates existing properties by their name

  ~~~ lay
  $b = {
    color: red
    background-color: white
  }

  $b::color = $b::`background-color`
  $b::"background-color" = red

  body {
    color: $b::color
    background-color: $b::background-color
  }
  ~~~

  ~~~ css
  body {
    color: white;
    background-color: red;
  }
  ~~~

- Adds properties to the block

  ~~~ lay
   $b = {
    color: #666
  }

  $b::color |= red
  $b::background-color |= white
  $b::margin = 0px

  body {
    color: $b::color
    background-color: $b::background-color
    margin: $b::margin
  }
  ~~~

  ~~~ css
  body {
    color: #666666;
    background-color: white;
    margin: 0;
  }
  ~~~
