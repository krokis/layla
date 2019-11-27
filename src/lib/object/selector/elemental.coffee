SimpleSelector = require './simple'


###
###
class ElementalSelector extends SimpleSelector

  constructor: (@namespace = null) ->
    super()

  copy: (namespace = @namespace, etc...) ->
    super namespace, etc...

  toString: (name) ->
    str = ''

    if @namespace?
      if @namespace is '*'
        str += '*'
      else
        str += @escape @namespace
      str += '|'

    if name?
      str += name

    return str


module.exports = ElementalSelector
