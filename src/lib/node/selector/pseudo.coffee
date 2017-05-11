ComplementarySelector = require './complementary'

class PseudoSelector extends ComplementarySelector

  constructor: (name = null, @arguments = null) -> super name

  toJSON: ->
    json = super
    json.arguments = @arguments
    json

module.exports = PseudoSelector
