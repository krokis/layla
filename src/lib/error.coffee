Class = require './class'


###
###
class Error extends Class

  constructor: (@message) ->

  @property 'name', get: -> @type

  toString: -> "[#{@type}] #{@message}"


module.exports = Error
