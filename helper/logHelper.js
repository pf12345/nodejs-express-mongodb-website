// Generated by CoffeeScript 1.8.0
(function() {
  var config, dateTimeHelper, fs, path, _logInFile;

  path = require("path");

  fs = require("fs");

  config = require("../config");

  dateTimeHelper = require("../helper/dateTimeHelper");


  /*
    写入邮件发送记录
   */

  exports.emailLog = function(info) {
    var logDir;
    logDir = config.logPath.emailLog;
    return _logInFile(logDir, info);
  };


  /*
    写入错误日志
   */

  exports.errorLog = function(info) {
    var logDir;
    logDir = config.logPath.errorLog;
    return _logInFile(logDir, info);
  };


  /*
    写日志到文件中
   */

  _logInFile = function(logDir, info) {
    return fs.exists(logDir, function(exists) {
      var log, logPath;
      if ((!exists) || (!fs.statSync(logDir).isDirectory())) {
        fs.mkdirSync(logDir);
      }
      logPath = path.join(__dirname, logDir, dateTimeHelper.currentDate() + ".log");
      log = "" + (dateTimeHelper.currentTime()) + "=>" + (JSON.stringify(info)) + "\n";
      return fs.appendFile(logPath, log, function(e) {
        if (e) {
          return console.dir(e);
        }
      });
    });
  };

}).call(this);

//# sourceMappingURL=logHelper.js.map
