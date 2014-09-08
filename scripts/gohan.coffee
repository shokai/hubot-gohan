_         = require 'lodash'
request   = require 'request'
cheerio   = require 'cheerio'
NodeCache = require 'node-cache'
debug     = require('debug')('hubot-gohan:gohan')


module.exports = class Gohan

  constructor: ->
    @baseUrl = 'http://ja.wikipedia.org'
    @cache = new NodeCache
      stdTTL: 3600 # 1hour
      checkperiod: 120

  getPages: (url, callback = ->) ->
    request url, (err, res, body) ->
      if err
        return callback err

      $ = cheerio.load body
      callback null, _.map $('#bodyContent a'), (a) ->
        link: decodeURI a.attribs?.href
        title: a.attribs?.title

  getPagesCached: (url, callback = ->) ->
    @cache.get url, (err, val) =>
      if !err and val.hasOwnProperty url
        debug "cache hit (#{url})"
        callback null, val[url]
        return

      @getPages url, (err, pages) =>
        if err
          callback err
          return
        if pages instanceof Array and pages.length > 0
          @cache.set url, pages
        callback null, pages

  getGohan: (callback = ->) ->
    debug 'getting Gohan..'
    @getPagesCached "#{@baseUrl}/wiki/Category:料理", (err, pages) =>
      if err
        return callback err
      categories = _.filter pages, (page) -> /^\/wiki\/Category:/.test page.link
      category = _.sample categories

      @getPagesCached "#{@baseUrl}#{category.link}", (err, pages) =>
        if err
          return callback err
        pages = _.filter pages, (page) ->
          !(/^\/wiki\/Category:/.test page.link) and
          /^\/wiki\/.+/.test(page.link) and
          page.title?
        debug "got #{pages.length} pages"
        gohan = _.sample pages
        callback null, {url: "#{@baseUrl}#{gohan.link}", title: gohan.title}
