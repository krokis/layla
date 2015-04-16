{Parser} = require '../../lib'

describe 'The parser', ->
  parser = null

  it 'is a class', ->
    Parser.should.be.a.Function
    parser = new Parser

  describe '.parse()', ->
    it 'parses Layla source code and returns an AST', ->
      parser.parse.should.be.a.Function
      ast = parser.parse 'a { b: c }'
