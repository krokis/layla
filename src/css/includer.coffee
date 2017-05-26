CSSParser      = require './parser'
SourceIncluder = require '../lib/includer/source'
Evaluator      = require '../lib/evaluator'


###
###
class CSSIncluder extends SourceIncluder

  @EXTENSIONS: ['css']

  parse: (source) ->
    (new CSSParser).parse source


module.exports = CSSIncluder
