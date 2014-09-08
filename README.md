Hubot Gohan
===========
Recommend today's Gohan (ごはん|🍚), works with Hubot.

[![Build Status](https://travis-ci.org/shokai/hubot-gohan.svg?branch=master)](https://travis-ci.org/shokai/hubot-gohan)

- https://github.com/shokai/hubot-gohan
- https://npmjs.org/package/hubot-gohan


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
    Hubot>   hubot-gohan getting Gohan.. +0ms
    @Shell 「シャシリク」を食べましょう
    http://ja.wikipedia.org/wiki/シャシリク
