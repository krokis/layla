Object     = require '../../object'
Null       = require '../null'
Boolean    = require '../boolean'
String     = require '../string'
Number     = require '../number'
ValueError = require '../../error/value'


###
###
class RawString extends String

  @ESCAPE_CHARS = /[^\s\S]/

  ###
  ###
  reprValue: -> '`' + super() + '`'

  '.raw?': -> Boolean.true

Number::['.unit'] = -> if @unit then new RawString @unit else Null.null

Number::['.base'] = (context, base = Number.TEN) ->
  base = base.toNumber()

  unless base.isInteger()
    throw new ValueError """
      Cannot convert number to base `#{base.value}`: base must be integer
      """

  # TODO Check number is pure?

  unless 2 <= base.value <= 16
    throw new ValueError """
      Cannot convert number to base `#{base.value}`: base must be \
      between 2 and 16
      """

  str = @value.toString base.value

  # TODO On bases higher than 10, digits and units could be confused. Add
  # parens?
  str += @unit if @unit

  return new RawString str

String::['.raw?'] = -> Boolean.false

Object::['.raw'] = -> new RawString @toString()

do ->
  ###
  http://blog.stevenlevithan.com/archives/javascript-roman-numeral-converter
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
    if @isPure() and @isInteger() and 0 < @value <= 3000
      val = @value
      roman = ''

      for i of ROMANS
        while val >= ROMANS[i]
          roman += i
          val -= ROMANS[i]

      return new RawString roman

    throw new ValueError


module.exports = RawString
