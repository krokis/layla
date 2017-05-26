Emitter        = require '../emitter'
Rule           = require '../object/rule'
Property       = require '../object/property'
String         = require '../object/string'
RawString      = require '../object/string/raw'
QuotedString   = require '../object/string/quoted'
UnquotedString = require '../object/string/unquoted'


###
###
class CSSEmitter extends Emitter

  options: null

  constructor: (@options = {}) ->
    defaults =
      charset:                     'utf8' # or ascii. For escaping strategy.
      bom:                         'preserve' # Or: true, false/strip
      new_line:                    '\n'
      final_newline:               yes
      tab:                         '  '
      before_opening_brace:        ' '
      after_opening_brace:         '\n'
      before_statement:            '\t'
      after_statement:             '\n'
      align_declarations:          no # Or 'left' or 'right', all properties
      align_prefixed_declarations: no # Or 'left' or 'right'
      after_declaration_property:  ''
      before_declaration_value:    ' '
      after_declaration_value:     ''
      preferred_string_quote:      null # original, ", '
      force_string_quote:          null # same
      decimal_places:              2
      color_format:                'shortest'
      url_quote:                   '"'

    for name of defaults
      @options[name] = defaults[name] unless name of @options

  ###
  TODO :S Please refactor this
  ###
  indent: (str) ->
    lines = str.split '\n'
    lines = lines.map (line) ->
      if line.trim() is '' then line else "  #{line}"
    (lines.join '\n').replace /((?:(?:\\\\)*\\)\n)  /g, "$1"

  emitBody: (body) ->
    lines = for stmt in body
      switch yes
        when stmt instanceof Rule
          (@emit stmt) + (if stmt.items?.length then '' else ';') + '\n'
        when stmt instanceof Property
          (@emitProperty stmt) + ';'
        else
          throw new Error "Cannot emit a (#{stmt.type}) as CSS"

    str = lines.join '\n'

    if '\n' is str.substr -1
      str = str.substr 0, (str.length - 1)

    return str

  emitList: (list) ->
    sep = "#{list.separator.trim()} "
    (list.items.map (item) => @emit item).join sep

  emitRange: (range) ->
    (range.items.map (item) => @emit item).join ' '

  emitBlock: (block) ->
    css = "{\n#{@indent (@emitBody block.items)}\n}"
    return css

  escapeQuotedString: (value, quotes = '\'"') ->
    value = QuotedString.escape value, @options.charset
    value = String.escapeCharacters ///[#{quotes}]///, value, @options.charset

    return value

  escapeUnquotedString: (str) ->
    return str.class.escape str.value, @options.charset

  quoteString: (value, quote = '"') ->
    if not quote?
      if value.match /(^|[^\\]|(\\(\\\\)*))'/
        quote = '"'
      else
        quote = "'"
    else
      quote = quote

    return "#{quote}#{@escapeQuotedString value, quote}#{quote}"

  ###
  ###
  emitUnquotedString: (str) -> @escapeUnquotedString str

  emitQuotedString: (str, quote = null) ->
    @quoteString str.value, quote

  emitRawString: (str) ->
    str.value

  formatNumber: (num) ->
    if num % 1 isnt 0
      if @options.decimal_places >= 0
        m = Math.pow 10, @options.decimal_places
        num = (Math.round num * m) / m

    return num

  emitNumberValue: (num) -> "#{@formatNumber num.value}"

  emitNumberUnit: (num) ->
    if num.unit?
      if num.unit is '%'
        return '%'
      else
        return UnquotedString.escape num.unit, @options.charset

    return ''

  emitNumber: (num) ->
    value = @emitNumberValue num

    if value isnt '0'
      value += @emitNumberUnit num

    return value

  emitBoolean: (bool) -> if bool.value then 'true' else 'false'

  emitNull: (node) -> 'null'

  emitColor: (color) ->
    # Super meh. Done to pass 59 tests. TODO Allow to customize this.
    if @formatNumber(color.alpha) >= 1
      color.toHexString()
    else
      color.toString('rgb')

  emitURL: (url) ->
    str = url.name
    str += '('

    if @options.url_quote
      str += @emitQuotedString url, @options.url_quote
    else
      str += String.escapeCharacters /[\)\(\\]/, url.value, @options.charset

    str += ')'

    return str

  emitCall: (call) ->
    name = UnquotedString.escape call.name, @options.charset
    args = (@emit arg for arg in call.arguments)

    return "#{name}(#{args.join ', '})"

  emitRegExp: (regexp) ->
    'regexp(' + @quoteString(regexp.toString()) + ')'

  emitDataURI: (uri) -> @emitURL uri

  emitImportant: -> '!important'

  emitPropertyName: (property) ->
    UnquotedString.escape property.name, @options.charset

  emitPropertyValue: (property) ->
    str = @emit(property.value)

    if property.important
      str += ' ' + @emitImportant()

    return str

  emitProperty: (property) ->
    @emitPropertyName(property) + ': ' + @emitPropertyValue(property)

  emitPseudoSelector: (selector) ->
    str = selector.escape selector.name, @options.charset

    if selector.arguments
      str += '('

      args = selector.arguments.map (arg) =>
        ([].concat(arg).map (a) => @emit a).join ' '

      str += args.join ', '
      str += ')'

    return str

  emitPseudoClassSelector: (selector) ->
    ':' + @emitPseudoSelector selector

  emitPseudoElementSelector: (selector) ->
    '::' + @emitPseudoSelector selector

  emitSelectorNamespace: (selector) ->
    if selector.namespace?
      if selector.namespace is '*'
        return '*|'

      return selector.escape(selector.namespace, @options.charset) + '|'

    return ''

  emitAttributeSelector: (selector) ->
    str = '['

    str += @emitSelectorNamespace selector
    str += selector.escape selector.name, @options.charset

    if selector.operator
      str += selector.operator

    if selector.value?
      str += @emit selector.value

    if selector.flags
      str += " #{selector.escape selector.flags, @options.charset}"

    str += ']'

    return str

  emitIdSelector: (selector) ->
    '#' + selector.escape(selector.name, @options.charset)

  emitUniversalSelector: (selector) ->
    @emitSelectorNamespace(selector) + '*'

  emitTypeSelector: (selector) ->
    @emitSelectorNamespace(selector) +
    selector.escape(selector.name, @options.charset)

  emitKeyframeSelector: (selector) -> selector.keyframe

  emitClassSelector: (selector) ->
    '.' + @emitSelectorNamespace(selector) +
    selector.escape(selector.name, @options.charset)

  emitCompoundSelector: (selector) ->
    (selector.children.map (selector) => @emit selector).join ''

  emitCombinator: (combinator) -> combinator.toString()

  emitComplexSelector: (selector) ->
    str = ''

    for child in selector.children
      piece = @emit(child).trim()

      if piece
        str += ' ' + piece

    return str[1...]

  emitSelectorList: (selector) ->
    (selector.children.map (sel) => @emit sel).join ',\n'

  emitRuleSet: (rule) ->
    """
    #{@emitSelectorList rule.selector} #{@emitBlock rule}
    """

  emitAtRuleName: (rule) ->
    '@' + UnquotedString.escape(rule.name, @options.charset)

  emitAtRuleArguments: (args) ->
    str = ''

    for arg in args
      unless (str is '') or (arg instanceof RawString) and arg.value is ','
        str += ' '

      if arg instanceof Array
        str += '('
        str += @emitAtRuleArguments(arg)
        str += ')'
      else
        str += @emit arg

    return str

  emitAtRule: (rule) ->
    css = @emitAtRuleName rule

    if rule.arguments?
      css += " #{@emitAtRuleArguments rule.arguments}"

    if rule.items?.length
      css += " #{@emitBlock rule}"

    css

  emitDocument: (doc) ->
    css = ''

    if (@options.bom is yes) or (doc.bom and @options.bom is 'preserve')
      css += '\uFEFF'

    css += (@emitBody doc.items, doc)

    if @options.final_newline and (css isnt '')
      css += '\n'

    css

module.exports = CSSEmitter
