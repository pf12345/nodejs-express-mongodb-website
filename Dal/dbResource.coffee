dbHelper = require('../helper/dbHelper')
mongodb = dbHelper.newDb();
mongojs = require('mongojs');
ObjectId = mongojs.ObjectId;

###
    添加资源
###
exports.add = (info, cb) ->
	dbHelper.connectDB "resource", cb, (collection) ->
		collection.insert info, {safe: true},(err, resource) ->
			mongodb.close()
			if err
				cb new Error(err)
			else
				cb null,resource

###
    获取单个资源
###
exports.single = (id, cb) ->
	dbHelper.connectDB "resource", cb, (collection) ->
		collection.findOne { _id: ObjectId(id)},(err, source) ->
			mongodb.close()
			if err
				cb new Error(err)
			else
				cb null, source

###
    获取所有资源
###
exports.all = (cb) ->
	dbHelper.connectDB "resource", cb, (collection) ->
		collection.find().toArray (err, items) ->
			mongodb.close()
			if err
				cb new Error(err)
			else
				cb null, items

