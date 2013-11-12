'use strict'

angular.module('brokenPromisesApp')
    .controller 'MainCtrl', ($scope, $http, $filter, Restangular) ->
        today = $scope.today = new Date()
        month = $filter('date')(today, "MMMM")
        monthDigit = parseInt $filter('date')(today, "MM")
        year  = parseInt $filter('date')(today, "yyyy")
        day = parseInt $filter('date')(today, "dd")
        $scope.month = []
        $scope.year  = []
        # Date information
        $scope.date =
          day : $filter('date')(today, "dd")
          month : month
          year : year
        # Loads data from API
        filter = '?where={"ref_dates.date":' + year + ',"note":2}'
        (do (Restangular.all "articles#{filter}").getList).then (data) =>
          $scope.days = []
          _.map data._items, (article) =>
            if not article.ref_dates[0]?
              return
            _.map article.ref_dates, (ref_date, index) =>
              a_year = ref_date.date[0]
              if a_year is year
                a_month = ref_date.date[1]
                a_day = ref_date.date[2]
                article['reference_date'] = new Date a_year, a_month, a_day
                article['snippet'] = ref_date.extract if ref_date.extract?
                if a_month is monthDigit
                  if a_day is day
                    $scope.days.push article
                  else if not a_day?
                    $scope.month.push article
                else if not a_month?
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
