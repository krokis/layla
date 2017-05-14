# Whitespace

## Significance

### In rule-sets

#### Before selector

- Whitespace is not required

  ~~~ lay
  .whitespace {
    color: white
  };.whitespace  { color: white };#whitespace {color: white };
  #whitespace { color: white }
  [whitespace] { color: white } [whitespace] { color: white } * { color: white };
  * { color: white };
  whitespace { color: white };;whitespace { color: white };
  ~~~

  ~~~ css
  .whitespace {
    color: white;
  }

  .whitespace {
    color: white;
  }

  #whitespace {
    color: white;
  }

  #whitespace {
    color: white;
  }

  [whitespace] {
    color: white;
  }

  [whitespace] {
    color: white;
  }

  * {
    color: white;
  }

  * {
    color: white;
  }

  whitespace {
    color: white;
  }

  whitespace {
    color: white;
  }
  ~~~

- All whitespace is ignored

  ~~~ lay
     .whitespace {
    color: white
  };   .whitespace  { color: white };

      #whitespace {color: white }; #whitespace { color: white };	 [whitespace] { color: white }
  ~~~

  ~~~ css
  .whitespace {
    color: white;
  }

  .whitespace {
    color: white;
  }

  #whitespace {
    color: white;
  }

  #whitespace {
    color: white;
  }

  [whitespace] {
    color: white;
  }
  ~~~

#### In selector

##### Around combinators

- Whitespace is not required

  ~~~ lay
  body+foo bar~baz>qux { foo: nope }
  body +  foo    bar ~ baz>   qux { foo: nope }
  body+  foo    bar~  baz   >qux { foo: nope }
  ~~~

  ~~~ css
  body + foo bar ~ baz > qux {
    foo: nope;
  }

  body + foo bar ~ baz > qux {
    foo: nope;
  }

  body + foo bar ~ baz > qux {
    foo: nope;
  }
  ~~~

- Horizontal whitespace is ignored

  ~~~ lay
  body      +          foo                     bar     ~      baz         >          qux { foo: nope }
  ~~~

  ~~~ css
  body + foo bar ~ baz > qux {
    foo: nope;
  }
  ~~~

- Vertical whitespace is ignored (except on descendant combinator)

  ~~~ lay
  body      +
            foo bar
  ~
  baz
  >          qux { foo: nope }
  ~~~

  ~~~ css
  body + foo bar ~ baz > qux {
    foo: nope;
  }
  ~~~



##### In attribute selectors

###### Before attribute name

- Whitespace is not required

  ~~~ lay
  [foo] [foo=bar] [foo|=bar] [foo*=bar] [foo~=bar] [foo^=bar] [foo$=bar] {
    its: alright
  }
  [foo] [foo='bar'] [foo|='bar'] [foo*='bar'] [foo~='bar'] [foo^='bar'] [foo$='bar'] {
    its: alright
  }
  [foo] [foo="bar"] [foo|="bar"] [foo*="bar"] [foo~="bar"] [foo^="bar"] [foo$="bar"] {
    its: alright
  }
  ~~~

  ~~~ css
  [foo] [foo=bar] [foo|=bar] [foo*=bar] [foo~=bar] [foo^=bar] [foo$=bar] {
    its: alright;
  }

  [foo] [foo="bar"] [foo|="bar"] [foo*="bar"] [foo~="bar"] [foo^="bar"] [foo$="bar"] {
    its: alright;
  }

  [foo] [foo="bar"] [foo|="bar"] [foo*="bar"] [foo~="bar"] [foo^="bar"] [foo$="bar"] {
    its: alright;
  }
  ~~~

- Horizontal whitespace is ignored

  ~~~ lay
  [ foo] [  foo=bar] [  foo|=bar] [ foo*=bar] [ 	foo~=bar] [	 foo^=bar] [ foo$=bar] {
    its: alright
  }
  ~~~

  ~~~ css
  [foo] [foo=bar] [foo|=bar] [foo*=bar] [foo~=bar] [foo^=bar] [foo$=bar] {
    its: alright;
  }
  ~~~

###### Before operator

- Whitespace is not required

  ~~~ lay
  [foo] [foo=bar] [foo|=bar] [foo*=bar] [foo~=bar] [foo^=bar] [foo$=bar] {
    its: alright
  }
  ~~~

  ~~~ css
  [foo] [foo=bar] [foo|=bar] [foo*=bar] [foo~=bar] [foo^=bar] [foo$=bar] {
    its: alright;
  }
  ~~~

- Horizontal whitespace is ignored

  ~~~ lay
  [foo] [foo =bar] [foo  |=bar] [foo 	*=bar] [foo	~=bar] [foo ^=bar] [foo$=bar] {
    its: alright
  }
  ~~~

  ~~~ css
  [foo] [foo=bar] [foo|=bar] [foo*=bar] [foo~=bar] [foo^=bar] [foo$=bar] {
    its: alright;
  }
  ~~~

###### Before closing brace

- Horizontal whitespace is ignored

  ~~~ lay
  [foo   ] [foo=bar  ] [foo|=bar  i   ] [foo*=bar  ] [foo~=bar  ] [foo^=bar  ] [foo$=bar  i   ] {
    its: alright
  }
  [foo   ] [foo='bar'  ] [foo|='bar'  ] [foo*='bar'  ] [foo~='bar'  i   ] [foo^='bar'  ] [foo$='bar'] {
    its: alright
  }
  [foo   ] [foo="bar"  i] [foo|="bar"  ] [foo*="bar"  i   ] [foo~="bar"  ] [foo^="bar"  ] [foo$="bar"] {
    its: alright
  }
  ~~~

  ~~~ css
  [foo] [foo=bar] [foo|=bar i] [foo*=bar] [foo~=bar] [foo^=bar] [foo$=bar i] {
    its: alright;
  }

  [foo] [foo="bar"] [foo|="bar"] [foo*="bar"] [foo~="bar" i] [foo^="bar"] [foo$="bar"] {
    its: alright;
  }

  [foo] [foo="bar" i] [foo|="bar"] [foo*="bar" i] [foo~="bar"] [foo^="bar"] [foo$="bar"] {
    its: alright;
  }
  ~~~


#### Before flag

- Whitespace is not required

  ~~~ lay
  [foo] [foo=bari]  {
    its: alright;
  }
  ~~~

  ~~~ css
  [foo] [foo=bari] {
    its: alright;
  }
  ~~~

  ~~~ lay
  [foo] [foo="bar"i]  {
    its: alright;
  }
  ~~~

  ~~~ css
  [foo] [foo="bar" i] {
    its: alright;
  }
  ~~~

- Extra horizontal whitespace is ignored

  ~~~ lay
  [foo] [foo=bar        i]  {
    its: alright;
  }

  [foo] [foo="bar"         i]  {
    its: alright;
  }
  ~~~

  ~~~ css
  [foo] [foo=bar i] {
    its: alright;
  }

  [foo] [foo="bar" i] {
    its: alright;
  }
  ~~~

##### In pseudo-selectors

###### After colon

- Whitespace is not allowed

  ~~~ lay
  body ul > li a: hover {
    border: 1px solid red
  }
  ~~~

  ~~~ SyntaxError
  ~~~

  ~~~ lay
  body ul > li a:: before {
    border: 1px solid green
  }
  ~~~

  ~~~ SyntaxError
  ~~~

###### Before opening parenthesis

- Whitespace is not allowed

  ~~~ lay
  body ul > li a:not (.ext) {
    border: 1px solid red
  }
  ~~~

  ~~~ SyntaxError
  ~~~

###### Around arguments

- Whitespace is not required

  ~~~ lay
  body ul > li:nth-child(-2n+1) {
    border: 1px solid red
  }

  body ul > li a:not(.external,.ext){
    border: 1px solid red
  }
  ~~~

  ~~~ css
  body ul > li:nth-child(-2n + 1) {
    border: 1px solid red;
  }

  body ul > li a:not(.external, .ext) {
    border: 1px solid red;
  }
  ~~~

- Horizontal whitespace is ignored

  ~~~ lay
  body ul > li:nth-child(   -2n  +   1   ) {
    border: 1px solid red
  }

  body ul > li a:not(   .external   ,    .ext , strong   >  a){
    border: 1px solid red
  }
  ~~~

  ~~~ css
  body ul > li:nth-child(-2n + 1) {
    border: 1px solid red;
  }

  body ul > li a:not(.external, .ext, strong > a) {
    border: 1px solid red;
  }
  ~~~

### After selector

- Whitespace is not required

  ~~~ lay
  .class{color: white}
  #id{color: white}
  :pseudo(){color: white}
  ~~~

  ~~~ css
  .class {
    color: white;
  }

  #id {
    color: white;
  }

  :pseudo() {
    color: white;
  }
  ~~~

- All whitespace is ignored

  ~~~ lay
  .whitespace{color: white}
  .whitespace  { color: white }
  ~~~

  ~~~ css
  .whitespace {
    color: white;
  }

  .whitespace {
    color: white;
  }
  ~~~

## In at-rules

### Before at-symbol

- Whitespace is not required

  ~~~ lay
  @media screen { body { background: silver}};;@media print { body { background: white}}@media screen { body { max-width: 800px}}
  ~~~

  ~~~ css
  @media screen {
    body {
      background: silver;
    }
  }

  @media print {
    body {
      background: white;
    }
  }

  @media screen {
    body {
      max-width: 800px;
    }
  }
  ~~~

- All whitespace is ignored

  ~~~ lay
      @media screen { body { background: silver}}



  @media print { body { background: white}}     @media screen { body { max-width: 800px}}
  ~~~

  ~~~ css
  @media screen {
    body {
      background: silver;
    }
  }

  @media print {
    body {
      background: white;
    }
  }

  @media screen {
    body {
      max-width: 800px;
    }
  }
  ~~~

### Around arguments

- Horizontal whitespace is ignored

  ~~~ lay
  @media    screen    and  (max-width: 200px)   not    print    {
    body {
      background: silver
    }
  }
  ~~~

  ~~~ css
  @media screen and (max-width: 200px) not print {
    body {
      background: silver;
    }
  }
  ~~~

### After an opening parenthesis

- Horizontal whitespace is ignored

  ~~~ lay
  @media    screen    and  (    max-width: 200px)   not    print    {
    body {
      background: silver
    }
  }
  ~~~

  ~~~ css
  @media screen and (max-width: 200px) not print {
    body {
      background: silver;
    }
  }
  ~~~

### Before a closing parenthesis

- Horizontal whitespace is ignored

  ~~~ lay
  @media    screen    and  (max-width: 200px      )   not    print    {
    body {
      background: silver
    }
  }
  ~~~

  ~~~ css
  @media screen and (max-width: 200px) not print {
    body {
      background: silver;
    }
  }
  ~~~

### After a property name

- Whitespace is not required

  ~~~ lay
  @media    screen    and  (max-width: 200px)  {
    body {
      background: silver
    }
  }
  ~~~

  ~~~ css
  @media screen and (max-width: 200px) {
    body {
      background: silver;
    }
  }
  ~~~

- Horizontal whitespace is ignored

  ~~~ lay
  @media    screen    and  (max-width     :200px)  {
    body {
      background: silver
    }
  }
  ~~~

  ~~~ css
  @media screen and (max-width: 200px) {
    body {
      background: silver;
    }
  }
  ~~~

### Before a property value

- Whitespace is not required

  ~~~ lay
  @media    screen    and  (min-width:200px)and (max-width     :1200px)  {
    body {
      background: white
    }
  }
  ~~~

  ~~~ css
  @media screen and (min-width: 200px) and (max-width: 1200px) {
    body {
      background: white;
    }
  }
  ~~~

- Horizontal whitespace is ignored

  ~~~ lay
  @media    screen    and  (min-width:     200px)and (max-width     :     1200px)  {
    body {
      background: white
    }
  }
  ~~~

  ~~~ css
  @media screen and (min-width: 200px) and (max-width: 1200px) {
    body {
      background: white;
    }
  }
  ~~~

## In expressions

### After an opening parenthesis

- Whitespace is not required

  ~~~ lay
  expression::whitespace {
    $foo = 1
    i: ($foo + 1)
    ii: (2+3)
    iii: (-$foo + 1)
    iv: (-2+3)
    v: ((2,3))
    vi: (/.*/)
    vii: (url(http://example.org/home))
    viii: (null),(true),(false)
    ix: (1..2), (-1..1)
    x: (#fff)
  }
  ~~~

  ~~~ css
  expression::whitespace {
    i: 2;
    ii: 5;
    iii: 0;
    iv: 1;
    v: 2, 3;
    vi: regexp(".*");
    vii: url("http://example.org/home");
    viii: null, true, false;
    ix: 1 2, -1 0 1;
    x: #ffffff;
  }
  ~~~

- All whitespace is ignored

  ~~~ lay
  expression::whitespace {
    $foo = 1
    i: (  $foo + 1)
    ii: (

      2+3)
    iii: (  -$foo + 1)
    iv: ( -2+3)
    v: (   (

       2,3))
    vi: (   /.*/)
    vii: (
      url(http://example.org/home))
    viii: (   null),(   true),(  false)
    ix: (   1..2), (   -1..1)
    x: (   #fff)
  }
  ~~~

  ~~~ css
  expression::whitespace {
    i: 2;
    ii: 5;
    iii: 0;
    iv: 1;
    v: 2, 3;
    vi: regexp(".*");
    vii: url("http://example.org/home");
    viii: null, true, false;
    ix: 1 2, -1 0 1;
    x: #ffffff;
  }
  ~~~

### Before a closing parenthesis

- All whitespace is ignored

  ~~~ lay
  expression::whitespace {
    $foo = 1
    i: ($foo + 1   )
    ii: (2+3
      )
    iii: (-$foo + 1   )
    iv: (-2+3  )
    v: ((2,3

      )

    )
    vi: (/.*/

      )
    vii: (url(http://example.org/home)
    )
    viii: (null
      ),(true),(false  )
    ix: (1..2  ), (-1..1
      )
    x: (#fff

      )
  }
  ~~~

  ~~~ css
  expression::whitespace {
    i: 2;
    ii: 5;
    iii: 0;
    iv: 1;
    v: 2, 3;
    vi: regexp(".*");
    vii: url("http://example.org/home");
    viii: null, true, false;
    ix: 1 2, -1 0 1;
    x: #ffffff;
  }
  ~~~

### Around binary operators

- Around `+`, `-`, `/` and `*`

  + Whitespace is not required

    ~~~ lay
    whitespace::binary-operators {
      i: -(1+7)-3-2*+15px
    }
    ~~~

    ~~~ css
    whitespace::binary-operators {
      i: -41px;
    }
    ~~~

  + Is required for `/` sorrounded by literal numbers

    ~~~ lay
    whitespace::binary-operators {
      i: 1/2
      ii: 1 /2
      iii: 1/ 2
      iv: 1 / 2

      v: 1px/2
      vi: 1px /2
      vii: 1px/ 2
      viii: 1px / 2

      ix: 1/2%
      x: 1 /2px
      xi: 1/ 2%
      xii: 1 / 2%

      xiii: 1rem/2rem
      xiv: 1px /2px
      xv: 1px/ 2px
      xvi: 1px / 2px
    }
    ~~~

    ~~~ css
    whitespace::binary-operators {
      i: 1/2;
      ii: 0.5;
      iii: 0.5;
      iv: 0.5;
      v: 1px/2;
      vi: 0.5px;
      vii: 0.5px;
      viii: 0.5px;
      ix: 1/2%;
      x: 0.5px;
      xi: 0.5%;
      xii: 0.5%;
      xiii: 1rem/2rem;
      xiv: 0.5;
      xv: 0.5;
      xvi: 0.5;
    }
    ~~~

  + All whitespace is ignored

    ~~~ lay
    whitespace::binary-operators {
      i: - (1 +
        7)   -
        3/
        2   *    + 15px
    }
    ~~~

    ~~~ css
    whitespace::binary-operators {
      i: -30.5px;
    }
    ~~~

- Around `>`, `>=`, `<`, `<=` and `~`

  + Whitespace is not required

    ~~~ lay
    whitespace::binary-operators {
      i: 1>2, (1)>(2)
      ii: 2>=1, (2)>=(1)
      iii: 2<=1, (2)<=(1)
      iv: 2<1, (2)<(1)
      v: "foo"~/[a-z]+/, ("foo")~(/[a-z]+/)
    }
    ~~~

    ~~~ css
    whitespace::binary-operators {
      i: false, false;
      ii: true, true;
      iii: false, false;
      iv: false, false;
      v: "foo", "foo";
    }
    ~~~

  + All whitespace is ignored

    ~~~ lay
    whitespace::binary-operators {
      i: 1  >   2
      ii: 2>=
      1
      iii: 2<=
      1
      iv: 2              <
          (1)
    }
    ~~~

    ~~~ css
    whitespace::binary-operators {
      i: false;
      ii: true;
      iii: false;
      iv: false;
    }
    ~~~

- Around `=`, `|=`

  + Whitespace is not required

    ~~~ lay
    $foo=41
    $baz=$bar=$foo+1

    whitespace::assignment-operators {
      i: $foo
      ii: $bar
      iii: $baz
      iv: $foo|=($baz|=$bar|=45)
      v: $bar
      vi: $baz
    }
    ~~~

    ~~~ css
    whitespace::assignment-operators {
      i: 41;
      ii: 42;
      iii: 42;
      iv: 41;
      v: 42;
      vi: 42;
    }
    ~~~

  + All whitespace is ignored

    ~~~ lay
    $foo    =41
    $baz=
    $bar    =
      ($foo+1)

    whitespace::assignment-operators {
      i: $foo
      ii: $bar
      iii: $baz
      iv: $foo|=
      ($baz |=
           $bar|=    45
      )
      v: $bar
      vi: $baz
    }
    ~~~

    ~~~ css
    whitespace::assignment-operators {
      i: 41;
      ii: 42;
      iii: 42;
      iv: 41;
      v: 42;
      vi: 42;
    }
    ~~~

- Around `..`

  + Whitespace is not required

    ~~~ lay
    whitespace::range-operator {
      i: 1..5
      ii: (5)..(1px)
    }
    ~~~

    ~~~ css
    whitespace::range-operator {
      i: 1 2 3 4 5;
      ii: 5px 4px 3px 2px 1px;
    }
    ~~~

  + Horizontal whitespaces is ignored

    ~~~ lay
    whitespace::range-operator {
      i: 1  ..  5
      ii: (5)  ..
      (1px)
    }
    ~~~

    ~~~ css
    whitespace::range-operator {
      i: 1 2 3 4 5;
      ii: 5px 4px 3px 2px 1px;
    }
    ~~~

- After `..`

  + All whitespace is ignored

    ~~~ lay
    whitespace::range-operator {
      i: 1..
    5
      ii: (5)..
      (1px)
    }
    ~~~

    ~~~ css
    whitespace::range-operator {
      i: 1 2 3 4 5;
      ii: 5px 4px 3px 2px 1px;
    }
    ~~~

- Around `,`

  + Whitespace is not required

    ~~~ lay
    whitespace::comma-operator {
      $two = 2
      i: 1,$two,3
      ii: (1),($two),2+1
    }
    ~~~

    ~~~ css
    whitespace::comma-operator {
      i: 1, 2, 3;
      ii: 1, 2, 3;
    }
    ~~~

  + All whitespace is ignored

    ~~~ lay
    whitespace::comma-operator {
      $two = 2
      i: 1,     $two,
      3
      ii: (1),
      ($two),
          2+1
    }
    ~~~

    ~~~ css
    whitespace::comma-operator {
      i: 1, 2, 3;
      ii: 1, 2, 3;
    }
    ~~~

- Around `.` and `::`

  + Whitespace is not required

    ~~~ lay
    whitespace::subscript {
      i: 10.17.round
      ii: (10.17).("round")
      iii: (10.17).round
      iv: (&)::i
      v: &::("i")
    }
    ~~~

    ~~~ css
    whitespace::subscript {
      i: 10;
      ii: 10;
      iii: 10;
      iv: 10;
      v: 10;
    }
    ~~~

  + All whitespace is ignored

    ~~~ lay
    whitespace::subscript {
      i: 10.17. round
      ii: 10.17 .round
      iii: 10.17 . round
      iv: 10.17.
      round
      v: &:: i
      vi: &  ::i
      vii: &  ::  i
      viii: &  ::
        i
    }
    ~~~

    ~~~ css
    whitespace::subscript {
      i: 10;
      ii: 10;
      iii: 10;
      iv: 10;
      v: 10;
      vi: 10;
      vii: 10;
      viii: 10;
    }
    ~~~

### Before unary operators

- Whitespace is not required

  ~~~ lay
  whitespace::unary-operators {
    i: -2 -(17)
    ii: +2 +(18)
  }
  ~~~

  ~~~ css
  whitespace::unary-operators {
    i: -2 -17;
    ii: 2 18;
  }
  ~~~

- Horizontal whitespace is ignored, but not before a primary expression

  ~~~ lay
  whitespace::unary-operators {
    i: - 2 - 17px
    ii: + 2 (+ 18)
  }
  ~~~

  ~~~ css
  whitespace::unary-operators {
    i: -19px;
    ii: 2 18;
  }
  ~~~

### In blocks

#### Around brackets

- Whitespace is not required

  ~~~ lay
  div {a{color: red}}div {#foo{color: green}}div {.bar{color: blue}}div {[baz]{color,outline:black}}
  ~~~

  ~~~ css
  div a {
    color: red;
  }

  div #foo {
    color: green;
  }

  div .bar {
    color: blue;
  }

  div [baz] {
    color: black;
    outline: black;
  }
  ~~~

- All whitespace is ignored

  ~~~ lay
  div     {                 #foo


  {






  color: red            }




                 }
  ~~~

  ~~~ css
  div #foo {
    color: red;
  }
  ~~~

### In property declarations

#### After property name

- Whitespace is not required

  ~~~ lay
  div {
    border: 2px
    color: #fedcba
    content: "foo"
    margin: (10px 5px)
    padding: 1..4px
    font: {tipo:'Helvetica'}::tipo
    background: url(background.jpg)
    display: true
  }
  ~~~

  ~~~ css
  div {
    border: 2px;
    color: #fedcba;
    content: "foo";
    margin: 10px 5px;
    padding: 1px 2px 3px 4px;
    font: "Helvetica";
    background: url("background.jpg");
    display: true;
  }
  ~~~

- Horizontal whitespace is ignored

  ~~~ lay
  div {
    border :2px
    color:       #fedcba
  }
  ~~~

  ~~~ css
  div {
    border: 2px;
    color: #fedcba;
  }
  ~~~

- Vertical whitespace is not allowed

  ~~~ lay
  div {
    border
    :2px
  }
  ~~~

  ~~~ SyntaxError
  ~~~

#### After colon

- Whitespace is not required

  ~~~ lay
  div {
    border:2px
    color:#fedcba
    content:"foo"
    margin:(10px 5px)
    padding:1..4px
    font:{tipo:'Helvetica'}::tipo
    background:url(background.jpg)
    display:true
  }
  ~~~

  ~~~ css
  div {
    border: 2px;
    color: #fedcba;
    content: "foo";
    margin: 10px 5px;
    padding: 1px 2px 3px 4px;
    font: "Helvetica";
    background: url("background.jpg");
    display: true;
  }
  ~~~

- All whitespace is ignored

  ~~~ lay
  div {
    border:     2px
    color:
  #fedcba
    content:
    "foo"
    margin:
      (10px 5px)
    padding:
        1..4px
    font:


                               {tipo:'Helvetica'}::tipo
    background:





    url(background.jpg)
    display:






  true
  }
  ~~~

  ~~~ css
  div {
    border: 2px;
    color: #fedcba;
    content: "foo";
    margin: 10px 5px;
    padding: 1px 2px 3px 4px;
    font: "Helvetica";
    background: url("background.jpg");
    display: true;
  }
  ~~~

### In control structures

#### Before condition

- Horizontal whitespace is ignored

  ~~~ lay
  if            true { body {color: black }}
  if not       false { a { color: red }}
  $i = 0
  $s = 0
  while      $i < 10 { $s = $s + 1; $i = $i + 1 }
  s { s: $s }
  ~~~

  ~~~ css
  body {
    color: black;
  }

  a {
    color: red;
  }

  s {
    s: 10;
  }
  ~~~

- Vertical whitespace is not allowed

  ~~~ lay
  if
  true { body {color: black }}
  ~~~

  ~~~ SyntaxError
  ~~~

  ~~~ lay
  for
      $i in 1..10 {
      { a {color: red}}}
  ~~~

  ~~~ SyntaxError
  ~~~

### In directives

#### After name

- Horizontal white space is required only in some cases

  ~~~ lay
  numbers {
    i: () {return #fff}()
    ii: () {return(#fff)}()
    iii: () {return#fff}() //
    iv: () {return.1}()
    $n = 0
    while true {
      $n = $n + 1
      break1 // `break1` is parsed to an unquoted string
      v: $n
      break(1)
      v: $n + 1
    }
    vi: (){ return"HEY!".lower-case.raw}()
    vii: (){return{foo: 'bar!'}}()::foo.raw
  }
  ~~~

  ~~~ css
  numbers {
    i: #ffffff;
    ii: #ffffff;
    iii: #ffffff;
    iv: 0.1;
    v: 1;
    vi: hey!;
    vii: bar!;
  }
  ~~~

- Vertical whitespace is not allowed

  ~~~ lay
  $foo = ($n) {
    return
    $n
  }

  $bar = ($n) {
    return(
      $n
    )
  }

  body {
    i: $foo(1)
    ii: $bar(2)
  }
  ~~~

  ~~~ css
  body {
    i: null;
    ii: 2;
  }
  ~~~

#### Around commas

- All whitespace is ignored

### In functions

#### Before opening parentheses

- Whitespace is not required

  ~~~ lay
  () {};(a, b) { return a + b};;$foo=() {};

  body {> h1 {($s){font-size:$s}(17px)}}
  ~~~

  ~~~ css
  body > h1 {
    font-size: 17px;
  }
  ~~~

- All whitespace is ignored

  ~~~ lay


  foo;          () {};
  ($a,$b) { return $a + $b}

  body {> h1 {               ($s){font-size:$s}(17px)}                }

  body {
    two: '(\t(a,b){return a + b}(1,1))ct'.eval
  }
  ~~~

  ~~~ css
  body > h1 {
    font-size: 17px;
  }

  body {
    two: 2ct;
  }
  ~~~

#### Around argument name

- Whitespace is not required

  ~~~ lay


  body {
    > h1 {
      $n = (a,$b,c) { return a+$b+c}
      font-size: ($n(1,5,7))px

      $n = (a:1px,$b:2px,c:9+1px) { return a+$b+c}
      font-size: $n()
    }
  }
  ~~~

  ~~~ css
  body > h1 {
    font-size: 13px;
    font-size: 13px;
  }
  ~~~

- All whitespace is ignored

  ~~~ lay
  $n = (   a,



  $b,


       c
  ) { return a+$b+c}

  body {
    > h1 {
      font-size: ($n(1,5,7))px
      max-width: '$f=(\t $m,
      \t $u \t\t\t:

      "cm"){return `\#{$m.pure}\#{$u}`};$f(100ms)'.eval
    }
  }
  ~~~

  ~~~ css
  body > h1 {
    font-size: 13px;
    max-width: 100cm;
  }
  ~~~

#### After closing parentheses

- Whitespace is not required

  ~~~ lay
  (){};(a, b){ return a + b};;$foo=(){};body {> h1 {($s){font-size:$s}(17px)}}
  ~~~

  ~~~ css
  body > h1 {
    font-size: 17px;
  }
  ~~~

- All whitespace is ignored

  ~~~ lay
  ()      {};
                     (a, b)


  { return a + b};;$foo=(){};body {> h1 {($s)

    {font-size:$s}(17px)}}
  ~~~

  ~~~ css
  body > h1 {
    font-size: 17px;
  }
  ~~~

### In method calls

#### Before parentheses

- Whitespace is not allowed

  ~~~ lay
  $n = 10.6257

  whitespace::method-calls {
    i: $n.round
    ii: $n.round(2)
    iii: $n.round (2)
  }
  ~~~

  ~~~ css
  whitespace::method-calls {
    i: 11;
    ii: 10.63;
    iii: 11 2;
  }
  ~~~

#### Before commas

- Whitespace is not required

  ~~~ lay
  whitespace::commas {
    i: 1, 2, 3
    ii: "foo", "bar", "baz"
    iii: #abcdef, #fedcba
    iv: url(google.com), url(duckduckgo.com)
    v: true, false, null
  }
  ~~~

  ~~~ css
  whitespace::commas {
    i: 1, 2, 3;
    ii: "foo", "bar", "baz";
    iii: #abcdef, #fedcba;
    iv: url("google.com"), url("duckduckgo.com");
    v: true, false, null;
  }
  ~~~

- Horizontal whitespace is ignored

  ~~~ lay
  whitespace::commas {
    i: 1 ,  2   ,3
    ii: "foo"   ,"bar", "baz"
  }
  ~~~

  ~~~ css
  whitespace::commas {
    i: 1, 2, 3;
    ii: "foo", "bar", "baz";
  }
  ~~~

#### After commas

- Whitespace is not required

  ~~~ lay
  whitespace::commas {
    i: 1,2,3
    ii: "foo","bar","baz"
    iii: #abcdef,#fedcba
    iv: url(google.com),url(duckduckgo.com)
    v: true,false,null
  }
  ~~~

  ~~~ css
  whitespace::commas {
    i: 1, 2, 3;
    ii: "foo", "bar", "baz";
    iii: #abcdef, #fedcba;
    iv: url("google.com"), url("duckduckgo.com");
    v: true, false, null;
  }
  ~~~

- All whitespace is ignored

  ~~~ lay
  whitespace::commas {
    i: 1,     2,                         3
    ii: "foo",
  "bar",
        "baz"
    iii: #abcdef,
         #fedcba
    iv: url(google.com),
        url(duckduckgo.com)
    v:      true,
           false,
             null
  }
  ~~~

  ~~~ css
  whitespace::commas {
    i: 1, 2, 3;
    ii: "foo", "bar", "baz";
    iii: #abcdef, #fedcba;
    iv: url("google.com"), url("duckduckgo.com");
    v: true, false, null;
  }
  ~~~

### In URL literals

#### Before opening parenthesis

- Whitespace is not allowed

  ~~~ lay
  whitespace::urls {
    i: url("google.com")
    ii: url ("google.com")
  }
  ~~~

  ~~~ css
  whitespace::urls {
    i: url("google.com");
    ii: url "google.com";
  }
  ~~~

#### After opening parenthesis

- Whitespace is not required

  ~~~ lay
  whitespace::urls {
    i: url("google")
    ii: url('google')
    iii: url(google)
    iv: url("/search")
    v: url('/search')
    vi: url(/search)
    vii: url("google.com/search")
    viii: url('google.com/search')
    ix: url(google.co/search)
    x: url("//google.com/search")
    xi: url('//google.com/search')
    xii: url(//google.co/search)
    xiii: url("http://google.com/home")
    xiv: url('http://google.com/home')
    xv: url(http://google.com/home)
  }
  ~~~

  ~~~ css
  whitespace::urls {
    i: url("google");
    ii: url("google");
    iii: url("google");
    iv: url("/search");
    v: url("/search");
    vi: url("/search");
    vii: url("google.com/search");
    viii: url("google.com/search");
    ix: url("google.co/search");
    x: url("//google.com/search");
    xi: url("//google.com/search");
    xii: url("//google.co/search");
    xiii: url("http://google.com/home");
    xiv: url("http://google.com/home");
    xv: url("http://google.com/home");
  }
  ~~~

- All whitespace is ignored

  ~~~ lay
  whitespace::urls {
    i: url( "google")
    ii: url( 'google')
    iii: url( google)
    iv: url(      "/search")
    v: url(      '/search')
    vi: url(      /search)
    vii: url(
    "google.com/search")
    viii: url(
    'google.com/search')
    ix: url(
    google.co/search)
    x: url(
      "//google.com/search")
    xi: url(
      '//google.com/search')
    xii: url(
      //google.co/search)
  }
  ~~~

  ~~~ css
  whitespace::urls {
    i: url("google");
    ii: url("google");
    iii: url("google");
    iv: url("/search");
    v: url("/search");
    vi: url("/search");
    vii: url("google.com/search");
    viii: url("google.com/search");
    ix: url("google.co/search");
    x: url("//google.com/search");
    xi: url("//google.com/search");
    xii: url("//google.co/search");
  }
  ~~~

#### Before closing parenthesis

- All whitespace is ignored

  ~~~ lay
  whitespace::urls {
    i: url("google" )
    ii: url('google' )
    iii: url(google )
    iv: url("/search"       )
    v: url('/search'        )
    vi: url(/search         )
    vii: url("google.com/search"
    )
    viii: url('google.com/search'
    )
    ix: url(google.co/search
    )
    x: url("//google.com/search"
                  )
    xi: url('//google.com/search'
                        )
    xii: url(//google.co/search
                                    )
    xiii: url("http://google.com/home"

                                          )
    xiv: url('http://google.com/home'

                                          )
    xv: url(http://google.com/home

                                          )
  }
  ~~~

  ~~~ css
  whitespace::urls {
    i: url("google");
    ii: url("google");
    iii: url("google");
    iv: url("/search");
    v: url("/search");
    vi: url("/search");
    vii: url("google.com/search");
    viii: url("google.com/search");
    ix: url("google.co/search");
    x: url("//google.com/search");
    xi: url("//google.com/search");
    xii: url("//google.co/search");
    xiii: url("http://google.com/home");
    xiv: url("http://google.com/home");
    xv: url("http://google.com/home");
  }
  ~~~

### In numbers

#### Around decimal point

- Whitespace is not allowed

  ~~~ lay
  whitespace::numbers {
    i: 10.2px
    ii: 10 .2px
  }
  ~~~

  ~~~ css
  whitespace::numbers {
    i: 10.2px;
    ii: 10 0.2px;
  }
  ~~~

  ~~~ lay
  10 .  2px // Will try to call method `2px` on `10`
  ~~~

  ~~~ ReferenceError
  ~~~

#### Between value and unit

- Whitespace is not allowed

  ~~~ lay
  whitespace::number::units {
    i: 12px + 10px
    ii: 12 px + px 10
    iii: -90%;
  }
  ~~~

  ~~~ css
  whitespace::number::units {
    i: 22px;
    ii: 12 pxpx 10;
    iii: -90%;
  }
  ~~~

  ~~~ lay
  17 %
  ~~~

  ~~~ SyntaxError
  ~~~

## Line endings

- Can be of any type

  + LF

    ~~~ lay
    include 'whitespace/lf.lay'
    ~~~

    ~~~ css
    @lf {
      is: \Allowed;
    }
    ~~~

  + CR

    ~~~ lay
    include 'whitespace/cr.lay'
    ~~~

    ~~~ css
    @cr {
      is: \Dllowed;
    }
    ~~~

  + CRLF

    ~~~ lay
    include 'whitespace/crlf.lay'
    ~~~

    ~~~ css
    @crlf {
      is: "\D\Allowed";
    }
    ~~~

## UTF-8 BOM's

- Are ignored

  ~~~ lay
  include 'whitespace/bom.lay'
  ~~~

  ~~~ css
  @bom {
    is: ok;
  }
  ~~~
