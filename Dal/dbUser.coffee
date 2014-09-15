dbHelper = require('../helper/dbHelper')
mongodb = dbHelper.newDb();
mongojs = require('mongojs');
ObjectId = mongojs.ObjectId;

###
    注册
###
exports.register = (user, cb) ->
	##存瑞Mongodb的文档
	dbHelper.connectDB "userInfo", cb, (collection) ->
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
	dbHelper.connectDB "userInfo", cb, (collection) ->
		collection.findOne user, (err, doc)->
			mongodb.close()
			if err
				cb new Error("登录失败")
			else
				cb null, doc

###
	获取用户信息
###
exports.getUserInfo = (id, cb) ->
	dbHelper.connectDB "userInfo", cb, (collection) ->
		collection.findOne { _id: ObjectId(id)},(err, user) ->
			mongodb.close()
			if err
				cb new Error(err)
			else
				cb null, user


###
    获取所有用户
###
exports.getAllUser = (cb) ->
	dbHelper.connectDB "userInfo", cb, (collection) ->
		collection.find().limit(10).toArray (err, items) ->
			mongodb.close()
			if err
				cb new Error(err)
			else
				cb null,items



