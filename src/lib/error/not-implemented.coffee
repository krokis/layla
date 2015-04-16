Error = require '../error'

class NotImplementedError extends Error

  message = "Not implemented"

  constructor: (@message = @message, etc...) -> super

module.exports = NotImplementedError

