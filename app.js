
/**
 * Module dependencies.
 */

var express = require('express');
var http = require('http');
var path = require('path');
var MongoStore = require('connect-mongo')(express);
var logger = require('./helper/logger');
var config = require('./config');
var cons = require('consolidate');
var settings = require('./settings');
var sessionStore = new MongoStore({
    db:settings.db
}, function() {
    console.log('connect mongodb success...');
});

var app = express();
//routes(app);
// all environments

app.use(express.cookieParser('lalala')); //cookie处理
require("multi-process-session")(app, 'cookie');

app.configure(function (){
    app.set('views', path.join(__dirname, 'views'));
    app.engine('.html', cons.swig);
    app.set('views engine', 'html');
    app.use(express.favicon());
    app.use(express.logger('dev'));
    app.use(express.json());
    app.use(express.urlencoded());
    app.use(express.methodOverride());
    app.use(express.cookieParser('nothing'));
//    require('multi-process-session')(app); //配置session支持
    app.use(app.router);
    app.use(express.static(path.join(__dirname, 'public')));
});
require('simple-mvc')(app);//配置mvc




// development only
if ('development' == app.get('env')) {
    app.use(express.errorHandler());
}

http.createServer(app).listen(config.port, function(){
    console.log('Express server listening on port ' + config.port);
});
