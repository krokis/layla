SimpleSelector = require './simple'


###
###
class ComplementarySelector extends SimpleSelector

  constructor: (@name) ->
    super()

  copy: (name = @name, etc...) ->
    super name, etc...


module.exports = ComplementarySelector
