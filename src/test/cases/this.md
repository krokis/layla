`&`
===

- Holds a reference to current block

  ~~~ lay
  color: red
  border-color: &::color
  background-color: &::0.value
  items: &.length so far `(this makes {&.length + 1})`
  ~~~

  ~~~ css
  color: red;
  border-color: red;
  background-color: red;
  items: 3 so far (this makes 4);
  ~~~

- Cannot be overwritten
