Class      = require './class'
Parser     = require './parser/base'
Context    = require './context'
Evaluator  = require './evaluator'
Emitter    = require './emitter'
CSSEmitter = require './emitter/css'
CLIEmitter = require './emitter/cli'
Node       = require './node'
Object     = require './object'
Document   = require './object/document'
String     = require './object/string'
Error      = require './error'
Normalizer = require './css/normalizer'
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

  # Core methods
  parse: (source) ->
    @parser.parse source

  evaluate: (node, context = @context) ->
    node = @parse node unless node instanceof Node
    @evaluator.evaluate node, context

  normalize: (node) -> @normalizer.normalize node

  emit: (node) -> @emitter.emit node

  # This is a shortcut subject to deprecation
  compile: (source, file = null) ->
    @emit @normalize @evaluate @parse source, file

module.exports = Layla
