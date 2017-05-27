Object     = require '../object'
Null       = require './null'
Boolean    = require './boolean'
Number     = require './number'
ValueError = require '../error/value'


###
###
class String extends Object

  QUOTE_REGEXP = (str) -> str.replace /[.?*+^$[\]\\(){}|-]/g, "\\$&"

  @empty: new @ ''

  @escapeWhitespace: (value) ->
    # Escape new lines to \A
    value = value.replace /(^|[^\\]|(?:\\\\)+)(\r\n|\r|\n)/gm, '$1\\A'

    # Translate `\t` to \9
    value = value.replace /\t/gm, '\\9'

    return value

  @escapeBackslashes: (value) -> value

  @escapeCharacters: (value, chars) ->
    value.replace ///(^|[^\\]|(?:\\(?:\\\\)*))([#{chars}])///gm, '$1\\$2'

  @escapeRegex: (value, reg) ->
    value.replace ///(^|[^\\]|(?:\\(?:\\\\)*))([#{reg.source}])///gm, '$1\\$2'

  @escape: (value) -> value

  constructor: (@value = '') ->

  @property 'length',
    get: -> @value.length

  isEmpty: -> @length is 0

  isBlank: -> @value.trim() is ''

  isEqual: (other) -> other instanceof String and other.value is @value

  isPalindrome: ->
    letters = @value.toLowerCase().replace /[\W]+/g, ''
    return letters is (letters.split '').reverse().join ''

  toNumber: -> Number.fromString @value

  isNumeric: -> !!(try @toNumber())

  toBase64: -> new Buffer(@value).toString 'base64'

  escape: -> @class.escape @value

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

  toJSON: ->
    json = super
    json.value = @value
    json

  clone: (value = @value) -> super value

  reprValue: -> @escape()

  '.+': (context, other) ->
    if other instanceof String
      return @clone "#{@value}#{other.value}"
    else
      throw new ValueError (
        """
        Cannot perform #{@repr()} + #{other.repr()}: \
        right side must be a #{String.repr()}
        """
      )

  '.*': (context, other) ->
    if other instanceof Number
      if other.value >= 0
        unless other.unit
          return @clone ((Array other.value + 1).join @value)
        else
          throw new ValueError (
            """
            Cannot perform #{@repr()} * #{other.repr()}: \
            that's not a [Number]
            """
          )
      else
        throw new ValueError

    else
      throw new ValueError (
        """
        Cannot perform #{@repr()} * #{other.repr()}: \
        that's not a [Number]
        """
      )

  '.::': (context, other) ->
    if other instanceof Number
      len = @length
      idx = other.value
      idx += len if idx < 0
      char = @value.charAt(idx)

      if char is ''
        return Null.null
      else
        return @clone char
    else
      throw new ValueError

  '.length': -> new Number @length

  '.empty?': -> new Boolean @isEmpty()

  '.blank?': -> new Boolean @isBlank()

  '.trim': (context, chars) ->
    # TODO check bad args
    if chars instanceof String
      chars = QUOTE_REGEXP chars.value
    else
      chars = '\\s'

    @clone (@value.replace ///^[#{chars}]+|[#{chars}]+$///g, '')

  '.ltrim': (context, chars) ->
    # TODO check bad args
    if chars instanceof String
      chars = QUOTE_REGEXP chars.value
    else
      chars = '\\s'

    @clone (@value.replace ///^[#{chars}]+///g, '')

  '.rtrim': (context, chars) ->
    # TODO check bad args
    if chars instanceof String
      chars = QUOTE_REGEXP chars.value
    else
      chars = '\\s'

    @clone (@value.replace ///[#{chars}]+$///g, '')

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

  '.lower-case': -> @clone @value.toLowerCase()

  '.upper-case': -> @clone @value.toUpperCase()

  '.string': -> @clone()

  '.numeric?': -> Boolean.new @isNumeric()

  '.reverse': -> @clone (@value.split '').reverse().join ''

  '.palindrome?': -> Boolean.new @isPalindrome()

  '.base64': -> @clone @toBase64()

  '.repr': -> @clone @repr()

  '.eval': (context) -> context.evaluate @value

do ->
  supah = Number::['.*']

  Number::['.*'] = (context, other, etc...) ->
    if other instanceof String
      other['.*'] context, @
    else
      supah.call @, context, other, etc...


module.exports = String
