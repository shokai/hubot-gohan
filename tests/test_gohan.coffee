path = require 'path'
require path.resolve 'tests', 'test_helper'

assert = require 'assert'
Gohan  = require path.resolve 'lib', 'gohan'

gohan = new Gohan

describe 'Gohan', ->

  it 'should have method "getDetail"', ->
    assert.equal typeof gohan['getDetail'], 'function'

  describe 'method "getDetail"', ->

    it 'should callback page detail', ->
      @timeout 5000

      gohan.getDetail('けんちん汁')
      .then (res) ->
        assert.equal res.title, 'けんちん汁', '"title" property'
        assert.equal typeof res.description, 'string', '"detail" property'
        assert.equal /^https?:\/\/.+(.jpe?g|gif|png)/i.test(res.image), true, '"image" URL'

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
        assert.equal typeof res.title, 'string', '"title" property'
        assert.equal /^https?:\/\/.+/.test(res.url), true, '"url" property'
        assert.equal /^https?:\/\/.+(.jpe?g|gif|png)/i.test(res.image), true, '"image" URL'
        assert.equal typeof res.description, 'string', '"description" property'
