Class = require './class'


###
###
class Error extends Class

  constructor: (@message) ->
    super()

  @property 'name', -> @class.name

  toString: -> "[#{@name}] #{@message}"


module.exports = Error
