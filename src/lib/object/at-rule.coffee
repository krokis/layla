Rule         = require './rule'
QuotedString = require './string/quoted'


class AtRule extends Rule

  constructor: (@name, @arguments = []) -> super

  clone: ->
    that = super
    that.name = @name
    that.arguments = @arguments
    that

  # TODO
  # clone: (name = @name, args = @arguments, etc...) -> super name, args, etc...

  '.name': -> new QuotedString @name


module.exports = AtRule
