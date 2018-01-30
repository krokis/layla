# Include

- Imports rulesets from a external file onto current block

  ~~~ lay
  include './include/base.lay'
  include './include/extensionless'
  ~~~

  ~~~ css
  body p {
    font-family: "Helvetica";
    font-size: 12px;
  }

  foo {
    bar: baz!;
  }
  ~~~

- Can be called on any block

  ~~~ lay
  html {
    include './include/base.lay'
  }
  ~~~

  ~~~ css
  html body p {
    font-family: "Helvetica";
    font-size: 12px;
  }
  ~~~

- Works if called twice on the same file

  ~~~ lay
  html {
    include './include/base.lay'
    include './include/base.lay'
  }
  ~~~

  ~~~ css
  html body p {
    font-family: "Helvetica";
    font-size: 12px;
  }

  html body p {
    font-family: "Helvetica";
    font-size: 12px;
  }
  ~~~

- Imports symbols

  ~~~ lay
  html {
    include './include/base.lay'

    a {
      font: $base-font
    }
  }
  ~~~

  ~~~ css
  html body p {
    font-family: "Helvetica";
    font-size: 12px;
  }

  html a {
    font: "Helvetica";
  }
  ~~~

- Can import CSS files

  ~~~ lay
  include './include/layout.css'
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
    include "include/base.lay",
            "include/layout.lay"
  }
  ~~~

  ~~~ css
  html body p {
    font-family: "Futura";
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
  path = './include/'
  base = 'base.lay'

  include ("#{path}layout.css"), path + base
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
    font-family: "Helvetica";
    font-size: 12px;
  }
  ~~~

- Included files can recursively include others

  ~~~ lay
  html {
    include 'include/base-comic.lay'
  }
  ~~~

  ~~~ css
  html body p {
    font-family: "Comic Sans";
    font-size: 12px;
  }
  ~~~

- Uses current scope when evaluating included files, so variables can be shared

  ~~~ lay
  $base-font = "Comic Sans"

  html {
    include './include/base.lay'
  }
  ~~~

  ~~~ css
  html body p {
    font-family: "Comic Sans";
    font-size: 12px;
  }
  ~~~

- Imported rule-sets and properties can be isolated by using a block

  ~~~ lay
  include 'include/base.lay';

  $font = { include 'include/font.lay'}
  $back = { include 'include/font.lay'}
  $back = { include 'include/background.lay'}

  body {
    background-color: $back::color
    font: $font::family
    font-family: $base-font
    foo: $back::family
  }
  ~~~

  ~~~ css
  body p {
    font-family: "Helvetica";
    font-size: 12px;
  }

  body {
    background-color: #fff;
    font: "Helvetica";
    font-family: "Helvetica";
    foo: null;
  }
  ~~~

- URL's can be used instead of strings

  ~~~ lay
  $inc = url(./include/)

  html {
    include $inc + './../include/base.lay'
  }

  include url('./include/layout.lay')
  ~~~

  ~~~ css
  html body p {
    font-family: "Helvetica";
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
  include './include/this-is-not-a-real-file.lay'
  ~~~

  ~~~ IncludeError
  Could not include "./include/this-is-not-a-real-file.lay"
  ~~~

- Fails for unreadable files
