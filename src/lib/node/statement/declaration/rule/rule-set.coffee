RuleDeclaration = require '../rule'

class RuleSetDeclaration extends RuleDeclaration

  toJSON: ->
    json = super
    json.selector = @selector
    json

module.exports = RuleSetDeclaration
