Class = require './class'

###
###
class Error extends Class

  @property 'name', get: -> @type

  @property 'file', get: -> @location?.file

  @property 'line', get: -> @location?.line

  @property 'column', get: -> @location?.line

  constructor: (@message, @location = null, @stack = null) ->

  toString: ->
    str = "#{@type} - #{@message}"

    if @file?
      str += " at #{@file}"
      if @line?
        str += ":#{@line}"
        str += ",#{column}" if @column?

    str

module.exports = Error
