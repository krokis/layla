Declaration = require './declaration'


###
###
class PropertyDeclaration extends Declaration

  constructor: (@names, @value, @conditional = no) ->
    super()


module.exports = PropertyDeclaration
