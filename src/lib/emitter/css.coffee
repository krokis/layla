Emitter      = require '../emitter'
Block        = require '../object/block'
Rule         = require '../object/rule'
Property     = require '../object/property'
Comment      = require '../node/comment'

class CSSEmitter extends Emitter

  options: null

  constructor: (@options = {}) ->
    defaults =
      new_line:                    '\n'
      tab:                         '  '
      comments:                    yes # Also: block only, banged only
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
        when stmt instanceof Comment
          @emitComment stmt
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

  emitQuotedString: (str) ->
    @emitString str

  emitUnquotedString: (str) ->
    @emitString str, no

  quoteString: (val) ->
    if val.match /(^|[^\\]|(\\(\\\\)*))'/
      quote = '"'
    else
      quote = "'"

    "#{quote}#{val}#{quote}"

  ###
  ###
  emitString: (str, quoted = str.quote?) ->
    val = str.value

    # Escape `\n` and `\r` to \A
    val = val.replace /(^|(?:[^\\])|(?:(?:\\\\)+))(\r\n|\r|\n)/gm, '$1\\A'

    # TODO: Translate `\t` to ... \9?
    val = val.replace /(|[^\\]|(\\\\)+)\t/g, '$1\\9'

    if quoted then @quoteString val else val.trim()

  emitNumberValue: (num) ->
    value = num.value

    if value % 1 isnt 0
      m = Math.pow 10, @options.decimal_places
      value = (Math.round value * m) / m

    '' + value

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
    hex = '#'
    comps = ['red', 'green', 'blue']
    comps.push 'alpha' if color.alpha < 1

    for c in comps
      c = (Math.round(255 * color[c])).toString 16
      if c.length < 2
        hex += '0'
      hex += c

    return hex

  emitURL: (url) ->
    "url(#{@emitString url, url.quote?})"

  emitPropertyName: (property) -> property.name

  emitPropertyValue: (property) -> @emit property.value

  emitProperty: (property) ->
    """
    #{@emitPropertyName property}: #{@emitPropertyValue property}
    """

  emitSelector: (selector) -> selector

  emitSelectorList: (rule) ->
    (rule.selector.map (sel) => @emitSelector sel).join ',\n'

  emitRuleSet: (rule) ->
    """
    #{@emitSelectorList rule} #{@emitBlock rule}
    """

  emitAtRule: (rule) ->
    css = "@#{rule.name}"

    if rule.arguments?
      css += " #{rule.arguments}"

    if rule.items?.length
      css += " #{@emitBlock rule}"

    css

  emitDocument: (doc) ->
    css = (@emitBody doc.items, doc)
    if css isnt ''
      css += '\n'
    css

module.exports = CSSEmitter
