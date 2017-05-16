Emitter      = require '../emitter'
Block        = require '../object/block'
Rule         = require '../object/rule'
Property     = require '../object/property'
RawString    = require '../object/string/raw'

class CSSEmitter extends Emitter

  options: null

  constructor: (@options = {}) ->
    defaults =
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

  escapeCharacters: (val, chars) ->
    return val.replace ///(^|[^\\]|(?:\\(?:\\\\)*))([#{chars}])///gm, '$1\\$2'

  escapeRegex: (val, reg) ->
    val.replace ///(^|[^\\]|(?:\\(?:\\\\)*))(#{reg.source})///gm, '$1\\$2'

  escapeWhitespace: (val) ->
    # Escape new lines to \A
    val = val.replace /(^|[^\\]|(?:\\\\)+)(\r\n|\r|\n)/gm, '$1\\A'

    # Translate `\t` to \9
    val = val.replace /\t/gm, '\\9'

    return val

  escapeQuotedString: (val, quotes = '\'"') ->
    val = @escapeCharacters val, '\\\\'
    val = @escapeWhitespace val
    val = @escapeCharacters val, quotes

    return val

  # TODO What about `?`, `!` and `$`?
  escapeUnquotedString: (val) ->
    val = @escapeCharacters val, '\\\\'
    val = @escapeWhitespace val
    # Translate spaces to \20
    val = val.replace /\x20/gm, '\\20'
    val = @escapeRegex val, /[^a-zA-Z_0-9!\?\$\\\-\x80-\uFFFF]/

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
  emitUnquotedString: (str) ->
    # TODO This is not correct (same escping as quoted strings)
    @escapeUnquotedString str.value

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

  emitNumberUnit: (num) -> num.unit or ''

  emitNumber: (num) ->
    value = @emitNumberValue num
    if value isnt '0'
      value += @emitNumberUnit num
    value

  emitBoolean: (bool) ->
    bool.value ? 'true' : 'false'

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
      # TODO Escape something? Parens?
      str += url.value

    str += ')'

    return str

  emitCall: (call) ->
    args = (@emit arg for arg in call.arguments)
    return "#{call.name}(#{args.join ', '})"

  emitRegExp: (regexp) ->
    'regexp(' + @quoteString(regexp.toString()) + ')'

  emitDataURI: (uri) -> @emitURL uri

  emitPropertyName: (property) -> property.name

  emitPropertyValue: (property) -> @emit property.value

  emitProperty: (property) ->
    """
    #{@emitPropertyName property}: #{@emitPropertyValue property}
    """

  emitSelector: (selector) ->
    # TODO Trim should not be necessary, but currently a trailing descendant
    # combinator (whitespace) is added if there's whitespace between selector
    # and `{`. See TODO at the parser.
    selector.toString().trim()

  emitPseudoClassSelector: @::emitSelector

  emitSelectorList: (rule) ->
    (rule.selector.children.map (sel) => @emitSelector sel).join ',\n'

  emitRuleSet: (rule) ->
    """
    #{@emitSelectorList rule} #{@emitBlock rule}
    """

  emitAtRuleName: (rule) -> "@#{rule.name}"

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
