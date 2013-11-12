'use strict'

angular.module('brokenPromisesApp', ["ngRoute", "ui.bootstrap", 'restangular'])
  .config ["$routeProvider", "$sceProvider", 'RestangularProvider',
    ($routeProvider, $sceProvider, RestangularProvider) ->
      $sceProvider.enabled(false)

      RestangularProvider.setBaseUrl "http://broken-promises.herokuapp.com"
      RestangularProvider.setListTypeIsArray false
      RestangularProvider.setRestangularFields
        id: "_id"
      RestangularProvider.setDefaultHttpFields
        cache : no

      $routeProvider
        .when '/',
          templateUrl   : 'views/main.html'
          controller    : 'MainCtrl'
          reloadOnSearch: false
        .otherwise
          redirectTo: '/'
  ]