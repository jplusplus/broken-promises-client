'use strict'

angular.module('brokenPromisesApp')
    .controller 'MainCtrl', ($scope, $http, $filter, Restangular) ->
        today = $scope.today = new Date()
        month = $filter('date')(today, "MMMM")
        monthDigit = $filter('date')(today, "MM")
        year  = $filter('date')(today, "yyyy")
        day = $filter('date')(today, "dd")
        $scope.month = []
        $scope.year  = []
        # Date information
        $scope.date =
          day : $filter('date')(today, "dd")
          month : month
          year : year
        # Loads data from API
        #filter = '?where={"ref_date":"' + year + '"}'
        filter = ''
        (do (Restangular.all "articles#{filter}").getList).then (data) =>
          $scope.days = []
          _.map data._items, (article) =>
            if not article.ref_dates[0]?
              return
            a_year = article.ref_dates[0].date[0]
            if a_year is year
              a_month = article.ref_dates[0].date[1]
              a_day = article.ref_dates[0].date[2]
              article['reference_date'] = new Date a_year, a_month, a_day
              if a_month is monthDigit
                if a_day is day
                  $scope.days.push article
                else if not a_day? or a_day > day
                  $scope.month.push article
              else if not a_month? or a_month > monthDigit
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
