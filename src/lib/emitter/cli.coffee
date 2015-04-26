CSSEmitter = require './css'

class CLIEmitter extends CSSEmitter
  ESC        = '\u001b'
  RESET      = 0
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

    for name of defaults
      options[name] = defaults[name] unless name of options

    super options

  format: (str, codes...) ->
    if @options.colors
      ret = ''
      for code in codes
        ret += "#{ESC}[#{codes}m"
      ret += str
      ret += "#{ESC}[#{RESET}m"
    else
      str

  emitFunction: (func) -> @format func.repr(), YELLOW

  emitNumber: (num) -> @format (super num), YELLOW

  emitRegExp: (reg) -> @format "/#{reg.source}/#{reg.flags}", YELLOW

  emitColor: (str) -> @format (super str), YELLOW

  emitString: (str) -> @format (super str), YELLOW

  emitSelector: (sel) -> @format (super sel), GREEN

  emitAtRuleName: (sel) -> @format (super sel), GREEN

  emitAtRuleArguments: (sel) -> @format (super sel), GREEN

  emitPropertyName: (property) -> @format (super property), CYAN

module.exports = CLIEmitter
