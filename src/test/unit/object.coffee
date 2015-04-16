{Object, Node} = require '../../lib'

describe '`Object`', ->
  it 'is a class', ->
    Object.should.be.a.Function

  it 'extends `Node`', ->
    (new Object).should.be.an.instanceOf Node

