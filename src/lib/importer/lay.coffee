SourceImporter = require './source'
LayParser      = require '../parser'
Evaluator      = require '../evaluator'

class LayImporter extends SourceImporter

  parse: (source) ->
    parser = new LayParser
    parser.parse source

module.exports = LayImporter
