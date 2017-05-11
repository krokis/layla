ComplementarySelector = require './complementary'

class IdSelector extends ComplementarySelector

  toString: -> '#' + @name

module.exports = IdSelector
