Indexed    = require './indexed'
Boolean    = require './boolean'
Number     = require './number'
Null       = require './null'
ValueError = require '../error/value'


###
###
class Collection extends Indexed

  constructor: (@items = []) ->
    super()

  length: -> @items.length

  getByIndex: (index) -> @items[index]

  push: (objs...) ->
    @items.push obj.clone() for obj in objs

  slice: (start, end) ->
    unless start?
      start = 0
    else unless start instanceof Number and start.isPure()
      throw new Error "Bad arguments for `.slice`"
      start = start.value

    if end?
      unless end instanceof Number and end.isPure()
        throw new Error "Bad arguments for `.slice`"
      end = end.value
    else
      end = @items.length

    @items.slice start, end

  contains: (other) ->
    @items.some other.isEqual.bind other

  isUnique: ->
    for a in @items
      for b in @items
        if a isnt b and a.isEqual b
          return no

    return yes

  isEqual: (other) ->
    if other instanceof Collection
      if other.items.length is @items.length
        for i in [0...@items.length]
          return no unless @items[i].isEqual other.items[i]

        return yes

    return no

  copy: (items = @items, etc...) ->
    super (obj.clone() for obj in items), etc...

  '.+': (context, other) ->
    if other instanceof Collection
      return @copy @items.concat(other.items)

    throw new ValueError "Cannot sum collection with that"

  '.::': (context, other) ->
    if other instanceof Number
      idx = other.value
      idx += @items.length if idx < 0

      if 0 <= idx < @items.length
        return @items[idx]
      else
        return Null.NULL
    else if other instanceof Collection
      slice = @copy []
      for idx in other.items
        slice.items.push @['.::'](context, idx)
      return slice

    throw new ValueError "Bad member: #{other.type}"

  '.::=': (context, key, value) ->
    if key instanceof Number
      idx = key.value
      idx += @items.length if idx < 0
      if 0 <= idx <= @items.length
        return @items[idx] = value

    throw new ValueError

  '.length': -> new Number @length()

  '.push': (context, args...) -> @push args...; @

  '.pop': -> @items.pop() or Null.NULL

  '.shift': -> @items.shift() or Null.NULL

  '.unshift': (context, objs...) ->
    @items.unshift (obj.clone() for obj in objs)...
    this

  '.slice': (context, start, end) -> @copy @slice(start, end)

  '.empty': -> @items = []; @

  '.first': -> @items[0] or Null.NULL

  '.last': -> @items[@items.length - 1] or Null.NULL

  '.unique?': -> Boolean.new @isUnique()

  '.unique': ->
    unique = []

    @items.filter (item) ->
      for val in unique
        if val.isEqual item
          return no

      unique.push item
      return yes


    return @copy unique


module.exports = Collection
