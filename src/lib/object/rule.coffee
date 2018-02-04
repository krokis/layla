Block = require './block'


###
###
class Rule extends Block


Block::['.rules'] = ->
  new Block(@items.filter (obj) -> obj instanceof Rule)


module.exports = Rule
