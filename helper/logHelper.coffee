path = require("path")
fs = require("fs")
config = require("../config")

dateTimeHelper = require("../helper/dateTimeHelper")

###
  写入邮件发送记录
###
exports.emailLog = (info)->
  logDir = config.logPath.emailLog
  _logInFile(logDir, info)

###
  写入错误日志
###
exports.errorLog = (info)->
  logDir = config.logPath.errorLog
  _logInFile(logDir, info)


###
  写日志到文件中
###
_logInFile = (logDir, info)->
  fs.exists logDir, (exists) ->
    fs.mkdirSync logDir  if (not exists) or (not fs.statSync(logDir).isDirectory())
    logPath = path.join(__dirname, logDir, dateTimeHelper.currentDate() + ".log")
    log = "#{dateTimeHelper.currentTime()}=>#{JSON.stringify(info)}\n"
    fs.appendFile logPath, log, (e) ->
      console.dir e if e
