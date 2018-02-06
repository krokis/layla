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

  constructor: (components = {}) ->
    super()
    @components = {scheme: null, components...}

  @parseComponents: (uri) ->
    # scheme = alpha *( alpha | digit | "+" | "-" | "." )
    match = uri.match /^[a-z][a-z\d\+\-\.]+(?=:)/i

    if not match
      throw new Error "Could not parse URI"

    return {
      scheme: match[0].toLowerCase()
    }

  @parse: (uri) -> new @ @parseComponents(uri)

  @property 'scheme', -> @components.scheme

  @property 'protocol', -> @components.scheme

  @property 'value', -> @toString()

  clone: -> @

  copy: (components = {}) ->
    super {@components..., components...}

  '.scheme': ->
    if not @components.scheme
      Null.NULL
    else
      new QuotedString @components.scheme

  '.protocol': -> @['.scheme']()

  # TODO move these methods to the `URL` and `DataURI` classes?
  COMMON_SCHEMES.forEach (scheme) ->
    URI::[".#{scheme}?"] = -> Boolean.new @components.scheme is scheme

  '.string': -> new QuotedString @toString()


module.exports = URI
