Context     = require '../context'
LayImporter = require '../importer/lay'
String      = require '../object/string'
Number      = require '../object/number'
VERSION     =  require '../version'

class BaseContext extends Context

  constructor: (parent, etc...) ->
    super parent, etc...

    unless parent
      @use new LayImporter
      @set 'LAYLA-VERSION', new String VERSION
      @set 'PI', new Number Math.PI
      @set 'π', new Number Math.PI
      @set 'E', new Number Math.E

module.exports = BaseContext
