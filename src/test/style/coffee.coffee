fs         = require 'fs'
path       = require 'path'
coffeelint = require 'coffeelint'

describe 'CoffeeScript', ->
  base_dir = fs.realpathSync "#{__dirname}/../.."
  rules = require "#{base_dir}/coffeelint.json"

  doFile = (file) ->
    it (file.substr base_dir.length + 1), ->
      source = fs.readFileSync file, 'utf-8'
      errors = coffeelint.lint source, rules

      for err in errors
        if err.level isnt 'ignore'
          throw new Error "#{err.message} @ #{file}:#{err.lineNumber}"

  doDir = (dir) ->
    for name in fs.readdirSync dir
      if name[0] != '.'
        file = path.join dir, name
        if st = fs.statSync file
          if st.isDirectory()
            doDir file
          else if st.isFile() and name.match /Cakefile|layla|\.coffee$/
            doFile file
        else
          throw new Error "Could not stat file #{file_path}"

  doDir base_dir
