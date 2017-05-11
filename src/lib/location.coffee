Class = require './class'

class Location extends Class

  constructor: (@file = null, @line = 0, @column = 0) ->

  clone: (file = @file, line = @line, column = @column, etc...) ->
    super file, line, column, etc...

  toString: -> "#{@file}:#{@line}:#{@column}"

  toJSON: ->
    json = super
    json.file = @file
    json.line = @line
    json.column = @column
    json

module.exports = Location
