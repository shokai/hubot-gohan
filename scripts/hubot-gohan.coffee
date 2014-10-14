# Description:
#   recommend today's Gohan (ごはん)
#
# Commands:
#   hubot ごはん
#
# Author:
#   @shokai

path  = require 'path'
Gohan = require path.join __dirname, '../lib/gohan'
debug = require('debug')('hubot-gohan')
{Promise} = require 'es6-promise'

gohan = new Gohan()

module.exports = (robot) ->

  robot.respond /(ごはん|ご飯)$/i, (msg) ->
    who = msg.message.user.name

    gohan.getGohan()
    .then (res) ->
      text = """
      @#{who} 「#{res.title}」を食べましょう
      #{res.url}
      """
      if res.description
        desc = res.description.match(/^([^。]+。)/)[0]
        text += "\n\n#{desc}"
      if res.image
        text += "\n#{res.image}"
      msg.send text

    .catch (err) ->
      msg.send """
      @#{who} ごはんエラー
      ```
      #{err}
      ```
      """

