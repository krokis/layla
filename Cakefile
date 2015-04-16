start = (task) ->

success = (message = 'Ok') ->

warning = (message) ->

error = (message) ->

readFile = (path) ->
  fs = require 'fs'
  fs.readFileSync path, 'utf-8'

writeFile = (path, contents) ->
  fs = require 'fs'
  fs.writeFileSync path, contents, 'utf-8'

option '-w', '--watch', 'Watch source files for changes'
option '-v', '--verbose', 'Be verbose'

option '-b', '--build', ''
option '-s', '--source', ''

task 'clean', 'Remove builds', ->
  del = require 'del'
  files = ['bin', 'lib', 'dist', 'License.md', 'index.js', 'package.json']
  del files, (err) ->

task 'build:all', 'Build everything',  ->
  invoke 'build:lib'
  invoke 'build:bin'
  invoke 'build:license'
  invoke 'build:package'
  invoke 'build:etc'
  invoke 'build:dist'

task 'build:bin', 'Build binary', (options) ->
  coffee  = require 'coffee-script'
  source = readFile "#{__dirname}/src/bin/ass.coffee"
  js = coffee.compile source, bare: yes, header: no
  js = "#!/usr/bin/env node\n#{js}"
  writeFile "#{__dirname}/bin/ass", js

task 'build:test', 'Build tests', (options) ->
  {exec} = require 'child_process'
  exec 'coffee --compile --output test/ src/test', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

task 'build:lib', 'Build library', (options) ->
  {exec} = require 'child_process'
  exec 'coffee --compile --no-header --output lib/ src/lib', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

task 'build:license', 'Build license file', (options) ->
  writeFile './License.md', require "#{__dirname}/src/license"

task 'build:package', 'Build node package', (options) ->
  coffee  = require 'coffee-script'
  pckg = require "#{__dirname}/src/package"
  json = JSON.stringify pckg, null, 2
  writeFile './package.json', json

  source = readFile "#{__dirname}/src/index.coffee"
  js = coffee.compile source, bare: yes, header: no
  writeFile "#{__dirname}/index.js", js

task 'build:etc', 'Build etc files', (options) ->
  # tmLanguage

task 'build:dist', 'Build browserified lib', (options) ->
  fs = require 'fs'
  coffee = require 'coffee-script'
  browserify = require 'browserify'
  coffeeify = require 'coffeeify'
  uglify = require 'uglify-js'

  extensions = ['.coffee', '.cson', '.js', '.json']
  b = browserify "#{__dirname}/src/browserify.coffee", extensions: extensions
  b.transform 'coffeeify'
  js = b.bundle()
  file = fs.createWriteStream "#{__dirname}/dist/layla.js"
  js.pipe file

task 'test:source', 'Test source coffee', (options) ->

task 'test:package', 'Test NPM package', (options) ->

task 'test:lib', 'Test built lib', (options) ->

task 'test:lib', 'Test built lib', (options) ->

task 'test:dist', 'Test browserified lib on a browser environment', (options) ->

task 'test:all', 'Test everything', ->
  invoke 'test:source'
  invoke 'test:lib'
  invoke 'test:dist'

task 'test', 'Test everything', ->
  invoke 'test:all'
