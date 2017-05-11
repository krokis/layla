SourceImporter = require './source'
LayParser      = require '../parser/lay'
Evaluator      = require '../evaluator'

class LayImporter extends SourceImporter

  @EXTENSIONS: ['lay', '']

  parse: (source) ->
    (new LayParser).parse source

module.exports = LayImporter
