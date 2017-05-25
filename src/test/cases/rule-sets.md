Rule sets
=========

- Can have an empty body

  ~~~ lay
  body
  {
    if not true
    {
      border-color: #f00
    }
  }
  ;body{} ; ; ; div {};
  ~~~

  ~~~ css
  ~~~

- Can be nested

  ~~~ lay
  body {
    color: #000;

    div {
      border: #f00
      padding: 20px

      b {
        font-weight: 700
      }
    }
  }
  ~~~

  ~~~ css
  body {
    color: #000;
  }

  body div {
    border: #f00;
    padding: 20px;
  }

  body div b {
    font-weight: 700;
  }
  ~~~

## Selectors

- Can be multiple

  ~~~ lay
  html, body, p {
    font-family: "Helvetica"
  }

  table,
  tbody,tfoot,
  th, td
  {
    padding: 0
    margin: 0
  }

  *[hidden] ::after, ::before { display: none }
  ~~~

  ~~~ css
  html,
  body,
  p {
    font-family: "Helvetica";
  }

  table,
  tbody,
  tfoot,
  th,
  td {
    padding: 0;
    margin: 0;
  }

  *[hidden] ::after,
  ::before {
    display: none;
  }
  ~~~

## Support common syntax

### Simple selectors

#### Universal selectors

- Are supported

  ~~~ lay
  * {
    color: #f00
  }
  html * * {
    color: grey
  }
  ~~~

  ~~~ css
  * {
    color: #f00;
  }

  html * * {
    color: #808080;
  }
  ~~~

#### Type selectors

- Are supported

  ~~~ lay
  body, div_2 {
    color: #000
  }
  ~~~

  ~~~ css
  body,
  div_2 {
    color: #000;
  }
  ~~~

- Support namespaces

  ~~~ lay
  foo|body { color: white }
  *|body { color: white }
  |body { color: white }
  ~~~

  ~~~ css
  foo|body {
    color: #fff;
  }

  *|body {
    color: #fff;
  }

  |body {
    color: #fff;
  }
  ~~~

- Support escapes

  ~~~ lay
  \#foo\20 bar\.baz        { border: 0 }
  ~~~

  ~~~ css
  \#foo\20 bar\.baz {
    border: 0;
  }
  ~~~

- Are correctly scaped

  ~~~ lay
  $special-chars = "!\"#$%&'()*+,./:;<=>?@[]^`{|}~- \t\n\r\n\r\\"

  #{$special-chars} {
    color: none
  }

  my-o#{$special-chars.characters.join('o')}o-tag {
    color: none
  }
  ~~~

  ~~~ css
  \!\"\#\$\%\&\'\(\)\*\+\,\.\/\:\;\<\=\>\?\@\[\]\^\`\{\|\}\~-\20\9\A\D\A\D\\ {
    color: none;
  }

  my-o\!o\"o\#o\$o\%o\&o\'o\(o\)o\*o\+o\,o\.o\/o\:o\;o\<o\=o\>o\?o\@o\[o\]o\^o\`o\{o\|o\}o\~o-o\20o\9o\Ao\Do\Ao\Do\\o-tag {
    color: none;
  }
  ~~~

- Support interpolation

  ~~~ lay
  doc = 'bod'

  html > #{doc + 'y'}.js {
    color: white
  }
  ~~~

  ~~~ css
  html > body.js {
    color: #fff;
  }
  ~~~

  ~~~ lay
  $ns = 'svg'

  #{$ns}|circle {
    border: 2px solid red
  }
  ~~~

  ~~~ css
  svg|circle {
    border: 2px solid #f00;
  }
  ~~~

#### Class selectors

- Are supported

  ~~~ lay
  .h1 {
    font-size: largest
  }

  .col-xs-4 {
    width: 33.33%
  }

  *.hide {
    display: none
  }

  div.col-xs-4.hide {
    width: 0
  }
  ~~~

  ~~~ css
  .h1 {
    font-size: largest;
  }

  .col-xs-4 {
    width: 33.33%;
  }

  *.hide {
    display: none;
  }

  div.col-xs-4.hide {
    width: 0;
  }
  ~~~

- Support escapes

  ~~~ lay
  .my\.very\.special\@class {
    color: none
  }
  ~~~

  ~~~ css
  .my\.very\.special\@class {
    color: none;
  }
  ~~~

- Are correctly scaped

  ~~~ lay
  $special-chars = "!\"#$%&'()*+,./:;<=>?@[]^`{|}~- \t\n\r\n\r\\"

  .#{$special-chars} {
    color: none
  }

  .my-o#{$special-chars.characters.join('o')}o-class {
    color: none
  }
  ~~~

  ~~~ css
  .\!\"\#\$\%\&\'\(\)\*\+\,\.\/\:\;\<\=\>\?\@\[\]\^\`\{\|\}\~-\20\9\A\D\A\D\\ {
    color: none;
  }

  .my-o\!o\"o\#o\$o\%o\&o\'o\(o\)o\*o\+o\,o\.o\/o\:o\;o\<o\=o\>o\?o\@o\[o\]o\^o\`o\{o\|o\}o\~o-o\20o\9o\Ao\Do\Ao\Do\\o-class {
    color: none;
  }
  ~~~

- Support interpolation

  ~~~ lay
  class = 'mobile'

  body.#{class} {
    width: 800px
  }
  ~~~

  ~~~ css
  body.mobile {
    width: 800px;
  }
  ~~~

#### Id selectors

- Are supported

  ~~~ lay
  #H1 {
    width: 33.33%
  }

  #col-1 {
    width: 25%
  }

  form#form#form.hide {
    visibility: hidden
  }

  .hide#form {
    display: none
  }
  ~~~

  ~~~ css
  #H1 {
    width: 33.33%;
  }

  #col-1 {
    width: 25%;
  }

  form#form#form.hide {
    visibility: hidden;
  }

  .hide#form {
    display: none;
  }
  ~~~

- Support escapes

  ~~~ lay
  #\#foo\20 bar\.baz        { border: 0 }
  ~~~

  ~~~ css
  #\#foo\20 bar\.baz {
    border: 0;
  }
  ~~~

- Are correctly scaped

  ~~~ lay
  $special-chars = "!\"#$%&'()*+,./:;<=>?@[]^`{|}~- \t\n\r\n\r\\"

  ##{$special-chars} {
    color: none
  }

  #my-o#{$special-chars.characters.join('o')}o-id {
    color: none
  }
  ~~~

  ~~~ css
  #\!\"\#\$\%\&\'\(\)\*\+\,\.\/\:\;\<\=\>\?\@\[\]\^\`\{\|\}\~-\20\9\A\D\A\D\\ {
    color: none;
  }

  #my-o\!o\"o\#o\$o\%o\&o\'o\(o\)o\*o\+o\,o\.o\/o\:o\;o\<o\=o\>o\?o\@o\[o\]o\^o\`o\{o\|o\}o\~o-o\20o\9o\Ao\Do\Ao\Do\\o-id {
    color: none;
  }
  ~~~

- Support interpolation

  ~~~ lay
  id = 'main'

  div##{id} #header {
    font-size: 48px
  }
  ~~~

  ~~~ css
  div#main #header {
    font-size: 48px;
  }
  ~~~

#### Attribute selectors

- Attribute is present

  ~~~ lay
  a[href] {
    text-decoration: underline
  }

  a[ href ] {
    text-decoration: underline
  }

  a[href][data-external], a[href].external {
    color: #f00
  }
  ~~~

  ~~~ css
  a[href] {
    text-decoration: underline;
  }

  a[href] {
    text-decoration: underline;
  }

  a[href][data-external],
  a[href].external {
    color: #f00;
  }
  ~~~

- Attribute is exactly

  ~~~ lay
  *[href="http://disney.es"] {
    color: pink
  }

  *[href = "http://disney.es" ] {
    color: pink
  }

  [target=_blank] {
    text-decoration: underline
  }

  [target=   _blank] {
    text-decoration: underline
  }

  [target   =_blank] {
    text-decoration: underline
  }
  ~~~

  ~~~ css
  *[href="http://disney.es"] {
    color: #ffc0cb;
  }

  *[href="http://disney.es"] {
    color: #ffc0cb;
  }

  [target=_blank] {
    text-decoration: underline;
  }

  [target=_blank] {
    text-decoration: underline;
  }

  [target=_blank] {
    text-decoration: underline;
  }
  ~~~

- Attribute is or is prefixed by

  ~~~ lay
  [foo|=bar] {
    foo: bar
  }
  ~~~

  ~~~ css
  [foo|=bar] {
    foo: bar;
  }
  ~~~

- Attribute contains substring

  ~~~ lay
  [foo*=bar] {
    foo: bar
  }
  ~~~

  ~~~ css
  [foo*=bar] {
    foo: bar;
  }
  ~~~

- Attribute contains in list

  ~~~ lay
  [foo~=bar] {
    foo: bar
  }
  ~~~

  ~~~ css
  [foo~=bar] {
    foo: bar;
  }
  ~~~

- Attribute is prefixed by

  ~~~ lay
  [href^=http] {
    text-decoration: underline
  }
  ~~~

  ~~~ css
  [href^=http] {
    text-decoration: underline;
  }
  ~~~

- Attribute is suffixed by

  ~~~ lay
  *[class$="-xl"] {
    font-size: larger
  }

  *[class $= "-xl"] {
    font-size: larger
  }
  ~~~

  ~~~ css
  *[class$="-xl"] {
    font-size: larger;
  }

  *[class$="-xl"] {
    font-size: larger;
  }
  ~~~

- Case-sensitivity flag

  ~~~ lay
  [data-foo="bar" i] {
    display: block
  }

  [data-foo="bar"  i  ] {
    display: block
  }
  ~~~

  ~~~ css
  [data-foo="bar" i] {
    display: block;
  }

  [data-foo="bar" i] {
    display: block;
  }
  ~~~

- Support namespaces

  ~~~ lay
  a[html|href] {
    text-decoration: none
  }

  a[html|target=_blank] {
    text-decoration: underline
  }
  ~~~

  ~~~ css
  a[html|href] {
    text-decoration: none;
  }

  a[html|target=_blank] {
    text-decoration: underline;
  }
  ~~~

- Support escapes

  ~~~ lay
  *[\#\[\\foo\20 bar\.baz=2] { border: 0 }
  ~~~

  ~~~ css
  *[\#\[\\foo\20 bar\.baz=2] {
    border: 0;
  }
  ~~~

- Are correctly scaped

  ~~~ lay
  $special-chars = "!\"#$%&'()*+,./:;<=>?@[]^`{|}~- \t\n\r\n\r\\"

  [#{$special-chars}] {
    color: none
  }

  [my-o#{$special-chars.characters.join('o')}o-attr="foo"] {
    color: none
  }
  ~~~

  ~~~ css
  [\!\"\#\$\%\&\'\(\)\*\+\,\.\/\:\;\<\=\>\?\@\[\]\^\`\{\|\}\~-\20\9\A\D\A\D\\] {
    color: none;
  }

  [my-o\!o\"o\#o\$o\%o\&o\'o\(o\)o\*o\+o\,o\.o\/o\:o\;o\<o\=o\>o\?o\@o\[o\]o\^o\`o\{o\|o\}o\~o-o\20o\9o\Ao\Do\Ao\Do\\o-attr="foo"] {
    color: none;
  }
  ~~~

- Support interpolation

  ~~~ lay
  attr = 'target'

  a[#{attr}="_blank"] {
    after: ' (External) '
  }

  a[#{attr}=_blank] {
    after: ' (External) '
  }
  ~~~

  ~~~ css
  a[target="_blank"] {
    after: " (External) ";
  }

  a[target=_blank] {
    after: " (External) ";
  }
  ~~~

  ~~~ lay
  ext-target = '_blank'

  a[target=#{ext-target}] {
    after: ' (External) '
  }

  a[target="#{ext-target}"] {
    after: ' (External) '
  }
  ~~~

  ~~~ css
  a[target=_blank] {
    after: " (External) ";
  }

  a[target="_blank"] {
    after: " (External) ";
  }
  ~~~
  ~~~ lay
  body a[target]:#{'after'} {
    content: '(EXT)'
  }

  body a:hov#{'e' + 'r'} {
    text-decoration: underline
  }
  ~~~

  ~~~ css
  body a[target]:after {
    content: "(EXT)";
  }

  body a:hover {
    text-decoration: underline;
  }
  ~~~

  ~~~ lay
  $ns = 'svg'

  #{"*"}|*[#{$ns}|stroke] {
    border: none
  }
  ~~~

  ~~~ css
  *|*[svg|stroke] {
    border: none;
  }
  ~~~

#### Pseudo selectors

- Pseudo-classes

  ~~~ lay
  a:hover {
    text-decoration: underline
  }
  ~~~

  ~~~ css
  a:hover {
    text-decoration: underline;
  }
  ~~~

- Pseudo-elements

  ~~~ lay
  a[ext]::after {
    content: ' (External) '
  }

  ::before {
    display: none
  }
  ~~~

  ~~~ css
  a[ext]::after {
    content: " (External) ";
  }

  ::before {
    display: none;
  }
  ~~~

- Arguments

  ~~~ lay
  tr:nth-child(2n+1) {
    background: #c0c0c0
  }

  tr:nth-of-type(odd) {
    background: #c0c0c0
  }

  html:lang(it) {
    background: #ff0
  }

  p:not(.par[imp=yes]#foo) {
    margin: 0 0 50px
  }

  p:not(.foo, .bar) {
    margin: 0 0 50px
  }
  ~~~

  ~~~ css
  tr:nth-child(2n + 1) {
    background: #c0c0c0;
  }

  tr:nth-of-type(odd) {
    background: #c0c0c0;
  }

  html:lang(it) {
    background: #ff0;
  }

  p:not(.par[imp=yes]#foo) {
    margin: 0 0 50px;
  }

  p:not(.foo, .bar) {
    margin: 0 0 50px;
  }
  ~~~

- Support escapes

  ~~~ lay
  *:\#not\20 bar\.baz(2px)        { border: 0 }
  ~~~

  ~~~ css
  *:\#not\20 bar\.baz(2px) {
    border: 0;
  }
  ~~~

- Are correctly scaped

  ~~~ lay
  $special-chars = "!\"#$%&'()*+,./:;<=>?@[]^`{|}~- \t\n\r\n\r\\"

  a:#{$special-chars} {
    color: none
  }

  a:link::my-o#{$special-chars.characters.join('o')}o-pseudo('bar') {
    color: none
  }
  ~~~

  ~~~ css
  a:\!\"\#\$\%\&\'\(\)\*\+\,\.\/\:\;\<\=\>\?\@\[\]\^\`\{\|\}\~-\20\9\A\D\A\D\\ {
    color: none;
  }

  a:link::my-o\!o\"o\#o\$o\%o\&o\'o\(o\)o\*o\+o\,o\.o\/o\:o\;o\<o\=o\>o\?o\@o\[o\]o\^o\`o\{o\|o\}o\~o-o\20o\9o\Ao\Do\Ao\Do\\o-pseudo("bar") {
    color: none;
  }
  ~~~


- Support interpolation

  ~~~ lay
  body a[target]:#{'after'} {
    content: '(EXT)'
  }

  body a:hov#{'e' + 'r'} {
    text-decoration: underline
  }
  ~~~

  ~~~ css
  body a[target]:after {
    content: "(EXT)";
  }

  body a:hover {
    text-decoration: underline;
  }
  ~~~

### Combinators

- Descendant combinator

  ~~~ lay
  html head body {
    max-width: 640px
  }
  ~~~

  ~~~ css
  html head body {
    max-width: 640px;
  }
  ~~~

- Child combinator

  ~~~ lay
  html > head > body {
    max-width: 640px
  }
  ~~~

  ~~~ css
  html > head > body {
    max-width: 640px;
  }
  ~~~

- Following sibling combinator

  ~~~ lay
  * ul > li ~ li {
    display: block
  }
  ~~~

  ~~~ css
  * ul > li ~ li {
    display: block;
  }
  ~~~

- Next sibling combinator

  ~~~ lay
  * ul li + li ~ li {
    display: block
  }
  ~~~

  ~~~ css
  * ul li + li ~ li {
    display: block;
  }
  ~~~

- They can appear at the begining of the selector

  ~~~ lay
  + div {
    color: #0f0
  }

  ~ b {
    color: #000
  }
  > div {
    color: #f00
  }
  ~~~

  ~~~ css
  + div {
    color: #0f0;
  }

  ~ b {
    color: #000;
  }

  > div {
    color: #f00;
  }
  ~~~

### Parent selector

- Is implicit

  ~~~ lay
  body {
    div {
      b {
        border: #f00
      }
    }
  }

  h1, h2, h3 {
    a, p { color: #f00 }
  }
  ~~~

  ~~~ css
  body div b {
    border: #f00;
  }

  h1 a,
  h2 a,
  h3 a,
  h1 p,
  h2 p,
  h3 p {
    color: #f00;
  }
  ~~~

- Can appear anywhere as another complementary selector

  ~~~ lay
  div {
    span & {
      display: none
    }

    p > &:hover {
      text-decoration: `underline`
    }
  }
  ~~~

  ~~~ css
  span div {
    display: none;
  }

  p > div:hover {
    text-decoration: underline;
  }
  ~~~

  ~~~ lay
  h1, h2, h3 {
    a, p {
      &:hover {
        color: #f00
      }
    }
  }
  ~~~

  ~~~ css
  h1 a:hover,
  h2 a:hover,
  h3 a:hover,
  h1 p:hover,
  h2 p:hover,
  h3 p:hover {
    color: #f00;
  }
  ~~~

  ~~~ lay
  a { color: #f00; &:hover { color: #00f }; div & { color: #0f0 }; p & span { color: #ff0 }}
  ~~~

  ~~~ css
  a {
    color: #f00;
  }

  a:hover {
    color: #00f;
  }

  div a {
    color: #0f0;
  }

  p a span {
    color: #ff0;
  }
  ~~~

  ~~~ lay
  .foo {
    .bar, .baz {
      & .qux {
        display: block
      }
      .qux & {
        display: inline
      }
      .qux& {
        display: inline-block
      }
      .qux & .biz {
        display: none
      }
    }
  }
  ~~~

  ~~~ css
  .foo .bar .qux,
  .foo .baz .qux {
    display: block;
  }

  .qux .foo .bar,
  .qux .foo .baz {
    display: inline;
  }

  .foo .qux.bar,
  .foo .qux.baz {
    display: inline-block;
  }

  .qux .foo .bar .biz,
  .qux .foo .baz .biz {
    display: none;
  }
  ~~~

  ~~~ lay
  .b {
   &.c {
    .a& {
     color: #f00
    }
   }
  }

  .b {
   .c & {
    &.a {
     color: #f00
    }
   }
  }

  .p {
    .foo&.bar {
      color: #f00
    }
  }

  ;.other {
    ::bnord { color: #f00 };
    &::bnord { color: #f00 };
  };
  ~~~

  ~~~ css
  .a.b.c {
    color: #f00;
  }

  .c .b.a {
    color: #f00;
  }

  .foo.p.bar {
    color: #f00;
  }

  .other ::bnord {
    color: #f00;
  }

  .other::bnord {
    color: #f00;
  }
  ~~~

- Cannot appear more than once
