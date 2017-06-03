ElementalSelector = require './elemental'


###
###
class UniversalSelector extends ElementalSelector

  toString: ->
    if @namespace?
      if @namespace is '*'
        str = '*'
      else
        str = @escape @namespace

      str += '|'
    else
      str = ''

    str += '*'

    return str


module.exports = UniversalSelector
