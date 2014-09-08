path = require 'path'
require path.resolve 'tests', 'test_helper'

assert     = require 'assert'
Gohan = require path.resolve 'scripts', 'gohan'

gohan = new Gohan

describe 'Gohan', ->

  it 'sohuld have method "getPages"', ->
    assert.equal typeof gohan['getPages'], 'function'

  describe 'method "getPages"', ->

    it 'should callback Array of pages', (done) ->
      @timeout 5000

      gohan.getPages "http://ja.wikipedia.org/wiki/Category:料理", (err, pages) ->
        assert.equal !err, true
        if err
          done()
          return
        assert.equal pages instanceof Array, true
        done()


  it 'sohuld have method "getGohan"', ->
    assert.equal typeof gohan['getGohan'], 'function'

  describe 'method "getGohan"', ->

    it 'should callback the gohan', (done) ->
      @timeout 5000

      gohan.getGohan (err, res) ->
        assert.equal !err, true
        if err
          done()
          return
        assert.equal typeof res['title'], 'string', '"title" property'
        assert.equal /^https?:\/\/.+/.test(res['url']), true, '"url" property'
        done()
