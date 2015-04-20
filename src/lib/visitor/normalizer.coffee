Visitor       = require '../visitor'
Block         = require '../object/block'
RuleSet       = require '../object/rule-set'
AtRule        = require '../object/at-rule'
Property      = require '../object/property'
Null          = require '../object/null'

InternalError = require '../error/internal'

###
###
class Normalizer extends Visitor

  options: null
  indentation: 0

  constructor: (@options = {}) ->
    defaults =
      unnest_rules:           yes
      expand_blocks:          yes
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

  isEmptyProperty: (node) -> node.value instanceof Null

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

          if child.value instanceof Block
            for grandchild in child.value.items
              if grandchild instanceof Property
                name = "#{child.name}-#{grandchild.name}"
                value = grandchild.value
                node.items.push new Property name, value
            continue

        else if child instanceof AtRule
        else
          throw new InternalError # This should never happen

        node.items.push child

    return node

  ###
  ###
  normalizeDocument: (node) -> @normalizeBlock node

module.exports = Normalizer
