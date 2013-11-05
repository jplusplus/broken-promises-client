'use strict'

angular.module("brokenPromisesApp").filter "slugify", ->
    (string) =>
        (do string.toLowerCase).replace /\s+/g, '_'