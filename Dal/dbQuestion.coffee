mongodb = require('./newDb');
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
	mongodb.open (err, db) ->
		if err
			cb new Error("数据库连接失败")
			mongodb.close()
		else
			db.collection "questions", (err, collection) ->
				if err
					mongodb.close()
					cb new Error("数据库连接questions失败")
				else
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
	mongodb.open (err, db) ->
		if err
			cb new Error(err)
		else
			db.collection "questions",(err, collection) ->
				if err
					mongodb.close()
					cb new Error(err)
				else
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
	mongodb.open (err,db) ->
		if err
			cb new Error(err)
		else
			db.collection "questions", (err, collection) ->
				if err
					mongodb.close()
					cb new Error(err)
				else
					collection.find().toArray (err, items) ->
						mongodb.close()
						if err
							cb new Error(err)
						else
							cb null, items

