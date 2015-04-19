Object    = require '../object'
Boolean   = require './boolean'
Null      = require './null'
String    = require './string'
List      = require './list'
TypeError = require '../error/type'

class RegExp extends Object

  _value: null
  source: null
  global: no
  multiline: no
  insensitive: no

  @property 'value',
    get: ->
      if @_value
        if @_value.source is @source and \
           @_value.ignoreCase is @insensitive and \
           @_value.global is @global and \
           @_value.multiline is @multiline
        else
          @build()
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

  @escape: (str) -> str.replace /[-\/\\^$*+?.()|[\]{}]/g, '\\$&'

  setFlag: (flag, value) ->
    switch flag
      when 'm'
        @multiline = yes
      when 'g'
        @global = yes
      when 'i'
        @insensitive = yes
      else
        throw new TypeError "Bad flag for RegExp: \"#{flag}\""

    return this

  build: ->
    try
      @_value = new global.RegExp @source, @flags
    catch e
      throw new TypeError e.message

  constructor: (@source, @flags) -> @build()

  isEqual: (other) ->
    (other instanceof RegExp) and
    (other.source is @source) and
    (other.flags is @flags)

  toString: -> @source

  clone: (source = @source, flags = @flags, etc...) ->
    super source, flags, etc...

  reprValue: -> "/#{@constructor.escape source}/#{@flags}"

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

do ->
  supah = String::divide

  String::['./'] = (other) ->
    if other instanceof RegExp
      reg = other.value
    else if other instanceof String
      reg = RegExp.escape other.value
      reg = new global.RegExp "#{reg}+"
    else
      return supah.call this, other

    chunks =
      (@value.split reg)
      .filter (str) -> str isnt ''
      .map (str) => @clone str

    new List chunks

module.exports = RegExp
