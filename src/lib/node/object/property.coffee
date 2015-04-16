Object = require '../object'
Null   = require './null'
String = require './string'
List   = require './list'

class Property extends Object

  name: null
  value: null

  constructor: (@name, @value = Null.null) ->

  isEmpty: ->
    @value.isNull()

  isEqual: (other) ->
    (other instanceof Property) and
    (other.name is @name) and
    (other.value.isEqual @value)

  toJSON: ->
    json = super
    json.name = @name
    json.value = @value
    json

  clone: (name = @name, value = @value) ->
    super name, value.clone()

  reprValue: -> "#{@name}: #{@value.repr()}"

  '.name': -> new String @name

  '.value': -> @value

module.exports = Property
