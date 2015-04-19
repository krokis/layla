{Class, Object} = require '../../lib'

describe '`Object`', ->
  it 'is a class', ->
    Object.should.be.a.Function
    (new Object).should.be.an.instanceOf Class
