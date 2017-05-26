NodeContext = require '../node/context'


###
###
class CLIContext extends NodeContext
  constructor: (args...) ->
    super args...

    @pushPath process.cwd()


module.exports = CLIContext
