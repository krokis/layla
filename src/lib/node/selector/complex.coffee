Selector = require '../selector'


###
###
class ComplexSelector extends Selector

  constructor: (@items = []) ->
    super()

  toString: ->
    (@items.map (child) -> child.toString().trim()).join ' '


module.exports = ComplexSelector
