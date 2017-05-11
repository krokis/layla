ElementalSelector = require './elemental'

class UniversalSelector extends ElementalSelector

  toString: ->
    if @namespace?
      str = @namespace + '|'
    else
      str = ''

    str += '*'

    return str

module.exports = UniversalSelector
