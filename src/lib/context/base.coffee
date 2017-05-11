Context     = require '../context'
LayImporter = require '../importer/lay'
CSSImporter = require '../importer/css'
String      = require '../object/string'
Number      = require '../object/number'
VERSION     =  require '../version'

class BaseContext extends Context

  constructor: ->
    super

    @use new LayImporter
    @use new CSSImporter

    @set 'LAYLA-VERSION', new String VERSION
    @set 'PI', new Number Math.PI
    @set 'π', new Number Math.PI
    @set 'E', new Number Math.E

module.exports = BaseContext
