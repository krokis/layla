{Emitter} = require '../../lib'

describe 'The CSS emitter', ->
  emitter = null

  it 'is a class', ->
    Emitter.should.be.a.Function
    emitter = new Emitter

  describe '.emit()', ->
    it 'emits an AST as CSS', ->
      emitter.emit.should.be.a.Function
