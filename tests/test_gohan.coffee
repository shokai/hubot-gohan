path = require 'path'
require path.resolve 'tests', 'test_helper'

assert     = require 'assert'
Gohan = require path.resolve 'scripts', 'gohan'

gohan = new Gohan

describe 'Gohan', ->

  it 'sohuld have method "getPages"', ->
    assert.equal typeof gohan['getPages'], 'function'

  describe 'method "getPages"', ->

    it 'should callback Array of pages', ->
      @timeout 5000

      gohan.getPages "http://ja.wikipedia.org/wiki/Category:料理"
      .then (pages) ->
        assert.equal pages instanceof Array, true


  it 'sohuld have method "getGohan"', ->
    assert.equal typeof gohan['getGohan'], 'function'

  describe 'method "getGohan"', ->

    it 'should callback the gohan', ->
      @timeout 5000

      gohan.getGohan()
      .then (res) ->
        assert.equal typeof res['title'], 'string', '"title" property'
        assert.equal /^https?:\/\/.+/.test(res['url']), true, '"url" property'
