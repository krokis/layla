Collection = require './collection'
Object     = require '../object'
Boolean    = require './boolean'
String     = require './string'
Number     = require './number'


class List extends Collection

  constructor: (items, @separator = ' ') -> super items

  flattenItems: ->
    flat = []

    for item in @items
      if item instanceof List
        flat.push item.flattenItems()...
      else
        flat.push item

    return flat

  join: (glue = '') -> (@items.map (item) -> item.toString()).join glue

  clone: (items, separator = @separator, etc...) ->
    super items, separator, etc...

  toJSON: ->
    json = super
    json.separator = @separator
    json

  '.commas': -> @clone null, ','

  '.spaces': -> @clone null, ' '

  '.list': -> @clone()

  '.flatten': -> @clone @flattenItems()

  '.join': (context, glue = QuotedString.EMPTY) -> glue.clone @join glue.value

Object::['.list'] = ->
  if @ instanceof Collection
    new List @items
  else
    new List [@]


module.exports = List
