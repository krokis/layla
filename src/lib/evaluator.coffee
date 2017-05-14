fs   = require 'fs'
path = require 'path'


###
Note not all of these classes are being actually used here. But many of them
monkey-patche others (so they can live in separate files without circular
imports), so they all need to be `require`d in order to have the chance to
"register" their methods.

TODO Should we define this "stdlib" somewhere else (as a list of all built-in
classes -- or a plugin)?
###
Class                 = require './class'
Parser                = require './parser/lay'
Plugin                = require './plugin'
Context               = require './context'
Node                  = require './node'
Expression            = require './node/expression'
Operation             = require './node/expression/operation'
Group                 = require './node/expression/group'
Literal               = require './node/expression/literal'
LiteralString         = require './node/expression/string'
LiteralNumber         = require './node/expression/number'
LiteralCalc           = require './node/expression/calc'
Directive             = require './node/statement/directive'
PropertyDeclaration   = require './node/statement/property'
Root                  = require './node/root'
Object                = require './object'
Enumerable            = require './object/enumerable'
Document              = require './object/document'
List                  = require './object/list'
Block                 = require './object/block'
Number                = require './object/number'
RegExp                = require './object/regexp'
Boolean               = require './object/boolean'
String                = require './object/string'
QuotedString          = require './object/string/quoted'
UnquotedString        = require './object/string/unquoted'
RawString             = require './object/string/raw'
Null                  = require './object/null'
Range                 = require './object/range'
Function              = require './object/function'
DataURI               = require './object/data-uri'
URL                   = require './object/url'
Color                 = require './object/color'
Property              = require './object/property'
Call                  = require './object/call'
Calc                  = require './object/calc'
RuleSet               = require './object/rule-set'
AtRule                = require './object/at-rule'
UniversalSelector     = require './object/selector/universal'
TypeSelector          = require './object/selector/type'
ParentSelector        = require './object/selector/parent'
IdSelector            = require './object/selector/id'
ClassSelector         = require './object/selector/class'
AttributeSelector     = require './object/selector/attribute'
PseudoClassSelector   = require './object/selector/pseudo-class'
PseudoElementSelector = require './object/selector/pseudo-element'
Combinator            = require './object/selector/combinator'
KeyframeSelector      = require './object/selector/keyframe'
CompoundSelector      = require './object/selector/compound'
ComplexSelector       = require './object/selector/complex'
SelectorList          = require './object/selector/list'
RuntimeError          = require './error/runtime'
ValueError            = require './error/value'
ReferenceError        = require './error/reference'
InternalError         = require './error/internal'


###
###
class Evaluator extends Class

  error: (cls, msg, node, context, stack = context.stack) ->
    throw new cls msg, node.start, node.end, stack.slice()

  runtimeError: (msg, node, context) ->
    @error RuntimeError, msg, node, context

  valueError: (msg, node, context) ->
    @error ValueError, msg, node, context

  referenceError: (msg, node, context) ->
    @error ReferenceError, msg, node, context

  ###
  ###
  evaluateNode: (node, context) ->
    if node
      method = "evaluate#{node.type}"

      if method of @
        try
          return @[method] node, context
        catch e
          e.location or= node.start
          e.stack ?= [].concat context.stack

          throw e

    unless node instanceof Object
      throw new InternalError "Don't know how to evaluate node #{node.type}"

    return node

  ###
  ###
  evaluateColor: (node, context) ->
    Color.parse node.value

  evaluateSequence: (pieces, context) ->
    value = ''

    for piece in pieces
      if typeof piece is 'string'
        value += piece
      else
        # TODO :S
        if piece instanceof Root
          val = @evaluateBody piece.body, context
        else
          val = @evaluateNode piece, context

        value += val.toString()

    return value


  getStringValue: (node, context) ->
    pieces = [].concat node.value

    return @evaluateSequence pieces, context

  ###
  ###
  evaluateString: (node, context) ->
    value = @getStringValue node, context

    if node.quote
      str = new QuotedString
    else if node.raw
      str = new RawString
    else
      dollar = value[0] is '$'

      if context.has value
        return context.get value
      else if dollar
        @referenceError "Undefined variable: `#{value}`", node, context
      else
        str = new UnquotedString

    str.value = value

    return str

  ###
  ###
  evaluateThis: (node, context) -> context.block

  ###
  ###
  evaluateUnicodeRange: (node, context) ->
    new RawString (@getStringValue node, context).toUpperCase()

  evaluateCalcLiteral: (node, context) ->
    if node instanceof LiteralCalc
      return '(' + @evaluateCalcExpression(node.expression) + ')'

    value = @evaluateNode(node, context)

    return value.toString()

  evaluateCalcUnaryOperation: (node, context) ->
    " #{node.operator}" + @evaluateCalcExpression(node.right)

  evaluateCalcBinaryOperation: (node, context) ->
    @evaluateCalcExpression(node.left, context) +
    " #{node.operator} " +
    @evaluateCalcExpression(node.right, context)

  evaluateCalcOperation: (node, context) ->
    if node.binary
      @evaluateCalcBinaryOperation node, context
    else
      @evaluateCalcUnaryOperation node, context

  evaluateCalcGroup: (node, context) ->
    '(' + @evaluateCalcExpression(node.expression) + ')'

  evaluateCalcExpression: (node, context) ->
    if node instanceof Group
      @evaluateCalcGroup node, context
    else if node instanceof Operation
      @evaluateCalcOperation node, context
    else if node instanceof Literal
      @evaluateCalcLiteral node, context
    else
      throw new Error "Bad calc()!"

  ###
  ###
  evaluateCalc: (node, context) ->
    expr = @evaluateCalcExpression node.expression, context

    return new Calc node.name, expr

  ###
  ###
  evaluateCall: (node, context) ->
    name = @getStringValue(node.name, context).toLowerCase()
    args = (@evaluateNode arg, context for arg in node.arguments)

    return @_evaluateCall name, args, context

  ###
  ###
  _evaluateCall: (name, args, context) ->
    switch name
      when 'url', 'url-prefix'
        uri = args[0]?.value or ''

        if uri[0...5].trim().toLowerCase() is 'data:'
          obj = new DataURI uri
        else
          obj = new URL uri

        obj.name = name
      when 'regexp'
        obj = new RegExp args[0]?.value or null
      else
        obj = new Call name, args

    return obj

  ###
  ###
  evaluateNumber: (node) ->
    new Number node.value, node.unit

  ###
  ###
  evaluateRegExp: (node, context) ->
    new RegExp node.value, node.flags

  ###
  ###
  evaluateFunction: (node, context) ->
    body = node.block.body

    in_args = []
    rest_arg = null

    for arg in node.arguments
      if arg[2]
        rest_arg = arg[0]
      else
        in_args.push arg

    return new Function (caller, args...) =>
      try
        ctx = context.child caller.block
        l = in_args.length

        for arg, i in args
          if i < l
            ctx.set in_args[i][0], arg
          else
            break

        for d in [i...in_args.length]
          if in_args[d][1]
            value = @evaluateNode in_args[d][1], ctx
          else
            value = Null.null

          ctx.set in_args[d][0], value

        if rest_arg
          rest = new List args[in_args.length...]
          ctx.set rest_arg, rest

        @evaluateBody body, ctx

        return null

      catch e
        if (e instanceof Directive) and (e.name is 'return')
          return e.value
        else
          throw e

  ###
  ###
  evaluateGroup: (node, context) ->
    @evaluateNode node.expression, context

  ###
  ###
  evaluateList: (node, context) ->
    items = (@evaluateNode item, context for item in node.body)

    return new List items, node.separator

  ###
  ###
  evaluateUnaryOperation: (node, context) ->
    right = @evaluateNode node.right, context
    op = "#{node.operator.value}@"

    try
      return @call context, right, op, [], node.operator.start
    catch e
      message = "Cannot perform `#{right.reprOp op}`"
      message += ". #{e.message}" if e.message
      @error e.class, message, node, context

  call: (context, obj, method, args = [], start = null, end = null) ->
    method = method.toString()

    context.stack.push {
      start: start,
      end: end,
      name: obj.reprMethod(method)
    }

    try
      res = obj["."](context, method, args...) or Null.null
    catch e
      throw e
    finally
      context.stack.pop()

    return res

  ###
  TODO Reimplement this mess as a Node methods
  ###
  evaluateBinaryOperation: (node, context) ->
    switch node.operator.value
      when '=', '|='
        @evaluateAssignment node, context

      when '!'
        left = @evaluateNode node.left, context
        name = @getStringValue node.right, context

        return @call context, left, "!#{name}", [], node.operator.start

      when '.', '::'
        left = @evaluateNode node.left, context
        right = node.right

        if right instanceof LiteralString
          right = new UnquotedString @getStringValue(right, context)
        else
          right = @evaluateNode right, context

        if node.operator.value is '.'
          return @call context, left, right, [], node.operator.start
        else
          return @call context, left, '::', [right], node.operator.start

      when '('
        left = node.left
        args = (@evaluateNode arg, context for arg in node.right)

        if (left instanceof Operation) and (left.operator.value in ['.', '::'])
          if left.right instanceof LiteralString
            name = new UnquotedString @getStringValue left.right
            obj = @evaluateNode left.left, context
            method = if left.operator.value is '.' then '' else '::'
            args.unshift name

            return @call context, obj, method, args, left.operator.start

        else if left instanceof LiteralString
          name = @getStringValue left

          if name[0] isnt '$'
            if not context.has name
              # TODO :S
              return @_evaluateCall name, args, context

        left = @evaluateNode left, context

        unless left instanceof Function
          @referenceError(
            "Cannot call #{left.repr()}(): this object is not callable",
            node.operator,
            context
          )

        return @call context, left, 'call', args, node.operator.start

      else
        left = @evaluateNode node.left, context
        right = @evaluateNode node.right, context
        op = node.operator.value

        try
          return @call context, left, op, [right], node.operator.start
        catch e
          message = "Cannot perform #{left.reprOp(op, right)}"
          message += ". #{e.message}" if e.message
          @error e.constructor, message, node.operator, context

  evaluateOperation: (node, context) ->
    if node.binary
      @evaluateBinaryOperation node, context
    else
      @evaluateUnaryOperation node, context

  ###
  TODO Refactor!
  Maybe the left node SHOULD be evaluated, but maybe in a new scope,
  so existing defined factors on current scope are not applied
  ###
  evaluateUnitAssignment: (node, context) ->
    value = parseFloat node.left.value
    unit = node.left.unit?.value

    unless unit and value isnt 0
      @referenceError "Bad unit definition", node.left, context

    unless node.operator is '|=' and Number.isDefined unit
      right = (@evaluateNode node.right, context)

      unless right.unit and right.value isnt 0
        @referenceError "Bad unit definition", right, context

      # TODO This is a temporary hack, because units are not scoped yet
      left = new Number value
      left.unit = unit

      # TODO scope this
      Number.define left, right, yes

    return @evaluateNode node.left, context

  ###
  ###
  evaluateAssignment: (node, context) ->
    getter = setter = null

    {left, right} = node

    if left instanceof LiteralNumber
      return @evaluateUnitAssignment node, context

    if left instanceof LiteralString
      name = @getStringValue left, context

      if name[0] isnt '$'
        if context.has(name)
          if node.operator.value is '=' or context.get(name).isNull()
            @referenceError "Cannot overwrite constant `#{name}`", left, context

      getter = context.get.bind context, name
      setter = context.set.bind context, name

    else if left instanceof Operation and left.operator.value in ['.', '::']
      name = @evaluateNode left.right, context
      ref = @evaluateNode left.left, context

      if left.operator.value is '.'
        getter = ref['.'].bind ref, context, name
        setter = ref['.='].bind ref, context, name
      else
        getter = ref['.'].bind ref, context, '::', name
        setter = ref['.'].bind ref, context, '::=', name

    unless setter
      @referenceError "Bad left side of assignment", left, context

    if node.operator.value is '|='
      if getter
        curr = getter()
        return curr if not curr.isNull()

    value = @evaluateNode right, context
    setter value

    return value

  ###
  ###
  evaluateConditional: (node, context) ->
    met = not node.condition or
          (@evaluateNode node.condition, context).toBoolean()

    if met
      @evaluateBody node.block.body, context
    else if node.elses
      for els in node.elses
        met = not els.condition or
              (@evaluateNode els.condition, context).toBoolean()

        if met
          @evaluateBody els.block.body, context
          break

    return #undefined

  evaluateControlFlowDirective: (node, context) ->
    switch node.arguments.length
      when 0
        depth = 1
      when 1
        depth = @evaluateNode node.arguments[0], context

        if depth instanceof Number
          unless depth.isInteger() and depth.isPositive()
            @valueError(
              "Bad argument for `#{node.name}` depth: #{depth.reprValue()}:",
              depth, context
            )
        else
          @valueError(
            "Bad argument for `#{node.name}`: #{depth.class.repr()}",
            depth, context
          )

        depth = parseInt depth.value, 10
      else
        @valueError "Too many arguments for `#{node.name}`", node, context

    node.depth = depth

    throw node

  evaluateContinue: (node, context) ->
    @evaluateControlFlowDirective node, context

  evaluateBreak: (node, context) ->
    @evaluateControlFlowDirective node, context

  evaluateReturn: (node, context) ->
    switch node.arguments.length
      when 0
        node.value = Null.null
      when 1
        node.value = @evaluateNode node.arguments[0], context
      else
        @valueError "Too many arguments for `return`", node, context

    throw node

  ###
  ###
  evaluateFor: (node, context) ->
    expression = @evaluateNode node.expression, context

    unless expression.isEnumerable()
      @valueError """
        Cannot traverse over #{expression.class.repr()}: \
        this object is not enumerable
        """, node, context

    expression.each (key, value) =>
      context.set node.value.value, value

      if node.key?
        context.set node.key.value, key

      try
        @evaluateBody node.block.body, context
      catch e
        if e instanceof Directive
          if e.name is 'break'
            return no unless --e.depth > 0
          else if e.name is 'continue'
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
          break if not met
        @evaluateBody node.block.body, context
      catch e
        if e instanceof Directive
          if e.name is 'break'
            break unless --e.depth > 0
          else if e.name is 'continue'
            continue unless --e.depth > 0
        throw e

    return #undefined

  ###
  ###
  evaluateInclude: (node, context) ->
    if node.arguments.length
      for arg in node.arguments
        file = @evaluateNode arg, context

        unless file instanceof URL or file instanceof String
          @valueError(
            "Bad argument for `include`: #{file.class.repr()}", args, context
          )

        uri = file.value

        context.stack.push {
          start: arg.start,
          end: arg.end,
          name: '<include>'
        }

        try
          context.include uri
        catch e
          throw e
        finally
          context.stack.pop()

    return Null.null

  ###
  ###
  evaluateUse: (node, context) ->
    for arg in node.arguments
      name = @evaluateNode arg

      unless name instanceof String
        @valueError "Bad argument for `use`: #{name.class.repr()}", arg, context
      @layla.use name.value

    return Null.null

  ###
  ###
  evaluateDirective: (node, context) ->
    switch node.name
      when 'use'
        @evaluateUse node, context
      when 'include'
        @evaluateInclude node, context
      when 'return'
        @evaluateReturn node, context
      when 'break'
        @evaluateBreak node, context
      when 'continue'
        @evaluateContinue node, context
      else
        throw new InternalError "Unkown directive!"

  ###
  ###
  evaluatePropertyDeclaration: (node, context) ->
    value = @evaluateNode(node.value, context).clone()

    for name in node.names
      name = @getStringValue name, context

      if node.conditional
        current = context.block.getProperty(name)
        if current and not current.isNull()
          continue

      property = new Property name, value
      context.block.items.push property

    return property

  ###
  ###
  evaluateBody: (body, context) ->
    value = Null.null

    for node in body
      value = @evaluateNode node, context

    return value

  ###
  ###
  evaluateBlock: (node, context) ->
    block = new Block
    ctx = context.child block
    @evaluateBody node.body, ctx

    return block

  ###
  ###
  evaluateCombinator: (combinator, context) ->
    new Combinator combinator.value

  ###
  ###
  evaluateSelectorNamespace: (node, context) ->
    if node.namespace?
      # TODO :S
      if typeof node.namespace is 'string'
        return node.namespace
      else
        return @getStringValue node.namespace, context
    else
      return null

  ###
  ###
  evaluateElementalSelector: (node, context) ->
    namespace = @evaluateSelectorNamespace node, context

    switch node.name
      when '*'
        return new UniversalSelector namespace
      else
        # TODO :S
        name = node.name
        unless typeof name is 'string'
          name = @getStringValue name, context

        return new TypeSelector name, namespace

  ###
  ###
  evaluateIdSelector: (node, context) ->
    new IdSelector @getStringValue node.name, context

  ###
  ###
  evaluateClassSelector: (node, context) ->
    new ClassSelector @getStringValue node.name, context

  ###
  ###
  evaluateAttributeSelector: (node, context) ->
    namespace = @evaluateSelectorNamespace node, context
    name = @getStringValue node.name, context

    attr_selector = new AttributeSelector name, null, null, null, namespace

    if node.operator
      attr_selector.operator = node.operator

    if node.value
      attr_selector.value = @evaluateNode node.value, context

    if node.flags
      attr_selector.flags = @getStringValue node.flags, context

    return attr_selector

  ###
  ###
  evaluatePseudoSelector: (cls, node, context) ->
    name = @getStringValue node.name, context

    if node.arguments
      args = []

      for arg in node.arguments
        args.push (@evaluateNode node, context for node in arg)
    else
      args = null

    return new cls name, args

  ###
  ###
  evaluatePseudoClassSelector: (node, context) ->
    return @evaluatePseudoSelector PseudoClassSelector, node, context

  ###
  ###
  evaluatePseudoElementSelector: (node, context) ->
    return @evaluatePseudoSelector PseudoElementSelector, node, context

  ###
  ###
  evaluateParentSelector: (node, context) ->
    return new ParentSelector

  ###
  ###
  evaluateCompoundSelector: (node, context) ->
    compound = new CompoundSelector

    for child in node.items
      compound.children.push @evaluateNode child, context

    return compound

  evaluateKeyframeSelector: (node, context) ->
    return new KeyframeSelector node.keyframe

  ###
  ###
  evaluateComplexSelector: (node, context) ->
    complex = new ComplexSelector

    for child in node.items
      complex.children.push @evaluateNode child, context

    return complex

  ###
  ###
  evaluateSelectorList: (node, context) ->
    selector_list = new SelectorList

    for child in node.items
      selector_list.children.push @evaluateNode child, context

    return selector_list

  ###
  ###
  evaluateRuleSetDeclaration: (node, context) ->
    rule = new RuleSet
    context.block.items.push rule

    # TODO When evaluating a rule-set selector, the context is the parent of the
    # block being created. It makes sense because `&` inside a selector refers
    # to the parent selector. Decide if this is ok or not and create test case.
    rule.selector = @evaluateSelectorList node.selector, context

    ctx = context.child rule
    @evaluateBody node.block.body, ctx

    return rule

  ###
  ###
  evaluateAtRuleArguments: (args, context) ->
    args.map (arg) =>
      if arg instanceof Array
        return @evaluateAtRuleArguments arg, context
      else if arg instanceof PropertyDeclaration
        name = @getStringValue arg.names[0], context
        value = (@evaluateNode arg.value, context).clone() # TODO ??
        return new Property name, value

      return @evaluateNode arg, context

  ###
  ###
  evaluateAtRuleDeclaration: (node, context) ->
    rule = new AtRule
    context.block.items.push rule
    rule.name = @getStringValue node.name, context

    args = @evaluateAtRuleArguments node.arguments, context

    if not args.length
      args = null

    rule.arguments = args

    ctx = context.child rule

    if node.block
      @evaluateBody node.block.body, ctx
    else
      rule.block = null

    return rule

  ###
  ###
  evaluateRoot: (node, context = new Context) ->
    @evaluateBody node.body, context

  parse: (source) -> (new Parser).parse source

  evaluate: (program, context = new Context) ->
    unless program instanceof Node
      program = @parse program

    try
      ret = @evaluateNode program, context
      return ret
    catch err
      if err instanceof Directive
        @runtimeError "Uncaught `#{err.name}`", err, context
      else
        throw err


module.exports = Evaluator
