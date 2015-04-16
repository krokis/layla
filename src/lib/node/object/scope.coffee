Object   = require '../object'
Null     = require './null'
Function = require './function'

class Scope extends Object

  parent: null
  names: null
  paths: null

  constructor: (@parent = null) ->
    @names = {}
    @paths = []

    if @parent
      @paths.push @parent.paths...

  get: (name, self, args...) ->
    if name of @names
      if @names[name] instanceof Function
        (@names[name].invoke self, args...) || Null.null
      else
        @names[name]
    else if @parent
      @parent.get name, self, args...
    else
      Null.null

  set: (name, value) ->
    @names[name] = value.clone()

  has: (name) ->
    (name of @names) or (@parent?.has name) or no

  clone: ->
    that = new Scope
    that.parent = this
    that

module.exports = Scope
