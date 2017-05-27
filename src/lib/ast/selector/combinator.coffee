Selector = require '../selector'


###
###
class Combinator extends Selector

  constructor: (@value) ->
    super()

  toString: -> @value


module.exports = Combinator
