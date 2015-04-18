camelCase  = require 'camel-case'
pascalCase = require 'pascal-case'
snakeCase  = require 'snake-case'
titleCase  = require 'title-case'
kebabCase  = require 'param-case'

Indexed    = require './indexed'
Object     = require '../object'
Null       = require './null'
Boolean    = require './boolean'
Number     = require './number'

TypeError  = require '../error/type'

class String extends Indexed

  QUOTE_REGEXP = (str) -> str.replace /[.?*+^$[\]\\(){}|-]/g, "\\$&"

  constructor: (@value = '', @quote = null) ->

  length: -> @value.length

  getByIndex: (index) -> @clone @value.charAt index

  isEqual: (other) -> other instanceof String and other.value is @value

  isPalindrome: ->
    letters = @value.toLowerCase().replace /[\W]+/g, ''
    letters is (letters.split '').reverse().join ''

  toNumber: -> Number.fromString @value

  isNumeric: -> !!(try @toNumber())

  toString: -> @value

  append: (others...) ->
    for other in others
      if other instanceof String
        @value += other.value
        @quote ||= other.quote
      else
        throw new TypeError "Cannot append that to a string"

    return @

  compare: (other) ->
    if other instanceof String
      if other.value is @value
        0
      else if other.value > @value
        1
      else
        -1
    else
      throw new Error "Cannot compare that"

  contains: (other) ->
    # TODO should throw an error when other is not an string?
    (other instanceof String) and (@value.indexOf other.value) >= 0

  toJSON: ->
    json = super
    json.quote = @quote
    json.value = @value
    json

  clone: (value = @value, quote = @quote) ->
    super value, quote

  # TODO: escape double quotes
  reprValue: -> '"' + @value + '"'

  '.+': (other) ->
    if other instanceof String
      return new String "#{@value}#{other.value}", @quote or other.quote

  '.*': (other) ->
    if other instanceof Number
      if other.value >= 0
        unless other.unit
          return @clone ((Array other.value + 1).join @value)
        else
          throw new TypeError (
            """
            Cannot perform #{this.repr()} * #{other.repr()}: \
            that's not a [Number]
            """
          )
      else
        throw new TypeError

    else
      throw new TypeError (
        """
        Cannot perform #{this.repr()} * #{other.repr()}: \
        that's not a [Number]
        """
      )


  '.<<': @::append

  '.blank?': -> Boolean.new @value.trim() is ''

  '.quoted?': -> Boolean.new @quote?

  '.quote': -> new String @value, '"'

  '.quoted': @::['.quote']

  '.unquote': -> new String @value, null

  '.unquoted': @::['.unquote']

  '.unquoted?': -> Boolean.new not @quote?

  '.append': @::append

  '.trim': (chars) ->
    if chars instanceof String
      chars = chars.value
    else
      chars = chars = '\n\r\t '
    chars = QUOTE_REGEXP chars
    @clone (@value.replace ///^[#{chars}]+|[#{chars}]+$///g, '')

  '.ltrim': (chars) ->
    if chars instanceof String
      chars = chars.value
    else
      chars = chars = '\n\r\t '

    @clone (@value.replace ///^[#{QUOTE_REGEXP chars}]+///g, '')

  '.rtrim': (chars) ->
    if chars instanceof String
      chars = chars.value
    else
      chars = chars = '\n\r\t '
    @clone (@value.replace ///[#{QUOTE_REGEXP chars}]+$///g, '')

  '.starts-with?': (str) ->
    Boolean.new (
      str instanceof String and
      (@value.length >= str.value.length) and
      (@value.substr 0, str.value.length) is str.value
    )

  '.ends-with?': (str) ->
    Boolean.new (
      str instanceof String and
      (@value.length >= str.value.length) and
      (@value.substr -(str.value.length), str.value.length) is str.value
    )

  '.lower-case': -> @clone @value.toLowerCase()

  '.upper-case': -> @clone @value.toUpperCase()

  '.camel-case': -> @clone camelCase @value

  '.pascal-case': -> @clone pascalCase @value

  '.snake-case': -> @clone snakeCase @value

  '.kebab-case': -> @clone kebabCase @value

  '.spinal-case': @::['.kebab-case']

  '.title-case': -> @clone titleCase @value

  '.string': -> @clone()

  '.numeric?': -> Boolean.new @isNumeric()

  '.reverse': -> @clone (@value.split '').reverse().join ''

  '.palindrome?': -> Boolean.new @isPalindrome()

Number::['.base'] = (base = Number.TEN) ->
  base = base.toNumber()

  if base.value isnt Math.round base.value
    throw new TypeError """
      Cannot convert number to base `#{base.value}`: base must be integer
      """

  unless 2 <= base.value <= 16
    throw new TypeError """
      Cannot convert number to base `#{base.value}`: base must be \
      between 2 and 16
      """

  str = @value.toString base.value
  str += @unit if @unit
  new String str

###
http://blog.stevenlevithan.com/archives/javascript-roman-numeral-converter#comment-16107
###
ROMANS =
  M:  1000
  CM:  900
  D:   500
  CD:  400
  C:   100
  XC:   90
  L:    50
  XL:   40
  X:    10
  IX:    9
  V:     5
  IV:    4
  I:     1

Number::['.roman'] = ->
  val = @value
  roman = ''
  for i of ROMANS
    while val >= ROMANS[i]
      roman += i
      val -= ROMANS[i]
  new String roman

do ->
  _multiply = Number::['.*']

  Number::['.*'] = (other, etc...) ->
    if other instanceof String
      other['.*'] @
    else
      _multiply.call @, other, etc...

Number::['.format'] = (fmt) -> # TODO

Number::['.unit'] = -> if @unit then new String @unit else Null.nulle

Object::['.string'] = -> new String @toString()

Object::['.unquoted'] = Object::['.string']

Object::['.quoted'] = -> new String @toString(), '"'

Object::['.repr'] = -> new String @repr(), '"'

do ->
  supah = Object::isA

  Object::isA = (other, etc...) ->
    if other instanceof String
      @reprType().toLowerCase() is other.value.toLowerCase()
    else
      supah.call @, other, etc...

module.exports = String
