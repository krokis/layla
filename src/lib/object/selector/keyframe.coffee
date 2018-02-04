Selector = require '../selector'


###
###
class KeyframeSelector extends Selector

  constructor: (@keyframe = null) ->
    super()

  copy: (keyframe = @keyframe) ->
    super keyframe

  toString: -> @keyframe


module.exports = KeyframeSelector
