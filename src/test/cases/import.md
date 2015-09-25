Import
======

- Imports rulesets from a external file onto current block

  ~~~ lay
  import './import/base.lay'
  import './import/extensionless'
  ~~~

  ~~~ css
  body p {
    font-family: 'Helvetica';
    font-size: 12px;
  }

  foo {
    bar: baz!;
  }
  ~~~

- Can be called on any block

  ~~~ lay
  html {
    import './import/base.lay'
  }
  ~~~

  ~~~ css
  html body p {
    font-family: 'Helvetica';
    font-size: 12px;
  }
  ~~~

- Works if called twice on the same file

  ~~~ lay
  html {
    import './import/base.lay'
    import './import/base.lay'
  }
  ~~~

  ~~~ css
  html body p {
    font-family: 'Helvetica';
    font-size: 12px;
  }

  html body p {
    font-family: 'Helvetica';
    font-size: 12px;
  }
  ~~~

- Imports symbols

  ~~~ lay
  html {
    import './import/base.lay'

    a {
      font: $base-font
    }
  }
  ~~~

  ~~~ css
  html body p {
    font-family: 'Helvetica';
    font-size: 12px;
  }

  html a {
    font: 'Helvetica';
  }
  ~~~

- Can import CSS files

  ~~~ lay
  import './import/layout.css'
  ~~~

  ~~~ css
  body {
    max-width: 940px;
  }

  body header {
    position: absolute;
    top: 0;
  }
  ~~~

- Multiple comma-separted files can be passed

  ~~~ lay
  $base-font  |= 'Futura'
  $body-width |= 1200px

  html {
    import "import/base.lay",
           "import/layout.lay"
  }
  ~~~

  ~~~ css
  html body p {
    font-family: 'Futura';
    font-size: 12px;
  }

  html body {
    max-width: 1200px;
  }

  html body header {
    position: absolute;
    top: 0;
  }
  ~~~

- Arguments can be any type of expressions

  ~~~ lay
  path = './import/'
  base = 'base.lay'

  import ("{path}layout.css"), path + base
  ~~~

  ~~~ css
  body {
    max-width: 940px;
  }

  body header {
    position: absolute;
    top: 0;
  }

  body p {
    font-family: 'Helvetica';
    font-size: 12px;
  }
  ~~~

- Imported files can recursively import others

  ~~~ lay
  html {
    import 'import/base-comic.lay'
  }
  ~~~

  ~~~ css
  html body p {
    font-family: 'Comic Sans';
    font-size: 12px;
  }
  ~~~

- Uses current scope when evaluating the imported files, so variables can be shared

  ~~~ lay
  $base-font = "Comic Sans"

  html {
    import './import/base.lay'
  }
  ~~~

  ~~~ css
  html body p {
    font-family: "Comic Sans";
    font-size: 12px;
  }
  ~~~

- Imported rule-sets and properties can be assigned to variables instead of being imported in current block with `as`

  ~~~ lay
  import 'import/base.lay',
         'import/font.lay' as $font,
         'import/font.lay' as $back,
         'import/background.lay' as $back

  body {
    background-color: $back::color
    font: $font::family
    font-family: $base-font
    foo: $back::family
  }
  ~~~

  ~~~ css
  body p {
    font-family: 'Helvetica';
    font-size: 12px;
  }

  body {
    background-color: white;
    font: 'Helvetica';
    font-family: 'Helvetica';
    foo: null;
  }
  ~~~

- URL's can be used instead of strings

  ~~~ lay
  $inc = url(./import/)

  html {
    import $inc + './../import/base.lay'
  }

  import url('./import/layout.lay')
  ~~~

  ~~~ css
  html body p {
    font-family: 'Helvetica';
    font-size: 12px;
  }

  body {
    max-width: 940px;
  }

  body header {
    position: absolute;
    top: 0;
  }
  ~~~

- Fails for non-existent files

  ~~~ lay
  import './import/this-is-not-a-real-file.lay'
  ~~~

  ~~~ RuntimeError
  Could not import file: "./import/this-is-not-a-real-file.lay"
  ~~~

- Fails for unreadable files
