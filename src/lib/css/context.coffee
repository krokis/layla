BaseContext = require '../context/base'
CSSIncluder = require './includer'

###
###
class CSSContext extends BaseContext

  constructor: ->
    super

    @use new CSSIncluder
    # TODO Add HERE normalizer and emitter


module.exports = CSSContext
