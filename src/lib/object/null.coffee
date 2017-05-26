Object  = require '../object'
Boolean = require './boolean'


###
###
class Null extends Object

  @null = new @

  @new: -> @null

  @ifNull: (value) ->
    if not value? or (value instanceof @) then @null else value

  toString: -> ''

  isEqual: (other) -> other.isNull()

  isNull: -> yes

  isEmpty: -> yes

  toBoolean: -> no

  clone: -> @

Object::isNull = -> no

Object::['.null?'] = -> Boolean.new @isNull()


module.exports = Null
