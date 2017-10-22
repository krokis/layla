Object = require '../object'


###
###
class Boolean extends Object

  constructor: (@value) ->
    super()
    @value = !!@value

  @TRUE: new @ yes

  @FALSE: new @ no

  @new: (value) -> value and @TRUE or @FALSE

  isEqual: (other, context) ->
    other instanceof Boolean and @value is other.value

  toBoolean: -> @value

  isEmpty: -> not @value

  toString: -> if @value then 'true' else 'false'

  clone: -> @


Object::toBoolean = -> yes

# TODO should throw an exception ("Cannot compare")?
Object::isEqual = (other, context) -> other is @

Object::['.=='] = (context, other) ->
  Boolean.new @isEqual other, context

Object::['.!='] = (context, other) ->
  Boolean.new not @isEqual other, context

Object::['.not@'] = (context, other) ->
  Boolean.new not @toBoolean()

Object::['.and'] = (context, other) ->
  if @toBoolean() then other else @

Object::['.or'] = (context, other) ->
  if @toBoolean() then @ else other

Object::['.>'] = (context, other) ->
  Boolean.new @compare(other, context) < 0

Object::['.>='] = (context, other) ->
  Boolean.new @compare(other, context) <= 0

Object::['.<'] = (context, other) ->
  Boolean.new @compare(other, context) > 0

Object::['.<='] = (context, other) ->
  Boolean.new @compare(other, context) >= 0

Object::['.contains?'] = (context, other) ->
  Boolean.new @contains(other, context)

Object::['.enumerable?'] = ->
  Boolean.new @isEnumerable()

Object::['.boolean'] = ->
  Boolean.new @toBoolean()

Object::['.true?'] = Object::['.boolean']

Object::['.false?'] = ->
  Boolean.new not @toBoolean()

Object::['.empty?'] = ->
  Boolean.new @isEmpty()

Object::['.important?'] = ->
  Boolean.new @important


module.exports = Boolean
