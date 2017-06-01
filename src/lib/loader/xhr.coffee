URL = require 'url'

Loader = require '../loader'

class XHRLoader extends Loader

  canLoad: (uri, context) ->
    url = URL.parse uri
    url.protocol in ['http:', 'https:']

  load: (uri, context) ->
    xhr = new XMLHttpRequest
    xhr.addEventListener 'load', ->
    xhr.open 'GET', uri, no
    xhr.send()

    if xhr.status == 200
      return xhr.responseText
    else
      throw new IncludeError (
        "Could not include URL: \"#{uri}\""
      )

module.exports = XHRLoader
