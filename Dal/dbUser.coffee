mongodb = require('./newDb');
logger = require('../helper/logger');

###
    注册
###
exports.register = (user, cb) ->
	##存瑞Mongodb的文档
	mongodb.open (err, db) ->
		if err
			cb new Error("数据库连接失败")
			mongodb.close()
		else
			db.collection "userInfo", (err, collection) ->
				if err
					cb new Error("数据库连接userInfo失败")
					mongodb.close()
				else
					collection.findOne user, (err, doc) ->
						if doc
							cb new Error("已经存在该用户")
							mongodb.close()
						else
							collection.insert user, {
								safe: true
							}, (err, u) ->
								if err
									cb new Error("注册失败")
								else
									cb null, u
								mongodb.close()


###
    登录
###
exports.login = (user, cb) ->
	mongodb.open (err, db)->
		if err
			cb new Error("数据库连接失败")
			mongodb.close()
		else
			db.collection "userInfo", (err, collection) ->
				if err
					cb new Error("数据库连接失败")
					mongodb.close()
				else
					collection.findOne user, (err, doc)->
						if err
							cb new Error("登录失败")
						else
							cb null, doc
						mongodb.close()

