{Object, String} = require '../../lib'

describe '`String`', ->
  it 'is a class', ->
    String.should.be.a.Function

  it 'extends `Object`', ->
    (new String).should.be.an.instanceOf Object

  describe 'new', ->

    str = String.new 'hey'

    it 'creates a new String', ->
      str.should.be.an.instanceOf String

    it 'creates an unquoted string by default', ->
      (str.quote is null).should.be.ok

    it 'creates an empty string by default', ->
      str.value.should.equal('')

