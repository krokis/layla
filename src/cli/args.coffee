###
###
class Args

  ###
  ###
  class Arg
    constructor: (@value) ->

  ###
  ###
  class Opt extends Arg
    constructor: (@name, value = null) ->
      super value

    bool: ->
      @value is null or /^\s*1|true|y|yes|on\s*/i.test(@value)

  constructor: (argv) ->
    @args = []

    for arg in argv
      if arg[0] is '-'
        if arg[1] is '-'
          [name, value] = arg[2..].split '=', 2
          @args.push new Opt name, value
        else
          [name, value] = arg[1..].split '=', 2
          for c in name
            @args.push new Opt c, value
      else
        @args.push new Arg arg

  getArg: ->
    if @args.length
      return @args.shift()

  getOpt: ->
    if @args.length and @args[0] instanceof Opt
      return @args.shift()


module.exports = Args
