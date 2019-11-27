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
      throw new ValueError """
        Invalid `start` argument for #{@reprMethod('slice')}: #{start.repr()}. \
        Expected a pure number
        """
      start = start.value

    if end?
      unless end instanceof Number and end.isPure()
        throw new ValueError """
          Invalid `end` argument for #{@reprMethod('slice')}: #{end.repr()}. \
          Expected a pure number
          """
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

    return super context, other

  '.::': (context, other) ->
    if other instanceof Collection
      slice = @copy []
      for idx in other.items
        slice.items.push @['.::'](context, idx)
      return slice

    return super context, other

  '.::=': (context, key, value) ->
    if key instanceof Number
      idx = key.value
      idx += @items.length if idx < 0

      if 0 <= idx <= @items.length
        return @items[idx] = value

      return Null.null

    return super context, key, value

  '.push': (context, args...) -> @push args...; @

  '.pop': -> Null.ifNull @items.pop()

  '.shift': -> Null.ifNull @items.shift()

  '.unshift': (context, objs...) ->
    @items.unshift (obj.clone() for obj in objs)...

    return @

  '.slice': (context, start, end) -> @copy @slice(start, end)

  '.empty': -> @items = []; @

  '.unique?': -> Boolean.new @isUnique()

  '.unique': ->
    unique = []

    for item in @items
      unless unique.some((other) -> other.isEqual item)
        unique.push item

    return @copy unique


module.exports = Collection
