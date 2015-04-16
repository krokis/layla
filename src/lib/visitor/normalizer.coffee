Walker        = require './walker'
RuleSet       = require '../node/object/rule-set'
AtRule        = require '../node/object/at-rule'
Property      = require '../node/object/property'
Null          = require '../node/object/null'

InternalError = require '../error/internal'

###
###
class Normalizer extends Walker

  options: null
  indentation: 0

  constructor: (@options = {}) ->
    defaults =
      strip_nulls:            yes
      strip_empty_blocks:     yes
      strip_empty_rule_sets:  yes
      strip_empty_at_rules:   yes
      strip_null_properties:  no
      strip_empty_properties: no
      hoist_nested_rule_sets: yes
      hoist_at_rules:         yes
      hoist_media_at_rules:   yes

    for name of defaults
      @options[name] = defaults[name] unless name of @options

  ###
  ###
  normalize: (node) ->
    method = "normalize#{node.type}"

    if method of this
      this[method].call this, node
    else
      node

  normalizeRule: (node, root) -> node

  isEmptyProperty: (node) ->
    value = node.value
    if value instanceof Null
      yes
    else
      no

  normalizeBlock: (node, root) ->
    if body = node.items
      root ?= node
      node.items = []

      while body.length
        child = body.shift()

        if child instanceof RuleSet
          if @options.hoist_nested_rule_sets
            # TODO refactor
            l = root.items.length
            root.items.push child
            @normalizeBlock child, root

            if @options.strip_empty_blocks and not child.items?.length
              root.items.splice l, 1
            continue
        else if child instanceof Property
          if @options.strip_empty_properties and @isEmptyProperty child
            continue
        else if child instanceof AtRule
        else
          throw new InternalError # This should never happen

        node.items.push child

    return node

  ###
  ###
  normalizeDocument: (node) ->
    @normalizeBlock node

module.exports = Normalizer
