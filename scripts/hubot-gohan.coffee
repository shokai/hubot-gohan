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

gohan = new Gohan()

module.exports = (robot) ->

  robot.respond /(ごはん|ご飯)$/i, (msg) ->
    who = msg.message.user.name

    gohan.getGohan (err, res) ->
      if err
        msg.send "@#{who} ごはんエラー #{err}"
        return
      msg.send """
      @#{who} 「#{res.title}」を食べましょう
      #{res.url}
      """
