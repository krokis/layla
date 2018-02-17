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

  ~~~ lay
  lists:tabs {
    i: "\t1\t\t2 3  4  \t5".eval
  }
  ~~~

  ~~~ css
  lists:tabs {
    i: 1 2 3 4 5;
  }
  ~~~

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
    bar.push('foo')
    bar.push('bar')
    bar: bar.length
    bar: bar
  }
  ~~~

  ~~~ css
  body {
    foo: 0;
    bar: 0;
    bar: 2;
    bar: "foo" "bar";
  }
  ~~~

- Explicit lists can be declared with one single element using a trailing comma

  ~~~ lay
  foo = ('foo',)
  bar = (0,)
  bar.push(1)
  body {
    foo:foo
    foo:foo.length
    bar:bar::0 bar.length
  }
  ~~~

  ~~~ css
  body {
    foo: "foo";
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
    font: (14px "Helvetica", "Arial", sans-serif #666).flatten
  }

  $nums = (1 2 3), (a b c), (I II III)

  #bar {
    all: $nums
    len: $nums.length
    one: $nums::0::0 $nums::1::0 $nums::2::0
    two: $nums::0::1 $nums::1::1 $nums::2::1
    three: $nums::0::2 $nums::1::2 $nums::2::2

    &.baz {
      $nums = 1 2 3, a b c, I II III
      all: $nums
      len: $nums.length
      one: $nums::0::0 $nums::1::0 $nums::2::0
      two: $nums::0::1 $nums::1::1 $nums::2::1
      three: $nums::0::2 $nums::1::2 $nums::2::2
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
    font: 14px "Helvetica", "Arial", sans-serif #666666;
    font: 14px "Helvetica", "Arial", sans-serif #666666;
    font: 14px "Helvetica", "Arial", sans-serif #666666;
    font: 14px, "Helvetica", "Arial", sans-serif, #666666;
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
    bar: (a b c).empty.push(d)
  }
  ~~~

  ~~~ css
  .foo {
    bar: true 0;
    bar: d;
  }
  ~~~

### `contains?`

- Returns `true` if the list contains the passed value

  ~~~ lay
  a = (1 2 3 4 5)

  foo: a.contains?(1)
  foo: a.contains?(6)
  foo: a.contains?('2')
  ~~~

  ~~~ css
  foo: true;
  foo: false;
  foo: false;
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
    a: a.last (a.first == a.last)
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
    all: a.push(5)
    last = a.push(6)
    all: a
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
  list.slice {
    foo: (1px 2px 3px).slice
  }
  ~~~

  ~~~ css
  list.slice {
    foo: 1px 2px 3px;
  }
  ~~~

- Can be used with negative indices

  ~~~ lay
  $list = 1 2 3 4 5
  list.slice {
    i: $list.slice(-1)
    ii: $list.slice(-2)
    iii: $list.slice(-5)
    iv: $list.slice(-999)
  }
  ~~~

  ~~~ css
  list.slice {
    i: 5;
    ii: 4 5;
    iii: 1 2 3 4 5;
    iv: 1 2 3 4 5;
  }
  ~~~

### `flatten`

- Flattens the list and contained lists recursively into one dimension list

  ~~~ lay
  list.flatten {
    i: (1 2 3).flatten
    ii: (1, 2, 3, 4 5).flatten
    iii: (1, 2, 3, (4, (5, 6))).flatten
  }
  ~~~

  ~~~ css
  list.flatten {
    i: 1 2 3;
    ii: 1, 2, 3, 4, 5;
    iii: 1, 2, 3, 4, 5, 6;
  }
  ~~~

### `max`

- Returns the maximum value in the list

  ~~~ lay
  list.max {
    foo: (1, +71, 2, 3, -1, 5).max
    foo: (b 'a' `d` "c" ).max.quoted
  }
  ~~~

  ~~~ css
  list.max {
    foo: 71;
    foo: "d";
  }
  ~~~

### `min`

- Returns the minimum value in the list

  ~~~ lay
  list.min {
    foo: (1, +71, 2, 3, -1, 5).min
    foo: (b 'a' `d` "c" ).min.quoted
  }
  ~~~

  ~~~ css
  list.min {
    foo: -1;
    foo: "a";
  }
  ~~~

## Operators

### `==`

- Returns `true` only if the other operand is a collection and has equal elements, in the same order.

  ~~~ lay
  list[operator="=="] {
    a: (1 2 3) == (1, 2, 3)
    b: (1 2 3) == (1, 2)
    c: (1 2) == (1, 2, 3)
    d: (1 2 2 3) == (1, 2, 3)
    e: () == ()
    f: (0,) == (().push(0))
    g: (a b c) == ('a' `b` "c")
    h: (1 2 3) == (1 `2` 3)
    i: (1 2 3) == (2 1 3)
  }
  ~~~

  ~~~ css
  list[operator="=="] {
    a: true;
    b: false;
    c: false;
    d: false;
    e: true;
    f: true;
    g: true;
    h: false;
    i: false;
  }
  ~~~

### `!=`

- Returns `false` only if the other operand is a collection and has equal elements, in the same order.

  ~~~ lay
  list[operator="!="] {
    a: (1 2 3) != (1, 2, 3)
    b: (1 2 3) != (1, 2)
    c: (1 2) != (1, 2, 3)
    d: (1 2 2 3) != (1, 2, 3)
    e: () != ()
    f: (0,) != (().push(0))
    g: (a b c) != ('a' `b` "c")
    h: (1 2 3) != (1 `2` 3)
    i: (1 2 3) != (2 1 3)
  }
  ~~~

  ~~~ css
  list[operator="!="] {
    a: false;
    b: true;
    c: true;
    d: true;
    e: false;
    f: false;
    g: false;
    h: true;
    i: true;
  }
  ~~~

### `has`

- Returns `true` if the collection has an object equal to the passed

  ~~~ lay
  list[operator="has"] {
    a = (1 2 3 4 5)

    i: a has 1
    ii: a has 6
    iii: a has '2'
  }
  ~~~

  ~~~ css
  list[operator="has"] {
    i: true;
    ii: false;
    iii: false;
  }
  ~~~

### `hasnt`

- Is the negated version of `has`

  ~~~ lay
  a = (1 2 3 4 5)

  list[operator="hasnt"] {
    i: a hasnt 1
    ii: a hasnt 6
    iii: a hasnt '2'
  }
  ~~~

  ~~~ css
  list[operator="hasnt"] {
    i: false;
    ii: true;
    iii: true;
  }
  ~~~

### `in`

- Calls `contains?` on the right operand

  ~~~ lay
  a = (1 2 3 4 5)

  list[operator="contains"] {
    i: 1 in a
    ii: 6 in a
    iii: '2' in a
  }
  ~~~

  ~~~ css
  list[operator="contains"] {
    i: true;
    ii: false;
    iii: false;
  }
  ~~~

### `+`

- Concatenates lists

  ~~~ lay
  $a = 1 2

  list[operator="+"] {
    i: $a
    ii: $a + (3 4)
    $a = $a + (5,)
    iii: $a
  }
  ~~~

  ~~~ css
  list[operator="+"] {
    i: 1 2;
    ii: 1 2 3 4;
    iii: 1 2 5;
  }
  ~~~

### `::`

- Accesses the items of the list by their numeric index

  ~~~ lay
  list[operator="::"] {
    border: 1px solid red
    box-shadow: (((2px 2px (4px) #000)))
  }

  lipsum = (lorem ipsum dolor sit)

  list[operator="::"] {
    all: lipsum
    foo: lipsum::0
    bar: lipsum::(2 + 1)
  }
  ~~~

  ~~~ css
  list[operator="::"] {
    border: 1px solid red;
    box-shadow: 2px 2px 4px #000000;
  }

  list[operator="::"] {
    all: lorem ipsum dolor sit;
    foo: lorem;
    bar: sit;
  }
  ~~~

- Can be used with negative indices

  ~~~ lay
  a = 1 2 3 4

  list[operator="::"] {
    len: a.length
    foo: a::-1
    foo: a::(-2)
    foo: a::(-0)
    foo: a::-(a.length)
  }
  ~~~

  ~~~ css
  list[operator="::"] {
    len: 4;
    foo: 4;
    foo: 3;
    foo: 1;
    foo: 1;
  }
  ~~~

- Returns `null` for indices out of bounds

  ~~~ lay
  a = null 2 3 4

  list[operator="::"] {
    foo: a::0
    foo: a::1
    foo: a::5
    foo: a::-(a.length + 1)
  }
  ~~~

  ~~~ css
  list[operator="::"] {
    foo: null;
    foo: 2;
    foo: null;
    foo: null;
  }
  ~~~

- Returns multiple elements if a list is passed, including `null`'s

  ~~~ lay
  a = 1 2 3 4 5 6 7

  list[operator="::"] {
    foo: a::(0, 2, 4, 12, -1, -8)
  }
  ~~~

  ~~~ css
  list[operator="::"] {
    foo: 1 3 5 null 7 null;
  }
  ~~~

- Returns a slice of the list if a range is supplied

  ~~~ lay
  a = 1 2 3 4 5 6 7

  list[operator="::"] {
    bar: a::(0..2)
    bar: a::(0..-1)
    bar: a::(-5..-3)
    bar: a::(-2..0)
    bar: a::(-2..2)
    bar: a::(9..11)
  }
  ~~~

  ~~~ css
  list[operator="::"] {
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

  list[operator="::"] {
    prime: a::(0..2, 4, 6)
    bar: a::(-9..-5, 9, -1, 1 0..2)
  }
  ~~~

  ~~~ css
  list[operator="::"] {
    prime: 1 2 3 5 7;
    bar: null null 1 2 3 null 7 2 1 2 3;
  }
  ~~~

### `::=`

- Replaces an item of the list with another value by its numerical index

  ~~~ lay
  a = 1 2 3
  a::0 = 2
  list[operator="::="] {
    foo: a
  }
  ~~~

  ~~~ css
  list[operator="::="] {
    foo: 2 2 3;
  }
  ~~~

- Adds items at the end of the list

  ~~~ lay
  a = 1 2 3
  a::3 = 4
  list[operator="::="] {
    foo: a
  }
  ~~~

  ~~~ css
  list[operator="::="] {
    foo: 1 2 3 4;
  }
  ~~~

- Accepts negative indices

  ~~~ lay
  list[operator="::="] {
    a = 1 2 3
    a::(-1) = 1
    foo: a
    a::(-3) = 3
    foo: a
  }
  ~~~

  ~~~ css
  list[operator="::="] {
    foo: 1 2 1;
    foo: 3 2 1;
  }
  ~~~

- Returns `null` for indices out of bounds

  ~~~ lay
  $list = 1,2,3

  list[operator="::="] {
    i: $list::3
  }
  ~~~

  ~~~ css
  list[operator="::="] {
    i: null;
  }
  ~~~

- Fails for non-numeric indices

  ~~~ lay
  $list = 1,2,3

  list[operator="::="] {
    i: $list::('foo')
  }
  ~~~

  ~~~ ValueError
  ~~~
