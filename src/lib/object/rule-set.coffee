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

  clone: ->
    that = super
    that.selector = @selector.clone()
    that

  '.selector': -> new QuotedString @selector.toString()


module.exports = RuleSet
