'use strict'

# Lowercase, transforms spaces / tabs into _ and keeps only alphanumerics
angular.module("brokenPromisesApp").filter "slugify", ->
    (string) =>
        ((do string.toLowerCase).replace /[^\w\s]/g, '').replace /\s+/g, '_'