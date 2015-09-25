Strings
=======

## Quoted strings

- Are declared with 'single' or "double" quotes

  ~~~ lay
  foo: 'Bar'
  foo: "Bar"
  ~~~

  ~~~ css
  foo: 'Bar';
  foo: "Bar";
  ~~~

- Can have escaped new lines (`\n`), tabs (`\t`) and carriage returns (`\r`)

  ~~~ lay
  foo: "Lorem\n\n\nIpsum\tdolor\t\tsit\r"
  bar: "\nDolor\r\n\nSit\n"
  baz: '\
  Lorem\
  Ipsum\
  Dolor\
  Sit\
  '
  baz: '\
  Lorem \
  Ipsum \
  Dolor \
  Sit\
  '
  foo: '\tLorem\t'
  foo: '\nLorem\n'
  foo: '\rLorem\r'
  foo: '\r\nLorem\r\n'
  ~~~

  ~~~ css
  foo: "Lorem\A\A\AIpsum\9dolor\9\9sit\A";
  bar: "\ADolor\A\ASit\A";
  baz: 'LoremIpsumDolorSit';
  baz: 'Lorem Ipsum Dolor Sit';
  foo: '\9Lorem\9';
  foo: '\ALorem\A';
  foo: '\ALorem\A';
  foo: '\ALorem\A';
  ~~~

- Can have escaped unicode characters

  ~~~ lay
  foo: "\20"
  ~~~

  ~~~ css
  foo: "\20";
  ~~~

- Support interpolation

  ~~~ lay

  $say-hi = ($who = 'world') {
    return 'Hello, world'
  }

  body {
    $you = 'world'
    foo: '{$say-hi($you) + ','} how are you?'
  }
  ~~~

  ~~~ css
  body {
    foo: 'Hello, world, how are you?';
  }
  ~~~

- Are always trueish

  ~~~ lay
  foo: "".true? "  ".true? "0".boolean "false".true?
  ~~~

  ~~~ css
  foo: true true true true;
  ~~~

## Unquoted strings

- Can be made out of unresolved idents

  ~~~ lay
  background: light-green
  background: red
  red = "#f00"
  background: red
  ~~~

  ~~~ css
  background: light-green;
  background: red;
  background: "#f00";
  ~~~

- Can be made with backticks

  ~~~ lay
  background: `light-green`
  margin: `0`
  background: red
  red = `#f00`
  background: `red`
  background: red
  ~~~

  ~~~ css
  background: light-green;
  margin: 0;
  background: red;
  background: red;
  background: #f00;
  ~~~

- Support interpolation between backticks

  ~~~ lay
  body {
    $you = 'world'
    foo: `Hello, {$you}`
  }
  ~~~

  ~~~ css
  body {
    foo: Hello, world;
  }
  ~~~

- Are always trueish

  ~~~ lay
  bar {
    foo: ``.true? `  `.true? yes.true? -moz-border-radius.true? not !important.false?
  }
  ~~~

  ~~~ css
  bar {
    foo: true true true true true;
  }
  ~~~

## Operators

### `is`

- Returns `true` only if the right side is a string with the same value

  ~~~ lay
  a: 'black' is 'black'
  b: 'black' is "black"
  c: 'black' isnt " black"
  d: 'Black' isnt "black"
  e: 'foo' is foo
  f: '' is ``
  g: '' isnt false
  h: '' isnt null
  i: '0' isnt 0
  j: 'google.com' isnt url('google.com')
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
  j: true;
  ~~~

### `has`

- Returns `true` if the string contains the given substring

  ~~~ lay
  foo: 'Lorem ipsum dolor sit' has 'ipsum'
  foo: 'Lorem ipsum dolor sit' has 'Ipsum'
  ~~~

  ~~~ css
  foo: true;
  foo: false;
  ~~~

### `in`

- Returns `true` if the string is contained in another string

  ~~~ lay
  foo: 'ipsum' in 'Lorem ipsum dolor sit'
  foo: 'Ipsum' in 'Lorem ipsum dolor sit'
  foo: 'dolor' in 'Lorem ipsum dolor'
  ~~~

  ~~~ css
  foo: true;
  foo: false;
  foo: true;
  ~~~

### `+`

- Joins strings

  ~~~ lay
  a: 'Hello' + "," + ' ' + world
  b: hello + ' world'
  ~~~

  ~~~ css
  a: 'Hello, world';
  b: 'hello world';
  ~~~

### `*`

- Repeats a string a number of times

  ~~~ lay
  foo: "na" * 0
  foo: "na" * 1
  foo: "na" * 2
  foo: "na" * 5
  foo: 0 * "na"
  foo: 1 * "na"
  foo: 2 * "na"
  foo: 5 * "na"
  ~~~

  ~~~ css
  foo: "";
  foo: "na";
  foo: "nana";
  foo: "nanananana";
  foo: "";
  foo: "na";
  foo: "nana";
  foo: "nanananana";
  ~~~

### `/`

- Splits a string by another string

  ~~~ lay
  body {
    foo: ('Lorem ipsum dolor sit amet' / ' ').commas
  }
  ~~~

  ~~~ css
  body {
    foo: 'Lorem', 'ipsum', 'dolor', 'sit', 'amet';
  }
  ~~~

- Splits a string by a regular expression.

  ~~~ lay
  sp = /\s+/
  body {
    foo: 'Lorem    ipsum   \n\t \r\n dolor \
    sit amet' / sp
  }
  ~~~

  ~~~ css
  body {
    foo: 'Lorem' 'ipsum' 'dolor' 'sit' 'amet';
  }
  ~~~

- Does not create empty chunks

  ~~~ lay
  sp = /\s+/

  body {
    foo: '  Lorem    ipsum   \n\t \r\n dolor \
    sit amet' / sp
    foo: ' Lorem    ipsum  dolor \
  sit amet   ' / ' '
  }
  ~~~

  ~~~ css
  body {
    foo: 'Lorem' 'ipsum' 'dolor' 'sit' 'amet';
    foo: 'Lorem' 'ipsum' 'dolor' 'sit' 'amet';
  }
  ~~~

### `>`, `>=`, `<` and `<=`

- Compare strings

  ~~~ lay
  foo: 'a' > 'a'
  foo: 'b' >= 'a'
  foo: 'aa' < 'a'
  foo: 'ab' <= 'aa'
  ~~~

  ~~~ css
  foo: false;
  foo: true;
  foo: false;
  foo: false;
  ~~~

### `~`

- Matches a string against a regular expression

  ~~~ lay
    i: 'abc' ~ /\d+/, '123px' ~ /\d+/
   ii: `100px` ~ /(\d+)(px|rem)/
  iii: "99rem" ~ /(\d+)(px|rem)/
   iv: border-color ~ /([a-z]+)-([a-z]+)/
  ~~~

  ~~~ css
  i: null, '123';
  ii: 100px 100 px;
  iii: "99rem" "99" "rem";
  iv: border-color border color;
  ~~~

### `::`

- Returns the character of the string at a given numeric index

  ~~~ lay
  $s = 'Lorem ipsum dolor sit'
  foo: ($s::6).upper-case
  bar: $s::0
  ~~~

  ~~~ css
  foo: 'I';
  bar: 'L';
  ~~~

- Accepts negative indices

  ~~~ lay
  $s = 'Lorem ipsum dolor sit'
  foo: ($s::-1).upper-case
  ~~~

  ~~~ css
  foo: 'T';
  ~~~

- Returns `null` if the passed index is out of bounds

  ~~~ lay
  $s = 'Lorem ipsum dolor sit'

  foo: ($s::($s.length)).null?
  foo: ($s::-($s.length + 1)).null?
  foo: ($s::-($s.length)).null?
  foo: ($s::99999).null?
  ~~~

  ~~~ css
  foo: true;
  foo: true;
  foo: false;
  foo: true;
  ~~~

- Returns a substring if a range is passed

  ~~~ lay
  $s = 'Lorem ipsum dolor sit'

  foo: $s::(0..4)
  ~~~

  ~~~ css
  foo: 'Lorem';
  ~~~

### `<<` and `>>`

- Appends strings to strings

  ~~~ lay
  $a = 'Lorem'

  $a << ' '
  $a << 'ipsum' + ' '
  'dolor' >> $a

  foo: $a
  ~~~

  ~~~ css
  foo: 'Lorem ipsum dolor';
  ~~~

- Always return the resulting string

  ~~~ lay
  foo: 'lorem' << ' ' << 'ipsum' << ' ' << 'dolor'
  foo: 'lorem' >> ' ' >> 'ipsum' >> ' ' >> 'dolor'
  ~~~

  ~~~ css
  foo: 'lorem ipsum dolor';
  foo: 'dolor ipsum lorem';
  ~~~

### `is-a`

- Returns `true` if the right side is the class `String` or the string "string"

## Methods

### `length`

- Returns the number of characters in the string.

  ~~~ lay
  body {
    foo: "".length
    foo: " hello world ".length
    foo: " hello world ".trim.length
    foo: "hello  world ".length
  }
  ~~~

  ~~~ css
  body {
    foo: 0;
    foo: 13;
    foo: 11;
    foo: 13;
  }
  ~~~

### `empty?`

- Returns `true` if the string has 0 length

  ~~~ lay
  body {
    foo: "hello world".empty?
    foo: "   ".empty? '\
  '.empty? "   ".trim.empty?
    foo: ``.empty?
    foo: '0'.empty?
  }
  ~~~

  ~~~ css
  body {
    foo: false;
    foo: false true true;
    foo: true;
    foo: false;
  }
  ~~~

### `blank?`

- Returns `true` if the string is empty or has only whitespace

  ~~~ lay
  foo: "hello world".blank?
  foo: ' '.blank? "  \n\t ".blank? " \n\t  ".trim.blank?
  foo: ``.blank?
  a = "\
  "
  foo: a.length a.blank?
  ~~~

  ~~~ css
  foo: false;
  foo: true true true;
  foo: true;
  foo: 0 true;
  ~~~

### `trim`

- Returns a copy of the string without leading or trailing whitespace

  ~~~ lay
  foo: " hello world ".trim
  bar: " \t \r \n \
  \t".trim
  ~~~

  ~~~ css
  foo: "hello world";
  bar: "";
  ~~~

- Accepts a parameter with the characters to be trimmed

  ~~~ lay
  baz: '(hey there] '.trim('(] h')
  ~~~

  ~~~ css
  baz: 'ey there';
  ~~~

### `ltrim`

- Returns a copy of the string without leading whitespace

  ~~~ lay
  foo: " hello world ".ltrim
  bar: " \t \r \n \
  \t".ltrim
  ~~~

  ~~~ css
  foo: "hello world ";
  bar: "";
  ~~~

- Accepts a parameter with the characters to be trimmed

  ~~~ lay
  baz: '(hey there] '.ltrim('(] h')
  ~~~

  ~~~ css
  baz: 'ey there] ';
  ~~~

### `rtrim`

- Returns a copy of the string without trailing whitespace

  ~~~ lay
  foo: " hello world ".rtrim
  bar: " \t \r \n \
  \t".rtrim
  ~~~

  ~~~ css
  foo: " hello world";
  bar: "";
  ~~~

- Accepts a parameter with the characters to be trimmed

  ~~~ lay
  baz: '(hey there] '.rtrim('(] h')
  ~~~

  ~~~ css
  baz: '(hey there';
  ~~~

### `first`

- Returns the first character of the string, or `null` if it's empty

  ~~~ lay
  foo: ''.first
  bar: 'Ê'.first
  baz: 'abcd'.first
  ~~~

  ~~~ css
  foo: null;
  bar: 'Ê';
  baz: 'a';
  ~~~

### `last`

- Returns the last character of the string, or `null` if the string is empty

  ~~~ lay
  foo: ''.last
  bar: 'Ê'.last
  baz: 'abcd'.last
  ~~~

  ~~~ css
  foo: null;
  bar: 'Ê';
  baz: 'd';
  ~~~

### `append`

- Appends one or more strings to this string

  ~~~ lay
  $a = 'Lorem'

  $a.append(' ')
  $a.append('ipsum' + ' ' + 'dolor')

  foo: $a
  foo: $a.append()
  ~~~

  ~~~ css
  foo: 'Lorem ipsum dolor';
  foo: 'Lorem ipsum dolor';
  ~~~

### `reverse`

- Returns a copy of the string, reversed

  ~~~ lay
  foo: ''.reverse()
  foo: "roma".reverse
  foo: "España ".reverse
  ~~~

  ~~~ css
  foo: '';
  foo: "amor";
  foo: " añapsE";
  ~~~

### `palindrome?`

- Checks if the string is a palindrome

  ~~~ lay
  i: 'Lorem'.palindrome?
  ii: 'Eva, can I stab bats in a cave?'.palindrome?
  iii: "Dammit, I'm mad!".palindrome?
  iv: '   \naha\r '.palindrome?
  v: 'Anna?'.palindrome?
  ~~~

  ~~~ css
  i: false;
  ii: true;
  iii: true;
  iv: true;
  v: true;
  ~~~

### `lower-case`

- Returns a "lower case" copy of the string

  ~~~ lay
  foo: 'Lorem Ipsum Dolor Sit Amet'.lower-case
  ~~~

  ~~~ css
  foo: 'lorem ipsum dolor sit amet';
  ~~~

### `upper-case`

- Returns an "UPPER CASE" copy of the string

  ~~~ lay
  foo: 'Lorem Ipsum Dolor Sit Amet'.upper-case
  ~~~

  ~~~ css
  foo: 'LOREM IPSUM DOLOR SIT AMET';
  ~~~

### `camel-case`

- Returns a "camelCase" copy of the string

  ~~~ lay
  foo: 'make me a sandwich'.camel-case
  foo: lorem.camel-case IPSUM.camel-case Dolor.camel-case
  foo: 'lorem ipsum dolor sit'.camel-case()
  foo: 'LoremIpsumDolorSit'.camel-case
  foo: 'lorem.ipsum/dolor/sit'.camel-case
  foo: 'Lorem Ípsum\r\ndolor-SIT'.camel-case
  foo: '___Lorem__Ipsum__DOLOR__SIT'.camel-case
  foo: 'Version1.2.3'.camel-case
  ~~~

  ~~~ css
  foo: 'makeMeASandwich';
  foo: lorem ipsum dolor;
  foo: 'loremIpsumDolorSit';
  foo: 'loremIpsumDolorSit';
  foo: 'loremIpsumDolorSit';
  foo: 'loremÍpsumDolorSit';
  foo: 'loremIpsumDolorSit';
  foo: 'version1_2_3';
  ~~~

### `pascal-case`

- Returns a "PascalCase" copy of the string

  ~~~ lay
  foo: lorem.pascal-case IPSUM.pascal-case Dolor.pascal-case
  foo: 'lorem ipsum dolor sit'.pascal-case
  foo: 'LoremIpsumDolorSit'.pascal-case
  foo: 'lorem.ipsum/dolor/sit'.pascal-case
  foo: 'Lorem Ípsum\r\ndolor-SIT'.pascal-case
  foo: '___Lorem__Ipsum__DOLOR__SIT'.pascal-case
  foo: 'Version1.2.3'.pascal-case
  ~~~

  ~~~ css
  foo: Lorem Ipsum Dolor;
  foo: 'LoremIpsumDolorSit';
  foo: 'LoremIpsumDolorSit';
  foo: 'LoremIpsumDolorSit';
  foo: 'LoremÍpsumDolorSit';
  foo: 'LoremIpsumDolorSit';
  foo: 'Version1_2_3';
  ~~~

### `snake-case`

- Returns a "snake_case" copy of the string

  ~~~ lay
  foo: lorem.snake-case IPSUM.snake-case Dolor.snake-case
  foo: 'lorem ipsum dolor sit'.snake-case
  foo: 'LoremIpsumDolorSit'.snake-case
  foo: 'lorem.ipsum/dolor/sit'.snake-case
  foo: 'Lorem Ípsum\r\ndolor-SIT'.snake-case
  foo: '___Lorem__Ipsum__DOLOR__SIT'.snake-case
  foo: 'Version1.2.3'.snake-case
  ~~~

  ~~~ css
  foo: lorem ipsum dolor;
  foo: 'lorem_ipsum_dolor_sit';
  foo: 'lorem_ipsum_dolor_sit';
  foo: 'lorem_ipsum_dolor_sit';
  foo: 'lorem_ípsum_dolor_sit';
  foo: 'lorem_ipsum_dolor_sit';
  foo: 'version_1_2_3';
  ~~~

### `kebab-case`

- Returns a "kebab-case" copy of the string

  ~~~ lay
  foo: lorem.kebab-case IPSUM.kebab-case Dolor.kebab-case
  foo: 'lorem ipsum dolor sit'.kebab-case
  foo: 'LoremIpsumDolorSit'.kebab-case
  foo: 'lorem.ipsum/dolor/sit'.kebab-case
  foo: 'Lorem Ípsum\r\ndolor-SIT'.kebab-case
  foo: '___Lorem__Ipsum__DOLOR__SIT'.kebab-case
  foo: 'Version1.2.3'.kebab-case
  ~~~

  ~~~ css
  foo: lorem ipsum dolor;
  foo: 'lorem-ipsum-dolor-sit';
  foo: 'lorem-ipsum-dolor-sit';
  foo: 'lorem-ipsum-dolor-sit';
  foo: 'lorem-ípsum-dolor-sit';
  foo: 'lorem-ipsum-dolor-sit';
  foo: 'version-1-2-3';
  ~~~

### `spinal-case`

- Is an alias of `kebab-case`

  ~~~ lay
  foo: lorem.spinal-case IPSUM.spinal-case Dolor.spinal-case
  foo: 'lorem ipsum dolor sit'.spinal-case
  foo: 'LoremIpsumDolorSit'.spinal-case
  foo: 'lorem.ipsum/dolor/sit'.spinal-case
  foo: 'Lorem Ípsum\r\ndolor-SIT'.spinal-case
  foo: '___Lorem__Ipsum__DOLOR__SIT'.spinal-case
  foo: 'Version1.2.3'.spinal-case
  ~~~

  ~~~ css
  foo: lorem ipsum dolor;
  foo: 'lorem-ipsum-dolor-sit';
  foo: 'lorem-ipsum-dolor-sit';
  foo: 'lorem-ipsum-dolor-sit';
  foo: 'lorem-ípsum-dolor-sit';
  foo: 'lorem-ipsum-dolor-sit';
  foo: 'version-1-2-3';
  ~~~

### `title-case`

- Returns a "Title Case" copy of the string

### `quoted?`

- Tells if the string is quoted

  ~~~ lay
  say-hello = ($who = "you") {
    return hello + $who
  }

  a: not hello-world.quoted?
  b: "hello world".quoted?, "hello world".trim.quoted?
  c: (hello + " world").quoted?
  d: say-hello('world').quoted?
  e: not say-hello(world).quoted?
  f: say-hello().quoted?
  g: hello-world.unquoted?
  ~~~

  ~~~ css
  a: true;
  b: true, true;
  c: true;
  d: true;
  e: true;
  f: true;
  g: true;
  ~~~

### `unquoted?`

- Tells if the string is unquoted

  ~~~ lay
  say-hello = ($who = "you") {
    return hello + $who
  }

  h: not "hello world".unquoted?, not "hello world".trim.unquoted?
  i: not (hello + " world").unquoted?
  j: not say-hello('world').unquoted?
  k: say-hello(world).unquoted?
  l: not say-hello().unquoted?
  ~~~

  ~~~ css
  h: true, true;
  i: true;
  j: true;
  k: true;
  l: true;
  ~~~

### `quoted`

- Returns a quoted copy of the string

  ~~~ lay
  background: "background.jpg".quoted no-repeat.quoted
  ~~~

  ~~~ css
  background: "background.jpg" "no-repeat";
  ~~~

### `unquoted`

- Returns an unquoted copy of the string

  ~~~ lay
  background: "background.jpg".unquoted no-repeat.unquoted `top`.unquoted 'center'.unquoted
  ~~~

  ~~~ css
  background: background.jpg no-repeat top center;
  ~~~

### `unquote`

- Is an alias of `.unquoted`

  ~~~ lay
  background: "background.jpg".unquote no-repeat.unquote `top`.unquote
  ~~~

  ~~~ css
  background: background.jpg no-repeat top;
  ~~~

### `starts-with?`

- Tells if the string starts with given substring

  ~~~ lay
  foo: not "Hello world".starts-with?('hello')
  foo: "Hello world".starts-with('Hello')?
  foo: not " Hello world".starts-with?('Hello')
  foo: "Hello world".starts-with(``)?
  ~~~

  ~~~ css
  foo: true;
  foo: true;
  foo: true;
  foo: true;
  ~~~

### `ends-with?`

- Tells if the string ends with given substring

  ~~~ lay
  foo: not "Hello world".ends-with?('world ')
  foo: "Hello world".ends-with('world')?
  foo: not "Hello world ".ends-with?('world')
  foo: "Hello world".ends-with?('')
  ~~~

  ~~~ css
  foo: true;
  foo: true;
  foo: true;
  foo: true;
  ~~~

### `split`

- Splits a string by another string

  ~~~ lay
  body {
    foo: ('Lorem ipsum dolor sit amet' / ' ').commas
  }
  ~~~

  ~~~ css
  body {
    foo: 'Lorem', 'ipsum', 'dolor', 'sit', 'amet';
  }
  ~~~

- Splits a string by a regular expression.

  ~~~ lay
  sp = /\s+/
  body {
    foo: 'Lorem    ipsum   \n\t \r\n dolor \
    sit amet' / sp
  }
  ~~~

  ~~~ css
  body {
    foo: 'Lorem' 'ipsum' 'dolor' 'sit' 'amet';
  }
  ~~~

- Accepts a `limit` argument

  ~~~ lay
  $str = 'Lorem ipsum dolor sit amet'
  foo: $str.split(/\s+/, 2)
  bar: $str.split(/\s+/, 0).length
  baz: $str.split(/\s+/, null)
  ~~~

  ~~~ css
  foo: 'Lorem' 'ipsum';
  bar: 0;
  baz: 'Lorem' 'ipsum' 'dolor' 'sit' 'amet';
  ~~~

### `characters`

- Splits the string in characters and returns them as a list

  ~~~ lay
  foo: 'Lorem'.characters
  foo: ipsum.characters
  foo: "España".characters
  ~~~

  ~~~ css
  foo: 'L' 'o' 'r' 'e' 'm';
  foo: i p s u m;
  foo: "E" "s" "p" "a" "ñ" "a";
  ~~~

- Returns an empty list for empty strings

  ~~~ lay
  foo: ''.characters.length
  ~~~

  ~~~ css
  foo: 0;
  ~~~

### `lines`

- Splits the string in lines and returns them as a list

  ~~~ lay
  foo: 'Lorem ipsum\ndolor sit\namet\nconsectetur \
  adipiscing \
  elit'.lines
  ~~~

  ~~~ css
  foo: 'Lorem ipsum' 'dolor sit' 'amet' 'consectetur adipiscing elit';
  ~~~

- Works with any line ending

  ~~~ lay
  foo: 'Lorem\nipsum\rdolor\r\nsit'.lines
  ~~~

  ~~~ css
  foo: 'Lorem' 'ipsum' 'dolor' 'sit';
  ~~~

- Does not create empty chunks

  ~~~ lay
  foo: '\nLorem\n\nipsum\ndolor\nsit\n'.lines
  ~~~

  ~~~ css
  foo: 'Lorem' 'ipsum' 'dolor' 'sit';
  ~~~

- Trims the lines

  ~~~ lay
  foo: '  Lorem\nipsum   \r   dolor   \r\n sit\n\n   amet\n'.lines
  ~~~

  ~~~ css
  foo: 'Lorem' 'ipsum' 'dolor' 'sit' 'amet';
  ~~~

- Returns an empty list for blank strings

  ~~~ lay
  foo: ''.lines.length
  foo: ' \n \r \t '.lines.length
  ~~~

  ~~~ css
  foo: 0;
  foo: 0;
  ~~~

### `words`

- Splits the string in words and returns them as a list

  ~~~ lay
  foo: `Lorem`.words
  foo: 'Lorem ipsum dolor'.words
  ~~~

  ~~~ css
  foo: Lorem;
  foo: 'Lorem' 'ipsum' 'dolor';
  ~~~

- Works with any line ending

  ~~~ lay
  foo: `Lorem\nipsum\r\ndolor\n\rsit\ramet`.words
  ~~~

  ~~~ css
  foo: Lorem ipsum dolor sit amet;
  ~~~

- Does not create empty chunks

  ~~~ lay
  for i, wd in `  Lorem . ipsum    dolor.  .  `.words {
    `word-{i}`: wd
  }
  ~~~

  ~~~ css
  word-0: Lorem;
  word-1: ipsum;
  word-2: dolor;
  ~~~

- Returns an empty list for blank strings

  ~~~ lay
  foo: ''.words.length
  foo: '   '.words.length
  foo: '  \t \r \n  '.words.length
  ~~~

  ~~~ css
  foo: 0;
  foo: 0;
  foo: 0;
  ~~~

### `numeric?`

- Tells if the string looks like a number

  ~~~ lay
  foo: '10'.numeric?
  foo: not 'px'.numeric?
  foo: not 'a10'.numeric?
  foo: '10px'.numeric?
  foo: ' 10px '.numeric?
  foo: '0'.numeric?
  foo: `5.5px`.numeric?
  ~~~

  ~~~ css
  foo: true;
  foo: true;
  foo: true;
  foo: true;
  foo: true;
  foo: true;
  foo: true;
  ~~~

### `replace`

- Searches for the given string or regular expression and replaces with another string

  ~~~ lay
  foo: "Mr Blue has a blue house and a blue car".replace('blue', 'red')
  foo: "Mr Blue has a blue house and a blue car".replace(/blue/g, 'green')
  foo: 'Mr Blue has a blue house and a blue car'.replace(/blue/gi, 'pink')
  foo: 'Mr Blue has a blue house and a blue car'.replace(/green/gi, 'pink')
  ~~~

  ~~~ css
  foo: "Mr Blue has a red house and a blue car";
  foo: "Mr Blue has a green house and a green car";
  foo: 'Mr pink has a pink house and a pink car';
  foo: 'Mr Blue has a blue house and a blue car';
  ~~~

### `number`

- Makes a number from the string, if it is numeric

  ~~~ lay
  foo: "12px".number
  foo: `3.14pt`.number
  foo: `-17%`.number
  foo: `000`.number
  ~~~

  ~~~ css
  foo: 12px;
  foo: 3.14pt;
  foo: -17%;
  foo: 0;
  ~~~

- Fails for non-numeric strings

  ~~~ lay
  foo: ''.number
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  foo: ''.number
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  foo: ' '.number
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  foo: '100px20'.number
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  foo: 'a'.number
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  foo: '2.2.2px'.number
  ~~~

  ~~~ TypeError
  ~~~

### `copy`

- Creates a copy of the string

  ~~~ lay
  orig = "Hello world"
  str = orig.copy
  val: str
  quote: str.quoted?
  diff: str isnt orig

  if str.copy.copy.copy isnt orig {
    god: damn!
  }
  ~~~

  ~~~ css
  val: "Hello world";
  quote: true;
  diff: false;
  ~~~
