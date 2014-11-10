
dbQuestion = require("../Dal/dbQuestion");


###
    add question
    info:
        title
        content
        userId
###
exports.add = (info, cb) ->
	inf =
		title: info.title
		content: info.content
		user: info.user
		viewNum: 0
		resNum: 0
		updateTime: new Date()
		addTime: new Date()

	dbQuestion.add inf, cb

###
    获取单个问题
    id
###
exports.single = (id, cb) ->
	dbQuestion.single id,cb


###
	获取所有问题
###
exports.all = (cb) ->
	dbQuestion.all cb

###
    获取某个用户提出问题
###
exports.getQuestionByUser = (id, cb) ->
	dbQuestion.getQuestionByUser id, cb


###
    修改更新时间
###
exports.changeUpdateTime = (qId, cb) ->
	dbQuestion.changeUpdateTime qId, cb


###
    获取最新问题
###
exports.getLastQuestion = (num, cb) ->
	dbQuestion.getLastQuestion num, cb

###
    获取最新回答问题
###
exports.getLastAnsQuestion = (num, cb) ->
	dbQuestion.getLastAnsQuestion num, cb

###
    修改查看数
###
exports.changeViewNum = (qId, cb) ->
	dbQuestion.changeViewNum qId, cb

###
	修改回复数
###
exports.changeResNum = (qId, cb) ->
	dbQuestion.changeResNum qId, cb

