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

  ###
  TODO: convert any object to string with `.string`?
  ###
  match: (other) ->
    if other instanceof String
      if m = other.value.match @value
        return new List m.map (str) -> other.clone str
      return Null.null

    throw new Error "Cannot match that!"

  isEqual: (other) ->
    (other instanceof RegExp) and
    (other.source is @source) and
    (other.global is @global) and
    (other.multiline is @multiline) and
    (other.insensitive is @insensitive)

  toString: -> @source

  clone: (source = @source, flags = @flags) ->
    super source, flags

  reprValue: -> "/#{@source}/#{@flags}"

  '.~': @::match

  '.global?': -> Boolean.new @global

  '.global': -> @clone().setFlag 'g', yes

  '.sensitive?': -> Boolean.new not @insensitive

  '.sensitive': -> @clone().setFlag 'i', no

  '.insensitive?': -> Boolean.new @insensitive

  '.insensitive': -> @clone().setFlag 'i', yes

  '.multiline?': -> Boolean.new @multiline

  '.multiline': -> @clone().setFlag 'm', yes

do ->
  _match = String::match

  String::['.~'] = (other, etc...) ->
    if other instanceof RegExp
      other.match this
    else
      _match.call @, other, etc...

do ->
  _divide = String::divide

  String::['./'] = (other) ->
    if other instanceof RegExp
      reg = other.value
    else if other instanceof String
      reg = other.value
      reg = reg.replace /[-\/\\^$*+?.()|[\]{}]/g, '\\$&'
      reg = new global.RegExp "#{reg}+"
    else
      return _divide.call this, other

    chunks = (@value.split reg)
             .filter (str) -> str isnt ''
             .map (str) => @clone str

    new List chunks

module.exports = RegExp
