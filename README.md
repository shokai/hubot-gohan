Hubot Gohan
===========
Recommend today's Gohan (ごはん|🍚), works with Hubot.

[![Build Status](https://travis-ci.org/shokai/hubot-gohan.svg?branch=master)](https://travis-ci.org/shokai/hubot-gohan)

- https://github.com/shokai/hubot-gohan
- https://npmjs.org/package/hubot-gohan

![screen shot](http://gyazo.com/742e56ecf153fbb04504ba059bb0e71f.png)

Install
-------

    % npm install hubot-gohan -save


### edit `external-script.json`

```json
["hubot-gohan"]
```

Usage
-----

    hubot ごはん
    hubot ご飯


Test
----

    % npm install

    % grunt
    # or
    % npm test


Debug
-----

    % DEBUG=hubot* hubot
    Hubot> hubot ごはん
    Hubot>   hubot-gohan:gohan getting Gohan.. +0ms
      hubot-gohan:gohan got 8 pages +2s
    @Shell 「シャシリク」を食べましょう
    http://ja.wikipedia.org/wiki/シャシリク
    Hubot> hubot ご飯
    Hubot>   hubot-gohan:gohan getting Gohan.. +6s
      hubot-gohan:gohan cache hit (http://ja.wikipedia.org/wiki/Category:料理) +1ms
      hubot-gohan:gohan got 46 pages +1s
    @Shell 「ロミロミサーモン」を食べましょう
    http://ja.wikipedia.org/wiki/ロミロミサーモン
