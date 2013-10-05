'use strict'

describe 'Filter: nl2br', () ->

  # load the filter's module
  beforeEach module 'brokenPromisesApp'

  # initialize a new instance of the filter before each test
  nl2br = {}
  beforeEach inject ($filter) ->
    nl2br = $filter 'nl2br'

  it 'should return the input prefixed with "nl2br filter:"', () ->
    text = 'angularjs'
    expect(nl2br text).toBe ('nl2br filter: ' + text)
