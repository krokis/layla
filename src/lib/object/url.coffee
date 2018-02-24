ParseURL     = require 'url'
Net          = require 'net'
Path         = require 'path'

URI          = require './uri'
Null         = require './null'
Boolean      = require './boolean'
String       = require './string'
QuotedString = require './string/quoted'
Number       = require './number'
Error        = require '../error'
ValueError   = require '../error/value'


###
###
class URL extends URI
  name: 'url'

  @COMPONENTS = [
    'scheme'
    'username'
    'password'
    'host'
    'port'
    'path'
    'query'
    'fragment'
  ]

  @ALIAS_COMPONENTS =
    protocol: 'scheme'
    hash: 'fragment'

  parse: (uri) ->
    uri = uri.trim()
    # TODO catch parsing errors
    @components = ParseURL.parse uri, no, yes
    @components.host = null

  @property 'scheme',
    get: ->
      @components.protocol and
      @components.protocol[0...@components.protocol.length - 1]

    set:(value) ->
      if value
        value = "#{value}:"
      @components.protocol = value

  @property 'auth',
    get: -> @components.auth
    set: (value) -> @components.auth = value

  makeAuth: (user, pass) ->
    @auth =
      if user?
        if pass?
          "#{user}:#{pass}"
        else
          user
      else if pass?
        ":#{pass}"
      else
        null

  @property 'username',
    get: ->
      if @auth?
        user = (@auth.split ':')[0]
      user ?= null
      user
    set: (value) ->
      @makeAuth value, @password

  @property 'password',
    get: ->
      if @auth
        pass = (@auth.split ':')[1]
      pass ?= null
    set: (value) ->
      @makeAuth @username, value

  @property 'host',
    get: ->
      if @components.hostname is null then null else @components.hostname
    set: (value) ->
      @components.hostname = value

  @property 'domain', ->
    if @isIP()
      return null
    else
      return @host

  @property 'port',
    get: -> @components.port
    set: (value) -> @components.port = value

  @property 'path',
    get: -> @components.pathname
    set: (value) -> @components.pathname = value

  @property 'query',
    get: ->  @components.search and @components.search[1..]
    set: (value) ->
      if value?
        value = "?#{value}"
      @components.search = value

  @property 'fragment',
    get: -> @components.hash and @components.hash[1..]
    set: (value) ->
      if value isnt null
        value = "##{value}"
      @components.hash = value

  @property 'dirname',
    get: ->
      if @path then Path.dirname @path else null
    set: (value) ->
      value = if value? then value else ''
      @path = Path.join '/', value, @basename

  @property 'basename',
    get: ->
      if @path then Path.basename @path else null
    set: (value) ->
      value = if value? then value else ''
      @path = Path.join '/', @dirname, value

  @property 'extname',
    get: ->
      if @path then Path.extname @path else null
    set: (value) ->
      value = if value? then value else ''
      basename = @filename + value
      @path = Path.join '/', @dirname, basename

  @property 'filename',
    get: ->
      if @path
        Path.basename @path, @extname

    set: (value) ->
      value = if value? then value else ''
      @path = Path.join '/', @dirname, "#{value}#{@extname}"

  isIP: -> Net.isIP @host

  ###
  Resolves another URL or string with this as the base
  ###
  '.+': (context, other) ->
    if other instanceof URL or other instanceof String
      @copy (ParseURL.resolve @value, other.value)
    else
      super context, other

  ###
  ###
  '.port': ->
    if @port? then new Number @port else Null.null

  ###
  Sets the `port` component
  ###
  '.port=': (context, port) ->
    unless port.isNull()
      if not (port instanceof Number)
        try
          port = port.toNumber()
        catch
          throw new ValueError (
            "Cannot set URL port to non-numeric value: #{port.repr()}"
          )

      unless port.isPure()
        throw new ValueError (
          "Cannot set URL port to non-pure number: #{port.reprValue()}"
        )

      unless port.isInteger()
        throw new ValueError (
          "Cannot set URL port to non-integer number: #{port.reprValue()}"
        )

      unless 0 <= port.value <= 65535
        throw new ValueError (
          "Port number out of 1..65535 range: #{port.reprValue()}"
        )

    @port = port.value

  ###
  Batch defines all other getters and setters (`scheme`, `path`, `query`, etc)
  ###
  @COMPONENTS.forEach (component) ->
    URL::[".#{component}"] ?= ->
      value = @[component]

      if value is null
        Null.null
      else
        new QuotedString value.toString()

    URL::[".#{component}="] ?= (context, value) ->
      value = if value.isNull() then null else value.toString()
      @[component] = value

  for alias of @ALIAS_COMPONENTS
    URL::[".#{alias}"] ?= URL::[".#{@ALIAS_COMPONENTS[alias]}"]
    URL::[".#{alias}?"] ?= URL::[".#{@ALIAS_COMPONENTS[alias]}?"]
    URL::[".#{alias}="] ?= URL::[".#{@ALIAS_COMPONENTS[alias]}="]

  ###
  Returns `true` if the URL is a fully qualified URL, ie: it has a scheme
  ###
  '.absolute?': -> Boolean.new @scheme

  ###
  Returns `true` if the URL is a relative URL, ie: it has no scheme
  ###
  '.relative?': -> Boolean.new not @scheme

  ###
  Returns `true` if the host is a v4 IP
  ###
  '.ipv4?': -> Boolean.new Net.isIPv4 @host

  ###
  Returns `true` if the host is a v6 IP
  ###
  '.ipv6?': -> Boolean.new Net.isIPv6 @host

  ###
  Returns `true` if the host is an IP (v4 or v6)
  ###
  '.ip?': -> Boolean.new @isIP()

  ###
  Returns `true` if the URL has a host and it's not an IP address.
  ###
  '.domain': ->
    if domain = @domain
      new QuotedString domain
    else
      Null.null

  ###
  Returns a copy of the URL with the scheme set to `http`
  ###
  '.http': -> @clone().set scheme: 'http'

  ###
  Returns a copy of the URL with the scheme set to `https`
  ###
  '.https': -> @clone().set scheme: 'https'

  ['dir', 'base', 'ext', 'file'].forEach (comp) ->
    name = "#{comp}name"

    URL::[".#{name}"] = ->
      value = @[name]

      if value?
        new QuotedString value

    URL::[".#{name}="] = (context, value) ->
      if not value.isNull()
        value = value.toString()
      else
        value = null

      @[name] = value

  toString: -> ParseURL.format @components

do ->
  supah = String::['.+']

  String::['.+'] = (context, other, etc...) ->
    if other instanceof URL
      other.copy ParseURL.resolve @value, other.value
    else
      supah.call @, context, other, etc...


module.exports = URL
