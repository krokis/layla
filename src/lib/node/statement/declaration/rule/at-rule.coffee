RuleDeclaration = require '../rule'

class AtRuleDeclaration extends RuleDeclaration

  toJSON: ->
    json = super
    json.name = @name
    json.arguments = @arguments
    json

module.exports = AtRuleDeclaration
