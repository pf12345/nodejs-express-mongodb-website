commentsBll = require("../Bll/commentsBll");
questionBll = require("../Bll/questionBll");
userBll = require("../Bll/userBll");
moment = require("moment");
moment.lang("zh-cn");
userHelper = require("../helper/userHelper");


###
    添加评论
###
exports.add_POST = (req, res) ->
	qId = req.body.qId
	info =
		qId: qId
		content: req.body.content
		user: userHelper.getUserInfo(req)
	commentsBll.add info,(err, comment) ->
		if err
			res.send
				code: 1
				message: err.message
		else
			questionBll.changeUpdateTime qId, (err) ->
				if err
					res.send
						code: 1
						message: err.message
				else
					questionBll.changeResNum qId, (err) ->
						if err
							console.log('changeQuestionResNum error:'+ err)
						if req.session.userId
							userBll.changeResNum req.session.userId, (err) ->
								if err
									console.log('changeUserResNum error:'+ err)
								if comment
									comment.addTime = moment(comment.addTime).fromNow()
									res.send
										code: 0
										message: "ok"
										comment: comment


###
    添加评论回复信息
###
exports.addReply_POST = (req, res) ->
	info =
		cId: req.body.cId
		user: userHelper.getUserInfo(req)
		content: req.body.content
	commentsBll.addReply info, (err, reply) ->
		if err
			res.send
				code: 1
				message: err.message
		else
			commentsBll.changeReplyNum info.cId, (err) ->
				if err
					console.log('changeReplyNum error:'+ err)
				res.send
					code: 0
					message: "ok"
					reply: reply


###
	修改喜欢数量
###
exports.changeLikeNum = (req, res) ->
	cId = req.query.cId
	commentsBll.changeLikeNum cId, (err) ->
		if err
			res.send
				code: 1
				message: err.message
		else
			res.send
				code: 0
				message: 'ok'
###
    获取评论所以回复
###
exports.getAllReply = (req, res) ->
	cId = req.query.cId
	commentsBll.getAllReply cId, (err, replies) ->
		if err
			res.send
				code: 1
				message: err.message
		else
			if replies
				replies.map (reply) ->
					reply.addTime = moment(reply.addTime).fromNow()
			res.send
				code: 0
				message: "ok"
				replies: replies


