angular.module('brokenPromisesApp').directive "scrollTo", ['$timeout', ($timeout) ->
    (scope, element, attrs) ->
        scope.$watch "$last", ->
            $timeout ->
                $(window).scrollTo(element, attrs.scrollTo or 0)
]