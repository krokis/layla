{Evaluator} = require '../../lib'

describe 'The evaluator', ->
  evaluator = null

  it 'is a class', ->
    Evaluator.should.be.a.Function
    evaluator = new Evaluator

  describe '.evaluate()', ->
    it 'evaluates an AST', ->
      evaluator.evaluate.should.be.a.Function

