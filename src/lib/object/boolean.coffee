Object = require '../object'


###
###
class Boolean extends Object

  constructor: (@value) ->
    super()
    @value = !!@value

  @true: new @ yes

  @false: new @ no

  @new: (value) -> value and @true or @false

  isEqual: (other) -> other instanceof Boolean and @value is other.value

  toBoolean: -> @value

  isEmpty: -> not @value

  toString: -> if @value then 'true' else 'false'

  clone: -> @


Object::toBoolean = -> yes

# TODO should throw an exception ("Cannot compare")?
Object::isEqual = (other) -> other is @

Object::['.=='] = (context, other) -> Boolean.new @isEqual other

Object::['.!='] = (context, other) -> Boolean.new not @isEqual other

Object::['.not@'] = (context, other) -> Boolean.new not @toBoolean()

Object::['.and'] = (context, other) -> if @toBoolean() then other else @

Object::['.or'] = (context, other) -> if @toBoolean() then @ else other

Object::['.>'] = (context, other) -> Boolean.new @compare(other) < 0

Object::['.>='] = (context, other) -> Boolean.new @compare(other) <= 0

Object::['.<'] = (context, other) -> Boolean.new @compare(other) > 0

Object::['.<='] = (context, other) -> Boolean.new @compare(other) >= 0

Object::['.contains?'] = (context, other) -> Boolean.new @contains(other)

Object::['.enumerable?'] = -> Boolean.new @isEnumerable()

Object::['.boolean'] = -> Boolean.new @toBoolean()

Object::['.true?'] = Object::['.boolean']

Object::['.false?'] = -> Boolean.new not @toBoolean()

Object::['.empty?'] = -> Boolean.new @isEmpty()

Object::['.important?'] = -> Boolean.new @important


module.exports = Boolean
