Path = require 'path'
URL  = require 'url'

Class        = require './class'
Document     = require './object/document'
Null         = require './object/null'
Function     = require './object/function'
Evaluator    = require './evaluator'
IncludeError = require './error/include'



###
###
class Context extends Class

  ###
  ###
  constructor: (@block = new Document, @_parent = null) ->
    super()

    @_scope = {}
    @_plugins = []
    @_includers = []
    @_loaders = []
    @_paths = []
    @_visitors = []
    @stack = @_parent?.stack or []

  @property 'parent', -> @_parent

  @property 'root', -> if @parent then @parent.root else @

  @property 'plugins', ->
    (if @parent then @parent.plugins else []).concat @_plugins

  @property 'includers', ->
    (if @parent then @parent.includers else []).concat @_includers

  @property 'loaders', ->
    (if @parent then @parent.loaders else []).concat @_loaders

  @property 'paths', ->
    (if @parent then @parent.paths else []).concat @_paths

  has: (name) ->
    (name of @_scope) or (@parent?.has name) or no

  get: (name, args...) ->
    if name of @_scope
      @_scope[name]
    else if @parent
      @parent.get name, args...
    else
      Null.null

  set: (name, value) ->
    @_scope[name] = value.clone()

  useLoader: (loader) ->
    @_loaders.push loader

  pushPath: (uri) ->
    uri = uri.trim()
    uri += Path.sep unless uri[-1..] in ['/', '\\']
    @_paths.push uri

  popPath: ->
    @_paths.pop()

  canLoad: (uri) ->
    @loaders.some (loader) => loader.canLoad uri, @

  load:(uri) ->
    for loader in @loaders
      if loader.canLoad uri, @
        return loader.load uri, @

    throw new IncludeError "Could not load \"#{uri}\""

  useIncluder: (includer) ->
    @_includers.push includer

  canInclude: (uri) ->
    @includers.some (includer) => includer.canInclude uri, @

  resolveURI: (uri) ->
    if not @paths.length
      return  uri

    base_uri = @paths[@paths.length - 1]

    return URL.resolve base_uri, uri

  include: (uri) ->
    abs_uri = @resolveURI uri

    for includer in @includers
      if includer.canInclude abs_uri, @
        res = includer.include abs_uri, @

        return res

    throw new IncludeError "Could not include \"#{uri}\""

  useVisitor: (visitor) ->
    @_visitors.push visitor

  visit: (node) ->

  uses: (plugin) ->
    (plugin in @_plugins) or (@parent and @parent.uses plugin) or no

  use: (plugins...) ->
    for plugin in plugins
      unless @uses plugin
        @_plugins.push plugin
        plugin.use @

  evaluate: (program, context = @) ->
    (new Evaluator).evaluate program, context

  child: (block = @block) ->
    new Context block, @


module.exports = Context
