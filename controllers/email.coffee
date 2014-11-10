fs = require("fs")
path = require("path")
config = require("../config")

dataTimeHelper = require("../helper/dateTimeHelper")
logHelper = require("../helper/logHelper")

###
  获取邮件发送日志
###
exports.index = (req, res) ->
  filePath = path.join(__dirname, config.logPath.emailLog, dataTimeHelper.currentDate() + ".log")
  fs.readFile filePath, 'utf8', (err, data) ->
    if err
      logHelper.errorLog err
    else
      res.send data