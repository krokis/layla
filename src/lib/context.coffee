Class = require './class'
Scope = require './scope'

class Context extends Class
  constructor: (@self, @scope = new Scope) ->

module.exports = Context
