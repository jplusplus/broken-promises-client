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

        @loadday = =>
          dateArr = [($filter 'date') $scope.dates.day, "yyyy"
                     ($filter 'date') $scope.dates.day, "MM"
                     ($filter 'date') $scope.dates.day, "dd"]
          date = _.reduce dateArr, (a, b) -> "#{a}, #{b}"
          filter = '?where={"ref_dates.date":{"$all":[' + date + ']},"note":2}&' + (do Date.now)
          load filter, (data) =>
            $scope.days = []
            _.map data, (article) =>
              article['reference_date'] = $scope.dates.day
              _.map article.ref_dates, (ref_date) =>
                if (_.difference dateArr, ref_date.date).length is 0
                  article['snippet'] = ref_date.extract if ref_date.extract?
              article.pub_date = new Date article.pub_date
              $scope.days.push angular.copy article

        @loadmonth = =>
          console.log "LOAD MONTH"

        @loadyear = =>
          console.log "LOAD YEAR"

        do @loadday

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
          ops = {}; ops["#{scale}s"] = direction
          $scope.dates[scale].add ops
          do @["load#{scale}"]