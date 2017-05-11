ComplementarySelector = require './complementary'

class ParentSelector extends ComplementarySelector

  toString: -> '&'

module.exports = ParentSelector
