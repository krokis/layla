Object       = require '../object'
Null         = require './null'
Boolean      = require './boolean'
QuotedString = require './string/quoted'


###
###
class URI extends Object

  name = 'url'

  # TODO add more? (`ftp`, `file`...)
  COMMON_SCHEMES = ['http', 'https', 'data']

  constructor: (@value) ->

  parse: (uri) ->
    # scheme = alpha *( alpha | digit | "+" | "-" | "." )
    m = uri.match /^[a-z][a-z\d\+\-\.]+(?=:)/i

    if m
      @scheme = m[0].toLowerCase()

  @property 'value',
    get: -> @toString()
    set: (value) -> @parse value

  clone: (value = @value, etc...) ->
    obj = super value, etc...
    obj.name = @name

    return obj

  toJSON: ->
    json = super
    json.value = @value

    return json

  '.scheme': ->
    if not @scheme
      Null.null
    else
      new QuotedString @scheme

  # TODO move these methods to the `URL` and `DataURI` classes?
  COMMON_SCHEMES.forEach (scheme) =>
    @::[".#{scheme}?"] = -> Boolean.new @scheme is scheme

  '.string': -> new QuotedString @toString()


module.exports = URI
