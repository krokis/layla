fs       = require 'fs'
{expect} = require 'chai'

Node     = require '../../../lib/node'
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

  it 'adds location info to every node', ->
    testLocations = (node, source) ->
      if node instanceof Node
        expect(node).to.have.property 'start'
        expect(node).to.have.property 'end'

        for prop of node
          childNode = node[prop]

          if Array.isArray(childNode)
            childNode.map testLocations
          else
            testLocations childNode

    lay = fs.readFileSync "#{__dirname}/../kitchen-sink.lay"

    root = testParse lay

    testLocations root, lay
