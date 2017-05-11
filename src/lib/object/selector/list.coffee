Selector = require '../selector'

class SelectorList extends Selector

  constructor: (@children = []) ->

  append: (other) ->

  resolve: (other) ->
    unless other instanceof SelectorList
      throw new Error "Cannot resolve selector list against that! (#{other})"

    resolved = []

    for child in @children
      for other_child in other.children
        resolved_child = child.resolve other_child
        resolved.push resolved_child

    return new SelectorList resolved

  toString: ->
    (child.toString() for child in @children).join ', '

  clone: (children = @children, etc...) ->
    super (child.clone() for child in children), etc...

  toJSON: ->
    json = super
    json.children = @children
    json

module.exports = SelectorList
