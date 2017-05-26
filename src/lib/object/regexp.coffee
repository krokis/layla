Object       = require '../object'
Boolean      = require './boolean'
Null         = require './null'
String       = require './string'
QuotedString = require './string/quoted'
Number       = require './number'
List         = require './list'
ValueError   = require '../error/value'

JSRegExp = global.RegExp


###
###
class RegExp extends Object

  @escape: (str) -> str.replace /[-\/\\^$*+?.()|[\]{}]/g, '\\$&'

  constructor: (@source, @flags = '') ->
    super()

    # Detect bad flags
    if e = @flags.match /[^img]/
      throw new ValueError "Invalid RegExp flag: \"#{e}\""

    # Remove duplicates
    @flags = @flags.split('').sort().join('').replace /(.)\1+/g, '$1'

    try
      @value = new JSRegExp @source, @flags
    catch e
      throw new ValueError e.message

  @property 'multiline', -> 'm' in @flags

  @property 'global', -> 'g' in @flags

  @property 'insensitive', -> 'i' in @flags

  isEqual: (other) ->
    (other instanceof RegExp) and
    (other.source is @source) and
    (other.flags is @flags)

  toString: -> @source

  copy: (source = @source, flags = @flags, etc...) ->
    super source, flags, etc...

  copyWithFlag: (flag, value) ->
    # Remove given flag
    flags = @flags.split(flag).join ''

    # Add if necessary
    if value
      flags += flag

    return @copy undefined, flags

  clone: -> @

  reprValue: -> "/#{@source}/#{@flags}"

  ###
  TODO: convert any object to string with `.string`?
  ###
  '.~': (context, other) ->
    if other instanceof String
      if m = other.value.match @value
        return new List m.map (str) -> other.copy str

      return Null.null

    throw new ValueError "Cannot match that!"

  '.flags': -> new QuotedString @flags

  '.global?': -> Boolean.new @global

  '.global': -> @copyWithFlag 'g', yes

  '.sensitive?': -> Boolean.new not @insensitive

  '.sensitive': -> @copyWithFlag 'i', no

  '.insensitive?': -> Boolean.new @insensitive

  '.insensitive': -> @copyWithFlag 'i', yes

  '.multiline?': -> Boolean.new @multiline

  '.multiline': -> @copyWithFlag 'm', yes

do ->
  supah = String::match

  String::['.~'] = (context, other, etc...) ->
    if other instanceof RegExp
      other['.~'] context, this
    else
      supah.call @, context, other, etc...

String::['.split'] = (context, separator, limit = Null.null) ->
  if not separator
    reg = null
  else if separator instanceof RegExp
    reg = separator.value
  else if separator instanceof String
    if separator.isEmpty()
      reg = ''
    else
      reg = RegExp.escape separator.value
      reg = new JSRegExp "#{reg}+"
  else
    throw new ValueError 'Bad `separator` argument for `String.split`'

  if limit instanceof Null
    limit = -1
  else if limit instanceof Number
    limit = limit.value
  else
    throw new ValueError 'Bad `limit` argument for `String.split`'

  chunks =
    (@value.split reg, limit)
    .filter (str) -> str isnt ''
    .map (str) => @copy str

  return new List chunks

do ->
  String::['./'] = (context, separator) ->
    if separator instanceof RegExp
      reg = separator.value
    else if separator instanceof String
      reg = RegExp.escape separator.value
      reg = new JSRegExp "#{reg}+"
    else
      throw new ValueError "Cannot divide string by a [#{separator.reprType()}]"

    return @['.split'] context, separator

String::['.characters'] = (context, limit = Null.null) ->
  new List (@value.split '').map (char) => @copy char

String::['.words'] = ->
  new List ((@value.match /\w+/g) or []).map (word) => @copy word

String::['.lines'] = ->
  new List ((@value.match /[^\s](.+)[^\s]/g) or []).map (line) => @copy line

String::['.replace'] = (context, search, replacement) ->
  if search instanceof RegExp
    search = search.value
  else
    search = new JSRegExp RegExp.escape(search.toString()), 'g'

  replacement = replacement.toString()

  @copy @value.replace(search, replacement)


module.exports = RegExp
