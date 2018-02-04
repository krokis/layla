Error = require '../error'


###
###
class ProgramError extends Error

  constructor: (message, @start = null, @end = null, @stack = null) ->
    super message

  @property 'file', -> @start?.file or null

  @property 'line', -> @start?.line or null

  @property 'column', -> @start?.column or null

  @property 'location', -> @start? or null


module.exports = ProgramError

