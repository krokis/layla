PseudoSelector = require './pseudo'


###
###
class PseudoElementSelector extends PseudoSelector

  toString: -> '::' + super()


module.exports = PseudoElementSelector
