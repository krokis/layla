# Data URIs

- Are supported

  ~~~ lay
  #data-uri {
    i: url(data:,FooBar)
  }
  ~~~

  ~~~ css
  #data-uri {
    i: url("data:,FooBar");
  }
  ~~~

- Can have a mime-type

  ~~~ lay
  #data-uri[mime] {
    i: url(data:text/html,<h1>Hello%20World</h1>)
    ii: url(data:text/plain,Hello%20World)
    iii: url(data:Text/Plain,Hello%20World)
    iv: url(data:TEXT/Html,<strong>Hey</strong>)
  }
  ~~~

  ~~~ css
  #data-uri[mime] {
    i: url("data:text/html,<h1>Hello%20World</h1>");
    ii: url("data:,Hello%20World");
    iii: url("data:,Hello%20World");
    iv: url("data:text/html,<strong>Hey</strong>");
  }
  ~~~

- Can have a charset

  ~~~ lay
  #data-uri[charset] {
    i: url(data:text/html;charset=iso-8859,<h1>Hello%20World</h1>)
    ii: url(data:;charset=utf-8,Hello%20World)
    iii: url(data:;CHARSET=UTF-8,Hello%20World)
  }
  ~~~

  ~~~ css
  #data-uri[charset] {
    i: url("data:text/html;charset=iso-8859,<h1>Hello%20World</h1>");
    ii: url("data:;charset=utf-8,Hello%20World");
    iii: url("data:;charset=utf-8,Hello%20World");
  }
  ~~~

- Can contain UTF-8 text

  ~~~ lay
  #data-uri[charset="utf-8"] {
    content: url(data:text/plain;charset=utf8,¿Qué tal, España?)
  }
  ~~~

  ~~~ css
  #data-uri[charset="utf-8"] {
    content: url("data:;charset=utf8,¿Qué tal, España?");
  }
  ~~~

- Can contain HTML

  ~~~ lay
  #data-uri[html] {
    background: url(data:text/html,<h1>Hello</h1>)
  }
  ~~~

  ~~~ css
  #data-uri[html] {
    background: url("data:text/html,<h1>Hello</h1>");
  }
  ~~~

- Can contain base-64 encoded text

  ~~~ lay
  #data-uri[base64] {
    i: url(data:text/html;base64,PGh0bWw+PGJvZHk+PGgxPkhlbGxvLCB3b3JsZDwvaDE+PC9ib2R5PjwvaHRtbD4=)
    ii: url(data:text/html;BASE64,PGh0bWw+PGJvZHk+PGgxPkhlbGxvLCB3b3JsZDwvaDE+PC9ib2R5PjwvaHRtbD4=)
  }
  ~~~

  ~~~ css
  #data-uri[base64] {
    i: url("data:text/html;base64,PGh0bWw+PGJvZHk+PGgxPkhlbGxvLCB3b3JsZDwvaDE+PC9ib2R5PjwvaHRtbD4=");
    ii: url("data:text/html;base64,PGh0bWw+PGJvZHk+PGgxPkhlbGxvLCB3b3JsZDwvaDE+PC9ib2R5PjwvaHRtbD4=");
  }
  ~~~

- Can contain base-64 encoded binary data

  ~~~ lay
  #data-uri {
    i:url(data:image/gif;base64,R0lGODlhEAAQAMQAAORHHOVSKudfOulrSOp3WOyDZu6QdvCchPGolfO0o/XBs/fNwfjZ0frl3/zy7////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAkAABAALAAAAAAQABAAAAVVICSOZGlCQAosJ6mu7fiyZeKqNKToQGDsM8hBADgUXoGAiqhSvp5QAnQKGIgUhwFUYLCVDFCrKUE1lBavAViFIDlTImbKC5Gm2hB0SlBCBMQiB0UjIQA7)
    ii:url("data:image/gif;base64,R0lGODlhEAAQAMQAAORHHOVSKudfOulrSOp3WOyDZu6QdvCchPGolfO0o/XBs/fNwfjZ0frl3/zy7////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAkAABAALAAAAAAQABAAAAVVICSOZGlCQAosJ6mu7fiyZeKqNKToQGDsM8hBADgUXoGAiqhSvp5QAnQKGIgUhwFUYLCVDFCrKUE1lBavAViFIDlTImbKC5Gm2hB0SlBCBMQiB0UjIQA7") no-repeat center
    iii: url(data:image/x-png,f9difSSFIIGFIFJD1f982FSDKAA9==)
  }
  ~~~

  ~~~ css
  #data-uri {
    i: url("data:image/gif;base64,R0lGODlhEAAQAMQAAORHHOVSKudfOulrSOp3WOyDZu6QdvCchPGolfO0o/XBs/fNwfjZ0frl3/zy7////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAkAABAALAAAAAAQABAAAAVVICSOZGlCQAosJ6mu7fiyZeKqNKToQGDsM8hBADgUXoGAiqhSvp5QAnQKGIgUhwFUYLCVDFCrKUE1lBavAViFIDlTImbKC5Gm2hB0SlBCBMQiB0UjIQA7");
    ii: url("data:image/gif;base64,R0lGODlhEAAQAMQAAORHHOVSKudfOulrSOp3WOyDZu6QdvCchPGolfO0o/XBs/fNwfjZ0frl3/zy7////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAkAABAALAAAAAAQABAAAAVVICSOZGlCQAosJ6mu7fiyZeKqNKToQGDsM8hBADgUXoGAiqhSvp5QAnQKGIgUhwFUYLCVDFCrKUE1lBavAViFIDlTImbKC5Gm2hB0SlBCBMQiB0UjIQA7") no-repeat center;
    iii: url("data:image/x-png,f9difSSFIIGFIFJD1f982FSDKAA9==");
  }
  ~~~

- Whitespace in between base-64 data is ignored

  ~~~ lay
  #data-uri[base64][whitespace] {
    i:url(data:image/gif;base64,   R0lGODlhEAAQ  AMQAAORHHOVSKudfOulrSOp3WOyDZu6QdvCchPGolfO0o/
            XBs/fNwfjZ0frl3/zy7////wAAAAAAAAAAA  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
            AAAAAAACH5BAkAABAALAAAAAAQABAAAAVVI  CSOZGlCQAosJ6mu7fiyZeKqNKToQGDsM8hBADgUXoGAiq
            hSvp5QAnQKGIgUhwFUYLCVDFCrKUE1lBavA  ViFIDlTImbKC5Gm2hB0SlBCBMQiB0UjIQA7)
  }
  ~~~

  ~~~ css
  #data-uri[base64][whitespace] {
    i: url("data:image/gif;base64,R0lGODlhEAAQAMQAAORHHOVSKudfOulrSOp3WOyDZu6QdvCchPGolfO0o/XBs/fNwfjZ0frl3/zy7////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAkAABAALAAAAAAQABAAAAVVICSOZGlCQAosJ6mu7fiyZeKqNKToQGDsM8hBADgUXoGAiqhSvp5QAnQKGIgUhwFUYLCVDFCrKUE1lBavAViFIDlTImbKC5Gm2hB0SlBCBMQiB0UjIQA7");
  }
  ~~~

- Support interpolation

  ~~~ lay
  $html = '<h1>Lorem ipsum</h1>'
  $data = $html.base64
  $mime = 'text/html'

  url[data] {
    html: url(data:#{$mime};base64,#{$data})
    html: url("data:#{$mime};base64,#{$data}")
  }
  ~~~

  ~~~ css
  url[data] {
    html: url("data:text/html;base64,PGgxPkxvcmVtIGlwc3VtPC9oMT4=");
    html: url("data:text/html;base64,PGgxPkxvcmVtIGlwc3VtPC9oMT4=");
  }
  ~~~

## Methods

### `data?`

- Returns `true` if the URI is a data URI

  ~~~ lay
  #data-uri.data {
    i: url(http://www.google.com).data?
    ii: url(data:text/html,<h1>Hello</h1>).data?
  }
  ~~~

  ~~~ css
  #data-uri.data {
    i: false;
    ii: true;
  }
  ~~~

### `.mime`

- Returns the MIME type of the URI data as a quoted string

  ~~~ lay
  #data-uri.mime {
    i: url(data:text/html,<h1>Hello</h1>).mime
    ii: url(data:image/gif;base64,R0lGODlhEAAQAMQAAORHHOVSKudfOu).mime
  }
  ~~~

  ~~~ css
  #data-uri.mime {
    i: "text/html";
    ii: "image/gif";
  }
  ~~~

- Defaults to `text/plain`

  ~~~ lay
  #data-uri.mime {
    i: url(data:,<h1>Hello</h1>).mime
  }
  ~~~

  ~~~ css
  #data-uri.mime {
    i: "text/plain";
  }
  ~~~

### `charset`

- Returns the charset type of the URL data as a quoted string

  ~~~ lay
  #data-uri.charset {
    i: url(data:text/html;charset=utf-8,<h1>Hello</h1>).charset
  }
  ~~~

  ~~~ css
  #data-uri.charset {
    i: "utf-8";
  }
  ~~~

- Defaults to `us-ascii`

  ~~~ lay
  #data-uri.mime {
    i: url(data:text/html,<h1>Hello</h1>).charset
    ii: url(data:,<h1>Hello</h1>).charset
  }
  ~~~

  ~~~ css
  #data-uri.mime {
    i: "us-ascii";
    ii: "us-ascii";
  }
  ~~~

### `mediatype`

- Returns the mediatype of the data URI

  ~~~ lay
  #data-uri.mediatype {
    i: url(data:,<h1>Hello</h1>).mediatype
    ii: url(data:image/gif;base64,R0lGODlhEAAQAMQAAORHHOVSKudfOu).mediatype
    iii: url(data:text/html;charset=utf-8,<h1>Hello</h1>).mediatype
    iv: url(data:text/html,<h1>Hello</h1>).mediatype
  }
  ~~~

  ~~~ css
  #data-uri.mediatype {
    i: "text/plain;charset=us-ascii";
    ii: "image/gif;charset=us-ascii";
    iii: "text/html;charset=utf-8";
    iv: "text/html;charset=us-ascii";
  }
  ~~~

### `data`

- Returns the data URI decoded data

  ~~~ lay
  #data-uri.data {
    i: url(data:text/html,<h1>Hello, World!</h1>).data
    ii: url(data:text/plain;charset=utf8,¿Qué tal, España?).data
  }
  ~~~

  ~~~ css
  #data-uri.data {
    i: "<h1>Hello, World!</h1>";
    ii: "¿Qué tal, España?";
  }
  ~~~

- Returns decoded data if it's base64-encoded

  ~~~ lay
  $url = url(data:text/html;base64,PGh0bWw+PGJvZHk+PGgxPkhlbGxvLCB3b3JsZDwvaDE+PC9ib2R5PjwvaHRtbD4=)

  #data-uri.data[base64] {
    data: $url.data
  }
  ~~~

  ~~~ css
  #data-uri.data[base64] {
    data: "<html><body><h1>Hello, world</h1></body></html>";
  }
  ~~~

### `base64?`

- Returns `true` if the data URI is base64-encoded

  ~~~ lay
  $url = url(data:text/html;base64,PGh0bWw+PGJvZHk+PGgxPkhlbGxvLCB3b3JsZDwvaDE+PC9ib2R5PjwvaHRtbD4=)

  #data-uri.base64 {
    i: $url.base64?
    ii: url(data:text/html,<h1>Hello, world</h1>).base64?
  }
  ~~~

  ~~~ css
  #data-uri.base64 {
    i: true;
    ii: false;
  }
  ~~~
