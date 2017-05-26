Object = require '../../object'
String = require '../string'


###
###
class UnquotedString extends String

  @ESCAPE_CHARS = /[^a-zA-Z\d_\-\x80-\uFFFF]/

Object::['.unquote'] = -> new UnquotedString @toString()

Object::['.unquoted'] = Object::['.unquote']


module.exports = UnquotedString
