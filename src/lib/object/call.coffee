Object = require '../object'


###
###
class Call extends Object

  constructor: (@name, @arguments = []) ->
    super()

  copy: (name = @name, args = @arguments, etc...) ->
    super name, args, etc...

  clone: -> @


module.exports = Call
