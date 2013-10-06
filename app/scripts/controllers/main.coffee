'use strict'

angular.module('brokenPromisesApp')
    .controller 'MainCtrl', ($scope, $http, $filter) ->
        today = $scope.today = new Date(2013, 10, 07)
        month = $filter('date')(today, "MMMM")
        year  = $filter('date')(today, "yyyy")        
        $scope.monthPlus = []
        $scope.yearPlus  = []
        # Loads data from files
        $http.get("./data/days-#{month.toLowerCase()}-#{year}.json").then (d)-> 
            $scope.days = d.data            
        $http.get("./data/#{month.toLowerCase()}-#{year}.json").then (d)->             
            $scope.month = d.data
        $http.get("./data/#{year}.json").then (d)-> 
            $scope.year = d.data
        $scope.active  = -1   
        $scope.article = null
        $scope.previewStyle = ->
            left: if $scope.active is -1 then "100%" else ($scope.active+1)*33.33 + "%"        
        $scope.setArticle = (article, active=-1)->
            # Record the data to the scope
            $scope.article = article
            $scope.active  = active 
        $scope.isToday = (item)-> true
