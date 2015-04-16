{Normalizer} = require '../../lib'

describe 'The CSS normalizer', ->
  normalizer = null

  it 'is a class', ->
    Normalizer.should.be.a.Function
    normalizer = new Normalizer

  describe '.normalize()', ->
    it 'normalizes an AST', ->
      normalizer.normalize.should.be.a.Function
