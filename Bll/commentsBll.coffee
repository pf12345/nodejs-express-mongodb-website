dbComment = require("../Dal/dbComments");


###
    添加问题评论
     info:
        qId 问题id
        user 用户内容
        content 评论内容
        replyNum 回复数量
        likeNum 赞数
        addTime 添加时间
###
exports.add = (info, cb) ->
	inf =
		qId: info.qId
		user: info.user
		content: info.content
		replyNum: 0
		likeNum: 0
		addTime: new Date()
	dbComment.add inf, cb


###
    获取问题所以评论
###
exports.getAll = (qId, cb) ->
	dbComment.getAll qId, cb



###
    添加评论回复
    info:
        cId 评论id
        user 用户信息
        content 回复内容
        addTime 添加时间

###
exports.addReply = (info, cb) ->
	inf =
		cId: info.cId
		user: info.user
		content: info.content
		addTime: new Date()
	dbComment.addReply inf, cb


###
    获取问题所以评论
###
exports.getAllReply = (cId, cb) ->
	dbComment.getAllReply cId, cb


###
    获取用户回答的问题
###
exports.getCommentByUser = (userId, cb) ->
	dbComment.getCommentByUser userId, cb

###
    修改回复数量
###
exports.changeReplyNum = (commentId, cb) ->
	dbComment.changeReplyNum commentId, cb


###
    修改赞数量
###
exports.changeLikeNum = (commentId, cb) ->
	dbComment.changeLikeNum commentId, cb