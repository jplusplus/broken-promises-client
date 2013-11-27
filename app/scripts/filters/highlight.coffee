'use strict'

_MONTHS = ['january', 'february', 'march', 'april', 'may', 'june', 'july',
  'august', 'september', 'october', 'november', 'december']

_SCALES = ['day', 'month', 'year']

(angular.module 'brokenPromisesApp').filter 'highlight', ->
    (str, date, scale) ->
        lCased = do str.toLowerCase

        match = undefined
        switch _SCALES[scale]
            when 'day'
                match = "#{do date.getDate} #{_MONTHS[do date.getMonth]} #{do date.getFullYear}"
            when "month"
                match = "#{_MONTHS[do date.getMonth]} #{do date.getFullYear}"
            when "year"
                match = "#{do date.getFullYear}"

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