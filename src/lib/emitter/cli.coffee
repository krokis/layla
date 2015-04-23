CSSEmitter = require './css'

class CLIEmitter extends CSSEmitter
  ESC        = '\u001b'
  RESET      = 0
  RED        = 31
  GREEN      = 32
  YELLOW     = 33
  MAGENTA    = 35
  CYAN       = 36

  BRIGHT_RED = "#{ESC}[91m"

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

  emitNumber: (num) -> @format (super num), CYAN

  emitString: (str) -> @format (super str), YELLOW

  emitSelector: (sel) -> @format (super sel), GREEN

  emitAtRuleName: (sel) -> @format (super sel), GREEN

  emitAtRuleArguments: (sel) -> @format (super sel), GREEN

  emitProperty: (property) ->
    (@format (@emitPropertyName property), CYAN) + ':' +
    (@emitPropertyValue property)

module.exports = CLIEmitter
