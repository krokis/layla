Class         = require './class'
Tokenizer     = require './tokenizer'
InternalError = require './error/internal'


isString = (obj) -> "[object String]" is toString.call obj

class Parser extends Class

  parseRoot: -> throw new InternalError 'Not implemented'

  ###
  Parse source string or an array of tokens.
  ###
  parse: (program, file = null) ->
    unless program instanceof Array
      program = program.toString()
      program = (new Tokenizer).tokenize program, file

    @token = program[0]

    return @parseRoot()


module.exports = Parser
