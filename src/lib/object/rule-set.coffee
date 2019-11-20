Rule         = require './rule'
QuotedString = require './string/quoted'


###
###
class RuleSet extends Rule

  @property 'selector',
    get: -> @prelude
    set: (@prelude) ->


  '.selector': -> new QuotedString @selector.toString()


module.exports = RuleSet
