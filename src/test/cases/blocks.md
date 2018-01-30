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
  a = { p { color: #fff } }

  bar {
    foo: {}.true? ({ border: #f00}).true? (not a.false?) a::0.true? a.empty.true?
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
    color: #f00
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
    -moz-border-color: #f00;
    -webkit-border-color: #f00;
    border-color: #f00;
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
    #{$border-color}: #000
    width,height: 20px

    p { background-color: #fff; color, border-color, decoration-color: #666 }
  }
  ~~~

  ~~~ css
  body {
    margin: 0;
    padding: 0;
    background-color: #000;
    color: #000;
    border-color: #000;
    width: 20px;
    height: 20px;
  }

  body p {
    background-color: #fff;
    color: #666;
    border-color: #666;
    decoration-color: #666;
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
        meet: you.raw
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
    been: "tryin'" to meet you;
  }
  ~~~

- When their content is a block, they are expanded with the block properties

  ~~~~ lay
  body {
    background: {
      color: #fff
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
    background-color: #fff;
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
    color: #f00
    border-left-width, border-right-width|: 1px
    font|: null
    color|: #00f
    border-left-width|: 2px
    border-top-width|: 2px
    font|: 'Arial'
    margin: 0
    margin, padding|: 20px
  }
  ~~~

  ~~~ css
  body {
    color: #f00;
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
    border: 1px solid #f00

    p {
      color: #fff
      border: none
    }
    color: #666
    font-size: 14px
    font-size: 14px

    @media screen {
      color: #fff
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
    -foo-border: 1px solid #f00;
    -foo-color: #666;
    -foo-font-size: 14px;
    -foo-font-size: 14px;
  }

  body .unique {
    -foo-border: 1px solid #f00;
    -foo-color: #666;
    -foo-font-size: 14px;
  }
  ~~~

### `.has-property?`

- Returns `true` if the block has a property with given name, even if it's `null`.

  ~~~~ lay
  block.has-property {
    color: red
    has-color: &.has-property?(color)
    has-background-color: &.has-property?(background-color)
    background-color: #fff
    has-background-color: &.has-property?(background-color)
    border: null
    has-border: &.has-property?("border")
    has-shadow: &.has-property?(`shadow`)
  }
  ~~~~

  ~~~~ css
  block.has-property {
    color: #f00;
    has-color: true;
    has-background-color: false;
    background-color: #fff;
    has-background-color: true;
    border: null;
    has-border: true;
    has-shadow: false;
  }
  ~~~~

- Is case sensitive

  ~~~~ lay
  body {
    color: #f00
    has-color: &.has-property?(color)
    has-Color: &.has-property?(Color)
  }
  ~~~~

  ~~~~ css
  body {
    color: #f00;
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
    color: #666;
    font-family: Helvetica;
    font-size: 14px;
  }

  a {
    color: #00f;
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

  foo = { color: #f00 }

  color: foo::color
  color: foo::`color`
  color = #fff
  color: foo::color
  color: foo::`color`
  ~~~

  ~~~ css
  #hey {
    been: "tryin' to meet you!";
    must: "be a devil between us";
  }

  color: #f00;
  color: #f00;
  color: #f00;
  color: #f00;
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
    but: hey\!.raw
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
    border: #f00
    div {
      color: #fff
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
    color: #f00
    background-color: #fff
  }

  $b::color = $b::`background-color`
  $b::"background-color" = #f00

  body {
    color: $b::color
    background-color: $b::background-color
  }
  ~~~

  ~~~ css
  body {
    color: #fff;
    background-color: #f00;
  }
  ~~~

- Adds properties to the block

  ~~~ lay
  $b = {
    color: #666
  }

  $b::color |= #f00
  $b::background-color |= #fff
  $b::margin = 0px

  body {
    color: $b::color
    background-color: $b::background-color
    margin: $b::margin
  }
  ~~~

  ~~~ css
  body {
    color: #666;
    background-color: #fff;
    margin: 0;
  }
  ~~~
