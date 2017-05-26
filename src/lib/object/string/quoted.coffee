Object  = require '../../object'
String  = require '../string'
Boolean = require '../boolean'


###
###
class QuotedString extends String

  @ESCAPE_CHARS = /[\n\r\t\\]/

  reprValue: -> '"' + super() + '"'

  '.quoted?': -> Boolean.true

  '.unquoted?': -> Boolean.false

String::['.quoted?'] = -> Boolean.false

String::['.unquoted?'] = -> Boolean.true

Object::['.quote'] = -> new QuotedString @toString()

Object::['.quoted'] = Object::['.quote']

Object::['.string'] = Object::['.quoted']


module.exports = QuotedString
