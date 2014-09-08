_       = require 'lodash'
request = require 'request'
cheerio = require 'cheerio'
debug   = require('debug')('hubot-gohan:gohan')

module.exports = class Gohan

  constructor: ->
    @baseUrl = 'http://ja.wikipedia.org'

  getPages: (url, callback = ->) ->
    request url, (err, res, body) ->
      if err
        return callback err

      $ = cheerio.load body
      callback null, _.map $('#bodyContent a'), (a) ->
        link: decodeURI a.attribs?.href
        title: a.attribs?.title

  getGohan: (callback = ->) ->
    debug 'getting Gohan..'
    @getPages "#{@baseUrl}/wiki/Category:料理", (err, pages) =>
      if err
        return callback err
      categories = _.filter pages, (page) -> /^\/wiki\/Category:/.test page.link
      category = _.sample categories
      @getPages "#{@baseUrl}#{category.link}", (err, pages) =>
        if err
          return callback err
        pages = _.filter pages, (page) ->
          !(/^\/wiki\/Category:/.test page.link) and
          /^\/wiki\/.+/.test(page.link) and
          page.title?
        debug "got #{pages.length} pages"
        gohan = _.sample pages
        callback null, {url: "#{@baseUrl}#{gohan.link}", title: gohan.title}
