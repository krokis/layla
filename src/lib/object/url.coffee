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

  @URL_COMPONENTS = [
    'scheme'
    'auth'
    'host'
    'port'
    'path'
    'query'
    'fragment'
  ]

  @PATH_COMPONENTS = [
    'dirname'
    'basename'
    'extname'
    'filename'
  ]

  @AUTH_COMPONENTS = [
    'username'
    'password'
  ]

  @ALIAS_COMPONENTS =
    hash: 'fragment'
    protocol: 'scheme'

  @parseComponents: (url) ->
    url = url.trim()

    # TODO catch parsing errors
    parsed_url = ParseURL.parse url, no, yes

    return {
      scheme:   parsed_url.protocol and parsed_url.protocol[...-1]
      auth:     parsed_url.auth
      host:     parsed_url.hostname
      port:     parsed_url.port
      path:     parsed_url.pathname
      query:    parsed_url.query
      fragment: parsed_url.hash and parsed_url.hash[1..]
      slashes:  parsed_url.slashes
    }

  @URL_COMPONENTS.forEach (component) ->
    URL.property component, -> @components[component]

  @property 'username', ->
    if @auth? then @auth.split(':')[0] else null

  @property 'password', ->
    if @auth? then @auth.split(':')[1] else null

  @property 'domain', ->
    if @isIP() then null else @host

  @property 'dirname', ->
    if @path then Path.dirname(@path) else null

  @property 'basename', ->
    if @path then Path.basename(@path) else null

  @property 'extname', ->
    if @path then Path.extname(@path) else null

  @property 'filename', ->
    if @path then Path.basename(@path, @extname) else null

  constructor: (components) ->
    components = {components...}

    if components.port?
      port = parseFloat components.port

      if isNaN port
        throw new ValueError """
          Cannot create URL with a non-numeric port: #{components.port}
          """

      if port % 1 # If not integer
        throw new ValueError """
          Cannot create URL with a non-integer port number: #{port}
          """

      unless 1 <= port <= 65535
        throw new ValueError """
          Cannot create URL with port `#{port}`: \
          port number is out of 1..65535 range
          """

      components.port = port.toString()

    if components.fragment?
      components.fragment = ParseURL.format components.fragment

    if components.query?
      components.query = ParseURL.format components.query

    if components.host?
      components.host = components.host.toLowerCase()

    super components

  isIP: ->
    Net.isIP @host

  makePath: (components = {}) ->
    components = {
      dirname: @dirname,
      filename: @filename,
      extname: @extname,
      components...
    }

    components.dirname  or= ''
    components.filename or= ''
    components.extname  or= ''
    components.basename ?=  components.filename + components.extname
    components.basename or= ''

    return Path.join '/', components.dirname, components.basename

  makeAuth: (components = {}) ->
    components = {
      username: @username,
      password: @password
      components...
    }

    if components.username?
      if components.password?
        "#{components.username}:#{components.password}"
      else
        components.username
    else if components.password?
      ":#{components.password}"
    else
      null

  ###
  Resolves another URL or string with this as the base
  ###
  '.+': (context, other) ->
    if other instanceof URL or other instanceof String
      @class.parse ParseURL.resolve(@value, other.value)
    else
      super context, other

  ###
  Batch define all accessors (`scheme`, `path`, `query`, etc)
  ###
  @URL_COMPONENTS.forEach (component) ->
    URL::[".#{component}"] = (context, value) ->
      if value is undefined
        value = @components[component]

        if value?
          return new QuotedString value
        else
          return Null.null

      value = if value.isNull() then null else value.toString()

      return @copy [component]: value

  @PATH_COMPONENTS.forEach (component) ->
    URL::[".#{component}"] = (context, value) ->
      if value is undefined
        value = @[component]

        if value?
          return new QuotedString value
        else
          return Null.null

      if value.isNull()
        value = null
      else
        try
          value = value.toString()
        catch e
          throw e # TODO!

      path = @makePath [component]: value

      return @copy path: path

  @AUTH_COMPONENTS.forEach (component) ->
    URL::[".#{component}"] = (context, value) ->
      if value is undefined
        value = @[component]

        if value?
          return new QuotedString value
        else
          return Null.null

      if value.isNull()
        value = null
      else
        try
          value = value.toString()
        catch e
          throw e # TODO!

      auth = @makeAuth [component]: value

      return @copy auth: auth

  for alias of @ALIAS_COMPONENTS
    URL::[".#{alias}"] = URL::[".#{@ALIAS_COMPONENTS[alias]}"]

  ###
  Returns `true` if the URL is a fully qualified URL, ie: it has a scheme
  ###
  '.absolute?': ->
    Boolean.new @scheme isnt null

  ###
  Returns `true` if the URL is a relative URL, ie: it has no scheme
  ###
  '.relative?': ->
    Boolean.new @scheme is null

  ###
  Returns `true` if the host is a v4 IP
  ###
  '.ipv4?': ->
    Boolean.new Net.isIPv4 @host

  ###
  Returns `true` if the host is a v6 IP
  ###
  '.ipv6?': ->
    Boolean.new Net.isIPv6 @host

  ###
  Returns `true` if the host is an IP (v4 or v6)
  ###
  '.ip?': ->
    Boolean.new @isIP()

  ###
  Returns `true` if the URL has a host and it's not an IP address.
  ###
  '.domain': ->
    if domain = @domain
      new QuotedString domain
    else
      Null.NULL

  ###
  Returns a copy of the URL with the scheme set to `http`
  ###
  '.http': ->
    @copy scheme: 'http'

  ###
  Returns a copy of the URL with the scheme set to `https`
  ###
  '.https': ->
    @copy scheme: 'https'

  toString: ->
    ParseURL.format {
      protocol: (@scheme and "#{@scheme }:") or null
      auth:     @auth
      host:     null
      hostname: @host
      port:     @port
      pathname: @path
      path:     @path
      search:   (@query? and "?#{@query}") or null
      hash:     (@fragment? and "##{@fragment}") or null
      slashes:  !!(@host or @scheme?)
    }

do ->
  supah = String::['.+']

  String::['.+'] = (context, other, etc...) ->
    if other instanceof URL
      other.class.parse ParseURL.resolve @value, other.value
    else
      supah.call @, context, other, etc...


module.exports = URL
