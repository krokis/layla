# 3rd party
fs            = require 'fs'
path          = require 'path'

Class         = require './class'
Parser        = require './parser'
Plugin        = require './plugin'
Expression    = require './node/expression'
Operation     = require './node/expression/operation'
Ident         = require './node/expression/ident'
LiteralNumber = require './node/expression/literal/number'
Directive     = require './node/statement/directive'
Object        = require './object'
Document      = require './object/document'
List          = require './object/list'
Block         = require './object/block'
Number        = require './object/number'
RegExp        = require './object/regexp'
Boolean       = require './object/boolean'
String        = require './object/string'
Null          = require './object/null'
Range         = require './object/range'
Function      = require './object/function'
URL           = require './object/url'
Color         = require './object/color'
Property      = require './object/property'
RuleSet       = require './object/rule-set'
AtRule        = require './object/at-rule'
Scope         = require './object/scope'

TypeError     = require './error/type'
RuntimeError  = require './error/runtime'
InternalError = require './error/internal'

class Evaluator extends Class

  constructor: (@layla, scope) ->

  ###
  ###
  evaluateNode: (node, self, scope) ->
    if node
      method = "evaluate#{node.type}"
      if method of this
        return this[method].call this, node, self, scope

    unless node instanceof Object
      throw new InternalError "Don't know how to evaluate node #{node.type}"

    return node

  ###
  TODO: allow interpolation here?
  col = #`'a2f'`
  ###
  evaluateLiteralColor: (node, self, scope) ->
    hex = node.value.substr 1
    alpha = 255

    switch hex.length
      when 1
        red = green = blue = 17 * parseInt hex, 16
      when 2
        red = green = blue = parseInt hex, 16
      when 3, 4
        red   = 17 * parseInt hex[0], 16
        green = 17 * parseInt hex[1], 16
        blue  = 17 * parseInt hex[2], 16
        if hex.length > 3
          alpha = 17 * parseInt hex[3], 16
      when 6, 8
        red   = parseInt (hex.substr 0, 2), 16
        green = parseInt (hex.substr 2, 2), 16
        blue  = parseInt (hex.substr 4, 2), 16
        if hex.length > 6
          alpha = parseInt (hex.substr 6, 2), 16
      else
        throw new InternalError "something"

    new Color red / 255, green / 255, blue / 255, alpha / 255

  ###
  ###
  evaluateLiteralString: (node, self, scope) ->
    value = ''

    for chunk in [].concat node.value
      if typeof chunk is 'string'
        value += chunk
      else
        val = @evaluateNode chunk, self, scope
        value += val.toString()

    new String value, node.quote

  ###
  ###
  evaluateLiteralThis: (node, self, scope) -> self

  ###
  ###
  evaluateLiteralURL: (node, self, scope) ->
    val = @evaluateNode node.value, self, scope
    new URL val.value, val.quote

  ###
  ###
  evaluateIdent: (node, self, scope) ->
    switch node.value
      when 'true'
        Boolean.true
      when 'false'
        Boolean.false
      when 'null'
        Null.null
      else
        if scope.has node.value
          if node.arguments?
            args = (@evaluateNode arg, self, scope for arg in node.arguments)
          else
            args = []
          (scope.get node.value, self, args...) or Null.null
        else
          new String node.value, null

  ###
  ###
  evaluateLiteralNumber: (node) ->
    new Number node.value, node.unit?.value
    # TODO:
    # new Number node.value, node.unit.value or ''

  ###
  ###
  evaluateLiteralRegExp: (node, self, scope) ->
    new RegExp node.value, node.flags

  ###
  ###
  evaluateLiteralFunction: (node, self, scope) ->
    block = node.block
    in_args = node.arguments

    new Function (self, args...) =>
      try
        scp = new Scope scope

        l = in_args.length

        for arg, i in args
          if i < l
            scp.set in_args[i].name, arg
          else
            break

        for d in [i...in_args.length]
          if in_args[d].value
            value = @evaluateNode in_args[d].value, self, scp
          else
            value = Null.null
          scp.set in_args[d].name, value

        @evaluateBody block.body, self, scp
        return

      catch e
        if e instanceof Object
          return e
        else
          throw e

  ###
  ###
  evaluateGroup: (node, self, scope) ->
    @evaluateNode node.expression, self, scope

  ###
  ###
  evaluateLiteralList: (node, self, scope) ->
    items = (@evaluateNode item, self, scope for item in node.body)
    new List items, node.separator

  ###
  ###
  evaluateUnaryOperation: (node, self, scope) ->
    (@evaluateNode node.right, self, scope).operate "#{node.operator}@"

  ###
  TODO Reimplement this mess as a Node methods
  ###
  evaluateBinaryOperation: (node, self, scope) ->
    switch node.operator
      when '=', '|='
        @evaluateAssignment node, self, scope

      when '.'
        left = @evaluateNode node.left, self, scope

        if node.right instanceof Ident
          if node.right.arguments?
            args = (
              @evaluateNode arg, self, scope for arg in node.right.arguments
            )
          else
            args = []

          (left['.'] node.right.name, args...) or Null.null
        else
          throw new Error "Bad right side of `.` operation"

      when '::'
        left = @evaluateNode node.left, self, scope

        if node.right instanceof Ident
          if node.right.arguments?
            throw new Error "Bad right side of `::` operation"
          right = new String node.right.value
        else
          right = @evaluateNode node.right, self, scope

        (left['.::'] right) or Null.null

      when '('
        left = @evaluateNode node.left, self, scope
        unless left instanceof Function
          throw new ReferenceError "Call to non-function"

        args = (@evaluateNode arg, self, scope for arg in node.right)

        ret = left.invoke.call left, self, args...
        ret or Null.null

      else
        left = @evaluateNode node.left, self, scope
        right = @evaluateNode node.right, self, scope
        left.operate node.operator, right

  evaluateOperation: (node, self, scope) ->
    if node.right and node.left
      @evaluateBinaryOperation node, self, scope
    else
      @evaluateUnaryOperation node, self, scope

  isReference: (node) ->
    (node instanceof Operation) and
    node.binary and
    (node.operator is '.' or node.operator is '::')

  ###
  TODO Refactor!
  Maybe the left node SHOULD be evaluated, but maybe in a new scope,
  so existing defined factors on current scope are not applied
  ###
  evaluateUnitAssignment: (node, self, scope) ->
    value = parseFloat node.left.value
    unit = node.left.unit.value

    unless unit and value isnt 0
      throw new Error "Bad unit definition"

    unless node.operator is '|=' and Number.isDefined unit
      right = (@evaluateNode node.right, self, scope)

      unless right.unit and right.value isnt 0
        throw new Error "Bad unit definition"

      # This is a temporary hack, because units are not scoped yet
      left = new Number value
      left.unit = unit

      Number.define left, right, yes

    @evaluateNode node.left, self, scope

  ###
  ###
  evaluateAssignment: (node, self, scope) ->
    getter = setter = null

    {left, right} = node

    if left instanceof LiteralNumber
      return @evaluateUnitAssignment node, self, scope

    if left instanceof Ident
      name = left.value
      getter = scope.get.bind scope, name
      setter = scope.set.bind scope, name
    else if @isReference left
      name = @evaluateNode left.right, self, scope

      ref = @evaluateNode left.left, self, scope

      if left.operator is '.'
        getter = ref['.'].bind ref, name
        setter = ref['.='].bind ref, name
      else
        getter = ref['.::'].bind ref, name
        setter = ref['.::='].bind ref, name

    unless setter
      throw new TypeError "Bad left side of assignment"

    if node.operator is '|='
      if getter
        curr = getter()
        return curr unless curr.isNull()

    value = (@evaluateNode right, self, scope).clone()
    setter value
    value

  ###
  ###
  evaluateWith: (node, self, scope) ->
    self = @evaluateNode node.reference, self, scope
    unless self instanceof Block
      throw new RuntimeError "Can only use `with` with blocks"
    @evaluateBody node.body, self, scope
    self

  ###
  ###
  evaluateConditional: (node, self, scope) ->
    met = not node.condition or
          (@evaluateNode node.condition, self, scope).toBoolean()

    if met isnt node.negate
      @evaluateBody node.block.body, self, scope
    else if node.elses
      for els in node.elses
        met = not els.condition or
              (@evaluateNode els.condition, self, scope).toBoolean()

        if met isnt els.negate
          @evaluateBody els.block.body, self, scope
          break

    return #undefined

  evaluateControlFlowDirective: (node, self, scope) ->
    switch node.arguments.length
      when 0
        depth = 1
      when 1
        depth = @evaluateNode node.arguments[0], self, scope
        unless (depth instanceof Number) and depth > 0
          throw new Error "Bad argument for a `#{node.name}`"
        depth = parseInt depth.value, 10
      else
        throw new TypeError "Too many arguments for a `#{node.name}`"

    node.depth = depth
    throw node

  evaluateContinue: (node, self, scope) ->
    @evaluateControlFlowDirective node, self, scope

  evaluateBreak: (node, self, scope) ->
    @evaluateControlFlowDirective node, self, scope

  evaluateReturn: (node, self, scope) ->
    unless node.arguments.length is 1
      throw new TypeError "Too many arguments for a `return`"

    throw @evaluateNode node.arguments[0], self, scope

  ###
  ###
  evaluateFor: (node, self, scope) ->
    expression = @evaluateNode node.expression, self, scope

    expression.each (key, value) =>
      scope.set node.value.value, value

      if node.key?
        scope.set node.key.value, key

      try
        @evaluateBody node.block.body, self, scope
      catch e
        if e instanceof Directive
          if e.name == 'break'
            return no unless --e.depth > 0
          else if e.name == 'continue'
            return unless --e.depth > 0
        throw e

    return # undefined

  ###
  ###
  evaluateLoop: (node, self, scope) ->
    loop
      try
        if node.condition
          met = (@evaluateNode node.condition, self, scope).toBoolean()
          if met is node.negate
            break
        @evaluateBody node.block.body, self, scope
      catch e
        if e instanceof Directive
          if e.name == 'break'
            break unless --e.depth > 0
          else if e.name == 'continue'
            continue unless --e.depth > 0
        throw e

    return #undefined

  resolvePath: (path, base) ->
    path

  doImportFile: (file, self, scope) ->
    source = fs.readFileSync file, 'utf-8'
    ast = @layla.parse source
    scope.paths.push path.dirname file
    imported = @evaluateRoot ast, self, scope
    scope.paths.pop()

  importFile: (file, self, scope) ->
    for p in scope.paths
      real_path = path.join p, file

      if fs.existsSync real_path
        return @doImportFile real_path, self, scope

    throw new RuntimeError "Could not import file: \"#{file}\""

  ###
  ###
  evaluateImport: (node, self, scope) ->
    for arg in node.arguments
      [name, file] = arg

      file = @evaluateNode file, self, scope

      unless file instanceof URL or file instanceof String
        throw new Error "Bad argument for `import`"

      file = file.value
      real_path = @resolvePath file

      if name isnt '&'
        _self = new Block
      else
        _self = self

      @importFile real_path, _self, scope

      if name isnt '&'
        scope.set name, _self

    Null.null

  ###
  ###
  evaluateUse: (node, self, scope) ->
    for arg in node.arguments
      name = @evaluateNode arg
      unless name instanceof String
        throw new Error "Bad argument for `use`"
      @layla.use name.value

    Null.null

  evaluateDirective: (node, self, scope) ->
    switch node.name
      when 'use'
        @evaluateUse node, self, scope
      when 'import'
        @evaluateImport node, self, scope
      when 'return'
        @evaluateReturn node, self, scope
      when 'break'
        @evaluateBreak node, self, scope
      when 'continue'
        @evaluateContinue node, self, scope

  ###
  ###
  evaluatePropertyDeclaration: (node, self, scope) ->
    value = (@evaluateNode node.value, self, scope).clone()

    for name in node.names
      name = (@evaluateNode name, self, scope)

      continue if node.conditional and self.hasProperty(name.value)

      property = new Property name.value, value
      self.items.push property

    property

  ###
  ###
  evaluateBody: (body, self, scope) ->
    @evaluateNode node, self, scope for node in body

  ###
  ###
  evaluateLiteralBlock: (node, self, scope) ->
    block = new Block
    @evaluateBody node.body, block, scope
    block

  evaluateSelector: (selector, self, scope) ->
    if self instanceof RuleSet
      ret = []
      for sel in selector
        if 0 > sel.indexOf '&'
          sel = "& #{sel}"
        for psel in self.selector
          ret.push sel.replace /&/g, psel
      ret
    else
      (sel for sel in selector)

  ###
  ###
  evaluateRuleSetDeclaration: (node, self, scope) ->
    rule = new RuleSet
    self.items.push rule
    rule.selector = @evaluateSelector node.selector, self, scope
    @evaluateBody node.block.body, rule, scope
    rule

  ###
  ###
  evaluateAtRuleDeclaration: (node, self, scope) ->
    rule = new AtRule
    self.items.push rule
    rule.name = (@evaluateLiteralString node.name, self, scope).value
    rule.arguments = node.arguments

    if node.block
      (@evaluateBody node.block.body, rule, scope)
    else
      rule.block = null

    rule

  ###
  ###
  evaluateRoot: (node, self = null, scope = null) ->
    self ?= new Document
    scope ?= new Scope
    @evaluateBody node.body, self, scope
    self

module.exports = Evaluator
