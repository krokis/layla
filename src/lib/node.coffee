Class = require './class'

class Node extends Class

  document: null
  parent: null

  start: null
  end: null

  before: null # pre (left) comment
  after: null # post (right) comment

  toJSON: ->
    json = super
    json.start = @start
    json.end = @end
    json

module.exports = Node