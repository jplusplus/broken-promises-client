'use strict'

angular.module('brokenPromisesApp')
    .controller 'MainCtrl', ($scope, $http, $filter, Restangular) ->
        today = $scope.today = new Date()
        month = $filter('date')(today, "MMMM")
        year  = $filter('date')(today, "yyyy")
        $scope.month = []
        $scope.year  = []
        # Date information
        $scope.date =
          day : $filter('date')(today, "dd")
          month : month
          year : year
        # Loads data from API
        (do (Restangular.all 'articles').getList).then (data) =>
          $scope.days = []
          _.map data[0], (article) =>
            year = parseInt article['ref_date'][0]
            if year is do today.getFullYear
              month = (parseInt article['ref_date'][1]) - 1
              day = parseInt article['ref_date'][2]
              article['reference_date'] = new Date year, month, day
              if month is do today.getMonth
                if day is do today.getDate
                  $scope.days.push article
                else
                  $scope.month.push article
              else
                $scope.year.push article
        $scope.active  = -1   
        $scope.article = null
        $scope.previewStyle = ->
            left: if $scope.active is -1 then "100%" else ($scope.active+1)*33.33 + "%"        
        $scope.setArticle = (article, active=-1)->
            # Record the data to the scope
            $scope.article = article
            $scope.active  = active 
        $scope.isToday = (item)-> true
