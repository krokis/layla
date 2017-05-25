# `&`

- Holds a reference to current block

  ~~~ lay
  #ampersand {
    color: #f00
    border-color: &::color
    background-color: &::0.value
    items: &.length so far `(this should make #{&.length + 1})`
  }
  ~~~

  ~~~ css
  #ampersand {
    color: #f00;
    border-color: #f00;
    background-color: #f00;
    items: 3 so far (this should make 4);
  }
  ~~~
