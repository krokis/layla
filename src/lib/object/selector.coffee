Object         = require '../object'
UnquotedString = require '../object/string/unquoted'

###
###
class Selector extends Object

  @escape: (value, charset) -> UnquotedString.escape value, charset

  escape: (value, charset) -> UnquotedString.escape value, charset


module.exports = Selector
