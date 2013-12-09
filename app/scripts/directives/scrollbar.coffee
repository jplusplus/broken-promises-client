'use strict';

angular.module('brokenPromisesApp')
	.directive 'scrollbar', ->
        restrict: "AE"
        link: (scope, element, attrs)->
            element.jScrollPane
                autoReinitialise     : true
                hideFocus            : true
                mouseWheelSpeed      : 20
                verticalDragMinHeight: 10
            if attrs.scrollbar?
                element.on 'jsp-scroll-y', (event, y, atTop, atBottom) ->
                    if atBottom
                        scope.$apply attrs.scrollbar
        template: '<div class="scrollbar"><div ng-transclude></div></div>',
        transclude: true