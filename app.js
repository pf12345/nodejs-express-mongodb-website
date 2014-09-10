
/**
 * Module dependencies.
 */

var express = require('express');
var routes = require('./routes');
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

//app.get('/',routes.index);
//app.get('/home',routes.home);
//app.get('/license',routes.license);
//app.get('/know',routes.know);
//app.get('/user',routes.userInfo);
//app.get('/single/:id', routes.singleQestion);
//app.get('/new', routes.resource);

app.post('/api/register',routes.registerApi);
app.post('/api/login',routes.loginApi);
app.post('/api/forum/addquestion', routes.addQuestion);



// development only
if ('development' == app.get('env')) {
    app.use(express.errorHandler());
}

http.createServer(app).listen(config.port, function(){
    console.log('Express server listening on port ' + config.port);
});
