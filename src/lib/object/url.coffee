# 3rd party
parseURL    = require 'url'

Object      = require '../object'
Boolean     = require './boolean'
Null        = require './null'
String      = require './string'
Number      = require './number'

Error     = require '../error'
TypeError = require '../error/type'

class URL extends Object

  @property 'value',
    get: -> @toString()
    set: (value) ->
      value = value.trim()

      if '//' is value.substr 0, 2
        value = 'fake:' + value
        fake_scheme = yes
      else
        fake_scheme = no

      try
        parsed  = parseURL.parse value
      catch e
        throw e # TODO

      @scheme = if not fake_scheme and parsed.protocol?
                  parsed.protocol.substr 0, parsed.protocol.length - 1
                else
                  null

      @host     = parsed.hostname
      @port     = parsed.port
      @path     = parsed.pathname
      @query    = parsed.query
      @fragment = if parsed.hash? then parsed.hash.substr 1 else null

  constructor: (@value = '', @quote = null) ->

  clone: (value = @value, quote = @quote) ->
    super value, quote

  toJSON: ->
    json = super
    json.value = @value
    json.quote = @quote
    json

  ###
  Resolves another URL or string with this as the base
  ###
  '.+': (other) ->
    if other instanceof URL or other instanceof String
      @clone (parseURL.resolve @value, other.value)
    else
      super

  '.scheme': -> if @scheme then new String @scheme, @quote

  '.scheme=': (sch) ->
    if sch instanceof Null
      @scheme = null
    else if sch instanceof String
      @scheme = sch.value
    else
      throw new Error "Bad URL scheme"

  '.protocol': @::['.scheme']

  '.protocol=': @::['.scheme=']

  '.absolute?': -> Boolean.new @scheme?

  '.relative?': -> Boolean.new not @scheme?

  '.http?': -> Boolean.new @scheme is 'http'

  '.http': ->
    http = @clone()
    http.scheme = 'http'
    http

  '.https?': -> Boolean.new @scheme is 'https'

  '.https': ->
    http = @clone()
    http.scheme = 'https'
    http

  '.host': -> if @host? then new String @host, @quote

  '.host=': (host) ->
    if host instanceof Null
      @host = null
    else if host instanceof String
      @host = host.value
    else
      throw new Error "Bad URL host"

  '.domain': -> #TODO

  '.port': -> if @port? then new String @port, @quote

  '.port=': (port) ->
    if port instanceof Null
      @port = null
    else if (port instanceof String) or (port instanceof Number)
      @port = "#{port.value}"
    else
      throw new Error "Bad URL port"

  '.path': -> if @path? then new String @path, @quote

  '.query': -> if @query? then new String @query, @quote

  '.query=': (query) ->
    if query instanceof Null
      @query = null
    else if query instanceof String
      @query = query.value.trim()
      @query = @query.substr 1 if '?' is @query.charAt 0
    else
      throw new Error "Bad URL query"

  '.fragment': -> if @fragment? then new String @fragment, @quote

  '.fragment=': (frag) ->
    if frag instanceof Null
      @fragment = null
    else if frag instanceof String
      @fragment = frag.value.trim()
      @fragment = @fragment.substr 1 if '#' is @fragment.charAt 0
    else
      throw new Error "Bad URL fragment"

  '.hash': @::['.fragment']
  '.hash=': @::['.fragment=']

  toString: ->
    str = ''

    str = "##{@fragment}#{str}" if @fragment?
    str = "?#{@query}#{str}" if @query?
    str = "#{@path}#{str}" if @path?

    if @host
      str = ":#{@port}#{str}" if @port?
      str = "//#{@host}#{str}"
      str = "#{@scheme}:#{str}" if @scheme?

    str

  '.string': -> new String @toString(), @quote

module.exports = URL
