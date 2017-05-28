Class = require './class'


###
###
class Error extends Class

  constructor: (@message) ->

  @property 'name', get: -> @class.name

  toString: -> "[#{@name}] #{@message}"


module.exports = Error
