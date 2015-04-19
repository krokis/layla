Lists
=====

- Can be made with spaces

  ~~~ lay
  lipsum = (lorem ipsum)
  border = 1px solid red
  $-shadow = ((((2px) (2px) 2 * 2 + 0px #000)))

  body {
    border: border
    box-shadow: $-shadow
    lorem: lipsum
    ipsum: (
      dolor,
      sit
    )
  }
  ~~~

  ~~~ css
  body {
    border: 1px solid red;
    box-shadow: 2px 2px 4px #000000;
    lorem: lorem ipsum;
    ipsum: dolor, sit;
  }
  ~~~

- Can be made with tabs

- Can be made with commas

  ~~~ lay
  $border = 1px, solid, red
  $l = (1,2,3,)

  body {
    border: $border
    content: $l
  }
  ~~~

  ~~~ css
  body {
    border: 1px, solid, red;
    content: 1, 2, 3;
  }
  ~~~

- Empty parens create empty lists

  ~~~ lay
  foo = ()
  bar = ((( )))

  body {
    foo: foo.length
    bar: bar.length
    bar << 'foo'
    bar << 'bar'
    bar: bar.length
    bar: bar
  }
  ~~~

  ~~~ css
  body {
    foo: 0;
    bar: 0;
    bar: 2;
    bar: 'foo' 'bar';
  }
  ~~~

- Explicit lists can be declared with one single element using a trailing comma

  ~~~ lay
  foo = ('foo',)
  bar = (0,)
  bar << 1
  body {
    "foo":foo
    "foo":foo.length
    "bar":bar::0 bar.length
  }
  ~~~

  ~~~ css
  body {
    foo: 'foo';
    foo: 1;
    bar: 0 2;
  }
  ~~~

- Multidimensional lists can be created by mixing commas and spaces and using parentheses

  ~~~ lay
  body, html {
    font: 14px ("Helvetica", "Arial", sans-serif) #666
    font: (14px "Helvetica"), "Arial", (sans-serif #666)
    font: 14px "Helvetica", "Arial", sans-serif #666
  }

  nums = (1 2 3), (a b c), (I II III)

  #bar {
    all: nums
    len: nums.length
    one: nums::0::0 nums::1::0 nums::2::0
    two: nums::0::1 nums::1::1 nums::2::1
    three: nums::0::2 nums::1::2 nums::2::2

    &.baz {
      nums = 1 2 3, a b c, I II III
      all: nums
      len: nums.length
      one: nums::0::0 nums::1::0 nums::2::0
      two: nums::0::1 nums::1::1 nums::2::1
      three: nums::0::2 nums::1::2 nums::2::2
    }
  }

  #baz {
    list = (1, 2, 3) (4, 5, 6), a b c
    a: list::0::0
    b: list::0::1
    c: list::1
  }

  l = (((),),)

  #l {
    l: l.length l::0.length l::0::0.length
  }
  ~~~

  ~~~ css
  body,
  html {
    font: 14px 'Helvetica', 'Arial', sans-serif #666666;
    font: 14px 'Helvetica', 'Arial', sans-serif #666666;
    font: 14px 'Helvetica', 'Arial', sans-serif #666666;
  }

  #bar {
    all: 1 2 3, a b c, I II III;
    len: 3;
    one: 1 a I;
    two: 2 b II;
    three: 3 c III;
  }

  #bar.baz {
    all: 1 2 3, a b c, I II III;
    len: 3;
    one: 1 a I;
    two: 2 b II;
    three: 3 c III;
  }

  #baz {
    a: 1, 2, 3;
    b: 4, 5, 6;
    c: a b c;
  }

  #l {
    l: 1 1 0;
  }
  ~~~

- Are always trueish

  ~~~ lay
  bar {
    foo: ().true? , not (1,).false?
  }
  ~~~

  ~~~ css
  bar {
    foo: true, true;
  }
  ~~~

## Methods

### `length`

- Returns the number of items in the list

  ~~~ lay
  l1 = (())
  l2 = 1 2 3 4 5 6
  l3 = 1 2 3 4 (5 6)

  body {
    foo: l1.length
    foo: l2.length
    foo: l3.length
    foo: (l3::4).length l3::4::0 + l3::4::1
    foo: l3::4.length
  }
  ~~~

  ~~~ css
  body {
    foo: 0;
    foo: 6;
    foo: 5;
    foo: 2 11;
    foo: 2;
  }
  ~~~

### `empty?`

- Tells if the list has no elements

  ~~~ lay
  foo: ().empty?
  bar: (null,).empty?
  baz: (1, 2).empty?
  ~~~

  ~~~ css
  foo: true;
  bar: false;
  baz: false;
  ~~~

### `empty`

- Removes all elements of the list in place and returns the empty list

  ~~~ lay
  foo = (1 2 3)
  foo.empty

  .foo {
    bar: foo.empty? foo.length
    bar: (a b c).empty << d
  }
  ~~~

  ~~~ css
  .foo {
    bar: true 0;
    bar: d;
  }
  ~~~

### `first`

- Returns the first element on the list, or `null` if it's empty

  ~~~ lay
  a = (1 2 3)
  b = ()
  foo {
    a: a.first
    b: b.first
  }
  ~~~

  ~~~ css
  foo {
    a: 1;
    b: null;
  }
  ~~~

### `last`

- Returns the last element on the list, or `null` if it's empty

  ~~~ lay
  a = (2,)
  b = ()
  foo {
    a: a.last (a.first is a.last)
    b: b.last
  }
  ~~~

  ~~~ css
  foo {
    a: 2 true;
    b: null;
  }
  ~~~

### `push`

- Adds one or more items to a list and returns the list

  ~~~ lay
  a = ()
  a.push(0)

  #numbers {
    first: a::0
    all: a
    a.push(1)
    a.push()
    all: a
    all: a.push(2)
    all: a.push(3)
    all: a.push(4)
    all: a << 5
    last = 6 >> a
    all: a
    last: last
  }
  ~~~

  ~~~ css
  #numbers {
    first: 0;
    all: 0;
    all: 0 1;
    all: 0 1 2;
    all: 0 1 2 3;
    all: 0 1 2 3 4;
    all: 0 1 2 3 4 5;
    all: 0 1 2 3 4 5 6;
    last: 6;
  }
  ~~~

### `unique?`

- Returns `true` if the list does not contain duplicated values

  ~~~ lay
  a: ().unique?
  b: (1,2,3).unique?
  c: (1,"2",#fff).unique?
  d: (1,2,1).unique?
  e: (1,1,2,1).unique?
  f: (#f,#ffffff,red).unique?
  ~~~~

  ~~~ css
  a: true;
  b: true;
  c: true;
  d: false;
  e: false;
  f: false;
  ~~~~

### `unique`

- Returns a copy of the list with duplicated values removed

  ~~~ lay
  a = (0 1 1 2 3 1 4 5 5 2)
  foo: a.unique
  bar: a
  ~~~

  ~~~ css
  foo: 0 1 2 3 4 5;
  bar: 0 1 1 2 3 1 4 5 5 2;
  ~~~

### `pop`

- Removes the last element of the list and returns it

  ~~~ lay
  foo: ().pop
  foo: (1,).pop
  foo: (1px,2px).pop
  ~~~

  ~~~ css
  foo: null;
  foo: 1;
  foo: 2px;
  ~~~

### `shift`

- Takes one element off the begining of the list and returns it

  ~~~ lay
  foo: ().shift
  foo: (1,).shift
  foo: (1px,2px).shift
  ~~~

  ~~~ css
  foo: null;
  foo: 1;
  foo: 1px;
  ~~~

### `unshift`

- Inserts one or more element at the the begining of the list and returns the list

  ~~~ lay
  l = ()
  l.unshift(1px, 2px)
  foo: l
  foo: l.unshift(3px)
  l.unshift
  foo: l
  ~~~

  ~~~ css
  foo: 1px 2px;
  foo: 3px 1px 2px;
  foo: 3px 1px 2px;
  ~~~

### `slice`

- Returns a slice of the list

  ~~~ lay
  l = 1px 2px 3px
  foo: l.slice(0)
  foo: l.slice(0, 2)
  foo: l.slice(2, 3)
  foo: l.slice(2, 4)
  ~~~

  ~~~ css
  foo: 1px 2px 3px;
  foo: 1px 2px;
  foo: 3px;
  foo: 3px;
  ~~~

- Can be called without arguments

  ~~~ lay
  foo: (1px 2px 3px).slice
  ~~~

  ~~~ css
  foo: 1px 2px 3px;
  ~~~

- Can be used with negative indices

### `splice`

### `max`

### `min`

## Operators

### `is`

- Returns `true` only if the other operand is a collection and has equal elements, in the same order.

  ~~~ lay
  a: (1 2 3) is (1, 2, 3)
  b: (1 2 3) isnt (1, 2)
  c: (1 2) isnt (1, 2, 3)
  d: (1 2 2 3) isnt (1, 2, 3)
  e: () is ()
  f: (0,) is (() << 0)
  g: (a b c) is ('a' `b` "c")
  h: (1 2 3) isnt (1 `2` 3)
  i: (1 2 3) isnt (2 1 3)
  ~~~

  ~~~ css
  a: true;
  b: true;
  c: true;
  d: true;
  e: true;
  f: true;
  g: true;
  h: true;
  i: true;
  ~~~

### `has`

- Returns `true` if the collection has an object equal to the passed

  ~~~ lay
  a = (1 2 3 4 5)

  foo: a has 1
  foo: a has 6
  foo: a has '2'
  ~~~

  ~~~ css
  foo: true;
  foo: false;
  foo: false;
  ~~~

### `hasnt`

- Is the negated version of `has`

  ~~~ lay
  a = (1 2 3 4 5)

  foo: a hasnt 1
  foo: a hasnt 6
  foo: a hasnt '2'
  ~~~

  ~~~ css
  foo: false;
  foo: true;
  foo: true;
  ~~~

### `in`

- Is the same of `has`, with switched operands

  ~~~ lay
  a = (1 2 3 4 5)

  foo: 1 in a
  foo: 6 in a
  foo: '2' in a
  ~~~

  ~~~ css
  foo: true;
  foo: false;
  foo: false;
  ~~~

### `+`

- Concatenates lists

  ~~~ lay
  a = 1 2

  body {
    foo: a
    foo: a + (3 4)
    a = a + (5,)
    foo: a
  }
  ~~~

  ~~~ css
  body {
    foo: 1 2;
    foo: 1 2 3 4;
    foo: 1 2 5;
  }
  ~~~

### `::`

- Access the items of the list by their numeric index

  ~~~ lay
  body {
    border: 1px solid red
    box-shadow: (((2px 2px (4px) #000)))
  }

  lipsum = (lorem ipsum dolor sit)

  lipsum {
    all: lipsum
    foo: lipsum::0
    bar: lipsum::(2 + 1)
  }
  ~~~

  ~~~ css
  body {
    border: 1px solid red;
    box-shadow: 2px 2px 4px #000000;
  }

  lipsum {
    all: lorem ipsum dolor sit;
    foo: lorem;
    bar: sit;
  }
  ~~~

- Can be used with negative indices

  ~~~ lay
  a = 1 2 3 4

  body {
    len: a.length
    foo: a::-1
    foo: a::(-2)
    foo: a::(-0)
    foo: a::-(a.length)
  }
  ~~~

  ~~~ css
  body {
    len: 4;
    foo: 4;
    foo: 3;
    foo: 1;
    foo: 1;
  }
  ~~~

- Returns `null`s for indices out of bounds

  ~~~ lay
  a = null 2 3 4

  body {
    foo: a::0
    foo: a::1
    foo: a::5
    foo: a::-(a.length + 1)
  }
  ~~~

  ~~~ css
  body {
    foo: null;
    foo: 2;
    foo: null;
    foo: null;
  }
  ~~~

- Returns multiple elements if a list is passed, including nulls

  ~~~ lay
  a = 1 2 3 4 5 6 7

  body {
    foo: a::(0, 2, 4, 12, -1, -8)
  }
  ~~~

  ~~~ css
  body {
    foo: 1 3 5 null 7 null;
  }
  ~~~

- Returns a slice of the list if a range is supplied

  ~~~ lay
  a = 1 2 3 4 5 6 7

  body {
    bar: a::(0..2)
    bar: a::(0..-1)
    bar: a::(-5..-3)
    bar: a::(-2..0)
    bar: a::(-2..2)
    bar: a::(9..11)
  }
  ~~~

  ~~~ css
  body {
    bar: 1 2 3;
    bar: 1 7;
    bar: 3 4 5;
    bar: 6 7 1;
    bar: 6 7 1 2 3;
    bar: null null null;
  }
  ~~~

- Lists with ranges work as expected

  ~~~ lay
  a = 1 2 3 4 5 6 7

  body {
    prime: a::(0..2, 4, 6)
    bar: a::(-9..-5, 9, -1, 1 0..2)
  }
  ~~~

  ~~~ css
  body {
    prime: 1 2 3 5 7;
    bar: null null 1 2 3 null 7 2 1 2 3;
  }
  ~~~

- When a list is passed, the list returned should have right side separator, which is not what the previous test says

### `<<` and `>>`

- Pushes objects to a list

  ~~~ lay
  #list {
    foo: () << 1
    foo: (1, 2, 3, 4) << 5
    l = (0,)
    1px >> l
    2rm >> l
    bar: l
  }
  ~~~

  ~~~ css
  #list {
    foo: 1;
    foo: 1, 2, 3, 4, 5;
    bar: 0, 1px, 2rm;
  }
  ~~~

- Always returns the receiver

  ~~~ lay
  foo: (0,) << 1px << 2px
  bar: 1px >> (0,) >> (1 2)
  ~~~

  ~~~ css
  foo: 0, 1px, 2px;
  bar: 1 2 0, 1px;
  ~~~