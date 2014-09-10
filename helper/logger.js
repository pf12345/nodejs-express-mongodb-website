var fs = require('fs'),
    path = require('path');
var utils = require('./util');

function log() {
    var argu = arguments;
    var logPath = path.join(__dirname, '..', 'log', utils.currentDate() + '.txt');
    fs.exists(logPath, function () {
        fs.appendFile(logPath, utils.currentTime() + '=>' + [].slice.call(argu).join(' ') + '\n', function (err) {
            if (err) {
                console.log(err);
            } else {
//                console.log("%j", argu);
                console.log.apply(this, argu);
            }
        });
    });
}
exports.log = log;
