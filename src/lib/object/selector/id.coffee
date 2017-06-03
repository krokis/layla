ComplementarySelector = require './complementary'


####
####
class IdSelector extends ComplementarySelector

  toString: -> '#' + @escape @name


module.exports = IdSelector
