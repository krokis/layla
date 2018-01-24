fs       = require 'fs'
{expect} = require 'chai'

RootNode = require '../../../lib/node/root'
Parser   = require '../../../lib/parser/lay'

LAY = 'body { width: 200px * 2  }'

# TODO Do separate tests for css/lay
describe 'The Parser', ->

  testParse = (input) ->
    output = (new Parser).parse input, 'test-file'
    expect(output).to.be.an.instanceof RootNode
    expect(output.body).to.be.an 'array'

    return output

  it 'can parse a string', ->
    output = testParse LAY
    expect(output.body).not.to.be.empty

  it 'can parse a buffer', ->
    output = testParse Buffer.from(LAY)
    expect(output.body).not.to.be.empty

  it 'can parse an empty or whitespace-only source', ->
    for lay in ['', '   ', '\n  \r\r  \n \n  \t\n\r\n  \t']
      output = testParse lay
      expect(output.body).to.be.empty
