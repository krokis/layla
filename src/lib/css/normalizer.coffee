Visitor       = require '../visitor'
Block         = require '../object/block'
Rule          = require '../object/rule'
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
      flatten_block_properties:   yes
      strip_root_properties:      no
      strip_empty_blocks:         no
      strip_null_properties:      no
      strip_empty_properties:     no
      strip_empty_rule_sets:      yes
      strip_empty_at_rules:       no
      strip_empty_media_at_rules: yes
      hoist_rule_sets:            yes
      hoist_at_rules:             no
      hoist_media_at_rules:       yes
      convert_unknown_units:      yes

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

        if child instanceof Rule
          hoist =
            (@options.hoist_rule_sets and
              (child instanceof RuleSet) and
              (node instanceof RuleSet)
            ) or
            (child instanceof AtRule and (
              @options.hoist_at_rules or
              @.options["hoist_#{child.name}_at_rules"]
            ))

          (if hoist then root else node).items.push child

          if child instanceof RuleSet and node instanceof RuleSet
            child.selector = child.selector.resolve node.selector

          @normalizeBlock child, root

          strip =
            not child.items.length and (
              @options.strip_empty_blocks or
              (child instanceof RuleSet and @options.strip_empty_rule_sets) or
              (child instanceof RuleSet and (
                @options.strip_empty_rule_sets or
                @options["strip_empty_#{child.name}_at_rules"]
              ))
            )

          if strip
            root.items.splice (root.items.indexOf child), 1

        else if child instanceof Property
          if @options.strip_empty_properties and @isEmptyProperty child
            continue

          if @options.flatten_block_properties and child.value instanceof Block
            for grandchild in child.value.items
              if grandchild instanceof Property
                name = "#{child.name}-#{grandchild.name}"
                value = grandchild.value
                node.items.push new Property name, value
          else
            node.items.push child

        else
          throw new InternalError # This should never happen

    return node

  ###
  ###
  normalizeDocument: (node) -> @normalizeBlock node

module.exports = Normalizer
