# URLs

- Are declared with `url(...)`

  ~~~ lay
  url {
    i: url(back.png)
  }
  ~~~

  ~~~ css
  url {
    i: url("back.png");
  }
  ~~~

- Can be quoted

  ~~~ lay
  url.quoted {
    i: url('background.jpg') no-repeat
    ii: url("http://example.org/background.jpg") center
    iii: url('roboto.eot?&#iefix')
    iv: url('fonts.svg#roboto')
  }
  ~~~

  ~~~ css
  url.quoted {
    i: url("background.jpg") no-repeat;
    ii: url("http://example.org/background.jpg") center;
    iii: url("roboto.eot?&#iefix");
    iv: url("fonts.svg#roboto");
  }
  ~~~

- Do not need to be quoted

  ~~~ lay
  url.unquoted {
    i: url(http://example.org/background.jpg) center
    ii: url(/background.jpg?v=123&c=0) center
    iii: url(`//example.org/background.jpg`) center
    iv: url(/fonts/roboto.eot?#iefix)
    v: url(/fonts/fonts.svg#roboto)
  }
  ~~~

  ~~~ css
  url.unquoted {
    i: url("http://example.org/background.jpg") center;
    ii: url("/background.jpg?v=123&c=0") center;
    iii: url("//example.org/background.jpg") center;
    iv: url("/fonts/roboto.eot?#iefix");
    v: url("/fonts/fonts.svg#roboto");
  }
  ~~~

- Can have no scheme

  ~~~ lay
  url[no-scheme] {
    i: url(//localhost/backdrop.png?q=foo)
  }
  ~~~

  ~~~ css
  url[no-scheme] {
    i: url("//localhost/backdrop.png?q=foo");
  }
  ~~~

- Can have no host

  ~~~ lay
  url[no-host] {
    i: url(/backdrop.png?q=foo)
    ii: url(img/backdrop.png?q=foo)
  }
  ~~~

  ~~~ css
  url[no-host] {
    i: url("/backdrop.png?q=foo");
    ii: url("img/backdrop.png?q=foo");
  }
  ~~~

- Can have no path

  ~~~ lay
  url[no-path] {
    i: url(?q=foo&r=bar)
  }
  ~~~

  ~~~ css
  url[no-path] {
    i: url("?q=foo&r=bar");
  }
  ~~~

- Can be just a `#fragment`

  ~~~ lay
  url#fragment {
    i: url(#foobar)
  }
  ~~~

  ~~~ css
  url#fragment {
    i: url("#foobar");
  }
  ~~~

- Can be empty

  ~~~ lay
  url[empty] {
    i: url()
    ii: url('')
  }
  ~~~

  ~~~ css
  url[empty] {
    i: url("");
    ii: url("");
  }
  ~~~

- Support interpolation

  ~~~ lay
  url:interpolation {
    $host = 'disney.com'
    $query = 'princess=beauty'
    $scheme = 'http'

    i: url(`#{$scheme + 's'}://#{$host}#{'/path' * 2}`)
    ii: url("#{$scheme + 's'}://#{$host}/?#{$query}")
  }
  ~~~

  ~~~ css
  url:interpolation {
    i: url("https://disney.com/path/path");
    ii: url("https://disney.com/?princess=beauty");
  }
  ~~~

## Methods

### `scheme`

- Returns the `scheme:` part of the URL, if any, or `null`

  ~~~ lay
  url.scheme {
    i: url('http://disney.com').scheme
    ii: url(//disney.com).scheme
    iii: url(file:///pr0n/7281.jpg).scheme
  }
  ~~~

  ~~~ css
  url.scheme {
    i: "http";
    ii: null;
    iii: "file";
  }
  ~~~

- Sets the `scheme:` part of the URL

  ~~~ lay
  url.scheme {
    $url = url('http://www.disney.com:8080/movies/?id=245#characters')

    i: $url
    ii: $url.scheme('https')
  }
  ~~~

  ~~~ css
  url.scheme {
    i: url("http://www.disney.com:8080/movies/?id=245#characters");
    ii: url("https://www.disney.com:8080/movies/?id=245#characters");
  }
  ~~~

- Accepts `null`, and makes it a scheme-less URL

  ~~~ lay
  url.scheme {
    i: url('http://www.disney.com').scheme(null)
  }
  ~~~

  ~~~ css
  url.scheme {
    i: url("//www.disney.com/");
  }
  ~~~

### `protocol`

- Is an alias of `scheme`

  ~~~ lay
  url.protocol {
    i: url('ftp://disney.com').protocol
    ii: url(//disney.com).protocol
    iii: url(mailto:hello@example.com).protocol
    iv: url(http://disney.com/).protocol('gopher')
    v: url(http://disney.com/).protocol(null)
  }
  ~~~

  ~~~ css
  url.protocol {
    i: "ftp";
    ii: null;
    iii: "mailto";
    iv: url("gopher://disney.com/");
    v: url("//disney.com/");
  }
  ~~~

  ~~~ css
  url.protocol {
    i: url("gopher://disney.com/");
    ii: url("//disney.com/");
  }
  ~~~

### `http?`

- Returns `true` if the URL has a protocol and it's 'http'

  ~~~ lay
  url.https {
    i: url('http://disney.com').http?
    ii: url(https://disney.com).http?
    iii: url(//127.0.0.1/background.url).http?
  }
  ~~~

  ~~~ css
  url.https {
    i: true;
    ii: false;
    iii: false;
  }
  ~~~

- Is case insensitive

  ~~~ lay
  url.https {
    i: url('HTTP://disney.com').http?
  }
  ~~~

  ~~~ css
  url.https {
    i: true;
  }
  ~~~

### `http`

- Return a copy of the URL with the scheme set to 'http'

  ~~~ lay
  url.http {
    i: url('ftp://disney.es/foo').http
  }
  ~~~

  ~~~ css
  url.http {
    i: url("http://disney.es/foo");
  }
  ~~~

### `https?`

- Returns `true` if the URL has a protocol and it's 'https'

  ~~~ lay
  url.https {
    i: url('http://disney.com').http?
    ii: url(https://disney.com).http?
    iii: url(//127.0.0.1/background.url).http?
  }
  ~~~

  ~~~ css
  url.https {
    i: true;
    ii: false;
    iii: false;
  }
  ~~~

- Is case insensitive

  ~~~ lay
  url.https {
    i: url('HTTPs://disney.com').https?
  }
  ~~~

  ~~~ css
  url.https {
    i: true;
  }
  ~~~

### `https`

- Returns a copy of the URL with the scheme set to 'https'

  ~~~ lay
  url.https {
    i: url('http://disney.es/index.aspx').https
  }
  ~~~

  ~~~ css
  url.https {
    i: url("https://disney.es/index.aspx");
  }
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

- Sets the `username` portion of the `auth` component

  ~~~ lay
  $url = url(http://john:1234@google.com)

  url.username {
    i: $url.username
    ii: $url.username('joe').username
    $url = $url.username(null)
    iii: $url.username
    iv: $url.username(``).username
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

- Sets the `password` portion of the `auth` component

  ~~~ lay
  $url = url(http://john:1234@google.com)

  url.password {
    i: $url.password
    $url = $url.password('4321')
    ii: $url.password
    $url = $url.password(null)
    iii: $url.password
    $url = $url.password('')
    iv: $url.password
    $url = $url.username('')
    v: $url
    $url = $url.username(null).password(null)
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
  url.host {
    i: url('http://disney.com').host
    ii: url(//disney.com).host
    iii: url(//127.0.0.1/pr0n/7281.jpg).host
  }
  ~~~

  ~~~ css
  url.host {
    i: "disney.com";
    ii: "disney.com";
    iii: "127.0.0.1";
  }
  ~~~

- Sets the `//host` part of the URL

  ~~~ lay
  url.host {
    i: url('http://www.disney.com/').host('disney.org')
  }
  ~~~

  ~~~ css
  url.host {
    i: url("http://disney.org/");
  }
  ~~~

- Accepts TLD's

  ~~~ lay
  $url = url('http://localhost/phpMyAdmin')

  url.host[tld] {
    i: $url
    ii: $url.host(com)
  }
  ~~~

  ~~~ css
  url.host[tld] {
    i: url("http://localhost/phpMyAdmin");
    ii: url("http://com/phpMyAdmin");
  }
  ~~~

- Accepts IP addresses

  ~~~ lay
  $url = url('http://www.disney.com/pixar')

  url.host[ipv4] {
    i: $url.host('192.168.1.1')
  }
  ~~~

  ~~~ css
  url.host[ipv4] {
    i: url("http://192.168.1.1/pixar");
  }
  ~~~

- Accepts IPv6 addresses

  ~~~ lay
  url.host[ipv6] {
    $url = url('http://www.disney.com/pixar')
    i: $url = $url.host('2001:0db8:85a3:08d3:1319:8a2e:0370:7334')
    ii: $url = $url.port(21)
    iii: $url.host('2001:0DB8::1428:57ab')

    $url = url(http://user:password@[3ffe:2a00:100:7031::1]:8080) +
           '/articles/index.html'
    iv: $url
    v: $url.port(null)
  }
  ~~~

  ~~~ css
  url.host[ipv6] {
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

  url.host[null] {
    i: $url
    ii: $url.host('')
    iii: $url.host(null)
  }
  ~~~

  ~~~ css
  url.host[null] {
    i: url("http://www.disney.com:8080/movies/");
    ii: url("http:///movies/");
    iii: url("http:///movies/");
  }
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

- Sets the `:port` part of the URL

  ~~~ lay
  url.port {
    i: url('http://disney.com/').port(8080)
  }
  ~~~

  ~~~ css
  url.port {
    i: url("http://disney.com:8080/");
  }
  ~~~

- Accepts numeric strings

  ~~~ lay
  $url = url('http://disney.com/')
  url.port {
    i: $url.port('80.0')
  }
  ~~~

  ~~~ css
  url.port {
    i: url("http://disney.com:80/");
  }
  ~~~

- Accepts `null`

  ~~~ lay
  url.port[null] {
    $url = url('http://disney.com/')
    $url = $url.port(8080)
    i: $url
    ii: $url.port(null)
  }
  ~~~

  ~~~ css
  url.port[null] {
    i: url("http://disney.com:8080/");
    ii: url("http://disney.com/");
  }
  ~~~

- Fails for non-numeric values

  ~~~ lay
  url('http://disney.com/').port(#fff)
  ~~~

  ~~~ ValueError
  ~~~

  ~~~ lay
  url('http://disney.com/').port('')
  ~~~

  ~~~ ValueError
  ~~~

- Fails for non-integer numbers

  ~~~ lay
  url('http://disney.com/').port(2.7)
  ~~~

  ~~~ ValueError
  Cannot create URL with a non-integer port number: 2.7
  ~~~

  ~~~ lay
  url('http://disney.com/').port('2.7')
  ~~~

  ~~~ ValueError
  Cannot create URL with a non-integer port number: 2.7
  ~~~

- Fails for numbers not in the 0..65535 range

  ~~~ lay
  url('http://disney.com/').port(-1)
  ~~~

  ~~~ ValueError
  Cannot create URL with port `-1`: port number is out of 1..65535 range
  ~~~

  ~~~ lay
  url('http://disney.com/').port(0)
  ~~~

  ~~~ ValueError
  Cannot create URL with port `0`: port number is out of 1..65535 range
  ~~~

  ~~~ lay
  url('http://disney.com/').port(65536)
  ~~~

  ~~~ ValueError
  Cannot create URL with port `65536`: port number is out of 1..65535 range
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

- Sets the `path` component of the URL

  ~~~ lay
  $url = url(http://disney.org/princesses/aladdin/jasmine.html);
  url.path {
    i: $url.path('/')
    ii: $url.path('/etc/foo/bar/baz')
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

- Sets the directory part of the URL path

  ~~~ lay
  $url = url(http://disney.org/princesses/aladdin/jasmine.html)

  url.dirname {
    i: $url.dirname('/')
    ii: $url.dirname('search')
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

- Sets the last portion of the URL path

  ~~~ lay
  $url = url(http://disney.org/princesses/aladdin/jasmine.html)

  url.basename {
    i: $url.basename('index.php')
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

- Sets the extension of the URL path

  ~~~ lay
  $url = url(http://disney.org/princesses/aladdin/jasmine.html)

  url.extname {
    i: $url.extname('.aspx')
    ii: $url.extname(null)
    iii: $url.path('/x/y/z').extname('.php')
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

- Sets the last portion of the URL path, without extension

  ~~~ lay
  $url = url(http://disney.org/princesses/aladdin/jasmine.html)

  url.filename {
    i: $url.filename('index')
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
  url.query {
    i: url(http://google.com/).query
    ii: url(http://google.com/?).query.quoted
    iii: url(http://google.com/?q=google).query
    iv: url(http://google.com/?q=google#top).query.quoted
  }
  ~~~

  ~~~ css
  url.query {
    i: null;
    ii: "";
    iii: "q=google";
    iv: "q=google";
  }
  ~~~

- Sets the `?query` part of the URL

  ~~~ lay
  $url = url(http://google.com/)

  url.query {
    i: $url.query('hey=Joe')
  }
  ~~~

  ~~~ css
  url.query {
    i: url("http://google.com/?hey=Joe");
  }
  ~~~

- Is properly encoded

  ~~~ lay
  $url = url(http://google.com/)
  url.query:encoding {
    i: $url.query('hey=John Doe&q=foo bar')
    /*
    TODO I think maybe `?` should be encoded to `%3F`, but Node
    `url.format()` implementation does not.
    https://tools.ietf.org/html/rfc2396#section-3.4
    */
    ii: $url.query('?hey=yo')
    iii: $url.query('#hey=yo')
  }
  ~~~

  ~~~ css
  url.query:encoding {
    i: url("http://google.com/?hey=John%20Doe&q=foo%20bar");
    ii: url("http://google.com/??hey=yo");
    iii: url("http://google.com/?%23hey=yo");
  }
  ~~~

- Accepts `null` and empty string

  ~~~ lay
  url.query[empty] {
    $url = url(http://google.com/?q=Lebowski)

    i: $url
    ii: $url.query('')
    iii: $url.query(null)
  }
  ~~~

  ~~~ css
  url.query[empty] {
    i: url("http://google.com/?q=Lebowski");
    ii: url("http://google.com/?");
    iii: url("http://google.com/");
  }
  ~~~

### `fragment`

- Returns the `#fragment` part of the URL, if any, or `null`

  ~~~ lay
  url.fragment {
    i: url(http://disney.com#start).fragment
    ii: url('http://localhost/#').fragment
    iii: url(http://localhost/index.php).fragment
  }
  ~~~

  ~~~ css
  url.fragment {
    i: "start";
    ii: "";
    iii: null;
  }
  ~~~

- Sets the `#fragment` part of the URL

  ~~~ lay
  url.fragment {
    $url = url('http://disney.com/')
    i: $url.fragment('footer')
  }
  ~~~

  ~~~ css
  url.fragment {
    i: url("http://disney.com/#footer");
  }
  ~~~

- Is properly encoded

  ~~~ lay
  url.fragment:encoding {
    $url = url('http://disney.com/')
    i: $url.fragment('second section')
  }
  ~~~

  ~~~ css
  url.fragment:encoding {
    i: url("http://disney.com/#second%20section");
  }
  ~~~

- Accepts `null` and empty string

  ~~~ lay
  url.fragment[empty] {
    $url = url(http://google.com/#images)

    i: $url
    ii: $url.fragment('')
    iii: $url.fragment(null)
  }
  ~~~

  ~~~ css
  url.fragment[empty] {
    i: url("http://google.com/#images");
    ii: url("http://google.com/#");
    iii: url("http://google.com/");
  }
  ~~~

### `hash`

- Is an alias of `fragment`

  ~~~ lay
  url.hash {
    i: url(http://disney.com#start).hash
    ii: url('http://localhost/#').hash
    iii: url(http://localhost/index.php).hash
  }
  ~~~

  ~~~ css
  url.hash {
    i: "start";
    ii: "";
    iii: null;
  }
  ~~~

### `hash=`

- Is an alias of `fragment=`

  ~~~ lay
  url.hash {
    $url = url('http://disney.org/')

    i: $url
    ii: $url.hash('footer')
    iii: $url.hash(null)
  }
  ~~~

  ~~~ css
  url.hash {
    i: url("http://disney.org/");
    ii: url("http://disney.org/#footer");
    iii: url("http://disney.org/");
  }
  ~~~

### `absolute?`

- Returns `true` if the URL is fully qualified, ie: it has a scheme

  ~~~ lay
  url.absolute {
    i: url('http://disney.com').absolute?
    ii: url(//disney.com).absolute?
    iii: url(file:///pr0n/7281.jpg).absolute?
  }
  ~~~

  ~~~ css
  url.absolute {
    i: true;
    ii: false;
    iii: true;
  }
  ~~~

### `relative?`

- Returns `true` if the URL is not absolute

  ~~~ lay
  url.relative {
    i: url('http://disney.com').relative?
    ii: url(//disney.com).relative?
    iii: url(file:///pr0n/7281.jpg).relative?
  }
  ~~~

  ~~~ css
  url.relative {
    i: false;
    ii: true;
    iii: false;
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
  url[operator="+"] {
    i: url('/one/two/three/') + 'four.php'
    ii: url('/one/two/three') + 'four.php' + 'five.php'
    iii: url('/one/two/three') + 'four.php' + '/five.php'
    iv: url(http://example.com/two) + '/one'
    v: url(//example.com/two) + '../one'
    vi: url(//example.com/one/two/three/) + '../' + '..'
    vii: url(//example.com/one/two/three) + '../../one'
    viii: url(//example.com/two/) + '../../../one'
    ix: url(//example.com/two) + url(/one)
    x: url(//example.com/two) + url(//example.org/three)
    xi: url(http://disney.com) + url(?princess=ariel)
    xii: url(http://disney.com) + url(https://example.com/)
    xiii: url(https://disney.com) + url(//example.com/path)
    xiv: 'http://example.com/one' + url(/two)
  }
  ~~~

  ~~~ css
  url[operator="+"] {
    i: url("/one/two/three/four.php");
    ii: url("/one/two/five.php");
    iii: url("/five.php");
    iv: url("http://example.com/one");
    v: url("//example.com/one");
    vi: url("//example.com/one/");
    vii: url("//example.com/one");
    viii: url("//example.com/one");
    ix: url("//example.com/one");
    x: url("//example.org/three");
    xi: url("http://disney.com/?princess=ariel");
    xii: url("https://example.com/");
    xiii: url("https://example.com/path");
    xiv: url("http://example.com/two");
  }
  ~~~
