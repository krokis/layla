Collection = require './collection'
Object     = require '../object'
Boolean    = require './boolean'
String     = require './string'
Number     = require './number'

class List extends Collection

  constructor: (items, @separator = ' ') -> super items

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

  isUnique: ->
    for a in @items
      for b in @items
        if a isnt b and a.isEqual b
          return no
    yes

  unique = (arr) ->
    vals = []

    arr.filter (item) ->
      for val in vals
        if val.isEqual item
          return no
      vals.push item
      return yes

  clone: (items, separator = @separator, etc...) ->
    super items, separator, etc...

  toJSON: ->
    json = super
    json.separator = @separator
    json

  '.unique?': -> Boolean.new @isUnique()

  '.unique': -> @clone (unique @items), @separator

  '.commas': -> @clone null, ','

  '.spaces': -> @clone null, ' '

  '.slice': (start, end) -> @clone (@slice start, end)

Object::['.list'] = ->
  if @ instanceof Collection
    if @ instanceof List
      @
    else
      new List @items
  else
    new List [@]

String::['.characters'] = ->
  new List (@value.split '').map (char) => @clone char

String::['.words'] = ->
  new List ((@value.match /\w+/g) or []).map (word) => @clone word

String::['.lines'] = ->
  new List ((@value.match /[^\s](.+)[^\s]/g) or []).map (word) => @clone word

module.exports = List
