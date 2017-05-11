# Comments

## Line comments

- Can be on their own line

  ~~~ lay
  // Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus non
  // commodo tellus. Mauris dolor justo, ornare eget venenatis nec,
  // ullamcorper sit amet ipsum.
  body {

    // Background color

    background-color: white

    // Font color
    color: #666
  }

  // Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus non
  // commodo tellus. Mauris dolor justo, ornare eget venenatis nec,
  // ullamcorper sit amet ipsum.

  ~~~

  ~~~ css
  body {
    background-color: white;
    color: #666666;
  }
  ~~~

- Can be at the end of a line

  ~~~ lay
  $background-color = white // This is the background color
  $margin = 20px, // top
            10px, // left/right
            40px // Bottom

  body { // Body styles

    background-color: $background-color // Background color
    margin: $margin.spaces // Margins color
  } // End of body styles
  ~~~

  ~~~ css
  body {
    background-color: white;
    margin: 20px 10px 40px;
  }
  ~~~

## Embedded comments

- Can be block comments

  ~~~ lay
  /*Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus non commodo tellus. Mauris dolor justo, ornare eget venenatis nec, ullamcorper sit amet ipsum.*/

  body {
    /**
    Lorem ipsum dolor sit amet, consectetur adipiscing elit.
    Vivamus non commodo tellus.
    Mauris dolor justo, ornare eget venenatis nec,
    ullamcorper sit amet ipsum.*/
    background: white }
  ~~~

  ~~~ css
  body {
    background: white;
  }
  ~~~

- Can be embedded in expressions

  ~~~ lay
  my-func/* this is my func */= (/* param*/ $foo) /* end of params */{
    return/* returning the same */$foo
  }

  expression::comments {
    i: 3/* three*/-/*two*/2
    ii: my-func(/* params passed */ 1 + /***/
      0)
  }
  ~~~

  ~~~ css
  expression::comments {
    i: 1;
    ii: 1;
  }
  ~~~

- Can be embedded in property declarations

  ~~~ lay
  body {
    color /* the font color*/ : /* a shade of gray */ #666

    section {
      box-shadow: /* These are the shadows */
        /* shadow one: */ 1px 2px 2px black /* end of shadow one */,
        /* shadow two: */ 1px 2px 4px silver /* end of shadow two */
    }
  }
  ~~~

  ~~~ css
  body {
    color: #666666;
  }

  body section {
    box-shadow: 1px 2px 2px black, 1px 2px 4px silver;
  }
  ~~~

- Can be embedded in selectors

  ~~~ lay
  /* lorem
  ipsum */body /*lorem*/ > /*ipsum*/div{
    border: red
  } /* */ a /* dolor */~ /* sit */a { color: red }
  ~~~

  ~~~ css
  body > div {
    border: red;
  }

  a ~ a {
    color: red;
  }
  ~~~

- Can be embedded in at-rules

  ~~~ lay
  /* media rule */@media/* lorem */screen /* ipsum */and (/* dolor */max-width/*sit*/:/*amet*/768px/*consectetur*/)/* adipiscing */{
    .container {
      max-width: 100%
    }
  }
  ~~~

  ~~~ css
  @media screen and (max-width: 768px) {
    .container {
      max-width: 100%;
    }
  }
  ~~~
