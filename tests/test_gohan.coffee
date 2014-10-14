path = require 'path'
require path.resolve 'tests', 'test_helper'

assert = require 'assert'
Gohan  = require path.resolve 'lib', 'gohan'

gohan = new Gohan

describe 'Gohan', ->

  it 'sohuld have method "getPageList"', ->
    assert.equal typeof gohan['getPageList'], 'function'

  describe 'method "getPageList"', ->

    it 'should callback Array of page list', ->
      @timeout 5000

      gohan.getPageList "http://ja.wikipedia.org/wiki/Category:料理"
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
