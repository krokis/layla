global.Layla = require '../lib/layla'
BrowserContext = require '../lib/context/browser'

if (new Function 'return this === window')()
  document.addEventListener "DOMContentLoaded", ->
    tags = document.querySelectorAll '[type="text/lay"]'

    # TODO do not concatenate sources and evaluate them all together: try with
    # next tag if previous fails.
    if tags.length
      URL = require 'url'

      source = ''

      for tag in tags
        switch tag.nodeName
          when 'STYLE'
            source += tag.textContent + "\n;\n"
          when 'LINK'
            if tag.hasAttribute 'href'
              uri = tag.getAttribute 'href'
              source += "import url('#{uri}')" + "\n;\n"
          else
            continue

      if source.trim()
        base_url = URL.resolve document.location.href, './'

        layla = new Layla
        layla.context = new BrowserContext
        layla.context.pushPath base_url

        # TODO Add location info
        css = layla.compile source

        style = document.createElement 'style'
        style.setAttribute 'rel', 'stylesheet'
        style.setAttribute 'type', 'text/css'
        style.textContent = css

        document.head.appendChild style
