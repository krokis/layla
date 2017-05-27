# SEE: https://gist.github.com/patoi/5330701

fs        = require 'fs'
Path      = require 'path'
Express   = require 'express'
Phantom   = require 'phantomjs-prebuilt'
webdriver = require 'selenium-webdriver'
{expect}  = require 'chai'

HTTP_PORT = 3000

$server = null

before ->
  # Start a mini web server
  app = Express()

  app.use Express.static __dirname
  app.use '/', Express.static(Path.join __dirname, '../../browser/')

  $server = app.listen HTTP_PORT

after ->
  $server.close()

describe 'Browser', ->

  By = webdriver.By

  if process.env.CI
    wd_url = 'http://ondemand.saucelabs.com:80/wd/hub'
    defaultCapabilities =
      username: process.env.SAUCE_USERNAME
      accessKey: process.env.SAUCE_ACCESS_KEY
      tunnelIdentifier: process.env.TRAVIS_JOB_NUMBER
  else
    wd_url = webdriver.Builder.DEFAULT_SERVER_URL
    defaultCapabilities =
      'phantomjs.binary.path': Phantom.path
      'phantomjs.cli.args': [
        '--web-security=false'
        '--debug=true'
      ]

  testBrowser = (name, version) ->
    version = '' if version is 'latest'

    it "#{name} #{version}", (done) ->
      capabilities = Object.assign defaultCapabilities, {
        browserName: name.toLowerCase()
      }

      try
        driver = (new webdriver.Builder)
          .usingServer wd_url
          .withCapabilities capabilities
          .build()

        driver.get "http://127.0.0.1:#{HTTP_PORT}"

        driver
          .findElement By.css 'body'
          .getCssValue 'font-size'
          .then (size) ->
            expect(size).to.equal "17px"
            driver
              .findElement By.css 'body'
              .getCssValue 'font-family'
              .then (font) ->
                font = font.replace /["'\s]/g, ''
                expect(font).to.equal "Helvetica®Neue,Arial,sans-serif"
                driver.quit()
                done()
      catch
        @skip()

  browsers = require './browsers.json'

  for name of browsers
    versions = [].concat browsers[name]

    for version in versions
      testBrowser name, version

