Path = require 'path'
URL  = require 'url'

Class     = require './class'
Document  = require './object/document'
Null      = require './object/null'
Function  = require './object/function'
Evaluator = require './evaluator'

ImportError = require './error/import'

class Context extends Class

  uri: null

  constructor: (@_parent = null, @block = new Document) ->
    @_scope = {}
    @_plugins = []
    @_importers = []
    @_loaders = []
    @_paths = []
    @_visitors = []

  @property 'parent',
    get: -> @_parent

  @property 'plugins',
    get: ->
      (if @parent then @parent.plugins else []).concat @_plugins

  @property 'importers',
    get: ->
      (if @parent then @parent.importers else []).concat @_importers

  @property 'loaders',
    get: ->
      (if @parent then @parent.loaders else []).concat @_loaders

  @property 'paths',
    get: ->
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

    throw new ImportError "Could not load \"#{uri}\""

  useImporter: (importer) ->
    @_importers.push importer

  canImport: (uri) ->
    @importers.some (importer) => importer.canImport uri, @

  resolveURI: (uri) ->

  import: (uri) ->
    for path in @paths by -1
      auri = URL.resolve path, uri

      for importer in @importers
        if importer.canImport auri, @

          try
            return importer.import auri, @
          catch
            # TODO Check thrown exception is ImportError or re-throw it
            # otherwise
            continue


      break # We don't allow more than one path where to look for at the moment

    throw new ImportError "Could not import \"#{uri}\""

  useVisitor: (visitor) ->
    @_visitors.push visitor

  uses: (plugin) ->
    (plugin in @_plugins) or (@parent and @parent.uses plugin) or no

  use: (plugins...) ->
    for plugin in plugins
      unless @uses plugin
        @_plugins.push plugin
        plugin.use @

  evaluate: (node, context = @) ->
    (new Evaluator).evaluateNode node, context

  fork: (block = @block) ->
    @clone @, block

module.exports = Context
