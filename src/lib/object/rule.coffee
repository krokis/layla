Block = require './block'


###
###
class Rule extends Block

  constructor: (items, @prelude = null) ->
    super items

  copy: (items, prelude = @prelude, etc...) ->
    super items, prelude, etc...

Block::['.rules'] = ->
  new Block(@items.filter (obj) -> obj instanceof Rule)


module.exports = Rule
