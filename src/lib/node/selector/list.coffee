Selector = require '../selector'

class SelectorList extends Selector

  constructor: (@items = []) -> super

  copy: (items = @items.slice(), etc...) ->
    super items, etc...

  toString: ->
    (@items.map (item) -> item.toString()).join ', '

  toJSON: ->
    json = super
    json.items = @items
    json

module.exports = SelectorList
