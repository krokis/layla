Rule sets
=========

- Can have an empty body

  ~~~ lay
  body
  {
    if not true
    {
      border-color: red
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
      border: red
      padding: 20px

      b {
        font-weight: 700
      }
    }
  }
  ~~~

  ~~~ css
  body {
    color: #000000;
  }

  body div {
    border: red;
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

## Must have a valid syntax

### Simple selectors

- Universal selector

  ~~~ lay
  * {
    color: red
  }
  html * * {
    color: grey
  }
  ~~~

  ~~~ css
  * {
    color: red;
  }

  html * * {
    color: grey;
  }
  ~~~

- Type selector

  ~~~ lay
  body, div_2 {
    color: black
  }
  ~~~

  ~~~ css
  body,
  div_2 {
    color: black;
  }
  ~~~

- Class selector

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

- Id selector

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
  ~~~

#### Attribute selectors

- Attribute is present

  ~~~ lay
  a[href] {
    text-decoration: underline
  }

  a[href][data-external], a[href].external {
    color: red
  }
  ~~~

  ~~~ css
  a[href] {
    text-decoration: underline;
  }

  a[href][data-external],
  a[href].external {
    color: red;
  }
  ~~~

- Attribute is exactly

  ~~~ lay
  *[href="http://disney.es"] {
    color: pink
  }

  [target=_blank] {
    text-decoration: underline
  }
  ~~~

  ~~~ css
  *[href="http://disney.es"] {
    color: pink;
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
  [class$="-xl"] {
    font-size: larger
  }
  ~~~

  ~~~ css
  [class$="-xl"] {
    font-size: larger;
  }
  ~~~

- Case-sensitivity flag

  ~~~ lay
  [data-foo="bar" i] {
    display: block
  }
  ~~~

  ~~~ css
  [data-foo="bar" i] {
    display: block;
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
    content: ' (External) ';
  }

  ::before {
    display: none;
  }
  ~~~

- Arguments

  ~~~ lay
  tr:nth-child(2n+1) {
    background: silver
  }

  tr:nth-of-type(odd) {
    background: silver
  }

  html:lang(it) {
    background: yellow
  }

  p:not(.par[imp=yes]#foo) {
    margin: 0 0 50px
  }

  p:not(.foo, .bar) {
    margin: 0 0 50px
  }
  ~~~

  ~~~ css
  tr:nth-child(2n+1) {
    background: silver;
  }

  tr:nth-of-type(odd) {
    background: silver;
  }

  html:lang(it) {
    background: yellow;
  }

  p:not(.par[imp=yes]#foo) {
    margin: 0 0 50px;
  }

  p:not(.foo, .bar) {
    margin: 0 0 50px;
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
    color: green
  }

  ~ b {
    color: black
  }
  > div {
    color: red
  }
  ~~~

  ~~~ css
  + div {
    color: green;
  }

  ~ b {
    color: black;
  }

  > div {
    color: red;
  }
  ~~~

### Namespaces

- Are supported in type selectors

  ~~~ lay
  foo|body { color: white }
  *|body { color: white }
  |body { color: white }
  ~~~

  ~~~ css
  foo|body {
    color: white;
  }

  *|body {
    color: white;
  }

  |body {
    color: white;
  }
  ~~~

- Are supported in universal selectors

  ~~~ lay
  foo|*   { color: white }
    *|*   { color: white }
     |*   { color: white }
  ~~~

  ~~~ css
  foo|* {
    color: white;
  }

  *|* {
    color: white;
  }

  |* {
    color: white;
  }
  ~~~

- Are supported in attribute selectors

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

### Parent selector

- Is implicit

  ~~~ lay
  body {
    div {
      b {
        border: red
      }
    }
  }

  h1, h2, h3 {
    a, p { color: red }
  }
  ~~~

  ~~~ css
  body div b {
    border: red;
  }

  h1 a,
  h2 a,
  h3 a,
  h1 p,
  h2 p,
  h3 p {
    color: red;
  }
  ~~~

- Can appear anywhere as another elemental selector

  ~~~ lay
  div {
    span & {
      display: none
    }

    p > &:hover {
      text-decoration: `underline`
    }
  }

  h1, h2, h3 {
    a, p {
      &:hover {
        color: red
      }
    }
  }

  a { color: red; &:hover { color: blue }; div & { color: green }; p & span { color: yellow }}

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

  .b {
   &.c {
    .a& {
     color: red
    }
   }
  }

  .b {
   .c & {
    &.a {
     color: red
    }
   }
  }

  .p {
    .foo&.bar {
      color: red
    }
  }

  ;.other {
    ::bnord { color: red };
    &::bnord { color: red };
  };
  ~~~

  ~~~ css
  span div {
    display: none;
  }

  p > div:hover {
    text-decoration: underline;
  }

  h1 a:hover,
  h2 a:hover,
  h3 a:hover,
  h1 p:hover,
  h2 p:hover,
  h3 p:hover {
    color: red;
  }

  a {
    color: red;
  }

  a:hover {
    color: blue;
  }

  div a {
    color: green;
  }

  p a span {
    color: yellow;
  }

  .foo .bar .qux,
  .foo .baz .qux {
    display: block;
  }

  .qux .foo .bar,
  .qux .foo .baz {
    display: inline;
  }

  .qux.foo .bar,
  .qux.foo .baz {
    display: inline-block;
  }

  .qux .foo .bar .biz,
  .qux .foo .baz .biz {
    display: none;
  }

  .a.b.c {
    color: red;
  }

  .c .b.a {
    color: red;
  }

  .foo.p.bar {
    color: red;
  }

  .other ::bnord {
    color: red;
  }

  .other::bnord {
    color: red;
  }
  ~~~

- Can appear more than once

  ~~~ lay
  .foo {
    .foo + & {
      background: amber;
    }
    & + & {
      background: amber;
    }
  }

  .foo, .bar {
    & + & {
      background: amber;
    }
  }

  .foo, .bar {
    a, b {
      & > & {
        background: amber;
      }
    }
  }
  ~~~

  ~~~ css
  .foo + .foo {
    background: amber;
  }

  .foo + .foo {
    background: amber;
  }

  .foo + .foo,
  .bar + .bar {
    background: amber;
  }

  .foo a > .foo a,
  .bar a > .bar a,
  .foo b > .foo b,
  .bar b > .bar b {
    background: amber;
  }
  ~~~

### Interpolation

- Is allowed in type selectors

- Is allowed in class selectors

- Is allowed in id selectors

- Is allowed in attribute names

- Is allowed in pseudo-selectors names

- Is allowed in attribute values

- Is allowed in namespaces

## Methods

## Operators

- `selector`

- `selector=`

- `block`

- `block=`
