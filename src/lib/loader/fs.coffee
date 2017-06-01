fs   = require 'fs'
URL  = require 'url'

Loader      = require '../loader'
IncludeError = require '../error/include'

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
      throw new IncludeError "Could not include file: \"#{uri}\""

module.exports = FSLoader
