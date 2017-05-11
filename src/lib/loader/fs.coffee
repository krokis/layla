fs   = require 'fs'
URL  = require 'url'

Loader      = require '../loader'
ImportError = require '../error/import'

class FSLoader extends Loader

  canLoad: (uri, context) ->
    url = URL.parse uri

    unless url.protocol in ['file', null]
      return no

    return fs.existsSync uri

  load: (uri, context) ->
    # TODO: Better capture exceptions
    try
      fs.readFileSync uri, 'utf8'
    catch
      throw new ImportError "Could not import file: \"#{uri}\""

module.exports = FSLoader
