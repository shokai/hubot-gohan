# Description:
#   hubot-random-gohan
#
# Commands:
#   hubot ごはん
#
# Author:
#   @shokai

_       = require 'lodash'
request = require 'request'
cheerio = require 'cheerio'
debug   = require('debug')('hubot-gohan')

base_url = 'http://ja.wikipedia.org'

getPages = (url, callback = ->) ->
  request url, (err, res, body) ->
    if err
      return callback err

    $ = cheerio.load body
    callback null, _.map $('#bodyContent a'), (a) ->
      link: decodeURI a.attribs?.href
      title: a.attribs?.title

getGohan = (callback = ->) ->
  getPages "#{base_url}/wiki/Category:料理", (err, pages) ->
    if err
      return callback err
    categories = _.filter pages, (page) -> /^\/wiki\/Category:/.test page.link
    category = _.sample categories
    getPages "#{base_url}#{category.link}", (err, pages) ->
      if err
        return callback err
      pages = _.filter pages, (page) ->
        !(/^\/wiki\/Category:/.test page.link) and
        /^\/wiki\/.+/.test(page.link) and
        page.title?
      gohan = _.sample pages
      callback null, {url: "#{base_url}#{gohan.link}", title: gohan.title}


module.exports = (robot) ->

  robot.respond /(ごはん|ご飯)$/i, (msg) ->
    who = msg.message.user.name

    debug 'getting Gohan..'
    getGohan (err, gohan) ->
      if err
        msg.send "ごはんエラー #{err}"
        return
      msg.send """
      @#{who} 「#{gohan.title}」を食べましょう
      #{gohan.url}
      """
