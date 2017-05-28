RuntimeError = require './runtime'


###
###
class NotImplementedError extends RuntimeError

  message = "Not implemented"

  constructor: (message = @message, etc...) -> super


module.exports = NotImplementedError

