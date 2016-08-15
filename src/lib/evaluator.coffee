# 3rd party
fs            = require 'fs'
path          = require 'path'

Class         = require './class'
Parser        = require './parser'
Plugin        = require './plugin'
Context       = require './context'
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

TypeError     = require './error/type'
RuntimeError  = require './error/runtime'
InternalError = require './error/internal'

class Evaluator extends Class

  ###
  ###
  evaluateNode: (node, context) ->
    if node
      method = "evaluate#{node.type}"
      if method of this
        return this[method].call this, node, context

    unless node instanceof Object
      throw new InternalError "Don't know how to evaluate node #{node.type}"

    return node

  ###
  ###
  evaluateLiteralColor: (node, context) ->
    new Color node.value

  ###
  ###
  evaluateLiteralString: (node, context) ->
    value = ''

    for chunk in [].concat node.value
      if typeof chunk is 'string'
        value += chunk
      else
        val = @evaluateNode chunk, context
        value += val.toString()

    new String value, node.quote

  ###
  ###
  evaluateLiteralThis: (node, context) -> context.block

  ###
  ###
  evaluateLiteralUnicodeRange: (node, context) ->
    new String node.value.toUpperCase(), ''

  ###
  ###
  evaluateLiteralURL: (node, context) ->
    val = @evaluateNode node.value, context
    new URL val.value, val.quote

  ###
  ###
  evaluateIdent: (node, context) ->
    switch node.value
      when 'true'
        Boolean.true
      when 'false'
        Boolean.false
      when 'null'
        Null.null
      else
        if context.has node.value
          if node.arguments?
            args = (@evaluateNode arg, context for arg in node.arguments)
          else
            args = []
          val = context.get node.value, args...

          if val instanceof Function
            val = val.invoke context.block, args...

        else
          val = new String node.value, null

        val

  ###
  ###
  evaluateLiteralNumber: (node) ->
    new Number node.value, node.unit?.value

  ###
  ###
  evaluateLiteralRegExp: (node, context) ->
    new RegExp node.value, node.flags

  ###
  ###
  evaluateLiteralFunction: (node, context) ->
    body = node.block.body
    in_args = node.arguments

    new Function (block, args...) =>
      try
        ctx = context.fork block
        l = in_args.length

        for arg, i in args
          if i < l
            ctx.set in_args[i].name, arg
          else
            break

        for d in [i...in_args.length]
          if in_args[d].value
            value = @evaluateNode in_args[d].value, ctx
          else
            value = Null.null
          ctx.set in_args[d].name, value

        @evaluateBody body, ctx
        return

      catch e
        if e instanceof Object
          return e
        else
          throw e

  ###
  ###
  evaluateGroup: (node, context) ->
    @evaluateNode node.expression, context

  ###
  ###
  evaluateLiteralList: (node, context) ->
    items = (@evaluateNode item, context for item in node.body)
    new List items, node.separator

  ###
  ###
  evaluateUnaryOperation: (node, context) ->
    (@evaluateNode node.right, context).operate "#{node.operator}@"

  ###
  TODO Reimplement this mess as a Node methods
  ###
  evaluateBinaryOperation: (node, context) ->
    switch node.operator
      when '=', '|='
        @evaluateAssignment node, context

      when '.'
        left = @evaluateNode node.left, context

        if node.right instanceof Ident
          if node.right.arguments?
            args = (
              @evaluateNode arg, context for arg in node.right.arguments
            )
          else
            args = []

          (left['.'] node.right.name, args...) or Null.null
        else
          throw new Error "Bad right side of `.` operation"

      when '::'
        left = @evaluateNode node.left, context

        if node.right instanceof Ident
          if node.right.arguments?
            throw new Error "Bad right side of `::` operation"
          right = new String node.right.value
        else
          right = @evaluateNode node.right, context

        (left['.::'] right) or Null.null

      when '('
        left = @evaluateNode node.left, context
        unless left instanceof Function
          throw new ReferenceError "Call to non-function"

        args = (@evaluateNode arg, context for arg in node.right)

        ret = left.invoke.call left, context.block, args...
        ret or Null.null

      else
        left = @evaluateNode node.left, context
        right = @evaluateNode node.right, context
        left.operate node.operator, right

  evaluateOperation: (node, context) ->
    if node.right and node.left
      @evaluateBinaryOperation node, context
    else
      @evaluateUnaryOperation node, context

  isReference: (node) ->
    (node instanceof Operation) and
    node.binary and
    (node.operator is '.' or node.operator is '::')

  ###
  TODO Refactor!
  Maybe the left node SHOULD be evaluated, but maybe in a new scope,
  so existing defined factors on current scope are not applied
  ###
  evaluateUnitAssignment: (node, context) ->
    value = parseFloat node.left.value
    unit = node.left.unit.value

    unless unit and value isnt 0
      throw new Error "Bad unit definition"

    unless node.operator is '|=' and Number.isDefined unit
      right = (@evaluateNode node.right, context)

      unless right.unit and right.value isnt 0
        throw new Error "Bad unit definition"

      # This is a temporary hack, because units are not scoped yet
      left = new Number value
      left.unit = unit

      Number.define left, right, yes

    @evaluateNode node.left, context

  ###
  ###
  evaluateAssignment: (node, context) ->
    getter = setter = null

    {left, right} = node

    if left instanceof LiteralNumber
      return @evaluateUnitAssignment node, context

    if left instanceof Ident
      name = left.value
      getter = context.get.bind context, name
      setter = context.set.bind context, name
    else if @isReference left
      name = @evaluateNode left.right, context

      ref = @evaluateNode left.left, context

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

    value = @evaluateNode right, context
    setter value
    value

  ###
  ###
  evaluateConditional: (node, context) ->
    met = not node.condition or
          (@evaluateNode node.condition, context).toBoolean()

    if met isnt node.negate
      @evaluateBody node.block.body, context
    else if node.elses
      for els in node.elses
        met = not els.condition or
              (@evaluateNode els.condition, context).toBoolean()

        if met isnt els.negate
          @evaluateBody els.block.body, context
          break

    return #undefined

  evaluateControlFlowDirective: (node, context) ->
    switch node.arguments.length
      when 0
        depth = 1
      when 1
        depth = @evaluateNode node.arguments[0], context
        unless (depth instanceof Number) and depth > 0
          throw new Error "Bad argument for a `#{node.name}`"
        depth = parseInt depth.value, 10
      else
        throw new TypeError "Too many arguments for a `#{node.name}`"

    node.depth = depth
    throw node

  evaluateContinue: (node, context) ->
    @evaluateControlFlowDirective node, context

  evaluateBreak: (node, context) ->
    @evaluateControlFlowDirective node, context

  evaluateReturn: (node, context) ->
    if node.arguments.length is 0
      throw Null.null
    else if node.arguments.length > 1
      throw new TypeError "Too many arguments for a `return`"

    throw @evaluateNode node.arguments[0], context

  ###
  ###
  evaluateFor: (node, context) ->
    expression = @evaluateNode node.expression, context

    expression.each (key, value) =>
      context.set node.value.value, value

      if node.key?
        context.set node.key.value, key

      try
        @evaluateBody node.block.body, context
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
  evaluateLoop: (node, context) ->
    loop
      try
        if node.condition
          met = (@evaluateNode node.condition, context).toBoolean()
          if met is node.negate
            break
        @evaluateBody node.block.body, context
      catch e
        if e instanceof Directive
          if e.name == 'break'
            break unless --e.depth > 0
          else if e.name == 'continue'
            continue unless --e.depth > 0
        throw e

    return #undefined

  ###
  ###
  evaluateImport: (node, context) ->
    for arg in node.arguments
      file = @evaluateNode arg, context

      unless file instanceof URL or file instanceof String
        throw new Error "Bad argument for `import`"

      path = file.value

      context.import path

    Null.null

  ###
  ###
  evaluateUse: (node, context) ->
    for arg in node.arguments
      name = @evaluateNode arg
      unless name instanceof String
        throw new Error "Bad argument for `use`"
      @layla.use name.value

    Null.null

  evaluateDirective: (node, context) ->
    switch node.name
      when 'use'
        @evaluateUse node, context
      when 'import'
        @evaluateImport node, context
      when 'return'
        @evaluateReturn node, context
      when 'break'
        @evaluateBreak node, context
      when 'continue'
        @evaluateContinue node, context

  ###
  ###
  evaluatePropertyDeclaration: (node, context) ->
    value = (@evaluateNode node.value, context).clone()

    for name in node.names
      name = (@evaluateNode name, context)
      continue if node.conditional and context.block.hasProperty(name.value)
      property = new Property name.value, value
      context.block.items.push property

    property

  ###
  ###
  evaluateBody: (body, context) ->
    @evaluateNode node, context for node in body

  ###
  ###
  evaluateLiteralBlock: (node, context) ->
    block = new Block
    ctx = context.fork block
    @evaluateBody node.body, ctx
    block

  evaluateSelector: (selector, context) ->
    if context.block instanceof RuleSet
      ret = []
      for sel in selector
        if 0 > sel.indexOf '&'
          sel = "& #{sel}"
        for psel in context.block.selector
          ret.push sel.replace /&/g, psel
      ret
    else
      (sel for sel in selector)

  ###
  ###
  evaluateRuleSetDeclaration: (node, context) ->
    rule = new RuleSet
    context.block.items.push rule
    rule.selector = @evaluateSelector node.selector, context
    ctx = context.fork rule
    @evaluateBody node.block.body, ctx
    rule

  ###
  ###
  evaluateAtRuleDeclaration: (node, context) ->
    rule = new AtRule
    context.block.items.push rule
    rule.name = (@evaluateLiteralString node.name, context).value
    rule.arguments = node.arguments

    ctx = context.fork rule

    if node.block
      (@evaluateBody node.block.body, ctx)
    else
      rule.block = null

    rule

  ###
  ###
  evaluateRoot: (node, context = new Context) ->
    @evaluateBody node.body, context
    context.block

module.exports = Evaluator
