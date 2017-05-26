Context      = require '../context'
LayIncluder  = require '../includer/lay'
Null         = require '../object/null'
Boolean      = require '../object/boolean'
QuotedString = require '../object/string/quoted'
Number       = require '../object/number'
VERSION      = require '../version'


###
###
class BaseContext extends Context

  constructor: ->
    super()

    @use new LayIncluder

    @set 'null', Null.null
    @set 'true', Boolean.true
    @set 'false', Boolean.false

    @set 'LAYLA-VERSION', new QuotedString VERSION

    @set 'PI', new Number Math.PI
    @set 'π', new Number Math.PI
    @set 'E', new Number Math.E


module.exports = BaseContext
