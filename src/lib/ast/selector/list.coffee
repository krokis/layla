Selector = require '../selector'

class SelectorList extends Selector

  constructor: (@items = []) -> super

  clone: (items = [].concat @items, etc...) ->
    super items, etc...

  toString: ->
    (@items.map (item) -> item.toString()).join ', '

  toJSON: ->
    json = super
    json.items = @items
    json

module.exports = SelectorList
