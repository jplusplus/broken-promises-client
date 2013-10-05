'use strict';

angular.module('brokenPromisesApp')
	.directive 'scrollbar', ->
        restrict: "AE"
        link: (scope, element, attrs)->            
            element.wrap("<div />").jScrollPane 
                autoReinitialise:true
                hideFocus:true      
                mouseWheelSpeed:20
                verticalDragMinHeight:10
        template: '<div class="scrollbar"><div ng-transclude></div></div>',
        transclude: true 