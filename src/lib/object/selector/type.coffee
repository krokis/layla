ElementalSelector = require './elemental'


###
###
class TypeSelector extends ElementalSelector

  constructor: (@name = null, etc...) -> super etc...

  clone: (name = @name, etc...) ->
    super name, etc...

  toString: ->
    str = ''

    if @namespace?
      if @namespace is '*'
        str += '*'
      else
        str += @escape @namespace
      str += '|'

    str += @escape @name

    return str

  toJSON: ->
    json = super
    json.name = @name
    json


module.exports = TypeSelector
