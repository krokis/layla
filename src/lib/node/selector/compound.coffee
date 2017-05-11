Selector = require '../selector'

class CompoundSelector extends Selector

  @property 'items',
    get: ->
      (if @elemental then [@elemental] else []).concat @complementary

  constructor: (@elemental = null, @complementary = []) -> super

  toJSON: ->
    json = super
    json.elemental = @elemental
    json.complementary = @complementary
    json

module.exports = CompoundSelector
