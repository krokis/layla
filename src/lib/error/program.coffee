Error = require '../error'


###
###
class ProgramError extends Error

  @property 'file', get: -> @location?.file

  @property 'line', get: -> @location?.line

  @property 'column', get: -> @location?.column

  constructor: (message, @location = null, @stack = null) ->
    super message

  toString: ->
    str = super()

    if @file?
      str += " @ #{@file}"

    if @line?
      str += ":#{@line}"
      str += ",#{@column}" if @column?

    return str


module.exports = ProgramError

