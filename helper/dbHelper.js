// Generated by CoffeeScript 1.8.0
(function() {
  var Connection, Db, Server, mongodb, settings;

  settings = require('../settings');

  Db = require('mongodb').Db;

  Connection = require('mongodb').Connection;

  Server = require('mongodb').Server;

  mongodb = new Db(settings.db, new Server(settings.host, Connection.DEFAULT_PORT, {
    auto_reconnect: true
  }), {
    safe: true
  });

  exports.newDb = function() {
    return mongodb;
  };


  /*
      连接数据库userInfo
   */

  exports.connectDB = function(dbName, cb, success) {
    return mongodb.open(function(err, db) {
      if (err) {
        return cb(new Error(err));
      } else {
        return db.collection(dbName, function(err, collection) {
          if (err) {
            cb(new Error("数据库连接失败"));
            return mongodb.close();
          } else {
            if (success && typeof success === "function") {
              return success(collection);
            }
          }
        });
      }
    });
  };

}).call(this);

//# sourceMappingURL=dbHelper.js.map
