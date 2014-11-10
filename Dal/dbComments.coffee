dbHelper = require('../helper/dbHelper')
mongodb = dbHelper.newDb();
mongojs = require('mongojs');
_ = require("underscore");
ObjectId = mongojs.ObjectId;

###
    添加评论
    info:
        qId 问题id
        user 用户内容
        content 评论内容
        replyNum 回复数量
        likeNum 赞数
        addTime 添加时间

###
exports.add = (info, cb) ->
	dbHelper.connectDB "comments", cb, (collection) ->
		collection.insert info, {safe: true}, (err, comment) ->
			mongodb.close()
			if err
				cb err
			else
				cb null, comment


###
    查找问题的相关评论
    qId 问题Id
###
exports.getAll = (qId, cb) ->
	dbHelper.connectDB "comments", cb, (collection) ->
		collection.find({ qId: qId}).toArray (err, items) ->
			mongodb.close()
			if err
				cb new Error(err)
			else
				cb null, items


###
    添加评论回复
    info:
        cId 评论id
        user 用户信息
        content 回复内容
        addTime 添加时间

###
exports.addReply = (info, cb) ->
	dbHelper.connectDB "replies", cb, (collection) ->
		collection.insert info, {safe: true}, (err, reply) ->
			mongodb.close()
			if err
				cb err
			else
				cb null, reply


###
    查找评论的相关回复
    cId 评论Id
###
exports.getAllReply = (cId, cb) ->
	dbHelper.connectDB "replies", cb, (collection) ->
		collection.find({ cId: cId}).toArray (err, items) ->
			mongodb.close()
			if err
				cb new Error(err)
			else
				cb null, items

###
    获取用户回答问题
###
exports.getCommentByUser = (userId, cb) ->
	dbHelper.connectDB "comments", cb, (collection) ->
		collection.find({"user.id": userId}).toArray (err, items) ->
			mongodb.close()
			if err
				cb new Error(err)
			else if items.length is 0
				cb null, []
			else
				questionsIdArr = []
				questionsArr = []
				items.map (item) ->
					if questionsIdArr.indexOf(item.qId) is -1
						questionsIdArr.push(item.qId)
						questionsArr.push(item)
				questions = []
				times = 0
				dbHelper.connectDB "questions", cb, (collection) ->
					questionsArr.map (item) ->
						collection.findOne { _id: ObjectId(item.qId)}, (err, question)->
							if !err and question
								times++
								questions.push(question)
								if times is questionsArr.length
									mongodb.close()
									cb null, questions
							else
								cb new Error(err)

###
    修改回复数量
###
exports.changeReplyNum = (commentId, cb)->
	dbHelper.connectDB "comments", cb, (collection) ->
		collection.findOne { _id: ObjectId(commentId)},(err, comment) ->
			if err
				cb new Error(err)
			else
				replyNum = comment.replyNum
				replyNum++
				collection.update {_id: ObjectId(commentId)},{$set:{replyNum:replyNum}},(err)->
					mongodb.close()
					if err
						cb new Error(err)
					else
						cb null, 'ok'


###
    修改赞数量
###
exports.changeLikeNum = (commentId, cb)->
	dbHelper.connectDB "comments", cb, (collection) ->
		collection.findOne { _id: ObjectId(commentId)},(err, comment) ->
			if err
				cb new Error(err)
			else
				likeNum = comment.likeNum
				likeNum++
				collection.update {_id: ObjectId(commentId)},{$set:{likeNum:likeNum}},(err)->
					mongodb.close()
					if err
						cb new Error(err)
					else
						cb null, 'ok'






