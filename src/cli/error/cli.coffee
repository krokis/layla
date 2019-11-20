###
###
class CLIError
  constructor: (@message) ->
  toString: -> @message


module.exports = CLIError
