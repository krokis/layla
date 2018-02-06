Object       = require '../object'
Null         = require './null'
Boolean      = require './boolean'
QuotedString = require './string/quoted'
URI          = require './uri'


###
###
class DataURI extends URI

  DEFAULT_MIME    = 'text/plain'
  DEFAULT_CHARSET = 'us-ascii'

  RE_MEDIATYPE = /\s*([^;,\s]+)?\s*(?:;\s*charset\s*=\s*([^;,\s]+))?/i
  RE_BASE_64   = /\s*;\s*(base64)\s*/i
  RE_DATA_URI  = ///^
                   data:
                     (?:
                       (?:(#{RE_MEDIATYPE.source})(#{RE_BASE_64.source})?)|
                       (#{RE_BASE_64.source})
                     )?
                   ,([\s\S]*)
                 ///i

  @decode: (data) -> new Buffer(data, 'base64').toString @charset

  @parseComponents: (uri) ->
    uri = uri.trim()

    if m = RE_DATA_URI.exec uri
      components =
        scheme:  'data'
        mime:    (m[2] or DEFAULT_MIME).toLowerCase()
        charset: (m[3] or DEFAULT_CHARSET).toLowerCase()
        base64:  !!m[5]

      data = m[8]

      if components.base64
        # TODO We should pre-check this is valid BASE64 data. Otherwise, errors
        # could raise when calling `DataURI.data` (which uses `Buffer`
        # implementation)
        # https://tools.ietf.org/html/rfc4648
        components.encoded_data = data.replace /\s+/g, ''
      else
        components.decoded_data = data

      return components

  @property 'data', ->
    @components.decoded_data ?= @class.decode @components.encoded_data

  @property 'mime', -> @components.mime

  @property 'charset', -> @components.charset

  @property 'base64', -> @components.base64

  toString: ->
    str = 'data:'

    str += @mime if @mime isnt DEFAULT_MIME
    str += ";charset=#{@charset}" if @charset isnt DEFAULT_CHARSET

    if @base64
      str += ";base64"
      data = @components.encoded_data
    else
      data = @components.decoded_data

    str += ",#{data}"

    return str

  '.charset': -> new QuotedString @charset

  '.mime': -> new QuotedString @mime

  '.mediatype': -> new QuotedString "#{@mime};charset=#{@charset}"

  '.base64?': -> Boolean.new @base64

  '.data': -> new QuotedString @data


module.exports = DataURI
