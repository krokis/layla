Class = require './class'

class Location extends Class

  file: null
  position: 0
  line: 0
  column: 0

  constructor: (@position = 0, @line = 1, @column = 0) ->

  clone: ->
    new @constructor @position, @line, @column

  toJSON: ->
    json = super
    json.position = @position
    json.line = @line
    json.column = @column
    json

module.exports = Location
