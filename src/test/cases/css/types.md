CSS Types
=========

## Functions

### `regexp()`

- Creates a new `RegExp`

  ~~~ lay
  regexp {
    i: regexp('.*')
    ii: (regexp(bar) ~ foobar)::0
    iii: (regexp("^bar") ~ foobar) or nope
    iv: (regexp(  `^foo`  ) ~ Foobar) or nope
  }
  ~~~

  ~~~ css
  regexp {
    i: regexp(".*");
    ii: bar;
    iii: nope;
    iv: nope;
  }
  ~~~

- Creates a case-sensitive, non-global, non-multiline `RegExp`

  ~~~ lay
  regexp {
    i: regexp('^$').multiline?
    ii: regexp('^$').global?
    iii: regexp('^$').insensitive?
  }
  ~~~

  ~~~ css
  regexp {
    i: false;
    ii: false;
    iii: false;
  }
  ~~~
