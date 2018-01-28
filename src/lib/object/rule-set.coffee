Rule         = require './rule'
QuotedString = require './string/quoted'


###
###
class RuleSet extends Rule

  constructor: ->
    super
    @selector = []

  toJSON: ->
    json = super
    json.selector = @selector
    json

  copy: ->
    copy = super
    copy.selector = @selector.clone()

    copy

  '.selector': -> new QuotedString @selector.toString()


module.exports = RuleSet
