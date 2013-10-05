'use strict'

angular.module('brokenPromisesApp')
    .controller 'MainCtrl', ($scope) ->
        $scope.today  = new Date()
        $scope.items  = new Array(100)
        $scope.active = -1   
        $scope.previewStyle = ->
            left: if $scope.active is -1 then "100%" else ($scope.active+1)*33.33 + "%"