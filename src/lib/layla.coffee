Class      = require './class'
Parser     = require './parser/lay'
Context    = require './context'
Evaluator  = require './evaluator'
Emitter    = require './emitter'
Node       = require './ast/node'
Object     = require './object'
Document   = require './object/document'
String     = require './object/string'
Error      = require './error'
CSS        = require '../css'
Normalizer = require '../css/normalizer'
CSSEmitter = require '../css/emitter'
VERSION    = require './version'


## TODO Remove this entire class?
class Layla

  # Library version
  @version: VERSION

  # Core classes
  @Class: Class
  @Node: Node
  @Object: Object
  @Document: Document
  @String: String
  @Parser: Parser
  @Evaluator: Evaluator
  @Emitter: Emitter
  @Normalizer: Normalizer
  @Context: Context
  @Error: Error

  ###
  ###
  constructor: (@context = new Context) ->
    @parser = new Parser
    @evaluator = new Evaluator
    @normalizer = new Normalizer
    @emitter = new CSSEmitter
    @context.use new CSS

  # Core methods
  parse: (source) ->
    @parser.parse source

  evaluate: (program, context = @context) ->
    @evaluator.evaluate program, context

  normalize: (node) -> @normalizer.normalize node

  emit: (node) -> @emitter.emit node

  # This is a shortcut subject to deprecation
  compile: (program, file = null) ->
    unless program instanceof Node
      program = @parse program, file

    @evaluate program

    return @emit @normalize(@context.block)


module.exports = Layla
