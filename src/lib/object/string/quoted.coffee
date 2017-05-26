Object  = require '../../object'
String  = require '../string'
Boolean = require '../boolean'


###
###
class QuotedString extends String

  @ESCAPE_CHARS = /[\n\r\t\\]/

  reprValue: -> '"' + super() + '"'

  '.quoted?': -> Boolean.TRUE

  '.unquoted?': -> Boolean.FALSE

String::['.quoted?'] = -> Boolean.FALSE

String::['.unquoted?'] = -> Boolean.TRUE

Object::['.quote'] = -> new QuotedString @toString()

Object::['.quoted'] = Object::['.quote']

Object::['.string'] = Object::['.quoted']


module.exports = QuotedString
