Rule         = require './rule'
QuotedString = require './string/quoted'


###
###
class AtRule extends Rule

  constructor: (@name, @arguments = []) ->
    super()

  copy: ->
    copy = super()
    copy.name = @name
    copy.arguments = @arguments

    return copy

  # TODO
  # copy: (name = @name, args = @arguments, etc...) -> super name, args, etc...

  '.name': -> new QuotedString @name


module.exports = AtRule
