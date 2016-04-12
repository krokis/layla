URLs
====

- Are declared with `url(...)`

  ~~~ lay
  body {
    background: url(back.png)
  }
  ~~~

  ~~~ css
  body {
    background: url(back.png);
  }
  ~~~

- Can be quoted

  ~~~ lay
  body {
    background: url('background.jpg') no-repeat
    background: url("http://example.org/background.jpg") center
  }

  @font-face {
    src: url('roboto.eot?&#iefix')
    src: url('fonts.svg#roboto')
  }
  ~~~

  ~~~ css
  body {
    background: url('background.jpg') no-repeat;
    background: url("http://example.org/background.jpg") center;
  }

  @font-face {
    src: url('roboto.eot?&#iefix');
    src: url('fonts.svg#roboto');
  }
  ~~~

- Can be unquoted

  ~~~ lay
  body {
    background: url(http://example.org/background.jpg) center
    background: url(/background.jpg?v=123&c=0) center
    background: url(`//example.org/background.jpg`) center
  }

  @font-face {
    src: url(/fonts/roboto.eot?#iefix)
    src: url(/fonts/fonts.svg#roboto)
  }
  ~~~

  ~~~ css
  body {
    background: url(http://example.org/background.jpg) center;
    background: url(/background.jpg?v=123&c=0) center;
    background: url(//example.org/background.jpg) center;
  }

  @font-face {
    src: url(/fonts/roboto.eot?#iefix);
    src: url(/fonts/fonts.svg#roboto);
  }
  ~~~

- Can have no scheme

  ~~~ lay
  body {
    background: url(//localhost/backdrop.png?q=foo)
  }
  ~~~

  ~~~ css
  body {
    background: url(//localhost/backdrop.png?q=foo);
  }
  ~~~

- Can have no host

  ~~~ lay
  body {
    background: url(/backdrop.png?q=foo)
    background: url(img/backdrop.png?q=foo)
  }
  ~~~

  ~~~ css
  body {
    background: url(/backdrop.png?q=foo);
    background: url(img/backdrop.png?q=foo);
  }
  ~~~

- Can have no path

  ~~~ lay
  body {
    background: url(?q=foo&r=bar)
  }
  ~~~

  ~~~ css
  body {
    background: url(?q=foo&r=bar);
  }
  ~~~

- Can be just a `#fragment`

  ~~~ lay
  body {
    background: url(#foobar)
  }
  ~~~

  ~~~ css
  body {
    background: url(#foobar);
  }
  ~~~

- Can be empty

  ~~~ lay
  background: url()
  background: url('')
  ~~~

  ~~~ css
  background: url();
  background: url('');
  ~~~

- Does not add trailing slashes

- Support data URIs

  ~~~ lay-TODO
  #data-uri {
    background:url(data:image/gif;base64,R0lGODlhEAAQAMQAAORHHOVSKudfOulrSOp3WOyDZu6QdvCchPGolfO0o/XBs/fNwfjZ0frl3/zy7////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAkAABAALAAAAAAQABAAAAVVICSOZGlCQAosJ6mu7fiyZeKqNKToQGDsM8hBADgUXoGAiqhSvp5QAnQKGIgUhwFUYLCVDFCrKUE1lBavAViFIDlTImbKC5Gm2hB0SlBCBMQiB0UjIQA7)

    background:url("data:image/gif;base64,R0lGODlhEAAQAMQAAORHHOVSKudfOulrSOp3WOyDZu6QdvCchPGolfO0o/XBs/fNwfjZ0frl3/zy7////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAkAABAALAAAAAAQABAAAAVVICSOZGlCQAosJ6mu7fiyZeKqNKToQGDsM8hBADgUXoGAiqhSvp5QAnQKGIgUhwFUYLCVDFCrKUE1lBavAViFIDlTImbKC5Gm2hB0SlBCBMQiB0UjIQA7") no-repeat center
  }
  ~~~

  ~~~ css-TODO
  #data-uri {
    background: url(data:image/gif;base64,R0lGODlhEAAQAMQAAORHHOVSKudfOulrSOp3WOyDZu6QdvCchPGolfO0o/XBs/fNwfjZ0frl3/zy7////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAkAABAALAAAAAAQABAAAAVVICSOZGlCQAosJ6mu7fiyZeKqNKToQGDsM8hBADgUXoGAiqhSvp5QAnQKGIgUhwFUYLCVDFCrKUE1lBavAViFIDlTImbKC5Gm2hB0SlBCBMQiB0UjIQA7);
    background: url('data:image/gif;base64,R0lGODlhEAAQAMQAAORHHOVSKudfOulrSOp3WOyDZu6QdvCchPGolfO0o/XBs/fNwfjZ0frl3/zy7////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAkAABAALAAAAAAQABAAAAVVICSOZGlCQAosJ6mu7fiyZeKqNKToQGDsM8hBADgUXoGAiqhSvp5QAnQKGIgUhwFUYLCVDFCrKUE1lBavAViFIDlTImbKC5Gm2hB0SlBCBMQiB0UjIQA7') no-repeat center;
  }
  ~~~

- Support interpolation

  ~~~ lay
  body {
    $host = 'disney.com'
    $query = 'princess=beauty'
    $scheme = 'http'

    foo: url(`{$scheme + 's'}://{$host}{'/path' * 2}`)
    foo: url("{$scheme + 's'}://{$host}/?{$query}")
  }
  ~~~

  ~~~ css
  body {
    foo: url(https://disney.com/path/path);
    foo: url("https://disney.com/?princess=beauty");
  }
  ~~~

## Methods

### `scheme`

- Returns the `scheme:` part of the URL, if any, or `null`

  ~~~ lay
  #foo {
    bar: url('http://disney.com').scheme
    bar: url(//disney.com).scheme
    bar: url(file:///pr0n/7281.jpg).scheme
  }
  ~~~

  ~~~ css
  #foo {
    bar: 'http';
    bar: null;
    bar: file;
  }
  ~~~

### `scheme=`

- Sets the `scheme:` part of the URL

  ~~~ lay
  $url = url('http://www.disney.com:8080/movies/?id=245#characters')
  foo: $url
  $url.scheme = 'https'
  foo: $url
  ~~~

  ~~~ css
  foo: url('http://www.disney.com:8080/movies/?id=245#characters');
  foo: url('https://www.disney.com:8080/movies/?id=245#characters');
  ~~~

- Fails for invalid schemes

- Accepts `null`, and makes it a scheme-less URL

  ~~~ lay
  $url = url('http://www.disney.com')
  $url.scheme = null
  foo: $url
  ~~~

  ~~~ css
  foo: url('//www.disney.com/');
  ~~~

### `protocol`

- Is an alias of `scheme`

  ~~~ lay
  #foo {
    bar: url('ftp://disney.com').protocol
    bar: url(//disney.com).protocol
    bar: url(mailto:hello@example.com).protocol
  }
  ~~~

  ~~~ css
  #foo {
    bar: 'ftp';
    bar: null;
    bar: mailto;
  }
  ~~~

### `protocol=`

- Is an alias of `scheme=`

  ~~~ lay
  $url = url(http://disney.com/)
  $url.protocol = 'gopher'
  foo: $url
  $url.protocol = null
  foo: $url
  ~~~

  ~~~ css
  foo: url(gopher://disney.com/);
  foo: url(//disney.com/);
  ~~~

### `host`

- Returns the `//host` part of the URL, if any, or `null`

  ~~~ lay
  #foo {
    bar: url('http://disney.com').host
    bar: url(//disney.com).host
    bar: url(//127.0.0.1/pr0n/7281.jpg).host
  }
  ~~~

  ~~~ css
  #foo {
    bar: 'disney.com';
    bar: disney.com;
    bar: 127.0.0.1;
  }
  ~~~

### `host=`

- Sets the `//host` part of the URL

  ~~~ lay
  $url = url('http://www.disney.com/')
  $url.host = 'disney.org'
  foo: $url
  ~~~

  ~~~ css
  foo: url('http://disney.org/');
  ~~~

- Accepts TLD's

  ~~~ lay
  $url = url('http://localhost/phpMyAdmin')
  foo: $url
  $url.host = com
  foo: $url
  ~~~

  ~~~ css
  foo: url('http://localhost/phpMyAdmin');
  foo: url('http://com/phpMyAdmin');
  ~~~

- Accepts IP addresses

  ~~~ lay
  $url = url('http://www.disney.com/pixar')
  $url.host = '192.168.1.1'
  foo: $url
  ~~~

  ~~~ css
  foo: url('http://192.168.1.1/pixar');
  ~~~

- Accepts IPv6 addresses

  ~~~ lay-TODO
  $url = url('http://www.disney.com/pixar')
  $url.host = '[2001:0db8:85a3:08d3:1319:8a2e:0370:7334]'
  foo: $url
  $url.host = '[2001:0DB8::1428:57ab]'
  foo: $url
  ~~~

  ~~~ css-TODO
  foo: url('http://[2001:0db8:85a3:08d3:1319:8a2e:0370:7334]/pixar');
  foo: url('http://[2001:0DB8::1428:57ab]/pixar');
  ~~~

- Fails for invalid hosts

- Accepts `null` and empty string

  ~~~ lay
  $url = url('http://www.disney.com:8080/movies/')
  foo: $url
  $url.host = ''
  foo: $url
  $url.host = null
  foo: $url
  ~~~

  ~~~ css
  foo: url('http://www.disney.com:8080/movies/');
  foo: url('/movies/');
  foo: url('/movies/');
  ~~~

### `domain`

- Returns the hostname, without `www.`

  ~~~ lay
  url.domain {
    i: url('http://www.disney.com').domain
    ii: url(http://disney.com).domain
    iii: url(//www.disney.com).domain
    iv: url("//disney.com").domain
  }
  ~~~

  ~~~ css
  url.domain {
    i: 'disney.com';
    ii: disney.com;
    iii: disney.com;
    iv: "disney.com";
  }
  ~~~

### `http?`

- Returns `true` if the URL has a protocol and it's 'http'

  ~~~ lay
  #foo {
    bar: url('http://disney.com').http?
    bar: url(https://disney.com).http?
    bar: url(//127.0.0.1/background.url).http?
  }
  ~~~

  ~~~ css
  #foo {
    bar: true;
    bar: false;
    bar: false;
  }
  ~~~

- Is case insensitive

  ~~~ lay
  #foo {
    bar: url('HTTP://disney.com').http?
  }
  ~~~

  ~~~ css
  #foo {
    bar: true;
  }
  ~~~

### `http`

- Return a copy of the URL with the scheme set to 'http'

  ~~~ lay
  foo: url('ftp://disney.es/foo').http
  ~~~

  ~~~ css
  foo: url('http://disney.es/foo');
  ~~~

### `https?`

- Returns `true` if the URL has a protocol and it's 'https'

  ~~~ lay
  #foo {
    bar: url('http://disney.com').http?
    bar: url(https://disney.com).http?
    bar: url(//127.0.0.1/background.url).http?
  }
  ~~~

  ~~~ css
  #foo {
    bar: true;
    bar: false;
    bar: false;
  }
  ~~~

- Is case insensitive

  ~~~ lay
  #foo {
    bar: url('HTTPs://disney.com').https?
  }
  ~~~

  ~~~ css
  #foo {
    bar: true;
  }
  ~~~

### `https`

- Return a copy of the URL with the scheme set to 'https'

  ~~~ lay
  foo: url('http://disney.es/index.aspx').https
  ~~~

  ~~~ css
  foo: url('https://disney.es/index.aspx');
  ~~~

### `port`

- Returns the `:port` part of the URL, if any, or `null`

  ~~~ lay
  #foo {
    bar: url('http://disney.com').port
    bar: url(http://disney.com:8080/index.php).port
  }
  ~~~

  ~~~ css
  #foo {
    bar: null;
    bar: 8080;
  }
  ~~~

### `port=`

- Sets the `:port` part of the URL

  ~~~ lay
  $url = url('http://disney.com/')
  $url.port = 8080
  foo: $url
  ~~~

  ~~~ css
  foo: url('http://disney.com:8080/');
  ~~~

- Fails for non-numeric values

  ~~~ lay
  url('http://disney.com/').port = #fff
  ~~~

  ~~~ TypeError
  Cannot set URL port to non-numeric value: [Color]
  ~~~

  ~~~ lay
  url('http://disney.com/').port = ''
  ~~~

  ~~~ TypeError
  Cannot set URL port to non-numeric value: [String ""]
  ~~~

- Fails for non-integer numbers

  ~~~ lay
  url('http://disney.com/').port = '2.7'
  ~~~

  ~~~ TypeError
  Cannot set URL port to non integer number: 2.7
  ~~~

  ~~~ lay
  $url = url('http://disney.com/')
  $url.port = '80.0'
  background: $url
  ~~~

  ~~~ css
  background: url('http://disney.com:80/');
  ~~~

- Fails for numbers not in the 1..65535 range

  ~~~ lay
  url('http://disney.com/').port = -1
  ~~~

  ~~~ TypeError
  Port number out of 1..65535 range: -1
  ~~~

  ~~~ lay
  url('http://disney.com/').port = 0
  ~~~

  ~~~ TypeError
  Port number out of 1..65535 range: 0
  ~~~

  ~~~ lay
  url('http://disney.com/').port = 65536
  ~~~

  ~~~ TypeError
  Port number out of 1..65535 range: 65536
  ~~~

- Accepts `null`

  ~~~ lay
  $url = url('http://disney.com/')
  $url.port = 8080
  foo: $url
  $url.port = null
  foo: $url
  ~~~

  ~~~ css
  foo: url('http://disney.com:8080/');
  foo: url('http://disney.com/');
  ~~~

### `query`

- Returns the `?query` part of the URL if any, or `null`

  ~~~ lay
  a: url(http://google.com/).query
  b: url(http://google.com/?).query.quoted
  c: url(http://google.com/?q=google).query
  d: url(http://google.com/?q=google#top).query.quoted
  ~~~

  ~~~ css
  a: null;
  b: "";
  c: q=google;
  d: "q=google";
  ~~~

### `query=`

- Sets the `?query` part of the URL

  ~~~ lay
  $url = url(http://google.com/)
  $url.query = 'hey=Joe'

  foo: $url
  ~~~

  ~~~ css
  foo: url(http://google.com/?hey=Joe);
  ~~~

- Gets properly encoded

- Accepts `null` and empty string

  ~~~ lay
  $url = url(http://google.com/?q=Lebowski)
  foo: $url
  $url.query = ''
  foo: $url
  $url.query = null
  foo: $url
  ~~~

  ~~~ css
  foo: url(http://google.com/?q=Lebowski);
  foo: url(http://google.com/?);
  foo: url(http://google.com/);
  ~~~

### `fragment`

- Returns the `#fragment` part of the URL, if any, or `null`

  ~~~ lay
  #foo {
    bar: url(http://disney.com#start).fragment
    bar: url('http://localhost/#').fragment
    bar: url(http://localhost/index.php).fragment
  }
  ~~~

  ~~~ css
  #foo {
    bar: start;
    bar: '';
    bar: null;
  }
  ~~~

### `fragment=`

- Sets the `#fragment` part of the URL

  ~~~ lay
  $url = url('http://disney.com/')
  $url.fragment = 'footer'
  foo: $url
  ~~~

  ~~~ css
  foo: url('http://disney.com/#footer');
  ~~~

- Gets properly encoded

- Accepts `null` and empty string

  ~~~ lay
  $url = url(http://google.com/#images)
  foo: $url
  $url.fragment = ''
  foo: $url
  $url.fragment = null
  foo: $url
  ~~~

  ~~~ css
  foo: url(http://google.com/#images);
  foo: url(http://google.com/#);
  foo: url(http://google.com/);
  ~~~

### `hash`

- Is an alias of `fragment`

  ~~~ lay
  #foo {
    bar: url(http://disney.com#start).hash
    bar: url('http://localhost/#').hash
    bar: url(http://localhost/index.php).hash
  }
  ~~~

  ~~~ css
  #foo {
    bar: start;
    bar: '';
    bar: null;
  }
  ~~~

### `hash=`

- Is an alias of `fragment=`

  ~~~ lay
  $url = url('http://disney.org/')
  $url.hash = 'footer'
  foo: $url
  $url.hash = null
  foo: $url
  ~~~

  ~~~ css
  foo: url('http://disney.org/#footer');
  foo: url('http://disney.org/');
  ~~~

### `absolute?`

- Returns `true` if the URL is fully qualified, ie: it has a scheme

  ~~~ lay
  #foo {
    bar: url('http://disney.com').absolute?
    bar: url(//disney.com).absolute?
    bar: url(file:///pr0n/7281.jpg).absolute?
  }
  ~~~

  ~~~ css
  #foo {
    bar: true;
    bar: false;
    bar: true;
  }
  ~~~

### `relative?`

- Returns `true` if the URL is not absolute

  ~~~ lay
  #foo {
    bar: url('http://disney.com').relative?
    bar: url(//disney.com).relative?
    bar: url(file:///pr0n/7281.jpg).relative?
  }
  ~~~

  ~~~ css
  #foo {
    bar: false;
    bar: true;
    bar: false;
  }
  ~~~

### `auth`

### Operators

#### `+`

- Resolves a relative URL or string

  ~~~ lay
  foo: url('/one/two/three/') + 'four.php'
  foo: url('/one/two/three') + 'four.php' + 'five.php'
  foo: url('/one/two/three') + 'four.php' + '/five.php'
  foo: url(http://example.com/two) + '/one'
  foo: url(//example.com/two) + '../one'
  foo: url(//example.com/one/two/three/) + '../' + '..'
  foo: url(//example.com/one/two/three) + '../../one'
  foo: url(//example.com/two/) + '../../../one'
  foo: url(//example.com/two) + url(/one)
  foo: url(//example.com/two) + url(//example.org/three)
  foo: url(http://disney.com) + url(?princess=ariel)
  foo: url(http://disney.com) + url(https://example.com/)
  foo: url(https://disney.com) + url(//example.com/path)
  foo: 'http://example.com/one' + url(/two)
  ~~~

  ~~~ css
  foo: url('/one/two/three/four.php');
  foo: url('/one/two/five.php');
  foo: url('/five.php');
  foo: url(http://example.com/one);
  foo: url(//example.com/one);
  foo: url(//example.com/one/);
  foo: url(//example.com/one);
  foo: url(//example.com/one);
  foo: url(//example.com/one);
  foo: url(//example.org/three);
  foo: url(http://disney.com/?princess=ariel);
  foo: url(https://example.com/);
  foo: url(https://example.com/path);
  foo: url(http://example.com/two);
  ~~~
