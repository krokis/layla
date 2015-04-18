Block = require './block'
List  = require './list'

class Rule extends Block

Block::['.rules'] = ->
  new List (@items.filter (obj) -> obj instanceof Rule)

module.exports = Rule
