'use strict'

_SCALES = ['day', 'month', 'year']

(angular.module 'brokenPromisesApp').filter 'highlight', ->
    (str, date, scale, strip = no) ->
        if strip
            str = str.replace /(<([^>]+)>)/g, ""
        lCased = do str.toLowerCase

        matches = undefined
        if typeof scale isnt typeof ''
            scale = _SCALES[scale]
        switch scale
            when 'day'
                matches = [
                    date.toString "dd MMMM yyyy"
                    date.toString "dd MMMM, yyyy"
                    "#{date.toString 'dd'}th of #{date.toString 'MMMM, yyyy'}"
                    "#{date.toString 'dd'}th in #{date.toString 'MMMM, yyyy'}"
                    "#{date.toString 'dd'}th by #{date.toString 'MMMM, yyyy'}"
                    "#{date.toString 'dd'}th of #{date.toString 'MMMM yyyy'}"
                    "#{date.toString 'dd'}th in #{date.toString 'MMMM yyyy'}"
                    "#{date.toString 'dd'}th by #{date.toString 'MMMM yyyy'}"
                    "#{date.toString 'dd'}th #{date.toString 'MMMM yyyy'}"
                    "#{date.toString 'dd'} of #{date.toString 'MMMM, yyyy'}"
                    "#{date.toString 'dd'} in #{date.toString 'MMMM, yyyy'}"
                    "#{date.toString 'dd'} by #{date.toString 'MMMM, yyyy'}"
                    "#{date.toString 'dd'} of #{date.toString 'MMMM yyyy'}"
                    "#{date.toString 'dd'} in #{date.toString 'MMMM yyyy'}"
                    "#{date.toString 'dd'} by #{date.toString 'MMMM yyyy'}"
                ]
            when "month"
                matches = [
                    date.toString 'MMMM yyyy'
                    date.toString 'MMMM, yyyy'
                ]
            when "year"
                matches = [ date.toString 'yyyy' ]

        _.map matches, (match) =>
            match = if match.startsWith '0' then [(match.substr 1, match.length), match] else [match]
            _.map match, (match) =>
                match = do match.toLowerCase
                i = 0
                shift = 0
                while i > -1
                    i = if i is 0 then lCased.indexOf match else lCased.indexOf match, i + 1
                    if i > 0
                        tmp = str
                        str = (tmp.substr 0, i + shift) + "<span class=\"littlepart\">"
                        str += (tmp.substr i + shift, match.length) + "</span>"
                        str += tmp.substr (i + match.length + shift), tmp.length
                        shift += 32

        str