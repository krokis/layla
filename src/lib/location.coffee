Class = require './class'


###
###
class Location extends Class

  constructor: (@file = null, @line = null, @column = null) ->
    super()

  copy: (file = @file, line = @line, column = @column, etc...) ->
    super file, line, column, etc...

  toString: -> "#{@file}:#{@line}:#{@column}"


module.exports = Location
