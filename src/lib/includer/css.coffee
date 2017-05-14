SourceIncluder = require './source'
CSSParser      = require '../parser/css'
Evaluator      = require '../evaluator'


class CSSIncluder extends SourceIncluder

  @EXTENSIONS: ['css']

  parse: (source, uri) ->
    (new CSSParser).parse source, uri

module.exports = CSSIncluder
