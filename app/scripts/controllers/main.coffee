'use strict'

angular.module('brokenPromisesApp')
    .controller 'MainCtrl', ($scope, $http, $filter, Restangular) ->
        $scope.days = []
        $scope.month = []
        $scope.year  = []
        # Date information
        $scope.dates =
          day : do Date.today
          month : do Date.today
          year : do Date.today

        load = (filter, cb) =>
          (do (Restangular.all "articles#{filter}").getList).then (data) =>
            cb data._items

        loadDay = =>
          dateArr = [($filter 'date') $scope.dates.day, "yyyy"
                     ($filter 'date') $scope.dates.day, "MM"
                     ($filter 'date') $scope.dates.day, "dd"]
          date = _.reduce dateArr, (a, b) -> "#{a}, #{b}"
          filter = '?where={"ref_dates.date":{"$all":[' + date + ']},"note":2}&' + (do Date.now)
          console.log filter
          load filter, (data) =>
            $scope.days = []
            _.map data, (article) =>
              article['reference_date'] = new Date $scope.dates.day[0], $scope.dates.day[1], $scope.dates.day[2]
              _.map article.ref_dates, (ref_date) =>
                if (_.difference dateArr, ref_date.date).length is 0
                  article['snippet'] = ref_date.extract if ref_date.extract?
              article.pub_date = new Date article.pub_date
              $scope.days.push angular.copy article

        do loadDay

        $scope.active  = -1
        $scope.article = null
        $scope.previewStyle = ->
            left: if $scope.active is -1 then "100%" else ($scope.active+1)*33.33 + "%"
        $scope.setArticle = (article, active=-1)->
            if (active >= 0)
              if $scope.article? and $scope.article.url is article.url
                $scope.article = undefined
                active = -1
              else
                $scope.article = article
            else
              $scope.article = undefined
            $scope.active  = active
        $scope.isToday = (item)-> true

        $scope.change = (scale, direction) =>
          if scale is 'day'
            $scope.dates.day.add days : direction
            do loadDay
          else if scale is 'month'
            $scope.dates.month.add months : direction
          else if scale is 'year'
            $scope.dates.year.add years : direction
