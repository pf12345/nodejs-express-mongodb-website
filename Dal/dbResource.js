// Generated by CoffeeScript 1.8.0
(function() {
  var ObjectId, dbHelper, mongodb, mongojs;

  dbHelper = require('../helper/dbHelper');

  mongodb = dbHelper.newDb();

  mongojs = require('mongojs');

  ObjectId = mongojs.ObjectId;


  /*
      添加资源
   */

  exports.add = function(info, cb) {
    return dbHelper.connectDB("resource", cb, function(collection) {
      return collection.insert(info, {
        safe: true
      }, function(err, resource) {
        mongodb.close();
        if (err) {
          return cb(new Error(err));
        } else {
          return cb(null, resource);
        }
      });
    });
  };


  /*
      获取单个资源
   */

  exports.single = function(id, cb) {
    return dbHelper.connectDB("resource", cb, function(collection) {
      return collection.findOne({
        _id: ObjectId(id)
      }, function(err, source) {
        mongodb.close();
        if (err) {
          return cb(new Error(err));
        } else {
          return cb(null, source);
        }
      });
    });
  };


  /*
      获取所有资源
   */

  exports.all = function(cb) {
    return dbHelper.connectDB("resource", cb, function(collection) {
      return collection.find().toArray(function(err, items) {
        mongodb.close();
        if (err) {
          return cb(new Error(err));
        } else {
          return cb(null, items);
        }
      });
    });
  };

}).call(this);

//# sourceMappingURL=dbResource.js.map
