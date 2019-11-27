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
    super()

  parse: (uri) ->
    m = uri.match /^[a-z][a-z\d\+\-\.]+(?=:)/i

    if m
      @scheme = m[0].toLowerCase()

  @property 'value',
    get: -> @toString()
    set: (value) -> @parse value

  clone: ->
    obj = @copy()
    obj.name = @name

    return obj

  copy: (value = @value) ->
    super value

  '.scheme': ->
    if not @scheme
      Null.null
    else
      QuotedString.new @scheme

  # TODO move these methods to the `URL` and `DataURI` classes?
  COMMON_SCHEMES.forEach (scheme) ->
    URI::[".#{scheme}?"] = -> Boolean.new @scheme is scheme

  '.string': -> QuotedString.new @toString()


module.exports = URI
