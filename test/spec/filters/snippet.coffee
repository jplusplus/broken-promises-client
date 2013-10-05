'use strict'

describe 'Filter: snippet', () ->

  # load the filter's module
  beforeEach module 'brokenPromisesApp'

  # initialize a new instance of the filter before each test
  snippet = {}
  beforeEach inject ($filter) ->
    snippet = $filter 'snippet'

  it 'should return the input prefixed with "snippet filter:"', () ->
    text = 'angularjs'
    expect(snippet text).toBe ('snippet filter: ' + text)
