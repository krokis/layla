Selector         = require '../selector'
CompoundSelector = require './compound'
ParentSelector   = require './parent'
Combinator       = require './combinator'

class ComplexSelector extends Selector

  constructor: (@children = []) ->

  resolve: (other) ->
    unless other instanceof ComplexSelector
      throw new Error "Cannot resolve complex selector against that!"

    resolved = []
    res = no

    for child in @children
      if (child instanceof CompoundSelector) and child.hasParentSelector()
        resolved = resolved.concat other.children[0...-1]
        resolved.push child.resolve other.children[other.children.length - 1]
        res ||= child.children.some (c) -> c instanceof ParentSelector
      else
        resolved.push child.clone()

    if not res
      resolved = [].concat other.children

      unless @children[0] instanceof Combinator
        resolved.push new Combinator ' '

      resolved = resolved.concat @children

    return new ComplexSelector resolved

  toString: ->
    str = ''

    for child in @children
      piece = child.toString()

      if piece.length
        if child instanceof Combinator
          if piece.trim() isnt ''
            piece = ' ' + piece
          if piece[-1..-1].trim() isnt ''
            piece += ' '
        str += piece

    return str

  clone: (children = @children, etc...) ->
    super (child.clone() for child in children), etc...

  toJSON: ->
    json = super
    json.children = @children
    json

module.exports = ComplexSelector
