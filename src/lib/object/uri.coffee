Object       = require '../object'
Null         = require './null'
Boolean      = require './boolean'
QuotedString = require './string/quoted'

class URI extends Object

  name = 'url'

  COMMON_SCHEMES = ['http', 'https', 'data']

  constructor: (@value = '', @quote = null) ->

  parse: (uri) ->
    # scheme = alpha *( alpha | digit | "+" | "-" | "." )
    m = uri.match /^[a-z][a-z\d\+\-\.]+(?=:)/i

    if m
      @scheme = m[0]

  @property 'value',
    get: -> @toString()
    set: (value) -> @parse value

  clone: (value = @value, quote = @quote) ->
    obj = super value, quote
    obj.name = @name

    return obj

  toJSON: ->
    json = super
    json.value = @value
    json.quote = @quote

    return json

  '.scheme': ->
    if not @scheme
      Null.null
    else
      new QuotedString @scheme, @quote or '"'

  COMMON_SCHEMES.forEach (scheme) =>
    @::[".#{scheme}?"] = -> Boolean.new @scheme is scheme

  '.string': -> new QuotedString @toString(), @quote or '"'

module.exports = URI
