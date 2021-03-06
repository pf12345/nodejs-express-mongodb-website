// Generated by CoffeeScript 1.7.1
(function() {
  var Connection, Db, Server, settings;

  settings = require('../settings');

  Db = require('mongodb').Db;

  Connection = require('mongodb').Connection;

  Server = require('mongodb').Server;

  module.exports = new Db(settings.db, new Server(settings.host, Connection.DEFAULT_PORT, {
    auto_reconnect: true
  }), {
    safe: true
  });

}).call(this);

//# sourceMappingURL=dbHelper.map
