ElementalSelector = require './elemental'


###
###
class UniversalSelector extends ElementalSelector

  toString: -> super('*')


module.exports = UniversalSelector
