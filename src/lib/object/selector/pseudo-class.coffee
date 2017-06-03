PseudoSelector = require './pseudo'


###
###
class PseudoClassSelector extends PseudoSelector

  toString: -> ':' + super


module.exports = PseudoClassSelector
