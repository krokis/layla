SourceIncluder = require './source'
LayParser      = require '../parser/lay'
Evaluator      = require '../evaluator'

class LayIncluder extends SourceIncluder

  @EXTENSIONS: ['lay', '']

  parse: (source, uri) ->
    (new LayParser).parse source, uri

module.exports = LayIncluder
