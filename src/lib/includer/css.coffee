SourceIncluder = require './source'
CSSParser      = require '../parser/css'
Evaluator      = require '../evaluator'

class CSSIncluder extends SourceIncluder

  @EXTENSIONS: ['css']

  parse: (source) ->
    (new CSSParser).parse source

module.exports = CSSIncluder
