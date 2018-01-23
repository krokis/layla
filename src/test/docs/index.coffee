# 3rd party
mark     = require 'commonmark'
fs       = require 'fs'
{expect} = require 'chai'

# Main lib
Layla = require '../../lib'

describe 'Docs', ->

  describe "The Readme file", ->

    doc = null

    it 'Is valid Markdown', ->
      text = fs.readFileSync 'Readme.md', 'utf8'
      parser = new mark.DocParser
      doc = parser.parse text
      expect(doc).to.be.an 'object'

    it 'Contains only code examples that actually work', ->
      last = null

      doNode = (node) ->
        if node.t is 'FencedCode'
          if last?.lang is 'lay' and node.info is 'css'
            expect(last.text).not.to.be.empty
            expect(node.string_content).not.to.be.empty
            source = last.text
            expected = node.string_content

            layla = new Layla
            actual = layla.compile source
            expect(actual).to.equal expected
          else
            last =
              lang: node.info
              text: node.string_content

        if node.children?
          doNode child for child in node.children

      doNode doc
