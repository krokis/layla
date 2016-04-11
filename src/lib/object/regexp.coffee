Object    = require '../object'
Boolean   = require './boolean'
Null      = require './null'
String    = require './string'
Number    = require './number'
List      = require './list'
TypeError = require '../error/type'

class RegExp extends Object

  _value: null
  source: null
  global: no
  multiline: no
  insensitive: no

  @escape: (str) -> str.replace /[-\/\\^$*+?.()|[\]{}]/g, '\\$&'

  constructor: (@source, @flags) -> @build()

  @property 'value',
    get: ->
      @build() unless @_value and
                      @_value.source is @source and
                      @_value.ignoreCase is @insensitive and
                      @_value.global is @global and
                      @_value.multiline is @multiline
      @_value

  @property 'flags',
    get: ->
      flags = ''
      flags += 'm' if @multiline
      flags += 'i' if @insensitive
      flags += 'g' if @global
      flags

    set: (flags) ->
      @multiline = no
      @global = no
      @insensitive = no

      if flags?.length
        @setFlag flag, yes for flag in flags

  setFlag: (flag, value) ->
    switch flag
      when 'm'
        @multiline = value
      when 'g'
        @global = value
      when 'i'
        @insensitive = value
      else
        throw new TypeError "Bad flag for RegExp: \"#{flag}\""

    return @

  build: ->
    try
      @_value = new global.RegExp @source, @flags
    catch e
      throw new TypeError e.message

  isEqual: (other) ->
    (other instanceof RegExp) and
    (other.source is @source) and
    (other.flags is @flags)

  toString: -> @source

  clone: (source = @source, flags = @flags, etc...) ->
    super source, flags, etc...

  reprValue: -> "/#{@constructor.escape @source}/#{@flags}"

  ###
  TODO: convert any object to string with `.string`?
  ###
  '.~': (other) ->
    if other instanceof String
      if m = other.value.match @value
        return new List m.map (str) -> other.clone str
      return Null.null

    throw new Error "Cannot match that!"

  '.global?': -> Boolean.new @global

  '.global': -> @clone().setFlag 'g', yes

  '.sensitive?': -> Boolean.new not @insensitive

  '.sensitive': -> @clone().setFlag 'i', no

  '.insensitive?': -> Boolean.new @insensitive

  '.insensitive': -> @clone().setFlag 'i', yes

  '.multiline?': -> Boolean.new @multiline

  '.multiline': -> @clone().setFlag 'm', yes

do ->
  supah = String::match

  String::['.~'] = (other, etc...) ->
    if other instanceof RegExp
      other['.~'] this
    else
      supah.call @, other, etc...

String::['.split'] = (separator, limit = Null.null) ->
  if separator instanceof RegExp
    reg = separator.value
  else if separator instanceof String
    reg = RegExp.escape separator.value
    reg = new global.RegExp "#{reg}+"
  else
    throw new TypeError 'Bad `separator` argument for `String.split`'

  if limit instanceof Null
    limit = -1
  else if limit instanceof Number
    limit = limit.value
  else
    throw new TypeError 'Bad `limit` argument for `String.split`'

  chunks =
    (@value.split reg, limit)
    .filter (str) -> str isnt ''
    .map (str) => @clone str

  new List chunks

do ->
  supah = String::['./']

  String::['./'] = (separator) ->
    if separator instanceof RegExp
      reg = separator.value
    else if separator instanceof String
      reg = RegExp.escape separator.value
      reg = new global.RegExp "#{reg}+"
    else
      return supah.apply this, arguments

    @['.split'] separator

String::['.characters'] = (limit = Null.null) ->
  new List (@value.split '').map (char) => @clone char

String::['.words'] = ->
  new List ((@value.match /\w+/g) or []).map (word) => @clone word

String::['.lines'] = ->
  new List ((@value.match /[^\s](.+)[^\s]/g) or []).map (line) => @clone line


String::['.replace'] = (search, replacement) ->
  if search instanceof RegExp
    search = search.value
  else
    search = new global.RegExp (RegExp.escape search.toString()), 'g'

  replacement = replacement.toString()

  @clone (@value.replace search, replacement)

module.exports = RegExp
