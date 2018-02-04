Rule         = require './rule'
QuotedString = require './string/quoted'


###
###
class RuleSet extends Rule

  constructor: (items, @selector = []) ->
    super items

  copy: (args...) ->
    copy = super args...
    copy.selector = @selector.clone()

    return copy

  '.selector': -> new QuotedString @selector.toString()


module.exports = RuleSet
