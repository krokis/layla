Object       = require '../object'
Null         = require './null'
QuotedString = require './string/quoted'


###
###
class Property extends Object

  constructor: (@name, @value = Null.NULL) ->
    super()

  @property 'important', ->
    @value.important

  isEmpty: -> @value.isNull()

  isEqual: (other) ->
    (other instanceof Property) and
    (other.name is @name) and
    (other.value.isEqual @value)

  copy: (name = @name, value = @value, etc...) ->
    super name, value.clone(), etc...

  clone: -> @

  reprValue: -> "#{@name}: #{@value.repr()}"

  '.name': -> new QuotedString @name

  '.value': -> @value


module.exports = Property
