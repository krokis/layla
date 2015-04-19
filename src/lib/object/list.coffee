Collection = require './collection'
Object     = require '../object'
Boolean    = require './boolean'
String     = require './string'
Number     = require './number'

class List extends Collection

  constructor: (items, @separator = ' ') -> super items

  clone: (items, separator = @separator, etc...) ->
    super items, separator, etc...

  toJSON: ->
    json = super
    json.separator = @separator
    json

  '.commas': -> @clone null, ','

  '.spaces': -> @clone null, ' '

  '.list': -> @

Object::['.list'] = ->
  if @ instanceof Collection
    new List @items
  else
    new List [@]

String::['.characters'] = ->
  new List (@value.split '').map (char) => @clone char

String::['.words'] = ->
  new List ((@value.match /\w+/g) or []).map (word) => @clone word

String::['.lines'] = ->
  new List ((@value.match /[^\s](.+)[^\s]/g) or []).map (line) => @clone line

module.exports = List