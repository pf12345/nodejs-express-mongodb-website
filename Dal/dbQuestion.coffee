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
        user
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


###
    获取某用户提出问题
###
exports.getQuestionByUser = (userId, cb) ->
	dbHelper.connectDB "questions", cb, (collection) ->
		collection.find({ "user.id": userId}).toArray (err, items) ->
			mongodb.close()
			if err
				cb new Error(err)
			else
				cb null, items

###
    获取最新问题
    param {Number} num 查找个数
###
exports.getLastQuestion = (num, cb) ->
	dbHelper.connectDB "questions", cb, (collection) ->
		collection.find().sort({addTime:-1}).limit(num).toArray (err, items) ->
			mongodb.close()
			if err
				cb new Error(err)
			else
				cb null, items

###
    获取最新回答问题
    param {Number} num
###
exports.getLastAnsQuestion = (num, cb) ->
	dbHelper.connectDB "questions", cb, (collection) ->
		collection.find().sort({updateTime:-1}).limit(num).toArray (err, items) ->
			mongodb.close()
			if err
				cb new Error(err)
			else
				cb null,items

###
    修改更新时间
###
exports.changeUpdateTime = (qId,cb)->
	now = new Date()
	dbHelper.connectDB "questions", null, (collection) ->
		collection.update {_id: ObjectId(qId)},{$set:{updateTime:now}},(err)->
			if err
				cb new Error(err)
			else
				cb null, 'ok'



###
    修改阅读数量
###
exports.changeViewNum = (qId, cb)->
	dbHelper.connectDB "questions", cb, (collection) ->
		collection.findOne { _id: ObjectId(qId)},(err, question) ->
			if err
				cb new Error(err)
			else
				viewNum = question.viewNum
				viewNum++
				collection.update {_id: ObjectId(qId)},{$set:{viewNum:viewNum}},(err)->
					mongodb.close()
					if err
						cb new Error(err)
					else
						cb null, 'ok'




###
    修改回复数量
###
exports.changeResNum = (qId, cb)->
	dbHelper.connectDB "questions", cb, (collection) ->
		collection.findOne { _id: ObjectId(qId)},(err, question) ->
			if err
				cb new Error(err)
			else
				resNum = question.resNum
				resNum++
				collection.update {_id: ObjectId(qId)},{$set:{resNum:resNum}},(err)->
					mongodb.close()
					if err
						cb new Error(err)
					else
						cb null, 'ok'
