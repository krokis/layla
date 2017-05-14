Indexed        = require './indexed'
Null           = require './null'
Boolean        = require './boolean'
List           = require './list'
Number         = require './number'
String         = require './string'
UnquotedString = require './string/unquoted'
ValueError     = require '../error/value'


###
###
class Range extends Indexed

  { min, max, abs, floor } = Math

  @property 'items', ->
    items = []

    for i in [0...@length()]
      items.push new Number (@getByIndex i), @unit

    return items

  isReverse: -> @first > @last

  length: -> 1 + floor (abs @last - @first) / @step

  minValue: -> new Number min(@first, @last), @unit

  maxValue: -> new Number max(@first, @last), @unit

  getByIndex: (index) ->
    step = @step

    if @isReverse()
      step *= -1

    return new Number @first + index * step, @unit

  constructor: (@first = 0, @last = 0, @unit = null, @step = 1) ->
    super()

  convert: (unit) ->
    unit = unit.toString()

    if unit isnt ''
      first = Number.convert @first, @unit, unit
      last = Number.convert @last, @unit, unit
      step = Number.convert @step, @unit, unit
    else
      unit = ''

    return @copy first, last, unit, step

  ###
  TODO this is buggy
  ###
  contains: (other) ->
    try
      other = other.convert @unit
      return min(@first, @last) <= other.value <= max(@first, @last)

    return no

  isPure: -> not @unit

  clone: -> @

  copy: (first = @first, last = @last, unit = @unit, step = @step, etc...) ->
    super first, last, unit, step, etc...

  reprValue: -> "#{@first}..#{@last}"

  './': (context, step) ->
    if step instanceof Number
      return @copy undefined, undefined, undefined, (step.convert @unit).value

    return super context, step

  '.unit': -> if @unit then new UnquotedString @unit else Null.null

  '.unit?': -> Boolean.new @unit

  '.pure?': -> Boolean.new @isPure()

  '.pure': -> @copy undefined, undefined, ''

  '.step': -> new Number @step, @unit

  '.convert': (context, args...) -> @convert args...

  '.)': @::['.convert']

  '.reverse?': -> Boolean.new @isReverse()

  '.reverse': -> @copy @last, @first

  '.list': -> new List @items


do ->
  supah = Number::['...']

  Number::['...'] = (context, other) ->
    if other instanceof Number
      if @unit
        other = other.convert @unit
        unit = @unit
      else if other.unit
        unit = other.unit
      else
        unit = null

      return new Range @value, other.value, unit

    return supah context, other

do ->
  supah = List::['.::']

  List::['.::'] = (context, other, etc...) ->
    if other instanceof Range
      slice = @copy []
      for idx in other.items
        slice.items.push @['.::'] context, idx
      slice
    else
      supah.call @, context, other, etc...

do ->
  { min, max } = Math

  supah = String::['.::']

  String::['.::'] = (context, other, etc...) ->
    if other instanceof Range
      str = ''
      if @value isnt ''
        len = @value.length

        end = other.last + 1
        end += len if end < 0
        end = min end, (len - 1)

        idx = other.first
        idx += len if idx < 0
        idx = max -len, idx

        while idx isnt end
          str += @value.charAt idx
          idx = (idx + 1) % len
      @copy str
    else
      supah.call @, context, other, etc...


module.exports = Range
