Collection = require './collection'
Object     = require '../object'
Boolean    = require './boolean'
String     = require './string'
Number     = require './number'

class List extends Collection

  constructor: (items, @separator = ' ') -> super items

  flatten: ->
    flat = []
    for item in @items
      if item instanceof List
        flat.push item.flatten()...
      else
        flat.push item

    flat

  clone: (items, separator = @separator, etc...) ->
    super items, separator, etc...

  toJSON: ->
    json = super
    json.separator = @separator
    json

  '.commas': -> @clone null, ','

  '.spaces': -> @clone null, ' '

  '.list': -> @

  '.flatten': -> @clone @flatten()

Object::['.list'] = ->
  if @ instanceof Collection
    new List @items
  else
    new List [@]

module.exports = List
