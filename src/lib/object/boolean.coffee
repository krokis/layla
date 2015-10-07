Object = require '../object'

class Boolean extends Object

  constructor: (@value = no) ->
    @value = !!@value

  @true: new @ yes

  @false: new @ no

  @new: (value = no) -> value and @true or @false

  isEqual: (other) -> other instanceof Boolean and @value is other.value

  toBoolean: -> @value

  isEmpty: -> not @value

  toString: -> if @value then 'true' else 'false'

  toJSON: ->
    json = super
    json.value = @value
    json

  clone: -> @

Object::toBoolean = -> yes

Object::['.is'] = (other) -> Boolean.new @isEqual other

Object::['.isnt'] = (other) -> Boolean.new not @isEqual other

Object::['.not@'] = (other) -> Boolean.new not @toBoolean()

Object::['.and'] = (other) -> if @toBoolean() then other else this

Object::['.or'] = (other) -> if @toBoolean() then this else other

Object::['.>'] = (other) -> Boolean.new ((@compare other) < 0)

Object::['.>='] = (other) -> Boolean.new ((@compare other) <= 0)

Object::['.<'] = (other) -> Boolean.new ((@compare other) > 0)

Object::['.<='] = (other) -> Boolean.new ((@compare other) >= 0)

Object::['.contains?'] = (other) -> Boolean.new @contains other

Object::['.has'] = (other) -> Boolean.new @contains other

Object::['.hasnt'] = (other) -> Boolean.new not @contains other

Object::['.in'] = (other) -> Boolean.new other.contains @

Object::['.enumerable?'] = -> Boolean.new @isEnumerable()

Object::['.boolean'] = -> Boolean.new @toBoolean()

Object::['.true?'] = Object::['.boolean']

Object::['.false?'] = -> Boolean.new not @toBoolean()

Object::['.empty?'] = -> Boolean.new @isEmpty()

module.exports = Boolean
