questionBll = require("../Bll/questionBll")
userBll = require("../Bll/userBll")
userHelper = require("../helper/userHelper");
commentsBll = require("../Bll/commentsBll")
moment = require("moment");
moment.lang("zh-cn");

###
mvc配置
@type {{}}
###
exports.$mvcConfig = route:
	single:
		path: "/single/:id"
		httpVerbs: ["get"]


###
    添加问题
###
exports.add_POST = (req, res) ->
	info =
		title: req.body.title
		content: req.body.content
		user: userHelper.getUserInfo(req)
	questionBll.add info, (err,question) ->
		if err
			res.send
				code: 1
				message: err.message
		else
			if req.session.userId
				userBll.changeAnsNum req.session.userId, (err) ->
					if err
						console.log(err)
					res.redirect '/single/'+question[0]._id.toString()


###
    获取单个问题
    id
###
exports.single = (req, res) ->
	id =  req.params.id
	questionBll.single id, (err, question) ->
		if err
			res.send
				code: 1
				message: err.message
		else
			question.addTime = moment(question.addTime).fromNow()
			question.updateTime = moment(question.updateTime).fromNow()
			questionBll.all (err, items) ->
				if err
					res.send
						code: 1
						message: err.message
				else
					items.map (item) ->
						item.addTime = moment(item.addTime).fromNow()
						item.updateTime = moment(item.updateTime).fromNow()
					userBll.getAllUser (err, users) ->
						if err
							res.send
								code: 1
								message: err.message
						else
							commentsBll.getAll id,(err, comments) ->
								if err
									res.send
										code: 1
										message: err.message
								else
									if comments
										comments.map (comment) ->
											comment.addTime = moment(comment.addTime).fromNow()
									questionBll.changeViewNum id, (err) ->
										if err
											res.send
												code: 1
												message: err.message
										else
											res.render "single",
												question: question
												items: items
												users: users
												currentUser: userHelper.getUserInfo(req)
												comments:comments
												isLogin: userHelper.isLogin(req, res)


###
    获取所有问题
###
exports.all = (req, res) ->
	questionBll.all (err, items) ->
		if err
			res.send
				code: 1
				message: err.message
		else
			res.send
				code: 0
				items: items
