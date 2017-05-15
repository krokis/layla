Indexed        = require './indexed'
Null           = require './null'
Boolean        = require './boolean'
List           = require './list'
Number         = require './number'
String         = require './string'
UnquotedString = require './string/unquoted'
TypeError      = require '../error/type'


class Range extends Indexed

  { min, max, abs, floor } = Math

  @property 'items',
    get: ->
      items = []

      for i in [0...@length()]
        items.push new Number (@getByIndex i), @unit

      items

  isReverse: -> @first > @last

  length: -> 1 + floor (abs @last - @first) / @step

  minValue: -> new Number min(@first, @last), @unit

  maxValue: -> new Number max @first, @last

  getByIndex: (index) ->
    step = @step

    if @isReverse()
      step *= -1

    return new Number @first + index * step

  constructor: (@first = 0, @last = 0, @unit = null, @step = 1) ->
    super

  convert: (unit) ->
    unit = unit.toString()

    if unit isnt ''
      first = Number.convert @first, @unit, unit
      last = Number.convert @last, @unit, unit
      step = Number.convert @step, @unit, unit
    else
      unit = ''

    return @clone first, last, unit, step

  ###
  TODO this is buggy
  ###
  contains: (other) ->
    try
      other = other.convert @unit
      return min(@first, @last) <= other.value <= max(@first, @last)

    return no

  isPure: -> not @unit

  clone: (first = @first, last = @last, unit = @unit, step = @step, etc...) ->
    super first, last, unit, step, etc...

  reprValue: -> "#{@first}..#{@last}"

  './': (step) ->
    if step instanceof Number
      return @clone null, null, null, (step.convert @unit).value

    throw new TypeError "Cannot divide a range by #{step.repr()}"

  '.unit': -> if @unit then new UnquotedString @unit else Null.null

  '.unit?': -> Boolean.new @unit

  '.pure?': -> Boolean.new @isPure()

  '.pure': -> @clone null, null, ''

  '.step': -> new Number @step, @unit

  '.step=': (step) ->
    if step instanceof Number
      @step = (step.convert @unit).value
    else
      throw new TypeError "Bad `step` value for a range: #{step.repr()}"

  '.convert': (args...) -> @convert args...

  '.reverse?': -> Boolean.new @isReverse()

  '.reverse': -> @clone @last, @first

  '.list': -> new List @items

Number::['...'] = (other) ->
  if other instanceof Number
    if @unit
      other = other.convert @unit
      unit = @unit
    else if other.unit
      unit = other.unit
    else
      unit = null

    return new Range @value, other.value, unit

  throw new TypeError "Cannot make a range with that: #{other.type}"

do ->
  supah = List::['.::']

  List::['.::'] = (other, etc...) ->
    if other instanceof Range
      slice = @clone []
      for idx in other.items
        slice.items.push @['.::'] idx
      slice
    else
      supah.call @, other, etc...

do ->
  { min, max } = Math

  supah = String::['.::']

  String::['.::'] = (other, etc...) ->
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
      @clone str
    else
      supah.call @, other, etc...


module.exports = Range
