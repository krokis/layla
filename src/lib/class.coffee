###
The base for all Layla classes (except for the core `Layla` class itself).
###
class Class

  { getOwnPropertyDescriptor, defineProperty } = Object

  ###
  Simple property support. Allows subclasses to define their own property
  accessors.
  ###
  @property: (name, desc) ->
    if '@' is name.charAt 0
      name = name.substr 1
      target = @
    else
      target = @::

    if typeof desc is 'function'
      desc = get: desc

    desc.enumerable ?= yes
    desc.configurable ?= yes

    # If the property already existed for this prototype, inherit its
    # descriptor, so properties can be partially overloaded.
    if target.hasOwnProperty name
      current = getOwnPropertyDescriptor target,  name
      desc[k] ?= v for k, v of current

    defineProperty target, name, desc

  @property 'class', -> @constructor

  @property 'type', -> @class.name

  copy: (etc...) -> new @class etc...

  clone: -> @copy()


module.exports = Class
