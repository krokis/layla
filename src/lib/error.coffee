Class = require './class'

###
###
class Error extends Class

  @property 'name', get: -> @type

  @property 'file', get: -> @location?.file

  @property 'line', get: -> @location?.line

  @property 'column', get: -> @location?.column

  constructor: (@message, @location = null, @stack = null) ->

  toString: ->
    str = "[#{@type}] #{@message}"

    if @file?
      str += " @ #{@file}"

    if @line?
      str += ":#{@line}"
      str += ",#{@column}" if @column?

    return str

module.exports = Error
