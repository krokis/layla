# Unicode ranges

- Are supported

  ~~~ lay
  unicode-ranges {
    unicode-range: U+26
    unicode-range: U+0-7F
    unicode-range: U+0025-00FF
    unicode-range: U+4??
    unicode-range: U+0025-00FF, U+4??
  }
  ~~~

  ~~~ css
  unicode-ranges {
    unicode-range: U+26;
    unicode-range: U+0-7F;
    unicode-range: U+0025-00FF;
    unicode-range: U+4??;
    unicode-range: U+0025-00FF, U+4??;
  }
  ~~~

- Can be lowercased

  ~~~ lay
  unicode-ranges {
    unicode-range: u+26
    unicode-range: u+0-7f
    unicode-range: u+0025-00ff
    unicode-range: u+4??
    unicode-range: u+0025-00ff, u+4??
  }
  ~~~

  ~~~ css
  unicode-ranges {
    unicode-range: U+26;
    unicode-range: U+0-7F;
    unicode-range: U+0025-00FF;
    unicode-range: U+4??;
    unicode-range: U+0025-00FF, U+4??;
  }
  ~~~
