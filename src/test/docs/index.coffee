# 3rd party
mark = require 'commonmark'
fs   = require 'fs'

# Main lib
Layla = require '../../lib'

describe 'Docs', ->

  describe "The Readme file", ->

    doc = null

    it 'Is valid Markdown', ->
      text = fs.readFileSync 'Readme.md', 'utf8'
      parser = new mark.DocParser
      doc = parser.parse text
      doc.should.be.an.Object

    it 'Contains only code examples that actually work', ->
      last = null

      doNode = (node) ->
        if node.t is 'FencedCode'
          if last?.lang is 'lay' and node.info is 'css'
            last.text.should.not.be.empty
            node.string_content.should.not.be.empty
            source = last.text
            expected = node.string_content

            layla = new Layla
            ast = layla.parse source
            doc = layla.evaluate ast
            actual = layla.emit doc
            actual.should.be.exactly expected
          else
            last =
              lang: node.info
              text: node.string_content

        if node.children?
          doNode child for child in node.children

      doNode doc
