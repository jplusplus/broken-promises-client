'use strict'
# parse a date in mm/dd/yyyy format
parseDate = (input)->
  parts = input.split("/")  
  # new Date(year, month [, date [, hours[, minutes[, seconds[, ms]]]]])
  new Date(parts[2], parts[0] - 1, parts[1]) # months are 0-based

# Yes if dates are the same day
daysBetween = (first, second) ->
  # Copy date parts of the timestamps, discarding the time parts.
  one = new Date(first.getFullYear(), first.getMonth(), 1)
  two = new Date(second.getFullYear(), second.getMonth(), 1)  
  # Do the math.
  millisecondsPerDay = 1000 * 60 * 60 * 24
  millisBetween = two.getTime() - one.getTime()
  days = millisBetween / millisecondsPerDay  
  # Round down.
  Math.floor days

# Yes if dates are the same month
monthsBetween = (first, second) ->
    months
    months = (second.getFullYear() - first.getFullYear()) * 12
    months -= first.getMonth() + 1
    months += second.getMonth()
    if months <= 0 then 0 else months

angular.module('brokenPromisesApp')
    .controller 'MainCtrl', ($scope, $http, $filter, Restangular) ->
        today = $scope.today = new Date()
        month = $filter('date')(today, "MMMM")
        year  = $filter('date')(today, "yyyy")        
        $scope.month = []
        $scope.year  = []
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
