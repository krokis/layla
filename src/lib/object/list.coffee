Collection = require './collection'
Object     = require '../object'
Boolean    = require './boolean'
String     = require './string'
Number     = require './number'


###
###
class List extends Collection

  constructor: (items, @separator = ' ') ->
    super items

  flattenItems: ->
    flat = []

    for item in @items
      if item instanceof List
        flat.push item.flattenItems()...
      else
        flat.push item

    return flat

  join: (glue = '') -> (@items.map (item) -> item.toString()).join glue

  copy: (items, separator = @separator, etc...) ->
    super items, separator, etc...

  '.commas': -> @copy undefined, ','

  '.spaces': -> @copy undefined, ' '

  '.list': -> @clone()

  '.flatten': -> @copy @flattenItems()

  '.join': (context, glue = QuotedString.EMPTY) ->
    glue.copy @join(glue.value)


Object::['.list'] = ->
  if @ instanceof Collection
    List.new @items
  else
    List.new [@]


module.exports = List
