Context     = require '../context'
LayIncluder = require '../includer/lay'
CSSIncluder = require '../css/includer'
Null        = require '../object/null'
Boolean     = require '../object/boolean'
String      = require '../object/string'
Number      = require '../object/number'
VERSION     =  require '../version'

class BaseContext extends Context

  constructor: ->
    super

    @use new LayIncluder
    @use new CSSIncluder

    @set 'null', Null.null
    @set 'true', Boolean.true
    @set 'false', Boolean.false

    @set 'LAYLA-VERSION', new String VERSION
    @set 'PI', new Number Math.PI
    @set 'π', new Number Math.PI
    @set 'E', new Number Math.E

module.exports = BaseContext
