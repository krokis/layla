List     = require './list'
Property = require './property'
Boolean  = require './boolean'
String   = require './string'
Null     = require './null'

###
###
class Block extends List

  ###
  Should hold a reference to child properties.
  ###
  properties: {}

  ###
  Should hold a reference to child rules.
  ###
  rules: {} # "blocks"?

  '.::': (other) ->
    if other instanceof String
      val = Null.null

      for node in @items
        if node instanceof Property and node.name is other.value
          val = node.value

      val
    else
      super

  ###
  ###
  push: (elements...) ->
    # TODO check pushed elements are properties or blocks
    super elements...

  ###
  Merge this block with another block.
  ###
  merge: (blocks...) ->

  ###
  Include another block (same as merge?)
  ###
  include: (blocks...) ->

  ###
  Extend one or more other blocks. Arguments can be strings containing *fuzzy*
  or exact  selectors (`body ... a` should match `body p a`, and `... p` should
  match `html body main article p`) or block instances (which should be passed
  by reference, and we don't have references yet).

  See Sass and Stylus `@extend`
  ###
  extend: (blocks...) ->

  hasProperty: (name) ->
    @items.some (item) ->
      (item instanceof Property) and
      (item.name is name) and
      (not item.value.isNull())

  ###
  Find a nested block.
  ###
  find: (selector) ->

  '.properties': ->
    new List (@items.filter (obj) -> obj instanceof Property)

  '.has-property?': (name) -> Boolean.new @hasProperty name.value

  ###
  '.extend':  @::['.include']
  '.merge':   @::['.include']
  '.include': @::['.include']
  ###

module.exports = Block
