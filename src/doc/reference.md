# Language reference

## Syntax

## Comments

Line (`//...`) and block (`/* ... */` comments are allowed. Both types are by default output as `/* ... */` on css.

## Line comments

``` lay-todo
// This is a line comment
```

```css-todo
/* This is a line comment */
```

## Block comments

```lay-todo
/**
 * This is a block comment
 */
```

```css-todo
/**
 * This is a block comment
 */
```

## Types and expressions

### Strings

You can use single (`'`) and double (`"`") quotes to define a string literal.

``` lay
comic-sans = 'Comic Sans'
helvetica = 'Helvetica'

body {
  font-family: helvetica, comic-sans
}
```

``` css
body {
  font-family: 'Helvetica', 'Comic Sans';
}
```

The following escape characters can be represented with backslash notation:

* `\n`: Newline
* `\r`: Carriage return
* `\t`: Tab

Also:
- Newline escape.
- Unicode escapes

### Numbers

### Null

### Regular expressions

Layla natively support regular expressions between slashes (`/.../`). You can
test strings and other types of variables against a regular expression using the binary `~` operator.

```lay-todo
body {
  matches: 'http://www.disney.com' ~ //
}
```

Empty regular expressions cannot be created with the `/.../` syntax (`//` is
interpreted an line comment).

### Colors

Layla supports colors as first-class types. Hexadecimal numbers and common CSS color functions generate color objects:

~~~~ lay-todo
~~~~

In CSS, hex literals may have 3/4 or 6/8 digits.

Layla provides two more shortcuts. If you write a color with only 1 or 2 hexadecimal digits...

### Lists

### Ranges

### Blocks

### Properties

### Rule sets

### At-rules

### Functions

## Operators

### Assignment

### Arithmetical

### Negation

### Relational

### Concatenation

### Subscript

### Logical

### `is` and `isnt`

### `in`, `not in`, `has` and `hasnt`

### `is-a` and `isnt-a`

### Parentheses

### Operator precedence

 # | Operator | Associativity | Description |
---|----------|---------------|-------------|
 . |

## Interpolation

## Conditionals

## Loops

### `while ...` and `until ...`

### `for ... in ...`

### `break` and `continue`

## Functions
