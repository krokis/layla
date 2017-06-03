Selector              = require '../selector'
ElementalSelector     = require './elemental'
ComplementarySelector = require './complementary'
ParentSelector        = require './parent'


###
###
class CompoundSelector extends Selector

  @property 'elemental',
    get: ->
      for child in @children
        return child if child instanceof ElementalSelector

      return null

  @property 'complementary',
    get: ->
      @children.filter (child) -> child instanceof ComplementarySelector

  constructor: (@children = []) ->

  hasParentSelector: -> @children.some (c) -> c instanceof ParentSelector

  resolve: (other) ->
    unless other instanceof CompoundSelector
      throw new Error

    complementary = @complementary

    for child, i in complementary
      if child instanceof ParentSelector
        resolved = []

        if other.elemental
          resolved.push other.elemental
        else if @elemental
          resolved.push @elemental

        resolved.push complementary[0...i]...
        resolved.push other.complementary...
        resolved.push complementary[i + 1...]...

        return new CompoundSelector resolved

    @clone()

  clone: (children = @children, etc...) ->
    super (child.clone() for child in children), etc...

  toString: ->
    (child.toString() for child in @children).join ''

  toJSON: ->
    json = super
    json.children = @children
    json


module.exports = CompoundSelector
