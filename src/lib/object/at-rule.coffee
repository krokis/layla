Rule         = require './rule'
QuotedString = require './string/quoted'


###
###
class AtRule extends Rule

  constructor: (items, prelude, @name) ->
    super items, prelude

  copy: (items, prelude, name = @name, etc...) ->
    super items, prelude, name, etc...

  '.name': -> new QuotedString @name


module.exports = AtRule
