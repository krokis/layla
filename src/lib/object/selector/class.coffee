ComplementarySelector = require './complementary'

class ClassSelector extends ComplementarySelector

  toString: -> '.' + @name

module.exports = ClassSelector
