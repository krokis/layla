# `!important`

- Can be used on properties

  ~~~ lay
  important {
    i: 1px 2px 3px !important
    ii: #f00 !important
    iii: "Helvetica" !important
    iv: url(google.com) !important
  }
  ~~~

  ~~~ css
  important {
    i: 1px 2px 3px !important;
    ii: #ff0000 !important;
    iii: "Helvetica" !important;
    iv: url("google.com") !important;
  }
  ~~~

- Can be used more than once

  ~~~ lay
  important {
    i: 20px !important !important !important
  }
  ~~~

  ~~~ css
  important {
    i: 20px !important;
  }
  ~~~

- Is carried when cloned

  ~~~ lay
  $border = none !important

  important {
    border: $border
  }
  ~~~

  ~~~ css
  important {
    border: none !important;
  }
  ~~~

## Methods

### `.important?`

- Returns `true` if the object is `!important`

  ~~~ lay
  important.important {
    i: (#f00 !important).important?
    $f = 5px
    ii: $f.important?
    $f = $f !important
    iii: $f.important?
    $f = $f !important
    iv: $f.important?
  }
  ~~~

  ~~~ css
  important.important {
    i: true;
    ii: false;
    iii: true;
    iv: true;
  }
  ~~~

### `.important`

- Returns an `!important` copy of the object

  ~~~ lay
  important.important {
    i: #f00.important
  }
  ~~~

  ~~~ css
  important.important {
    i: #ff0000 !important;
  }
  ~~~

### `.important`

- Returns a non `!important` copy of the object

  ~~~ lay
  important.important {
    i: (#f00 !important).unimportant
    &::ii = (2px !important).unimportant
  }
  ~~~

  ~~~ css
  important.important {
    i: #ff0000;
    ii: 2px;
  }
  ~~~
