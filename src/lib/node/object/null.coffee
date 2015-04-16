Object  = require '../object'
Boolean = require './boolean'

class Null extends Object

  @null = new @

  @new: -> @null

  toString: -> ''

  isEqual: (other) -> other instanceof Null

  isNull: -> yes

  isEmpty: -> yes

  toBoolean: -> no

  clone: -> @

Object::isNull = -> no

Object::['.null?'] = -> Boolean.new @isNull()

module.exports = Null
