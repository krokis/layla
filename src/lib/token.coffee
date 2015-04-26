Class = require './class'

class Token extends Class

  # Types
  #
  @IDENT           = 'Ident'
  @UNIT            = 'Unit'
  @AT_IDENT        = 'AtIdent'
  @STRING          = 'String'
  @COLOR           = 'Color'
  @REGEXP          = 'RegExp'
  @NUMBER          = 'Number'
  @PUNC            = 'Punc'
  @UNARY_OPERATOR  = 'UnaryOperator'
  @BINARY_OPERATOR = 'BinaryOperator'
  @WHITESPACE      = 'Whitespace'
  @SELECTOR        = 'Selector'
  @SIMPLE_SELECTOR = 'SimpleSelector'
  @COMBINATOR      = 'Combinator'
  @EOT             = 'EOT'

  ###
  Returns length of token, if it has a start and an end. Otherwise, returns
  `null`.
  ###
  @property 'length',
    get: ->
      if @start and @end then @end - @start else null

  ###
  ###
  constructor: (@type, @value = null, @start = null, @end = null) ->

module.exports = Token
