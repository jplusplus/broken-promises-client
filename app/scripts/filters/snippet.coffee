'use strict';

angular.module("brokenPromisesApp").filter "snippet", ->
  (string, type) ->
    end = undefined
    i = undefined
    parts = undefined
    theMatch = undefined
    trimmedString = undefined
    string = string.replace(/(<([^>]+)>)/g, "").toLowerCase()
    parts = string.split(".").slice(0, 50)
    i = 0
    end = parts.length
    while i < end
      switch type
        when "day"
          theMatch = "7 october 2013"
        when "month"
          theMatch = "october 2013"
        when "year"
          theMatch = "2013"
      return parts[i].replace(theMatch, "<span class=\"littlepart\">" + theMatch + "</span>")  if targetIndex isnt -1
      i++
    trimmedString = string.substr(0, 100)
    trimmedString.substr(0, Math.min(trimmedString.length, trimmedString.lastIndexOf(" "))) + " [...]"