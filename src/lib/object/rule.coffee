Block = require './block'


###
###
class Rule extends Block

Block::['.rules'] = ->
  Block.new(@items.filter (obj) -> obj instanceof Rule)


module.exports = Rule
