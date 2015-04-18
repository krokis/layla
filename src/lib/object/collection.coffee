Object     = require '../object'
Indexed    = require './indexed'
Number     = require './number'
Null       = require './null'

TypeError           = require '../error/type'
NotImplementedError = require '../error/not-implemented'

class Collection extends Indexed

  length: -> @items.length

  getByIndex: (index) -> @items[index]

  constructor: (@items = []) -> super

  insert: (items, before_key) ->

  push: (objs...) ->
    @items.push obj.clone() for obj in objs

  contains: (other) ->
    for value in @items
      return yes if value.isEqual other
    return no

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

  '.<<': (other) -> @push other; @

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

  '.push': (args...) -> @push args...; @

  '.pop': -> @items.pop() or Null.null

  '.shift': -> @items.shift() or Null.null

  '.unshift': (objs...) ->
    @items.unshift (obj.clone() for obj in objs)...
    this

  '.length': -> new Number @length()

  '.empty': -> @items = []; @

  '.first': -> @items[0] or Null.null

  '.last': -> @items[@items.length - 1] or Null.null

  ###
  '.reverse':       @::reverse
  '.compact':       @::compact
  '.compact':       @::compact
  '.concat':        @::concat
  '.max':           @::max
  '.greatest':      @::max
  '.min':           @::min
  '.avg':           @::min
  '.lowest':        @::min
  '.index-of':      @::indexOf
  '.last-index-of': @::lastIndexOf
  '.without':       @::without
  ###

Object::['.>>'] = (other) -> other['.<<'] this

module.exports = Collection
