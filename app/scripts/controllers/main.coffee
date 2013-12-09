'use strict'

angular.module('brokenPromisesApp')
    .controller 'MainCtrl', ($scope, $http, $filter, Restangular, $timeout) ->
        Limit = 20

        $scope.articles =
          day : []
          month : []
          year : []

        $scope.skipArticles =
          day : 0
          month : 0
          year : 0

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

        $scope.loading =
          day : yes
          month : yes
          year : yes

        $scope.calendars =
          day : no
          month : no
          year : no

        getDateArr = (scale) =>
          if scale is 'day'
            [($filter 'date') $scope.dates.day, "yyyy"
             ($filter 'date') $scope.dates.day, "MM"
             ($filter 'date') $scope.dates.day, "dd"]
          else if scale is 'month'
            [($filter 'date') $scope.dates.month, "yyyy"
             ($filter 'date') $scope.dates.month, "MM"]
          else if scale is 'year'
            [($filter 'date') $scope.dates.year, "yyyy"]
          else
            null

        $scope.subscribe = (scale) =>
          if $scope.email[scale].value
            dateArr = getDateArr scale
            url = "http://broken-promises.herokuapp.com/search_date/#{$scope.email[scale].value}/#{dateArr.join '/'}"
            ($http.post url, '').success (data) =>
              if data.status is 'ok'
                $scope.email[scale].registered = yes

        reset = (field, hard=no) =>
          if hard
            $scope.articles[field] = []
            $scope.skipArticles[field] = 0
            $scope.email[field] =
              showform : no
              registered : no
              value : undefined
            $scope.scrape_dates[field] = undefined
          $scope.loading[field] = yes

        load = (field, hard=no) =>
          dateArr = getDateArr field
          reset field, hard
          demanded = angular.copy $scope.dates[field]
          url = "articles/#{dateArr.join '/'}?limit=#{Limit}&skip=#{$scope.skipArticles[field]}"
          (do (Restangular.all url).getList).then (data) =>
            if Date.compare demanded, $scope.dates[field]
              return

            if data.articles.length < Limit
              $scope.skipArticles[field] = -1
            else
              $scope.skipArticles[field] += data.articles.length

            reset field, hard

            _.map data.articles, (article) =>
              article['reference_date'] = $scope.dates[field]
              _.map article.ref_dates, (ref_date) =>
                ref_date.date = _.map ref_date.date, (s) =>
                  if s < 10 then '0' + String s else String s
                if (_.difference dateArr, ref_date.date).length is 0
                  article['snippet'] = ref_date.extract if ref_date.extract?
              article.pub_date = Date.parse article.pub_date
              article.body = do article.body.trim
              $scope.articles[field].push angular.copy article

            $scope.loading[field] = no

            ### Retrieve the 'last_scrape' date ###
            (do (Restangular.all "last_scrape/#{dateArr.join '/'}").getList).then (data) =>
              if Date.compare demanded, $scope.dates[field]
                return
              if data.status isnt 'no_result'
                $scope.scrape_dates[field] = Date.parse data.last_scrape_date

        $scope.active  = -1
        $scope.article = null

        $scope.previewStyle = ->
          switch $scope.active
            when -1
              return ''
            when 0
              return 'day'
            when 1
              return 'month'
            when 2
              return 'year'

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
          load scale, yes
          $scope.active = -1

        $scope.$watch 'dates.day', => load 'day'
        $scope.$watch 'dates.month', => load 'month'
        $scope.$watch 'dates.year', => load 'year'

        $scope.openCalendar = (scale) =>
          if not $scope.calendars[scale]
            $timeout =>
              $scope.calendars[scale] = yes

        $scope.loadmore = (scale) =>
          if $scope.skipArticles[scale] >= 0 and !$scope.loading[scale]
            $scope.loading[scale] = yes
            load scale