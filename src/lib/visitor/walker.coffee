Visitor = require '../visitor'

class Walker extends Visitor

  visit: (node) ->
    try
      super node
    catch
      node

  visitBlock: (block) ->
    @visit stmt for stmt in block.body

module.exports = Walker
