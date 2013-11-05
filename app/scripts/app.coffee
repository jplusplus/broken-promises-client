'use strict'

angular.module('brokenPromisesApp', ["ngRoute", "ui.bootstrap", 'restangular'])
  .config ["$routeProvider", "$sceProvider", 'RestangularProvider', '$httpProvider',
    ($routeProvider, $sceProvider, RestangularProvider, $httpProvider) ->
      $sceProvider.enabled(false)

      RestangularProvider.setBaseUrl "http://localhost\:5000"
      RestangularProvider.setListTypeIsArray false
      RestangularProvider.setRestangularFields
        id: "_id"

      $routeProvider
        .when '/',
          templateUrl   : 'views/main.html'
          controller    : 'MainCtrl'
          reloadOnSearch: false
        .otherwise
          redirectTo: '/'
  ]