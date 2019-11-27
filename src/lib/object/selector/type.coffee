ElementalSelector = require './elemental'


###
###
class TypeSelector extends ElementalSelector

  constructor: (@name = null, etc...) ->
    super etc...

  copy: (name = @name, etc...) ->
    super name, etc...

  toString: -> super @escape(@name)


module.exports = TypeSelector
