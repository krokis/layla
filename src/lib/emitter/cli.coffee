CSSEmitter = require './css'


###
###
class CLIEmitter extends CSSEmitter
  ESC        = '\u001b'
  RESET      = 0
  BOLD       = 1
  RED        = 31
  GREEN      = 32
  YELLOW     = 33
  BLUE       = 34
  MAGENTA    = 35
  CYAN       = 36
  GREY       = 37

  constructor: (options = {}) ->
    defaults =
      colors: yes
      decimal_places: -1

    for name of defaults
      options[name] = defaults[name] unless name of options

    super options

  format: (str, codes...) ->
    if @options.colors
      ret = ''
      for code in codes
        ret += "#{ESC}[#{code}m"
      ret += str
      ret += "#{ESC}[#{RESET}m"
    else
      str

  emitNull: (nil) -> @format super(nil), BOLD

  emitBoolean: (bool) -> @format super(bool), BOLD

  emitImportant: -> @format super(), BOLD

  emitFunction: (func) -> @format func.repr(), BOLD

  emitNumber: (num) -> @format super(num), YELLOW

  emitRegExp: (reg) -> @format "/#{reg.source}/#{reg.flags}", YELLOW

  emitList: (lst) ->
    if lst.isEmpty()
      return '()'

    return @format super(lst), YELLOW

  emitColor: (str) -> @format super(str), YELLOW

  emitQuotedString: (str) -> @format super(str), YELLOW

  emitUnquotedString: (str) -> @format super(str), YELLOW

  emitRawString: (str) -> @format super(str), YELLOW

  emitSelector: (sel) -> @format super(sel), BOLD, GREEN

  emitAtRuleName: (sel) -> @format super(sel), BOLD, MAGENTA

  emitAtRuleArguments: (sel) -> @format super(sel), MAGENTA

  emitPropertyName: (property) -> @format super(property), BOLD, CYAN


module.exports = CLIEmitter
