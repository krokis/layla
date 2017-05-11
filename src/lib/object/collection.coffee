Indexed   = require './indexed'
Boolean   = require './boolean'
Number    = require './number'
Null      = require './null'
TypeError = require '../error/type'


class Collection extends Indexed

  constructor: (@items = []) -> super

  length: -> @items.length

  getByIndex: (index) -> @items[index]

  push: (objs...) ->
    @items.push obj.clone() for obj in objs

  slice: (start, end) ->
    unless start?
      start = 0
    else unless start instanceof Number
      throw new Error "Bad arguments for `.slice`"
      start = start.value

    if end?
      unless end instanceof Number
        throw new Error "Bad arguments for `.slice`"
      end = end.value
    else
      end = @items.length

    @items.slice start, end

  contains: (other) ->
    for value in @items
      return yes if value.isEqual other
    return no

  isUnique: ->
    for a in @items
      for b in @items
        if a isnt b and a.isEqual b
          return no
    yes

  isEqual: (other) ->
    if other instanceof Collection
      if other.items.length is @items.length
        for i in [0...@items.length]
          return no unless @items[i].isEqual other.items[i]
        return yes
    return no

  toJSON: ->
    json = super
    json.separator = @separator
    json.items = @items
    json

  clone: (items = @items, etc...) ->
    super (obj.clone() for obj in items), etc...

  '.+': (other) ->
    if other instanceof Collection
      return @clone @items.concat other.items
    throw new TypeError "Cannot sum collection with that"

  '.::': (other) ->
    if other instanceof Number
      idx = other.value
      idx += @items.length if idx < 0
      if 0 <= idx < @items.length
        @items[idx]
      else
        Null.null
    else if other instanceof Collection
      slice = @clone []
      for idx in other.items
        slice.items.push @['.::'] idx
      slice
    else
      throw new TypeError "Bad member: #{other.type}"

  '.::=': (key, value) ->
    if key instanceof Number
      idx = key.value
      idx += @items.length if idx < 0
      if 0 <= idx <= @items.length
        @items[idx] = value
      else
        throw new TypeError
    else
      throw new TypeError

  '.length': -> new Number @length()

  '.push': (args...) -> @push args...; @

  '.pop': -> @items.pop() or Null.null

  '.shift': -> @items.shift() or Null.null

  '.unshift': (objs...) ->
    @items.unshift (obj.clone() for obj in objs)...
    this

  '.slice': (start, end) -> @clone (@slice start, end)

  '.empty': -> @items = []; @

  '.first': -> @items[0] or Null.null

  '.last': -> @items[@items.length - 1] or Null.null

  '.unique?': -> Boolean.new @isUnique()

  '.unique': ->
    unique = []

    @items.filter (item) ->
      for val in unique
        if val.isEqual item
          return no

      unique.push item
      return yes

    @clone unique, @separator


module.exports = Collection
