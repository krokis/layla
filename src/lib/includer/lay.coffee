SourceIncluder = require './source'
LayParser      = require '../parser/lay'
Evaluator      = require '../evaluator'


###
###
class LayIncluder extends SourceIncluder

  @EXTENSIONS: ['lay', '']

  parse: (source) ->
    (new LayParser).parse source


module.exports = LayIncluder
