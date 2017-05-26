ComplementarySelector = require './complementary'


###
###
class ClassSelector extends ComplementarySelector

  toString: -> '.' + @escape @name


module.exports = ClassSelector
