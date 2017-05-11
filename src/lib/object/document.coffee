Block = require './block'


###
###
class Document extends Block

  toJSON: ->
    json = super
    json.body = @body
    json


module.exports = Document
