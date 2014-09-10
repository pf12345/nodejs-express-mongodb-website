// Generated by CoffeeScript 1.8.0
(function() {
  var logger, mongodb;

  mongodb = require('./newDb');

  logger = require('../helper/logger');


  /*
      注册
   */

  exports.register = function(user, cb) {
    return mongodb.open(function(err, db) {
      if (err) {
        cb(new Error("数据库连接失败"));
        return mongodb.close();
      } else {
        return db.collection("userInfo", function(err, collection) {
          if (err) {
            cb(new Error("数据库连接userInfo失败"));
            return mongodb.close();
          } else {
            return collection.findOne(user, function(err, doc) {
              if (doc) {
                cb(new Error("已经存在该用户"));
                return mongodb.close();
              } else {
                return collection.insert(user, {
                  safe: true
                }, function(err, u) {
                  if (err) {
                    cb(new Error("注册失败"));
                  } else {
                    cb(null, u);
                  }
                  return mongodb.close();
                });
              }
            });
          }
        });
      }
    });
  };


  /*
      登录
   */

  exports.login = function(user, cb) {
    return mongodb.open(function(err, db) {
      if (err) {
        cb(new Error("数据库连接失败"));
        return mongodb.close();
      } else {
        return db.collection("userInfo", function(err, collection) {
          if (err) {
            cb(new Error("数据库连接失败"));
            return mongodb.close();
          } else {
            return collection.findOne(user, function(err, doc) {
              if (err) {
                cb(new Error("登录失败"));
              } else {
                cb(null, doc);
              }
              return mongodb.close();
            });
          }
        });
      }
    });
  };

}).call(this);

//# sourceMappingURL=dbUser.js.map