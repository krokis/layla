Selector = require '../selector'


###
###
class Combinator extends Selector

  constructor: (@value = null) ->
    super()

  toString: -> @value or ''

  copy: (value = @value, etc...) ->
    super value, etc...


module.exports = Combinator
