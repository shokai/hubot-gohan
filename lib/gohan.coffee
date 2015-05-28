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

  getDetail: (url_or_title) =>
    debug "getDetail(#{url_or_title})"
    return new Promise (resolve, reject) =>
      url =
        if /^https?:\/\/.+/.test url_or_title
          url_or_title
        else
          "#{@baseUrl}/wiki/#{url_or_title}"
      request encodeURI(url), (err, res, body) ->
        if err or res.statusCode isnt 200
          return reject err or res
        $ = cheerio.load body
        image = $('img.thumbimage')[0]?.attribs?.src
        image = "http:#{image}" if /^\/\/.+/.test image
        return resolve
          title: $('h1').text()
          description: $('div#bodyContent p').text()
          image: image

  getPageList: (url) ->
    return new Promise (resolve, reject) ->
      debug "getPageList(#{url})"
      request encodeURI(url), (err, res, body) ->
        if err or res.statusCode isnt 200
          return reject err or res
        $ = cheerio.load body
        return resolve _.map $('#bodyContent a'), (a) ->
          link: decodeURI a.attribs?.href
          title: a.attribs?.title

  getPageListCached: (url) =>
    return new Promise (resolve, reject) =>
      @cache.get url, (err, val) =>
        if !err and val?
          debug "cache hit (#{url})"
          return resolve val

        @getPageList url
        .then (pages) =>
          if pages instanceof Array and pages.length > 0
            @cache.set url, pages
          return resolve pages

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
    .then (page) =>
      @getDetail page.url
      .then (detail) ->
        for k,v of detail
          page[k] = v unless page?.hasOwnProperty k
        return page
