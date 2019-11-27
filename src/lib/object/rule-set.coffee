Rule         = require './rule'
QuotedString = require './string/quoted'


###
###
class RuleSet extends Rule

  constructor: (items, @selector = []) ->
    super items

  copy: (items = @items, selector = @selector, etc...) ->
    super items, selector.copy(), etc...

  '.selector': -> QuotedString.new @selector.toString()


module.exports = RuleSet
