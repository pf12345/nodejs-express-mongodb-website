_ = require("underscore")

###
    添加天数
###
exports.addDays = (date, days)->
    if _.isDate date
        newTime = date.getTime() + days * 24 * 60 * 60 * 1000
        return new Date(newTime)
    else
        throw new Error("first parameter must be a date")

###
    添加月份
###
exports.addMonths = (date, month) ->
    if (not _.isDate(date)) or date < new Date()
        date = new Date()
        date.setDate date.getDate() + 1
    date.setHours 0, 0, 0, 0
    date.setMonth date.getMonth() + month
    return date

exports.readableDateTime = (datetime)->
    return _datetime(datetime)

###
当前时间
@return {string} [description]
###
exports.currentTime = ->
    now = new Date()
    return _datetime(now)

_datetime = (datetime)->
    datetime.getFullYear() + "-" + (datetime.getMonth() + 1) + "-" + datetime.getDate() + " " + datetime.getHours() + ":" + datetime.getMinutes() + ":" + datetime.getSeconds()

###
当前日期
@return {string} [description]
###
exports.currentDate = ->
    now = new Date()
    now.getFullYear() + "-" + (now.getMonth() + 1) + "-" + now.getDate()
