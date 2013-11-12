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
    string = string.replace /(<([^>]+)>)/g, ""
    theParts = (string.split ".").slice 0, 50
    string = do string.toLowerCase
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
      if targetIndex isnt -1
        ret = (theParts[i].substr 0, targetIndex) + "<span class=\"littlepart\">"
        ret += (theParts[i].substr targetIndex, theMatch.length) + "</span>"
        ret += (theParts[i].substr (targetIndex + theMatch.length), theParts[i].length) + '.'
        return ret
      i++
    trimmedString = string.substr(0, 100)
    trimmedString.substr(0, Math.min(trimmedString.length, trimmedString.lastIndexOf(" "))) + " [...]"