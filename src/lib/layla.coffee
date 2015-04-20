VERSION    = require '../version'

Class      = require './class'
Parser     = require './parser'
Evaluator  = require './evaluator'
Normalizer = require './visitor/normalizer'
Emitter    = require './emitter'
CSSEmitter = require './emitter/css'
Plugin     = require './plugin'
Node       = require './node'
Object     = require './object'
String     = require './object/string'
Error      = require './object/scope'
Scope      = require './object/scope'

class Layla

  # Library version
  @version: VERSION

  # Core classes
  @Class: Class
  @Node: Node
  @Object: Object
  @String: String
  @Parser: Parser
  @Evaluator: Evaluator
  @Emitter: Emitter
  @Normalizer: Normalizer
  @Scope: Scope
  @Error: Error

  ###
  ###
  constructor: ->
    @scope = new Scope
    @plugins = {}
    @parser = new Parser @
    @evaluator = new Evaluator @, @scope
    @normalizer = new Normalizer
    @emitter = new CSSEmitter

  register: (plugin, name) ->
    name ?= plugin.name.toLowerCase()

    if name of @plugins
      unless this is @plugins[name]
        throw new Error "\
          Cannot register plugin '#{name}': that name has already been used"

    @plugins[name] = plugin

  ###
  Use one or more plugins on this instance.
  ###
  use: (plugins...) ->
    for kind in plugins
      if kind.prototype instanceof Plugin
        plugin = new kind
        plugin.use this
      else if ('[object String]' is @toString.call kind)
        if kind of @plugins
          @use @plugins[kind]
        else
          mod_name = "layla-#{kind}"
          try
            require mod_name
          catch e
            throw new Error "Could not load plugin: #{kind}"
      else if kind instanceof Array
        @use kind...
      else if kind instanceof Object
        @use kind[k] for k of kind
      else
        throw new TypeError "That's not a plugin"

  # Core methods
  parse: (source) ->
    @parser.parse source

  evaluate: (node, scope = @scope) ->
    @evaluator.evaluate node, scope

  emit: (node) ->
    node = @normalizer.normalize node
    @emitter.emit node

module.exports = Layla
