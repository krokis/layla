ComplementarySelector = require './complementary'


###
###
class PseudoSelector extends ComplementarySelector

  constructor: (name, @arguments = null) ->
    super name

  copy: (name = @name, args = @arguments, etc...) ->
    super name, args, etc...

  toString: ->
    str = @escape @name

    if @arguments
      args = []

      for arg in @arguments
        args.push (arg.map (a) -> a.toString()).join ' '

      str += "(#{args.join ', '})"

    return str


module.exports = PseudoSelector
