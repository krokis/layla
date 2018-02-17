At-rules
========

- Can be nested

## Name

- Must be legal, but can be any

  ~~~ lay
  @foo {
    foo: bar
  }

  @-foo-document {
    bar: 1
  }
  ~~~

  ~~~ css
  @foo {
    foo: bar;
  }

  @-foo-document {
    bar: 1;
  }
  ~~~

- Can contain interpolation

  ~~~ lay
  vendors = webkit, moz
  for vendor in vendors {
    @-#{vendor}-supports (border-radius) {
      body {
        border-radius: 1px
      }
    }

    @-#{vendor}-supports (border-radius) {
      body {
        border-radius: 2px
      }
    }

    @-#{vendor}-supports (border-radius) {
      body {
        border-radius: 3px
      }
    }
  }
  ~~~

  ~~~ css
  @-webkit-supports (border-radius) {
    body {
      border-radius: 1px;
    }
  }

  @-webkit-supports (border-radius) {
    body {
      border-radius: 2px;
    }
  }

  @-webkit-supports (border-radius) {
    body {
      border-radius: 3px;
    }
  }

  @-moz-supports (border-radius) {
    body {
      border-radius: 1px;
    }
  }

  @-moz-supports (border-radius) {
    body {
      border-radius: 2px;
    }
  }

  @-moz-supports (border-radius) {
    body {
      border-radius: 3px;
    }
  }
  ~~~

- Supports escapes

  ~~~ lay
  $special-chars = "!\"#$%&'()*+,./:;<=>?@[\\]^`{|}~-"

  @__foo\.bar\$baz {
    ok: true
  }

  @--foo-#{$special-chars} {
    ok: true
  }
  ~~~

  ~~~ css
  @__foo\.bar\$baz {
    ok: true;
  }

  @--foo-\!\"\#\$\%\&\'\(\)\*\+\,\.\/\:\;\<\=\>\?\@\[\\\]\^\`\{\|\}\~- {
    ok: true;
  }
  ~~~

## Block

- Can not be present

  ~~~ lay
  // TODO Would be cool if we could use this at the begining of a document
  // https://developer.mozilla.org/en-US/docs/Web/CSS/@charset
  @charset 'iso-8859-1'
  ~~~

  ~~~ css
  @charset "iso-8859-1";
  ~~~

- Can be empty

  ~~~ lay
  @media screen {
  }
  ~~~

  ~~~ css
  ~~~

- Can contain nested rules

## Arguments

- Can be empty

  ~~~ lay
  @media
  @foo; @bar
  @baz
  ~~~

  ~~~ css
  @media;

  @foo;

  @bar;

  @baz;
  ~~~

### Must contain only valid tokens

- Strings

  ~~~ lay
  @foo "lorem ipsum" 'lorem \'ipsum\'' {
    border: #f00
  }
  ~~~

  ~~~ css
  @foo "lorem ipsum" "lorem 'ipsum'" {
    border: #f00;
  }
  ~~~

- Idents

  ~~~ lay
  @foo lorem ipsum dolor sit-amet {
    border: #00f
  }
  ~~~

  ~~~ css
  @foo lorem ipsum dolor sit-amet {
    border: #00f;
  }
  ~~~

- Booleans

  ~~~ lay
  bar? = bar; @media (screen) { foo: bar? }
  ~~~

  ~~~ css
  @media (screen) {
    foo: bar;
  }
  ~~~

- Properties

  ~~~ lay
  @media (max-width: 768px) {
    foo: bar
  }
  ~~~

  ~~~ css
  @media (max-width: 768px) {
    foo: bar;
  }
  ~~~

- Pseudo-classes

  ~~~ lay
  @foo-bar lorem :ipsum :sit-amet {
    border: #0f0
  }
  ~~~

  ~~~ css
  @foo-bar lorem :ipsum :sit-amet {
    border: #0f0;
  }
  ~~~

- URLs

  ~~~ lay
  @lorem url(http://example.org/home) url('http://disney.es/movies/#pixar') {
    foo: bar
  }
  ~~~

  ~~~ css
  @lorem url("http://example.org/home") url("http://disney.es/movies/#pixar") {
    foo: bar;
  }
  ~~~

- Arbitrary functions

  ~~~ lay
  @foo prefix(-webkit-) {
    margin: 0
  }
  ~~~

  ~~~ css
  @foo prefix(-webkit-) {
    margin: 0;
  }
  ~~~

- Parentheses

  ~~~ lay
  @foo --foo(bar, "baz", foo('baz')) {
    margin: 0
  }
  ~~~

  ~~~ css
  @foo --foo(bar, "baz", foo("baz")) {
    margin: 0;
  }
  ~~~

- Operators

  ~~~ lay
  @media screen and (max-width: 768px) and (min-width: 480px) {
    foo: bar
  }
  ~~~

  ~~~ css
  @media screen and (max-width: 768px) and (min-width: 480px) {
    foo: bar;
  }
  ~~~

- Commas

  ~~~ lay
  @lorem ipsum, dolor, "sit", :amet {
    lorem: ipsum
  }
  ~~~

  ~~~ css
  @lorem ipsum, dolor, "sit", :amet {
    lorem: ipsum;
  }
  ~~~

- Interpolation

  ~~~ lay
  $media = "screen"

  @media #{$media} and (max-#{'width'}: 768px) {
    foo: bar
  }

  $path = '/home'

  @lorem url(http://example.org#{$path}) {
    foo: bar;
  }
  ~~~

  ~~~ css
  @media screen and (max-width: 768px) {
    foo: bar;
  }

  @lorem url("http://example.org/home") {
    foo: bar;
  }
  ~~~

## `@charset` rules

- Are supported

  ~~~ lay
  @charset "UTF-8"
  @charset 'iso-8859-15'
  ~~~

  ~~~ css
  @charset "UTF-8";

  @charset "iso-8859-15";
  ~~~

## `@import` rules

- Are supported

  ~~~ lay
  @import "./extras/reset.css"
  @import "base"
  @import "layout" screen
  ~~~

  ~~~ css
  @import "./extras/reset.css";

  @import "base";

  @import "layout" screen;
  ~~~

## `@media` rules

- Are supported

  ~~~ lay
  @media print {
  body { font-size: 10pt }
  }
  @media screen {
    body { font-size: 13px }
  }
  @media screen, print {
    body { line-height: 1.2 }
  }
  ~~~

  ~~~ css
  @media print {
    body {
      font-size: 10pt;
    }
  }

  @media screen {
    body {
      font-size: 13px;
    }
  }

  @media screen, print {
    body {
      line-height: 1.2;
    }
  }
  ~~~

- Can be nested in a ruleset

- Can be nested in another `@media`

- Can be nested in an unknown at-rule

## `@document`

- Is supported

  ~~~ lay
  @document url(http://www.w3.org/),
            url-prefix(http://www.w3.org/Style/),
            domain(mozilla.org),
            regexp("https:.*")
  {
    foo: bar
  }
  ~~~

  ~~~ css
  @document url("http://www.w3.org/"), url-prefix("http://www.w3.org/Style/"), domain(mozilla.org), regexp("https:.*") {
    foo: bar;
  }
  ~~~

## `@page` rules

- Are supported

  ~~~ lay
  @page :first {
    margin: 0
  }

  @page :left {
    margin-right: 2in
  }

  @page :right {
    margin-left: 2in
  }
  ~~~

  ~~~ css
  @page :first {
    margin: 0;
  }

  @page :left {
    margin-right: 2in;
  }

  @page :right {
    margin-left: 2in;
  }
  ~~~

## `@keyframes` rules

- Are supported

  ~~~ lay
  @keyframes foo-bar
    { 0% { top: 0; left: 0; }
      30% { top: 50px; }
      68% { left: 50px; }
      100% { top: 100rm; left: 100%; }}
  ~~~

  ~~~ css
  @keyframes foo-bar {
    0% {
      top: 0;
      left: 0;
    }

    30% {
      top: 50px;
    }

    68% {
      left: 50px;
    }

    100% {
      top: 100rm;
      left: 100%;
    }
  }
  ~~~

## `@namespace` rules

- Are supported

  ~~~ lay
  @namespace svg "http://www.w3.org/2000/svg"
  @namespace lq "http://example.com/q-markup"
  ~~~

  ~~~ css
  @namespace svg "http://www.w3.org/2000/svg";

  @namespace lq "http://example.com/q-markup";
  ~~~

## `@font-face` rules

- Are supported

  ~~~ lay
  @font-face {
    font-family: "Bitstream Vera Serif Bold"
  }
  ~~~

  ~~~ css
  @font-face {
    font-family: "Bitstream Vera Serif Bold";
  }
  ~~~

## `@supports` rules

- Are supported

  ~~~ lay
  @supports (display: table-cell) and (display: list-item) and (display:run-in) {
    table {
      visibility: visible
    }
  }

  @supports ( transform-style: preserve ) or ( -moz-transform-style: preserve ) {
    foo: bar
  }

  @supports ( not ((text-align-last:justify) or (-moz-text-align-last:justify) )){
    body,
    p {
      text-align: left
    }
  }

  @supports ( (perspective: 10px) or (-moz-perspective: 10px) or (-webkit-perspective: 10px) or (-ms-perspective: 10px) or (-o-perspective: 10px) )
  {
    foo: 'baz'
  }
  ~~~

  ~~~ css
  @supports (display: table-cell) and (display: list-item) and (display: run-in) {
    table {
      visibility: visible;
    }
  }

  @supports (transform-style: preserve) or (-moz-transform-style: preserve) {
    foo: bar;
  }

  @supports (not ((text-align-last: justify) or (-moz-text-align-last: justify))) {
    body,
    p {
      text-align: left;
    }
  }

  @supports ((perspective: 10px) or (-moz-perspective: 10px) or (-webkit-perspective: 10px) or (-ms-perspective: 10px) or (-o-perspective: 10px)) {
    foo: "baz";
  }
  ~~~

## Methods

### `name`

- Returns the name of the at-rule as a quoted string

  ~~~ lay
  $rules = {
    @media print {}
    @charset 'latin1';
  }.rules

  at-rule.name {
    for $i, $rule in $rules {
      #{($i + 1).roman.lower-case}: $rule.name
    }
  }
  ~~~

  ~~~ css
  at-rule.name {
    i: "media";
    ii: "charset";
  }
  ~~~
