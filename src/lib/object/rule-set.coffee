Rule   = require './rule'
String = require './string'

class RuleSet extends Rule

  selector: null

  constructor: ->
    super
    @selector = []

  toJSON: ->
    json = super
    json.selector = @selector
    json

  clone: ->
    that = super
    that.selector = [].concat @selector
    that

  '.selector': -> new String @selector.join ',\n'

module.exports = RuleSet
