Context     = require '../context'
LayIncluder = require '../includer/lay'
Null        = require '../object/null'
Boolean     = require '../object/boolean'
String      = require '../object/string'
Number      = require '../object/number'
VERSION     =  require '../version'


###
###
class BaseContext extends Context

  constructor: ->
    super

    @use new LayIncluder

    @set 'null', Null.NULL
    @set 'true', Boolean.TRUE
    @set 'false', Boolean.FALSE

    @set 'LAYLA-VERSION', new String VERSION
    @set 'PI', new Number Math.PI
    @set 'π', new Number Math.PI
    @set 'E', new Number Math.E


module.exports = BaseContext
