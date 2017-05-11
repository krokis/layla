Object = require '../../object'
String = require '../string'

class UnquotedString extends String

  # TODO sure `\uFFFF` is the highest code point? JS will accep `\uFFFFF`
  # http://stackoverflow.com/questions/2124010/grep-regex-to-match-non-ascii-characters
  RE_ESCAPE_CHARS = /[^a-zA-Z_\x80-\uFFFF]/

  @escape: (value) ->
    value = @escapeWhitespace value
    value = @escapeRegex value, RE_ESCAPE_CHARS

    return value

Object::['.unquote'] = -> new UnquotedString @toString()

Object::['.unquoted'] = Object::['.unquote']

module.exports = UnquotedString
