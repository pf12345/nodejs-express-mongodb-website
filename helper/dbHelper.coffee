config = require('../config')
Db = require('mongodb').Db
Connection = require('mongodb').Connection
Server = require('mongodb').Server
mongodb = new Db(config.dbInfo.db, new Server(config.dbInfo.host, Connection.DEFAULT_PORT, {auto_reconnect:true}), {safe: true})

exports.newDb = () ->
	return mongodb


###
    连接数据库userInfo
###
exports.connectDB = (dbName, cb, success) ->
	mongodb.open (err, db) ->
		if err
			cb new Error(err)
		else
			db.collection dbName, (err, collection) ->
				if err
					cb new Error("数据库连接失败")
					mongodb.close()
				else
					if success and typeof success is "function"
						success(collection)