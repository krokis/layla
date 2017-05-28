Error = require '../error'


###
###
class ProgramError extends Error

  constructor: (message, @start = null, @end = null, @stack = null) ->
    super message

  @property 'file', get: -> @start?.file or null

  @property 'line', get: -> @start?.line or null

  @property 'column', get: -> @start?.column or null

  @property 'location', get: -> @start? or null


module.exports = ProgramError

