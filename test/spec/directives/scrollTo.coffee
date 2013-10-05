'use strict'

describe 'Directive: scrollTo', () ->

  # load the directive's module
  beforeEach module 'brokenPromisesApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<scroll-to></scroll-to>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the scrollTo directive'
