Strings
=======

## Quoted strings

- Are declared with 'single' or "double" quotes

  ~~~ lay
  string[quoted] {
    foo: 'Bar'
    foo: "Bar"
  }
  ~~~

  ~~~ css
  string[quoted] {
    foo: "Bar";
    foo: "Bar";
  }
  ~~~

- Can have escaped new lines (`\n`), tabs (`\t`) and carriage returns (`\r`)

  ~~~ lay
  string[quoted][escaped]
  {
  i: "Lorem\n\n\nIpsum\tdolor\t\tsit\r"
  ii: "\nDolor\r\n\nSit\n"
  iii: '\
  Lorem\
  Ipsum\
  Dolor\
  Sit\
  '
  iv: '\
  Lorem \
  Ipsum \
  Dolor \
  Sit\
  '
  vi: '\tLorem\t'
  vii: '\nLorem\n'
  viii: '\rLorem\r'
  ix: '\r\nLorem\r\n'
  }
  ~~~

  ~~~ css
  string[quoted][escaped] {
    i: "Lorem\A\A\AIpsum\9 dolor\9\9sit\D";
    ii: "\A Dolor\D\A\ASit\A";
    iii: "LoremIpsumDolorSit";
    iv: "Lorem Ipsum Dolor Sit";
    vi: "\9Lorem\9";
    vii: "\ALorem\A";
    viii: "\DLorem\D";
    ix: "\D\ALorem\D\A";
  }
  ~~~

- Can have escaped unicode characters

  ~~~ lay
  string.quoted[escaped=unicode] {
    i: "\20\9"
    ii: "\2660 \2663 \2665 \2666 "
  }
  ~~~

  ~~~ css
  string.quoted[escaped=unicode] {
    i: " \9";
    ii: "♠♣♥♦";
  }
  ~~~

- Can contain escaped quotes

  ~~~ lay
  string[quoted][escaped=quotes] {
    i: "These are \"double quotes\""
    ii: &::i.unquoted.quoted
    iii: 'These are \'single quotes\''
    iv: &::iii.unquoted.quoted
  }
  ~~~

  ~~~ css
  string[quoted][escaped=quotes] {
    i: "These are \"double quotes\"";
    ii: "These are \"double quotes\"";
    iii: "These are 'single quotes'";
    iv: "These are 'single quotes'";
  }
  ~~~

- Can contain escaped backslashes

  ~~~ lay
  string[quoted][escaped=back-slashes] {
    win-path: "C:\\Program Files\\"
  }
  ~~~

  ~~~ css
  string[quoted][escaped=back-slashes] {
    win-path: "C:\\Program Files\\";
  }
  ~~~

- Support interpolation

  ~~~ lay

  $say-hi = ($who: 'world') {
    return 'Hello, world'
  }

  string::interpolation {
    $you = 'world'
    i: '#{$say-hi($you) + ','} how are you?'
  }
  ~~~

  ~~~ css
  string::interpolation {
    i: "Hello, world, how are you?";
  }
  ~~~

- Are always trueish

  ~~~ lay
  string.true {
    i: "".true? "  ".true? "0".boolean "false".true?
  }
  ~~~

  ~~~ css
  string.true {
    i: true true true true;
  }
  ~~~

## Unquoted strings

- Are made without quotes

  ~~~ lay
  string.unquoted {
    background: light-green
    background: red
    red = "#f00"
    background: red
  }
  ~~~

  ~~~ css
  string.unquoted {
    background: light-green;
    background: red;
    background: "#f00";
  }
  ~~~

- Can have escaped unicode characters

  ~~~ lay
  string.unquoted[escaped=unicode] {
    is: Espa\f1ist\e1n, se\f1oras\20y\20se\f1ores!
  }
  ~~~

  ~~~ css
  string.unquoted[escaped=unicode] {
    is: Españistán, señoras\20y\20señores\!;
  }
  ~~~

- Can have escaped new lines (`\n`), tabs (`\t`), and carriage returns (`\r`)

  ~~~ lay
  string.unquoted[escaped=whitespace] {
    i: Lorem\nipsum\tdolor\rsit\r\namet
  }
  ~~~

  ~~~ css
  string.unquoted[escaped=whitespace] {
    i: Lorem\Aipsum\9 dolor\Dsit\D\A amet;
  }
  ~~~

- Can have escaped quotes

  ~~~ lay
  string.unquoted[escaped=quoted] {
    i: Lorem\"ipsum\"
  }
  ~~~

  ~~~ css
  string.unquoted[escaped=quoted] {
    i: Lorem\"ipsum\";
  }
  ~~~

- Are always trueish

  ~~~ lay
  string.unquoted.true {
    i: -moz-border-radius.true? not important!.false? yes.true?
  }
  ~~~

  ~~~ css
  string.unquoted.true {
    i: true true true;
  }
  ~~~

## Raw strings

- Can be made with backticks

  ~~~ lay
  string[raw] {
    background: `light-green`
    margin: `0`
    background: red
    red = `#f00`
    background: `red`
    background: red
  }
  ~~~

  ~~~ css
  string[raw] {
    background: light-green;
    margin: 0;
    background: red;
    background: red;
    background: #f00;
  }
  ~~~

- Can have escaped unicode characters

  ~~~ lay
  string.raw[escaped=unicode] {
    i: `\2660 \2663 \2665 \2666 `
    ii: `Hello\20World`
  }
  ~~~

  ~~~ css
  string.raw[escaped=unicode] {
    i: ♠♣♥♦;
    ii: Hello World;
  }
  ~~~

- Support interpolation

  ~~~ lay
  string[raw]::interpolation {
    $you = 'world'
    foo: `Hello, #{$you}`
  }
  ~~~

  ~~~ css
  string[raw]::interpolation {
    foo: Hello, world;
  }
  ~~~

- Are always trueish

  ~~~ lay
  string[raw].true {
    foo: ``.true? `  `.true?
  }
  ~~~

  ~~~ css
  string[raw].true {
    foo: true true;
  }
  ~~~

## Operators

### `is`

- Returns `true` only if the right side is a string with the same value

  ~~~ lay
  string is string {
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
  }
  ~~~

  ~~~ css
  string is string {
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
  }
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
  string[operator="+"] {
    a: 'Hello' + "," + ' ' + world
    b: hello + '-world'
  }
  ~~~

  ~~~ css
  string[operator="+"] {
    a: "Hello, world";
    b: hello-world;
  }
  ~~~

### `*`

- Repeats a string a number of times

  ~~~ lay
  string[operator="*"] {
    i: "na" * 0
    ii: "na" * 1
    iii: "na" * 2
    iv: "na" * 5
    v: 0 * "na"
    vi: 1 * "na"
    vii: 2 * "na"
    viii: 5 * "na"
  }
  ~~~

  ~~~ css
  string[operator="*"] {
    i: "";
    ii: "na";
    iii: "nana";
    iv: "nanananana";
    v: "";
    vi: "na";
    vii: "nana";
    viii: "nanananana";
  }
  ~~~

- Works with decimal numbers

  ~~~ lay
  string[operator="*"] {
    i: "1234567890" * 0.1
    ii: "1234567890" * 0.2
    iii: "1234567890" * 0.3
    iv: "1234567890" * 0.4
    v: "1234567890" * 0.5
    vi: "1234567890" * 0.6
    vii: "1234567890" * 0.7
    viii: "1234567890" * 0.8
    ix: "1234567890" * 0.9
    x: "1234567890" * 1
    xi: "1234567890" * 1.1
    xii: "1234567890" * 1.3
    xiii: "1234567890" * 1.47
    xiv: "1234567890" * 1.51
    xv: "1234567890" * 1.9
  }
  ~~~

  ~~~ css
  string[operator="*"] {
    i: "1";
    ii: "12";
    iii: "123";
    iv: "1234";
    v: "12345";
    vi: "123456";
    vii: "1234567";
    viii: "12345678";
    ix: "123456789";
    x: "1234567890";
    xi: "12345678901";
    xii: "1234567890123";
    xiii: "123456789012345";
    xiv: "123456789012345";
    xv: "1234567890123456789";
  }
  ~~~

- Fails for non-pure numbers

  ~~~ lay
  "na" * 2px
  ~~~

  ~~~ ValueError
  ~~~

- Fails for negative numbers

  ~~~ lay
  "na" * -2px
  ~~~

  ~~~ ValueError
  ~~~

  ~~~ lay
  "na" * -1
  ~~~

  ~~~ ValueError
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
    foo: "Lorem", "ipsum", "dolor", "sit", "amet";
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
    foo: "Lorem" "ipsum" "dolor" "sit" "amet";
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
    foo: "Lorem" "ipsum" "dolor" "sit" "amet";
    foo: "Lorem" "ipsum" "dolor" "sit" "amet";
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
  i: null, "123";
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
  foo: "I";
  bar: "L";
  ~~~

- Accepts negative indices

  ~~~ lay
  $s = 'Lorem ipsum dolor sit'
  foo: ($s::-1).upper-case
  ~~~

  ~~~ css
  foo: "T";
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
  foo: "Lorem";
  ~~~

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

### `contains?`

- Returns `true` if the string contains the given substring

  ~~~ lay
  string.contains {
    i: 'Lorem ipsum dolor sit'.contains?('ipsum')
    ii: `Lorem ipsum dolor sit`.contains?(ipsum)
    iii: 'Lorem ipsum dolor sit'.contains?('Ipsum')
  }
  ~~~

  ~~~ css
  string.contains {
    i: true;
    ii: true;
    iii: false;
  }
  ~~~

### `blank?`

- Returns `true` if the string is empty or has only whitespace

  ~~~ lay
  string.blank {
    foo: "hello world".blank?
    foo: ' '.blank? "  \n\t ".blank? " \n\t  ".trim.blank?
    foo: ``.blank?
    a = "\
  "
    foo: a.length a.blank?
  }
  ~~~

  ~~~ css
  string.blank {
    foo: false;
    foo: true true true;
    foo: true;
    foo: 0 true;
  }
  ~~~

### `trim`

- Returns a copy of the string without leading or trailing whitespace

  ~~~ lay
  string.trim {
    i: " hello world ".trim
    ii: " \t \r \n \
  \t\9\20".trim
  }
  ~~~

  ~~~ css
  string.trim {
    i: "hello world";
    ii: "";
  }
  ~~~

- Accepts a parameter with the characters to be trimmed

  ~~~ lay
  string.trim {
    baz: '(hey there] '.trim('(] h')
  }
  ~~~

  ~~~ css
  string.trim {
    baz: "ey there";
  }
  ~~~

### `ltrim`

- Returns a copy of the string without leading whitespace

  ~~~ lay
  string.ltrim {
    foo: " hello world ".ltrim
    bar: " \t \r \n \
  \9\20\t".ltrim
  }
  ~~~

  ~~~ css
  string.ltrim {
    foo: "hello world ";
    bar: "";
  }
  ~~~

- Accepts a parameter with the characters to be trimmed

  ~~~ lay
  string.ltrim {
    baz: '(hey there] '.ltrim('(] h')
  }
  ~~~

  ~~~ css
  string.ltrim {
    baz: "ey there] ";
  }
  ~~~

### `rtrim`

- Returns a copy of the string without trailing whitespace

  ~~~ lay
  string.rtrim {
    foo: " hello world ".rtrim
    bar: " \t \9\20 \r \n \
  \t".rtrim
  }
  ~~~

  ~~~ css
  string.rtrim {
    foo: " hello world";
    bar: "";
  }
  ~~~

- Accepts a parameter with the characters to be trimmed

  ~~~ lay
  string.rtrim {
    baz: '(hey there] '.rtrim('(] h')
  }
  ~~~

  ~~~ css
  string.rtrim {
    baz: "(hey there";
  }
  ~~~

### `reverse`

- Returns a copy of the string, reversed

  ~~~ lay
  string.reverse {
    i: ''.reverse()
    ii: "roma".reverse
    iii: "España ".reverse
  }
  ~~~

  ~~~ css
  string.reverse {
    i: "";
    ii: "amor";
    iii: " añapsE";
  }
  ~~~

### `palindrome?`

- Checks if the string is a palindrome

  ~~~ lay
  string.palindrome {
    i: 'Lorem'.palindrome?
    ii: 'Eva, can I stab bats in a cave?'.palindrome?
    iii: "Dammit, I'm mad!".palindrome?
    iv: '   \naha\r '.palindrome?
    v: 'Anna?'.palindrome?
  }
  ~~~

  ~~~ css
  string.palindrome {
    i: false;
    ii: true;
    iii: true;
    iv: true;
    v: true;
  }
  ~~~

### `lower-case`

- Returns a "lower case" copy of the string

  ~~~ lay
  string.lower-case {
    i: 'Lorem Ipsum Dolor Sit Amet'.lower-case
  }
  ~~~

  ~~~ css
  string.lower-case {
    i: "lorem ipsum dolor sit amet";
  }
  ~~~

### `upper-case`

- Returns an "UPPER CASE" copy of the string

  ~~~ lay
  string.upper-case {
    foo: 'Lorem Ipsum Dolor Sit Amet'.upper-case
  }
  ~~~

  ~~~ css
  string.upper-case {
    foo: "LOREM IPSUM DOLOR SIT AMET";
  }
  ~~~

### `quoted?`

- Tells if the string is quoted

  ~~~ lay
  say-hello = ($who: "you") {
    return hello + $who
  }

  string.quoted {
    a: not hello-world.quoted?
    b: "hello world".quoted?, "hello world".trim.quoted?
    c: (hello + " world").quoted?
    d: say-hello('world').quoted?
    e: not say-hello(world).quoted?
    f: say-hello().quoted?
    g: hello-world.unquoted?
  }
  ~~~

  ~~~ css
  string.quoted {
    a: true;
    b: true, true;
    c: false;
    d: false;
    e: true;
    f: false;
    g: true;
  }
  ~~~

### `unquoted?`

- Tells if the string is unquoted

  ~~~ lay
  say-hello = ($who: "you") {
    return hello + $who
  }

  string.unquoted {
    h: not "hello world".unquoted?, not "hello world".trim.unquoted?
    i: not (hello + " world").unquoted?
    j: not say-hello('world').unquoted?
    k: say-hello(world).unquoted?
    l: not say-hello().unquoted?
  }
  ~~~

  ~~~ css
  string.unquoted {
    h: true, true;
    i: false;
    j: false;
    k: true;
    l: false;
  }
  ~~~

### `raw?`

- Tells if the string is a raw string

  ~~~ lay
  string.raw {
    i: "you".raw?
    ii: you.raw?
    iii: 'you'.raw?
    iv: ''.raw?
    v: `yo man`.raw?
  }
  ~~~

  ~~~ css
  string.raw {
    i: false;
    ii: false;
    iii: false;
    iv: false;
    v: true;
  }
  ~~~

### `quoted`

- Returns a quoted copy of the string

  ~~~ lay
  string.quoted {
    background: "background.jpg".quoted no-repeat.quoted
  }
  ~~~

  ~~~ css
  string.quoted {
    background: "background.jpg" "no-repeat";
  }
  ~~~

### `quote`

- Is an alias of `quoted`

  ~~~ lay
  string.quote {
    background: "background.jpg".quote no-repeat.quote
  }
  ~~~

  ~~~ css
  string.quote {
    background: "background.jpg" "no-repeat";
  }
  ~~~

### `unquoted`

- Returns an unquoted copy of the string

  ~~~ lay
  string.unquoted {
    background: "background.jpg".unquoted no-repeat.unquoted `top`.unquoted 'center'.unquoted
  }
  ~~~

  ~~~ css
  string.unquoted {
    background: background\.jpg no-repeat top center;
  }
  ~~~

### `unquote`

- Is an alias of `.unquoted`

  ~~~ lay
  string.unquote {
    background: "background.jpg".unquote no-repeat.unquote `top`.unquote
  }
  ~~~

  ~~~ css
  string.unquote {
    background: background\.jpg no-repeat top;
  }
  ~~~

### `raw`

- Returns a raw copy of the string

  ~~~ lay
  string.raw {
    i: foo.raw
    ii: "foo/bar".raw
    iii: 'foo\'bar'.raw
  }
  ~~~

  ~~~ css
  string.raw {
    i: foo;
    ii: foo/bar;
    iii: foo'bar;
  }
  ~~~

### `starts-with?`

- Tells if the string starts with given substring

  ~~~ lay
  string.starts-with {
    i: not "Hello world".starts-with?('hello')
    ii: "Hello world".starts-with?('Hello')
    iii: not " Hello world".starts-with?('Hello')
    iv: "Hello world".starts-with?(``)
  }
  ~~~

  ~~~ css
  string.starts-with {
    i: true;
    ii: true;
    iii: true;
    iv: true;
  }
  ~~~

### `ends-with?`

- Tells if the string ends with given substring

  ~~~ lay
  string.ends-with {
    i: not "Hello world".ends-with?('world ')
    ii: "Hello world".ends-with?('world')
    iii: not "Hello world ".ends-with?('world')
    iv: "Hello world".ends-with?('')
  }
  ~~~

  ~~~ css
  string.ends-with {
    i: true;
    ii: true;
    iii: true;
    iv: true;
  }
  ~~~

### `split`

- Splits a string by another string

  ~~~ lay
  string.split {
    i: ('Lorem ipsum dolor sit amet' / ' ').commas
  }
  ~~~

  ~~~ css
  string.split {
    i: "Lorem", "ipsum", "dolor", "sit", "amet";
  }
  ~~~

- Splits a string by a regular expression.

  ~~~ lay
  sp = /\s+/

  string.split {
    foo: 'Lorem    ipsum   \n\t \r\n dolor \
    sit amet' / sp
  }
  ~~~

  ~~~ css
  string.split {
    foo: "Lorem" "ipsum" "dolor" "sit" "amet";
  }
  ~~~

- Accepts a `limit` argument

  ~~~ lay
  $str = 'Lorem ipsum dolor sit amet'
  string.split {
    i: $str.split(/\s+/, 2)
    ii: $str.split(/\s+/, 0).length
    iii: $str.split(/\s+/, null)
  }
  ~~~

  ~~~ css
  string.split {
    i: "Lorem" "ipsum";
    ii: 0;
    iii: "Lorem" "ipsum" "dolor" "sit" "amet";
  }
  ~~~

### `characters`

- Splits the string in characters and returns them as a list

  ~~~ lay
  string.characters {
    i: 'Lorem'.characters
    ii: ipsum.characters
    iii: "España".characters
  }
  ~~~

  ~~~ css
  string.characters {
    i: "L" "o" "r" "e" "m";
    ii: i p s u m;
    iii: "E" "s" "p" "a" "ñ" "a";
  }
  ~~~

  ~~~ lay
  string.characters {
    for char in 'ipsum'.characters {
      char: char
    }
  }
  ~~~

  ~~~ css
  string.characters {
    char: "i";
    char: "p";
    char: "s";
    char: "u";
    char: "m";
  }
  ~~~

  ~~~ lay
  string.characters {
    for i, char in "ipsum".characters {
      char-#{i}: char
    }
  }
  ~~~

  ~~~ css
  string.characters {
    char-0: "i";
    char-1: "p";
    char-2: "s";
    char-3: "u";
    char-4: "m";
  }
  ~~~

- Returns an empty list for empty strings

  ~~~ lay
  string.characters {
    i: ''.characters.length
  }
  ~~~

  ~~~ css
  string.characters {
    i: 0;
  }
  ~~~

### `lines`

- Splits the string in lines and returns them as a list

  ~~~ lay
  string.lines {
    foo: 'Lorem ipsum\ndolor sit\namet\nconsectetur \
  adipiscing \
  elit'.lines
  }
  ~~~

  ~~~ css
  string.lines {
    foo: "Lorem ipsum" "dolor sit" "amet" "consectetur adipiscing elit";
  }
  ~~~

- Works with any line ending

  ~~~ lay
  string.lines {
    i: 'Lorem\nipsum\rdolor\r\nsit'.lines
  }
  ~~~

  ~~~ css
  string.lines {
    i: "Lorem" "ipsum" "dolor" "sit";
  }
  ~~~

- Does not create empty chunks

  ~~~ lay
  string.lines {
    i: '\nLorem\n\nipsum\ndolor\nsit\n'.lines
  }
  ~~~

  ~~~ css
  string.lines {
    i: "Lorem" "ipsum" "dolor" "sit";
  }
  ~~~

- Trims the lines

  ~~~ lay
  string.lines {
    i: '  Lorem\nipsum   \r   dolor   \r\n sit\n\n   amet\n'.lines
  }
  ~~~

  ~~~ css
  string.lines {
    i: "Lorem" "ipsum" "dolor" "sit" "amet";
  }
  ~~~

- Returns an empty list for blank strings

  ~~~ lay
  string.lines {
    i: ''.lines.length
    ii: ' \n \r \t '.lines.length
  }
  ~~~

  ~~~ css
  string.lines {
    i: 0;
    ii: 0;
  }
  ~~~

### `words`

- Splits the string in words and returns them as a list

  ~~~ lay
  string.words {
    i: `Lorem`.words
    ii: 'Lorem ipsum dolor'.words
  }
  ~~~

  ~~~ css
  string.words {
    i: Lorem;
    ii: "Lorem" "ipsum" "dolor";
  }
  ~~~

- Works with any line ending

  ~~~ lay
  string.words {
    i: `Lorem\nipsum\r\ndolor\n\rsit\ramet`.words
  }
  ~~~

  ~~~ css
  string.words {
    i: Lorem ipsum dolor sit amet;
  }
  ~~~

- Does not create empty chunks

  ~~~ lay
  string.words {
    for i, wd in `  Lorem . ipsum    dolor.  .  `.words {
      word-#{i}: wd
    }
  }
  ~~~

  ~~~ css
  string.words {
    word-0: Lorem;
    word-1: ipsum;
    word-2: dolor;
  }
  ~~~

- Returns an empty list for blank strings

  ~~~ lay
  string.words {
    i: ''.words.length
    ii: '   '.words.length
    iii: '  \t \r \n  '.words.length
  }
  ~~~

  ~~~ css
  string.words {
    i: 0;
    ii: 0;
    iii: 0;
  }
  ~~~

### `numeric?`

- Tells if the string looks like a number

  ~~~ lay
  string.numeric {
    foo: '10'.numeric?
    foo: not 'px'.numeric?
    foo: not 'a10'.numeric?
    foo: '10px'.numeric?
    foo: ' 10px '.numeric?
    foo: '0'.numeric?
    foo: `5.5px`.numeric?
  }
  ~~~

  ~~~ css
  string.numeric {
    foo: true;
    foo: true;
    foo: true;
    foo: true;
    foo: true;
    foo: true;
    foo: true;
  }
  ~~~

### `replace`

- Searches for the given string or regular expression and replaces with another string

  ~~~ lay
  string.replace {
    foo: "Mr Blue has a blue house and a blue car".replace('blue', 'red')
    foo: "Mr Blue has a blue house and a blue car".replace(/blue/g, 'green')
    foo: 'Mr Blue has a blue house and a blue car'.replace(/blue/gi, 'pink')
    foo: 'Mr Blue has a blue house and a blue car'.replace(/green/gi, 'pink')
  }
  ~~~

  ~~~ css
  string.replace {
    foo: "Mr Blue has a red house and a red car";
    foo: "Mr Blue has a green house and a green car";
    foo: "Mr pink has a pink house and a pink car";
    foo: "Mr Blue has a blue house and a blue car";
  }
  ~~~

### `number`

- Makes a number from the string, if it is numeric

  ~~~ lay
  string.number {
    foo: "12px".number
    foo: `3.14pt`.number
    foo: `-17%`.number
    foo: `000`.number
  }
  ~~~

  ~~~ css
  string.number {
    foo: 12px;
    foo: 3.14pt;
    foo: -17%;
    foo: 0;
  }
  ~~~

- Fails for non-numeric strings

  ~~~ lay
  foo: ''.number
  ~~~

  ~~~ ValueError
  ~~~

  ~~~ lay
  foo: ''.number
  ~~~

  ~~~ ValueError
  ~~~

  ~~~ lay
  foo: ' '.number
  ~~~

  ~~~ ValueError
  ~~~

  ~~~ lay
  foo: '100px20'.number
  ~~~

  ~~~ ValueError
  ~~~

  ~~~ lay
  foo: 'a'.number
  ~~~

  ~~~ ValueError
  ~~~

  ~~~ lay
  foo: '2.2.2px'.number
  ~~~

  ~~~ ValueError
  ~~~

### `base64`

- Returns a copy of the string, encoded as Base64

  ~~~ lay
  string.base64 {
    i: "I have 1€ and £1".base64
  }
  ~~~

  ~~~ css
  string.base64 {
    i: "SSBoYXZlIDHigqwgYW5kIMKjMQ==";
  }
  ~~~

### `eval`

- Evaluates string contents as layla code

  ~~~ lay
  string.eval {
    'color: red'.eval
  }
  ~~~

  ~~~ css
  string.eval {
    color: red;
  }
  ~~~

- Uses current context

  ~~~ lay
  $white = #fff

  string.eval {
    $lay = '
    > div {
      background-color: $white
    }
    '

    $lay.eval()
  }
  ~~~

  ~~~ css
  string.eval > div {
    background-color: #ffffff;
  }
  ~~~

- Returns the last evaluated statement

  ~~~ lay
  string.eval {
    $lay = '2; true; $foo = "Yo!"'
    i: $lay.eval
    ii: '#f00;;'.eval
  }
  ~~~

  ~~~ css
  string.eval {
    i: "Yo!";
    ii: #ff0000;
  }
  ~~~

- Returns `null` for strings with no statements

  ~~~ lay
  string.eval {
    i: "".eval
    ii: "
    ".eval
    iii: ";".eval
    iv: " ; ;;".eval
    v: `if false {}`.eval
  }
  ~~~

  ~~~ css
  string.eval {
    i: null;
    ii: null;
    iii: null;
    iv: null;
    v: null;
  }
  ~~~

### `copy`

- Creates a copy of the string

  ~~~ lay
  string.copy {
    orig = "Hello world"
    str = orig.copy
    val: str
    quote: str.quoted?
    diff: str isnt orig

    if str.copy.copy.copy isnt orig {
      god: damn!
    }
  }
  ~~~

  ~~~ css
  string.copy {
    val: "Hello world";
    quote: true;
    diff: false;
  }
  ~~~
