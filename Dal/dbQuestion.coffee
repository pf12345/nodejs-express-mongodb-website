dbHelper = require('../helper/dbHelper')
mongodb = dbHelper.newDb();
mongojs = require('mongojs');
ObjectId = mongojs.ObjectId;

###
    添加问题
    info:
        title
        content
        viewNum
        resNum
        addTime
        updateTime
###
exports.add = (info, cb) ->
	dbHelper.connectDB "questions", cb, (collection) ->
		collection.insert info, {safe: true},(err, question) ->
			mongodb.close()
			if err
				cb err
			else
				cb null, question

###
    查找单个问题
    id
###
exports.single = (id, cb) ->
	dbHelper.connectDB "questions", cb, (collection) ->
		collection.findOne { _id: ObjectId(id)},(err, question) ->
			mongodb.close()
			if err
				cb new Error(err)
			else
				cb null, question

###
    获取所有问题
###
exports.all = (cb) ->
	dbHelper.connectDB "questions", cb, (collection) ->
		collection.find().sort({addTime:-1}).limit(10).toArray (err, items) ->
			mongodb.close()
			if err
				cb new Error(err)
			else
				cb null, items

