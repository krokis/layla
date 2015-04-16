Declaration = require '../declaration'

class RuleDeclaration extends Declaration

  toJSON: ->
    json = super
    json.block = @block
    json

module.exports = RuleDeclaration
