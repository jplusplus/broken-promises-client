'use strict'

angular.module('brokenPromisesApp')
    .controller 'MainCtrl', ($scope, $http, $filter, Restangular) ->
        $scope.day = []
        $scope.month = []
        $scope.year  = []
        # Date information
        $scope.dates =
          day : do Date.today
          month : do Date.today
          year : do Date.today

        $scope.scrap_dates =
          day : undefined
          month : undefined
          year : undefined

        load = (dateArr, field) =>
          $scope[field] = []
          (do (Restangular.all "articles/#{dateArr.join '/'}").getList).then (data) =>
            _.map data.articles, (article) =>
              article['reference_date'] = $scope.dates.day
              _.map article.ref_dates, (ref_date) =>
                if (_.difference dateArr, ref_date.date).length is 0
                  article['snippet'] = ref_date.extract if ref_date.extract?
              article.pub_date = new Date article.pub_date
              $scope[field].push angular.copy article
          ### Retrieve the 'last_scrape' date ###
          (do (Restangular.all "last_scrape/#{dateArr.join '/'}").getList).then (data) =>
            if data[0] isnt 'no_result'
              console.log "HERER"

        @loadday = =>
          dateArr = [($filter 'date') $scope.dates.day, "yyyy"
                     ($filter 'date') $scope.dates.day, "MM"
                     ($filter 'date') $scope.dates.day, "dd"]
          load dateArr, 'day'

        @loadmonth = =>
          dateArr = [($filter 'date') $scope.dates.month, "yyyy"
                     ($filter 'date') $scope.dates.month, "MM"]
          load dateArr, 'month'

        @loadyear = =>
          dateArr = [($filter 'date') $scope.dates.year, "yyyy"]
          load dateArr, 'year'

        do @loadday
        do @loadmonth
        do @loadyear

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