Selector = require '../selector'


###
###
class KeyframeSelector extends Selector

  constructor: (@keyframe = null, etc...) -> super etc...

  clone: (keyframe = @keyframe, etc...) ->
    super keyframe, etc...

  toString: -> @keyframe

  toJSON: ->
    json = super
    json.keyframe = @keyframe
    json


module.exports = KeyframeSelector
