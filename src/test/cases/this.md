`&`
===

- Holds a reference to current block

  ~~~ lay
  color: red
  border-color: &::color
  background-color: &::0.value

  with & {
    font-family: 'Arial'
    items: &.length so far `(this makes {&.length + 1})`
  }
  ~~~

  ~~~ css
  color: red;
  border-color: red;
  background-color: red;
  font-family: 'Arial';
  items: 4 so far (this makes 5);
  ~~~

- Cannot be overwritten
