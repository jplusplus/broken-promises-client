'use strict'

angular.module('brokenPromisesApp', ["ngRoute"])
  .config ["$routeProvider", "$sceProvider", ($routeProvider,$sceProvider) ->
    $sceProvider.enabled(false)
    $routeProvider
      .when '/',
        templateUrl   : 'views/main.html'
        controller    : 'MainCtrl'
        reloadOnSearch: false
      .otherwise
        redirectTo: '/'
  ]