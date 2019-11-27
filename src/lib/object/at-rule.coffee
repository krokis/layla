Rule         = require './rule'
QuotedString = require './string/quoted'


###
###
class AtRule extends Rule

  constructor: (items, @name, @arguments = []) ->
    super items

  copy: (items = @items, name = @name, args = @arguments, etc...) ->
    super items, name, args, etc...

  '.name': -> QuotedString.new @name


module.exports = AtRule
