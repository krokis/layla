Selector = require '../selector'


###
###
class CompoundSelector extends Selector

  @property 'items', ->
    (if @elemental then [@elemental] else []).concat @complementary

  constructor: (@elemental = null, @complementary = []) ->
    super()


module.exports = CompoundSelector
