CSSParser      = require './parser'
SourceIncluder = require '../includer/source'
Evaluator      = require '../evaluator'

###
###
class CSSIncluder extends SourceIncluder

  @EXTENSIONS: ['css']

  parse: (source) ->
    (new CSSParser).parse source


module.exports = CSSIncluder
