Declaration = require './declaration'

class RuleDeclaration extends Declaration

  block: yes

  toJSON: ->
    json = super
    json.block = @block
    json

module.exports = RuleDeclaration
