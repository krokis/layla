Parentheses
===========

- Can be used to group expressions

  ~~~ lay
  foo: 2 + 3 * 7
  bar: (2 + 3) * 7
  ~~~

  ~~~ css
  foo: 23;
  bar: 35;
  ~~~

- Can wrap literals

  ~~~ lay
  border-width: (1px)
  line-height: ((10))
  font-family: ("Helvetica")
  ~~~

  ~~~ css
  border-width: 1px;
  line-height: 10;
  font-family: 'Helvetica';
  ~~~

- Can wrap unary expressions

  ~~~ lay
  border-width: (-1px)
  line-height: ((-10))
  ~~~

  ~~~ css
  border-width: -1px;
  line-height: -10;
  ~~~

- Can be used on unary expressions

  ~~~ lay
  border-width: -(1px)
  line-height: +((10))
  ~~~

  ~~~ css
  border-width: -1px;
  line-height: 10;
  ~~~

- Can be used on binary expressions

  ~~~ lay
  line-height: 7v * (2 + ((3 - 1)))
  ~~~

  ~~~ css
  line-height: 28v;
  ~~~

- Can be nested

  ~~~ lay
  line-height: ((2 + 7) * 3) + 2
  line-height: (( 1 ))
  line-height: (((((2)))))
  ~~~

  ~~~ css
  line-height: 29;
  line-height: 1;
  line-height: 2;
  ~~~
