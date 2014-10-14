_         = require 'lodash'
request   = require 'request'
cheerio   = require 'cheerio'
NodeCache = require 'node-cache'
debug     = require('debug')('hubot-gohan:gohan')

{Promise} = require 'es6-promise'

module.exports = class Gohan

  constructor: ->
    @baseUrl = 'http://ja.wikipedia.org'
    @cache = new NodeCache
      stdTTL: 3600 # 1hour
      checkperiod: 120

  getPageList: (url) ->
    debug "getPageList(#{url})"
    return new Promise (resolve, reject) ->
      request url, (err, res, body) ->
        if err
          reject err
          return
        $ = cheerio.load body
        resolve _.map $('#bodyContent a'), (a) ->
          link: decodeURI a.attribs?.href
          title: a.attribs?.title

  getPageListCached: (url) ->
    return new Promise (resolve, reject) =>
      @cache.get url, (err, val) =>
        if !err and val.hasOwnProperty url
          debug "cache hit (#{url})"
          resolve val[url]
          return

        @getPageList url
        .then (pages) =>
          if pages instanceof Array and pages.length > 0
            @cache.set url, pages
          resolve pages

  getGohan: ->
    debug 'getting Gohan..'
    @getPageListCached "#{@baseUrl}/wiki/Category:料理"
    .then (pages) =>
      categories = _.filter pages, (page) -> /^\/wiki\/Category:/.test page.link
      return _.sample categories
    .then (category) =>
      @getPageListCached "#{@baseUrl}#{category.link}"
    .then (pages) =>
      pages = _.filter pages, (page) ->
        !(/^\/wiki\/Category:/.test page.link) and
        /^\/wiki\/.+/.test(page.link) and
        page.title?
      debug "got #{pages.length} pages"
      gohan = _.sample pages
      return {url: "#{@baseUrl}#{gohan.link}", title: gohan.title}
