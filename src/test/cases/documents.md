Documents
=========

- Can be empty

  ~~~ lay
  ~~~

  ~~~ css
  ~~~

## Can have any type of line endings

- LF

  ~~~ lay
  import 'whitespace/lf.lay'
  ~~~

  ~~~ css
  @lf {
    is: ok;
  }
  ~~~

- CR

  ~~~ lay
  import 'whitespace/cr.lay'
  ~~~

  ~~~ css
  @cr {
    is: ok;
  }
  ~~~

- CRLF

  ~~~ lay
  import 'whitespace/crlf.lay'
  ~~~

  ~~~ css
  @crlf {
    is: ok;
  }
  ~~~

## Charset

- Defaults to UTF-8

- UTF8 BOM's are ignored

  ~~~ lay
  import 'whitespace/bom.lay'
  ~~~

  ~~~ css
  @bom {
    is: ok;
  }
  ~~~
