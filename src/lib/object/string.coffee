Object     = require '../object'
Null       = require './null'
Boolean    = require './boolean'
Number     = require './number'
ValueError = require '../error/value'


###
###
class String extends Object

  PRINTABLE_CHARS =
    ascii: /[!-~]/
    utf8:  /[!-~]|[^\x00-\x80]/

  @ESCAPE_CHARS = /\\/

  QUOTE_REGEXP = (str) -> str.replace /[.?*+^$[\]\\(){}|-]/g, "\\$&"

  @EMPTY = new @ ''

  @escapeCharacters: (chars, value, charset = 'utf8') ->
    value.replace(
      ///
        (^|[^\\]|(?:\\(?:\\\\)*)) # $1
        (#{chars.source}+)        # $2
        ([a-fA-F\d]?)             # $3
      ///gm,

      ($0, $1, $2, $3) ->
        esc = ''

        while $2
          c = $2[0]
          $2 = $2[1...]

          is_printable = c.match PRINTABLE_CHARS[charset]
          esc += '\\'

          if is_printable
            esc += c
          else
            esc += c.charCodeAt(0).toString(16).toUpperCase()
            esc += ' ' if $3 and not $2.length

        return "#{$1}#{esc}#{$3 or ''}"
    )

  @escape: (value, charset = 'utf8') ->
    @escapeCharacters @ESCAPE_CHARS, value, charset

  constructor: (@value = '') ->
    super()

  @property 'length', -> @value.length

  isEmpty: -> @length is 0

  isBlank: -> @value.trim() is ''

  isEqual: (other) -> other instanceof String and other.value is @value

  isPalindrome: ->
    letters = @value.toLowerCase().replace /[\W]+/g, ''
    return letters is (letters.split '').reverse().join ''

  toNumber: -> Number.fromString @value

  isNumeric: -> !!(try @toNumber())

  toBase64: -> new Buffer(@value).toString 'base64'

  escape: (charset = 'utf8') -> @class.escape @value, charset

  toString: -> @value

  compare: (other) ->
    if other instanceof String
      if other.value is @value
        0
      else if other.value > @value
        1
      else
        -1
    else
      throw new Error "Cannot compare #{@reprType()} with #{other.reprType()}"

  contains: (other) ->
    # TODO should throw an error when other is not an string?
    (other instanceof String) and (@value.indexOf other.value) >= 0

  clone: -> @

  copy: (value = @value) ->
    super value

  reprValue: -> @escape()

  '.+': (context, other) ->
    if other instanceof String
      return @copy "#{@value}#{other.value}"

    throw new ValueError (
      """
      Cannot perform #{@repr()} + #{other.repr()}: \
      right side must be a #{String.repr()}
      """
    )

  '.*': (context, other) ->
    if other instanceof Number
      if other.isNegative()
        throw new ValueError """
          Cannot multiply a string with a negative number"""

      unless other.isPure()
        throw new ValueError """
          Cannot multiply a string with a dimension"""

      str = Array(Math.floor(other.value) + 1).join(@value) +
            @value[0...Math.round(@value.length * (other.value % 1))]

      return @copy str

  '.::': (context, other) ->
    if other instanceof Number
      len = @length
      idx = other.value
      idx += len if idx < 0
      char = @value.charAt(idx)

      if char is ''
        return Null.NULL
      else
        return @copy char

    throw new ValueError

  '.length': -> new Number @length

  '.empty?': -> Boolean.new @isEmpty()

  '.blank?': -> Boolean.new @isBlank()

  '.trim': (context, chars) ->
    # TODO check bad args
    if chars instanceof String
      chars = QUOTE_REGEXP chars.value
    else
      chars = '\\s'

    @copy @value.replace(///^[#{chars}]+|[#{chars}]+$///g, '')

  '.ltrim': (context, chars) ->
    # TODO check bad args
    if chars instanceof String
      chars = QUOTE_REGEXP chars.value
    else
      chars = '\\s'

    @copy @value.replace(///^[#{chars}]+///g, '')

  '.rtrim': (context, chars) ->
    # TODO check bad args
    if chars instanceof String
      chars = QUOTE_REGEXP chars.value
    else
      chars = '\\s'

    @copy @value.replace(///[#{chars}]+$///g, '')

  '.starts-with?': (context, str) ->
    Boolean.new (
      str instanceof String and
      (@value.length >= str.value.length) and
      (@value[0...str.value.length] is str.value)
    )

  '.ends-with?': (context, str) ->
    Boolean.new (
      str instanceof String and
      (@value.length >= str.value.length) and
      (@value.substr -(str.value.length), str.value.length) is str.value
    )

  '.lower-case': -> @copy @value.toLowerCase()

  '.upper-case': -> @copy @value.toUpperCase()

  '.string': -> @clone()

  '.numeric?': -> Boolean.new @isNumeric()

  '.reverse': -> @copy @value.split('').reverse().join('')

  '.palindrome?': -> Boolean.new @isPalindrome()

  '.base64': -> @copy @toBase64()

  '.repr': -> @copy @repr()

  '.eval': (context) -> context.evaluate @value


module.exports = String
