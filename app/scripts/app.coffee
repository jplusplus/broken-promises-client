'use strict'

angular.module('brokenPromisesApp', ["ngRoute"])
  .config ["$routeProvider", ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl   : 'views/main.html'
        controller    : 'MainCtrl'
        reloadOnSearch: false
      .otherwise
        redirectTo: '/'
  ]