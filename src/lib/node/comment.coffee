# /**
#  * before ruleset
#  */
#
# /* before selector */ html /* inside selector */ > body /* after selector */ { // before block body
#
#   // before property
#
#   /**
#    * before property
#    */
#   foo: bar
#   /* before property name */ foo: bar; /* after statement */
#   foo /* after property name */: bar // after expression
#   foo: /* before expression */ bar;
#   foo: 1 /* after expression*/ + /* before expression */ 2 * 3 // after expression
#   foo: /* before expression*/ (/* before expression*/$a) /* after expression
#
#   // before statement
#   /* before statement */ if /* before expression */ true { // before block
#     void
#   } // after block
#
#   // Before rule set
#   a // after selector
#   // Before block
#   { // Before block body
#     text-decoration
#   /* after block body*/} // after block
#
#   /* before selector */ strong { font-weight: bold }
#
# }

# /* foo */
# foo: bar;

Node = require '../node'

class Comment extends Node
  value: null
  inline: no

module.exports = Comment
