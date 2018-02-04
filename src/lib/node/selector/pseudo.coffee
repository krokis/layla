ComplementarySelector = require './complementary'


###
###
class PseudoSelector extends ComplementarySelector

  constructor: (name, @arguments = null) ->
    super name


module.exports = PseudoSelector
