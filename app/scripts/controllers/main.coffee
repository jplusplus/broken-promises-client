'use strict'
# parse a date in mm/dd/yyyy format
parseDate = (input)->
  parts = input.split("/")  
  # new Date(year, month [, date [, hours[, minutes[, seconds[, ms]]]]])
  new Date(parts[2], parts[0] - 1, parts[1]) # months are 0-based

# Yes if dates are the same
daysBetween = (first, second) ->
  # Copy date parts of the timestamps, discarding the time parts.
  one = new Date(first.getFullYear(), first.getMonth(), first.getDate())
  two = new Date(second.getFullYear(), second.getMonth(), second.getDate())  
  # Do the math.
  millisecondsPerDay = 1000 * 60 * 60 * 24
  millisBetween = two.getTime() - one.getTime()
  days = millisBetween / millisecondsPerDay  
  # Round down.
  Math.floor days

angular.module('brokenPromisesApp')
    .controller 'MainCtrl', ($scope, $http, $filter) ->
        today = $scope.today = new Date(2013, 9, 7)
        month = $filter('date')(today, "MMMM")
        year  = $filter('date')(today, "yyyy")        
        $scope.monthPlus = []
        $scope.yearPlus  = []
        # Loads data from files
        $http.get("./data/days-#{month.toLowerCase()}-#{year}.json").then (d)-> 
            $scope.days = []
            for article in d.data
                article["reference date"]       = parseDate(article["reference date"])
                article["web_publication_date"] = parseDate(article["web_publication_date"])
                console.log article["reference date"]
                # Same day!
                if daysBetween(article["reference date"], today) is 0
                    $scope.days.push article

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
