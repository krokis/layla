Object = require '../object'


###
###
class Call extends Object

  constructor: (@name, @arguments = []) ->

  copy: (name = @name, args = @arguments, etc...) ->
    super name, args, etc...

  clone: -> @

  toJSON: ->
    json = super
    json.name = @name
    json.arguments = @arguments
    json


module.exports = Call
