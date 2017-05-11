Object  = require '../object'
Boolean = require './boolean'


class Null extends Object

  @null = new @

  @new: -> @null

  toString: -> ''

  ifNull: (value) -> if value is null then Null.null else value

  isEqual: (other) -> other.isNull()

  isNull: -> yes

  isEmpty: -> yes

  toBoolean: -> no

  clone: -> @

Object::isNull = -> no

Object::['.null?'] = -> Boolean.new @isNull()


module.exports = Null
