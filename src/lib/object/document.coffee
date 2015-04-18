Block = require './block'

###
TODO Maybe this should not extend Block or Node, so we can make Object
extend Class instead of being a Node (the parser only uses *this* Object
subclass).
###
class Document extends Block

  toJSON: ->
    json = super
    json.body = @body
    json

module.exports = Document
