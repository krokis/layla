# URLs

- Are declared with `url(...)`

  ~~~ lay
  body {
    background: url(back.png)
  }
  ~~~

  ~~~ css
  body {
    background: url("back.png");
  }
  ~~~

- Can be quoted

  ~~~ lay
  string.quoted {
    i: url('background.jpg') no-repeat
    ii: url("http://example.org/background.jpg") center
    iii: url('roboto.eot?&#iefix')
    iv: url('fonts.svg#roboto')
  }
  ~~~

  ~~~ css
  string.quoted {
    i: url("background.jpg") no-repeat;
    ii: url("http://example.org/background.jpg") center;
    iii: url("roboto.eot?&#iefix");
    iv: url("fonts.svg#roboto");
  }
  ~~~

- Do not need to be quoted

  ~~~ lay
  string.unquoted {
    i: url(http://example.org/background.jpg) center
    ii: url(/background.jpg?v=123&c=0) center
    iii: url(`//example.org/background.jpg`) center
    iv: url(/fonts/roboto.eot?#iefix)
    v: url(/fonts/fonts.svg#roboto)
  }
  ~~~

  ~~~ css
  string.unquoted {
    i: url("http://example.org/background.jpg") center;
    ii: url("/background.jpg?v=123&c=0") center;
    iii: url("//example.org/background.jpg") center;
    iv: url("/fonts/roboto.eot?#iefix");
    v: url("/fonts/fonts.svg#roboto");
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
    background: url("//localhost/backdrop.png?q=foo");
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
    background: url("/backdrop.png?q=foo");
    background: url("img/backdrop.png?q=foo");
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
    background: url("?q=foo&r=bar");
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
    background: url("#foobar");
  }
  ~~~

- Can be empty

  ~~~ lay
  background: url()
  background: url('')
  ~~~

  ~~~ css
  background: url("");
  background: url("");
  ~~~

- Support interpolation

  ~~~ lay
  body {
    $host = 'disney.com'
    $query = 'princess=beauty'
    $scheme = 'http'

    foo: url(`#{$scheme + 's'}://#{$host}#{'/path' * 2}`)
    foo: url("#{$scheme + 's'}://#{$host}/?#{$query}")
  }
  ~~~

  ~~~ css
  body {
    foo: url("https://disney.com/path/path");
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
    bar: "http";
    bar: null;
    bar: "file";
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
  foo: url("http://www.disney.com:8080/movies/?id=245#characters");
  foo: url("https://www.disney.com:8080/movies/?id=245#characters");
  ~~~

- Accepts `null`, and makes it a scheme-less URL

  ~~~ lay
  $url = url('http://www.disney.com')
  $url.scheme = null
  foo: $url
  ~~~

  ~~~ css
  foo: url("//www.disney.com/");
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
    bar: "ftp";
    bar: null;
    bar: "mailto";
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
  foo: url("gopher://disney.com/");
  foo: url("//disney.com/");
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
  foo: url("http://disney.es/foo");
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

- Returns a copy of the URL with the scheme set to 'https'

  ~~~ lay
  foo: url('http://disney.es/index.aspx').https
  ~~~

  ~~~ css
  foo: url("https://disney.es/index.aspx");
  ~~~

### `username`

- Returns the username field on the `auth` component

  ~~~ lay
  url.username {
    i: url(http://google.com).username, url(http://google.com).username.null?
    ii: url(http://@google.com).username, url(http://@google.com).username.null?
    iii: url(http://john@google.com).username
    iv: url(http://john:1234@google.com).username
  }
  ~~~

  ~~~ css
  url.username {
    i: null, true;
    ii: "", false;
    iii: "john";
    iv: "john";
  }
  ~~~

### `username=`

- Sets the `username` portion of the `auth` component

  ~~~ lay
  $url = url(http://john:1234@google.com)

  url.username {
    i: $url.username
    $url.username = 'joe';
    ii: $url.username
    $url.username = null;
    iii: $url.username
    $url.username = '';
    iv: $url.username
  }
  ~~~

  ~~~ css
  url.username {
    i: "john";
    ii: "joe";
    iii: "";
    iv: "";
  }
  ~~~

### `password`

- Returns the password from the `auth` component

  ~~~ lay
  url.password {
    i: url(http://google.com).password, url(http://google.com).password.null?
    ii: url(http://@google.com).password, url(http://@google.com).password.null?
    iii: url(http://john@google.com).password
    iv: url(http://john:1234@google.com).password
    v: url(http://:1234@google.com).password
  }
  ~~~

  ~~~ css
  url.password {
    i: null, true;
    ii: null, true;
    iii: null;
    iv: "1234";
    v: "1234";
  }
  ~~~

### `password=`

- Sets the `password` portion of the `auth` component

  ~~~ lay
  $url = url(http://john:1234@google.com)

  url.password {
    i: $url.password
    $url.password = '4321';
    ii: $url.password
    $url.password = null;
    iii: $url.password
    $url.password = '';
    iv: $url.password
    $url.username = ''
    v: $url
    $url.username = $url.password = null;
    vi: $url
  }
  ~~~

  ~~~ css
  url.password {
    i: "1234";
    ii: "4321";
    iii: null;
    iv: "";
    v: url("http://:@google.com/");
    vi: url("http://google.com/");
  }
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
    bar: "disney.com";
    bar: "disney.com";
    bar: "127.0.0.1";
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
  foo: url("http://disney.org/");
  ~~~

- Accepts TLD's

  ~~~ lay
  $url = url('http://localhost/phpMyAdmin')
  foo: $url
  $url.host = com
  foo: $url
  ~~~

  ~~~ css
  foo: url("http://localhost/phpMyAdmin");
  foo: url("http://com/phpMyAdmin");
  ~~~

- Accepts IP addresses

  ~~~ lay
  $url = url('http://www.disney.com/pixar')
  $url.host = '192.168.1.1'
  foo: $url
  ~~~

  ~~~ css
  foo: url("http://192.168.1.1/pixar");
  ~~~

- Accepts IPv6 addresses

  ~~~ lay
  url[ipv6] {
    $url = url('http://www.disney.com/pixar')
    $url.host = '2001:0db8:85a3:08d3:1319:8a2e:0370:7334'
    i: $url
    $url.port = 21
    ii: $url

    $url.host = '2001:0DB8::1428:57ab'
    iii: $url

    $url = url(http://user:password@[3ffe:2a00:100:7031::1]:8080) +
           '/articles/index.html'
    iv: $url
    $url.port = null
    v: $url
  }
  ~~~

  ~~~ css
  url[ipv6] {
    i: url("http://[2001:0db8:85a3:08d3:1319:8a2e:0370:7334]/pixar");
    ii: url("http://[2001:0db8:85a3:08d3:1319:8a2e:0370:7334]:21/pixar");
    iii: url("http://[2001:0db8::1428:57ab]:21/pixar");
    iv: url("http://user:password@[3ffe:2a00:100:7031::1]:8080/articles/index.html");
    v: url("http://user:password@[3ffe:2a00:100:7031::1]/articles/index.html");
  }
  ~~~

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
  foo: url("http://www.disney.com:8080/movies/");
  foo: url("http:///movies/");
  foo: url("http:///movies/");
  ~~~

### `domain`

- Returns the hostname, if it's not an IP.

  ~~~ lay
  url.domain {
    i: url('http://www.disney.com').domain
    ii: url(http://disney.com).domain
    iii: url(//www.disney.com).domain
    iv: url("//admin.disney.com").domain
    v: url("http://www.888.com").domain
    vi: url("http://888.com").domain
    vii: url("http://888").domain
    viii: url("http://www.888").domain
  }
  ~~~

  ~~~ css
  url.domain {
    i: "www.disney.com";
    ii: "disney.com";
    iii: "www.disney.com";
    iv: "admin.disney.com";
    v: "www.888.com";
    vi: "888.com";
    vii: "888";
    viii: "www.888";
  }
  ~~~

- Returns 'null' if the host is blank or missing

  ~~~ lay
  url.domain {
    i: url('http:///index.html').domain
    ii: url('http:// /index.html').domain
    iii: url('/foo/index.html').domain
  }
  ~~~

  ~~~ css
  url.domain {
    i: null;
    ii: null;
    iii: null;
  }
  ~~~

- Returns 'null' if the host is an IP

  ~~~ lay
  url.domain {
    i: url('http://192.168.1.1/pixar').domain
    ii: url(http://[2001:0db8:85a3:08d3:1319:8a2e:0370:7334]/pixar).domain
  }
  ~~~

  ~~~ css
  url.domain {
    i: null;
    ii: null;
  }
  ~~~

### `ip?`

- Returns true if the host is a valid v4 or v6 IP address

  ~~~ lay
  url.ip {
    i: url('http://192.168.1.1/pixar').ip?
    ii: url(http://[2001:0db8:85a3:08d3:1319:8a2e:0370:7334]/pixar).ip?
    iii: url('http://www.disney.com/pixar').ip?
  }
  ~~~

  ~~~ css
  url.ip {
    i: true;
    ii: true;
    iii: false;
  }
  ~~~


### `ipv4?`

- Returns true if the host is a valid IPv4 address

  ~~~ lay
  url.ipv4 {
    i: url('http://192.168.1.1/pixar').ipv4?
    ii: url(http://[2001:0db8:85a3:08d3:1319:8a2e:0370:7334]/pixar).ipv4?
    iii: url('http://www.disney.com/pixar').ipv4?
  }
  ~~~

  ~~~ css
  url.ipv4 {
    i: true;
    ii: false;
    iii: false;
  }
  ~~~

### `ipv6?`

- Returns true if the host is a valid IPv6 address

  ~~~ lay
  url.ipv6 {
    i: url('http://192.168.1.1/pixar').ipv6?
    ii: url(http://[2001:0db8:85a3:08d3:1319:8a2e:0370:7334]/pixar).ipv6?
    iii: url('http://www.disney.com/pixar').ipv6?
  }
  ~~~

  ~~~ css
  url.ipv6 {
    i: false;
    ii: true;
    iii: false;
  }
  ~~~

### `port`

- Returns the `:port` part of the URL, if any, or `null`

  ~~~ lay
  url.port {
    i: url('http://disney.com').port
    ii: url(http://disney.com:8080/index.php).port
    iii: url(http://disney.com:21/index.php).port.number
  }
  ~~~

  ~~~ css
  url.port {
    i: null;
    ii: "8080";
    iii: 21;
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
  foo: url("http://disney.com:8080/");
  ~~~

- Fails for non-numeric values

  ~~~ lay
  url('http://disney.com/').port = #fff
  ~~~

  ~~~ TypeError
  ~~~

  ~~~ lay
  url('http://disney.com/').port = ''
  ~~~

  ~~~ TypeError
  ~~~

- Fails for non-integer numbers

  ~~~ lay
  url('http://disney.com/').port = '2.7'
  ~~~

  ~~~ TypeError
  Cannot set URL port to non-integer number: 2.7
  ~~~

  ~~~ lay
  $url = url('http://disney.com/')
  $url.port = '80.0'
  background: $url
  ~~~

  ~~~ css
  background: url("http://disney.com:80/");
  ~~~

- Fails for numbers not in the 0..65535 range

  ~~~ lay
  url('http://disney.com/').port = -1
  ~~~

  ~~~ TypeError
  Port number out of 1..65535 range: -1
  ~~~

  ~~~ lay
  url('http://disney.com/').port = 0
  ~~~

  ~~~ css
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
  foo: url("http://disney.com:8080/");
  foo: url("http://disney.com/");
  ~~~

### `path`

- Returns the `path` component of the URL

  ~~~ lay
  url.path {
    i: url(http://disney.org/princesses/aladdin/jasmine.html).path
    ii: url(http://disney.com).path
    iii: url(/etc/foo/bar/baz).path
  }
  ~~~

  ~~~ css
  url.path {
    i: "/princesses/aladdin/jasmine.html";
    ii: "/";
    iii: "/etc/foo/bar/baz";
  }
  ~~~

### `path=`

- Sets the `path` component of the URL

  ~~~ lay
  $url = url(http://disney.org/princesses/aladdin/jasmine.html);
  url.path {
    $url.path = '/';
    i: $url
    $url.path = '/etc/foo/bar/baz';
    ii: $url
  }
  ~~~

  ~~~ css
  url.path {
    i: url("http://disney.org/");
    ii: url("http://disney.org/etc/foo/bar/baz");
  }
  ~~~

### `dirname`

- Returns the directory part of the URL path

  ~~~ lay
  url.dirname {
    i: url(http://disney.org/princesses/aladdin/jasmine.html).dirname
    ii: url(http://disney.com).dirname
    iii: url(/etc/foo/bar/baz).dirname
  }
  ~~~

  ~~~ css
  url.dirname {
    i: "/princesses/aladdin";
    ii: "/";
    iii: "/etc/foo/bar";
  }
  ~~~

### `dirname=`

- Sets the directory part of the URL path

  ~~~ lay
  $url = url(http://disney.org/princesses/aladdin/jasmine.html)

  url.dirname {
    $url.dirname = '/'
    i: $url
    $url.dirname = 'search'
    ii: $url
  }
  ~~~

  ~~~ css
  url.dirname {
    i: url("http://disney.org/jasmine.html");
    ii: url("http://disney.org/search/jasmine.html");
  }
  ~~~

### `basename`

- Returns the last portion of the URL path

  ~~~ lay
  url.basename {
    i: url(http://disney.org/princesses/aladdin/jasmine.html).basename
    ii: url(http://disney.com).basename
    iii: url(/etc/foo/bar/baz).basename
  }
  ~~~

  ~~~ css
  url.basename {
    i: "jasmine.html";
    ii: "";
    iii: "baz";
  }
  ~~~

### `basename=`

- Sets the last portion of the URL path

  ~~~ lay
  $url = url(http://disney.org/princesses/aladdin/jasmine.html)

  url.basename {
    $url.basename = 'index.php'
    i: $url
  }
  ~~~

  ~~~ css
  url.basename {
    i: url("http://disney.org/princesses/aladdin/index.php");
  }
  ~~~

### `extname`

- Returns the extension of the URL path

  ~~~ lay
  url.extname {
    i: url(http://disney.org/princesses/aladdin/jasmine.html).extname
    ii: url(http://disney.com).extname
    iii: url(/etc/foo/bar/baz).extname
  }
  ~~~

  ~~~ css
  url.extname {
    i: ".html";
    ii: "";
    iii: "";
  }
  ~~~

### `extname=`

- Sets the extension of the URL path

  ~~~ lay
  $url = url(http://disney.org/princesses/aladdin/jasmine.html)

  url.extname {
    $url.extname = '.aspx'
    i: $url
    $url.extname = null
    ii: $url
    $url.path = '/x/y/z'
    $url.extname = '.php'
    iii: $url
  }
  ~~~

  ~~~ css
  url.extname {
    i: url("http://disney.org/princesses/aladdin/jasmine.aspx");
    ii: url("http://disney.org/princesses/aladdin/jasmine");
    iii: url("http://disney.org/x/y/z.php");
  }
  ~~~

### `filename`

- Returns the last portion of the URL path, without extension

  ~~~ lay
  url.filename {
    i: url(http://disney.org/princesses/aladdin/jasmine.html).filename
    ii: url(http://disney.com).filename
    iii: url(/etc/foo/bar/baz).filename
  }
  ~~~

  ~~~ css
  url.filename {
    i: "jasmine";
    ii: "";
    iii: "baz";
  }
  ~~~

### `filename=`

- Sets the last portion of the URL path, without extension

  ~~~ lay
  $url = url(http://disney.org/princesses/aladdin/jasmine.html)

  url.filename {
    $url.filename = 'index'
    i: $url
  }
  ~~~

  ~~~ css
  url.filename {
    i: url("http://disney.org/princesses/aladdin/index.html");
  }
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
  c: "q=google";
  d: "q=google";
  ~~~

### `query=`

- Sets the `?query` part of the URL

  ~~~ lay
  $url = url(http://google.com/)
  $url.query = 'hey=Joe'

  url.query {
    foo: $url
  }
  ~~~

  ~~~ css
  url.query {
    foo: url("http://google.com/?hey=Joe");
  }
  ~~~

- Is properly encoded

  ~~~ lay
  $url = url(http://google.com/)
  $url.query = 'hey=John Doe&q=foo bar'

  url.query {
    i: $url
    /*
    TODO I think maybe `?` should be encoded to `%3F`, but Node
    `url.format()` implementation does not.
    https://tools.ietf.org/html/rfc2396#section-3.4
    */
    $url.query = '?hey=yo'
    ii: $url
    $url.query = '#hey=yo'
    iii: $url
  }
  ~~~

  ~~~ css
  url.query {
    i: url("http://google.com/?hey=John%20Doe&q=foo%20bar");
    ii: url("http://google.com/??hey=yo");
    iii: url("http://google.com/?%23hey=yo");
  }
  ~~~

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
  foo: url("http://google.com/?q=Lebowski");
  foo: url("http://google.com/?");
  foo: url("http://google.com/");
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
    bar: "start";
    bar: "";
    bar: null;
  }
  ~~~

### `fragment=`

- Sets the `#fragment` part of the URL

  ~~~ lay
  url.fragment {
    $url = url('http://disney.com/')
    $url.fragment = 'footer'
    foo: $url
  }
  ~~~

  ~~~ css
  url.fragment {
    foo: url("http://disney.com/#footer");
  }
  ~~~

- Is properly encoded

  ~~~ lay
  url.fragment {
    $url = url('http://disney.com/')
    $url.fragment = 'second section'
    foo: $url
  }
  ~~~

  ~~~ css
  url.fragment {
    foo: url("http://disney.com/#second%20section");
  }
  ~~~

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
  foo: url("http://google.com/#images");
  foo: url("http://google.com/#");
  foo: url("http://google.com/");
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
    bar: "start";
    bar: "";
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
  foo: url("http://disney.org/#footer");
  foo: url("http://disney.org/");
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

### `data?`

- Returns `true` if the URL is a data URI

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
  foo: url("/one/two/three/four.php");
  foo: url("/one/two/five.php");
  foo: url("/five.php");
  foo: url("http://example.com/one");
  foo: url("//example.com/one");
  foo: url("//example.com/one/");
  foo: url("//example.com/one");
  foo: url("//example.com/one");
  foo: url("//example.com/one");
  foo: url("//example.org/three");
  foo: url("http://disney.com/?princess=ariel");
  foo: url("https://example.com/");
  foo: url("https://example.com/path");
  foo: url("http://example.com/two");
  ~~~
