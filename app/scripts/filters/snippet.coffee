'use strict';

_MONTHS = ['january', 'february', 'march', 'april', 'may', 'june', 'july',
  'august', 'september', 'october', 'november', 'december']

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
    today = new Date
    while i < end
      switch type
        when "day"
          theMatch = "#{do today.getDate} #{_MONTHS[do today.getMonth]} #{do today.getFullYear}"
        when "month"
          theMatch = "#{_MONTHS[do today.getMonth]} #{do today.getFullYear}"
        when "year"
          theMatch = "#{do today.getFullYear}"
      targetIndex = parts[i].indexOf(theMatch)
      return parts[i].replace(theMatch, "<span class=\"littlepart\">" + theMatch + "</span>")  if targetIndex isnt -1
      i++
    trimmedString = string.substr(0, 100)
    trimmedString.substr(0, Math.min(trimmedString.length, trimmedString.lastIndexOf(" "))) + " [...]"