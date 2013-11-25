'use strict'

angular.module('brokenPromisesApp')
    .controller 'MainCtrl', ($scope, $http, $filter, Restangular) ->
        $scope.articles =
          day : []
          month : []
          year : []

        $scope.dates =
          day : do Date.today
          month : do Date.today
          year : do Date.today

        $scope.scrape_dates =
          day : undefined
          month : undefined
          year : undefined

        $scope.dates_format =
          day : 'MMMM dd yyyy'
          month : 'MMMM yyyy'
          year : 'yyyy'

        $scope.email =
          day :
            showform : no
            registered : no
            value : undefined
          month :
            showform : no
            registered : no
            value : undefined
          year :
            showform : no
            registered : no
            value : undefined

        $scope.subscribe = (scale) =>
          if $scope.email[scale].value
            $scope.email[scale].registered = yes

        load = (dateArr, field) =>
          $scope.articles[field] = []
          $scope.email[field] =
            showform : no
            registered : no
            value : undefined
          $scope.scrape_dates[field] = undefined
          (do (Restangular.all "articles/#{dateArr.join '/'}").getList).then (data) =>
            _.map data.articles, (article) =>
              article['reference_date'] = $scope.dates.day
              _.map article.ref_dates, (ref_date) =>
                if (_.difference dateArr, ref_date.date).length is 0
                  article['snippet'] = ref_date.extract if ref_date.extract?
              article.pub_date = new Date article.pub_date
              $scope.articles[field].push angular.copy article
          ### Retrieve the 'last_scrape' date ###
          (do (Restangular.all "last_scrape/#{dateArr.join '/'}").getList).then (data) =>
            if data.status isnt 'no_result'
              $scope.scrape_dates[field] = new Date data.last_scrape_date

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
        $scope.setArticle = (article, active=-1) ->
            if active is 'day' then active = 0
            else if active is 'month' then active = 1
            else if active is 'year' then active = 2
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