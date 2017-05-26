Collection = require './collection'
List       = require './list'
Property   = require './property'
Boolean    = require './boolean'
String     = require './string'
Null       = require './null'


###
###
class Block extends Collection

  ###
  ###
  push: (elements...) ->
    # TODO check pushed elements are properties or blocks
    super elements...

  hasProperty: (name) ->
    @items.some (item) ->
      (item instanceof Property) and
      (item.name is name) and
      (not item.value.isNull())

  '.::': (context, other) ->
    if other instanceof String
      val = Null.NULL

      for node in @items
        if node instanceof Property and node.name is other.value
          val = node.value

      return val

    return super

  '.::=': (context, key, value) ->
    if key instanceof String
      name = key.value
      prop = null

      for node in @items
        if node instanceof Property and node.name is name
          prop = node

      if prop
        prop.value = value
      else
        @push new Property name, value

      return value

    return super

  '.properties': -> new Block (@items.filter (obj) -> obj instanceof Property)

  '.has-property?': (context, name) -> Boolean.new @hasProperty name.value


module.exports = Block
