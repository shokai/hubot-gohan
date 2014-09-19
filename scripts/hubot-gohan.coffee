# Description:
#   recommend today's Gohan (ごはん)
#
# Commands:
#   hubot ごはん
#
# Author:
#   @shokai

path  = require 'path'
Gohan = require path.join __dirname, 'gohan'
debug = require('debug')('hubot-gohan')
{Promise} = require 'es6-promise'

gohan = new Gohan()

module.exports = (robot) ->

  robot.respond /(ごはん|ご飯)$/i, (msg) ->
    who = msg.message.user.name

    gohan.getGohan()
    .then (res) ->
      msg.send """
      @#{who} 「#{res.title}」を食べましょう
      #{res.url}
      """

    .catch (err) ->
      msg.send """
      @#{who} ごはんエラー
      ```
      #{err}
      ```
      """

