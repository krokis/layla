# 3rd party
fs   = require 'fs'
path = require 'path'
mark = require 'commonmark'

# Main lib
Layla = require '../../lib'

describe 'Cases', ->
  json = (obj, indent = 4) ->
    JSON.stringify obj, null, indent

  stringContent = (node) ->
    if node.string_content?
      return node.string_content
    else if node.inline_content?
      str = ''
      for c in node.inline_content
        switch c.t
          when 'Str'
            str += c.c
          when 'Code'
            str += "`#{c.c}`"
      return str
    else
      throw new Error "Don't know how to get string content of node #{node.t}"

  testFile = (file) ->
    text = fs.readFileSync file, 'utf8'
    parser = new mark.DocParser
    doc = parser.parse text

    testDocument = (doc) ->
      nodes = [].concat doc.children

      do testSection = (level = 0) ->

        testListItem = (item) ->
          desc     = null
          cases    = []
          source   = null
          expected = null
          err_name = null
          err_msg  = null

          for node in item.children
            switch node.t
              when 'Paragraph'
                if desc
                  throw new Error "Unexpected paragraph"
                desc =  stringContent node
                source   = null
              when 'FencedCode'
                if node.info is 'lay'
                  if source?
                    throw new Error """
                      Unexpected two consecutive blocks of `lay` code \
                      at #{file}:#{node.start_line}
                      """
                  source = stringContent node
                  expected = null
                  err_name = null
                  err_msg = null
                else if node.info is 'css'
                  if expected?
                    throw new Error """
                      Unexpected two consecutive blocks of `css` code \
                      at #{file}:#{node.start_line}
                      """
                  expected = stringContent node
                else if 'Error' is node.info[-5...]
                  if err_name isnt null
                    throw new Error 'Oops'
                  err_name = node.info
                  err_msg = (stringContent node).trim()
              when 'List'
                if desc
                  it desc, ->
                    testList node
                  desc = null
                else
                  throw new Error 'Oops'
              else
                throw new Error 'Oops'

            if desc and source? and (expected? or err_name)
              cases.push {
                source:   source
                expected: expected
                err_name: err_name
                err_msg:  err_msg
              }

              source   = null
              expected = null
              err_name = null
              err_msg  = null

          if desc
            if cases.length
              it desc, ((cases) ->
                for c in cases
                  try
                    layla = new Layla
                    layla.scope.paths.push path.dirname file
                    actual = layla.compile c.source
                    actual.should.be.exactly c.expected
                  catch e
                    throw e unless c.err_name or c.err_msg
                    throw e if c.err_name and e.name isnt c.err_name
                    e.message.should.be.exactly c.err_msg if c.err_msg
              ).bind @, cases
            else
              it desc

        testList = (node) ->
          testListItem item for item in node.children

        todo = yes

        while nodes.length
          node = nodes[0]

          switch node.t
            when 'SetextHeader', 'ATXHeader'
              if node.level <= level
                if todo
                  it 'TODO'
                return
              else
                nodes.shift()
                desc = stringContent node
                describe desc, ->
                  testSection node.level
                todo = no

            when 'List'
              testList node
              nodes.shift()
              todo = no
            when 'BlockQuote'
              # Consider it a "comment"
              nodes.shift()
            else
              throw new Error "Unexpected node type: #{node.t}"

        it 'TODO' if todo

    testDocument doc

  testDir = (dir) ->
    for name in fs.readdirSync dir
      if name[0] != '.'
        file = path.join dir, name
        if st = fs.statSync file
          if st.isDirectory()
            desc = "#{(name.charAt 0).toUpperCase()}#{name.substr 1}"
            describe desc, ->
              testDir file
          else if st.isFile() and name.match /\.md$/
            testFile file
        else
          throw new Error "Could not stat file #{file_path}"

  testDir __dirname
