questionBll = require("../Bll/questionBll");
userHelper = require("../helper/userHelper");
userBll = require("../Bll/userBll");
commentsBll = require("../Bll/commentsBll");
moment = require("moment");
moment.lang("zh-cn");

###
mvc配置
@type {{}}
###
exports.$mvcConfig = route:
	index:
		path: "/user/:id"
		httpVerbs: ["get"]

###
    注册
    @param email
    @param password
###
exports.register_GET_POST = (req, res) ->
	loc = parseInt(Math.random() * 100) % 10
	if req.method is  "POST"
		user =
			name: req.body.name ##用户名
			email : req.body.email ##用户邮箱
			password : req.body.password ##用户密码
			resNum: 0  ##回答数目
			ansNum: 0  ##提问数目
			avatar: "/images/avatar-big/default"+loc+".jpg" ##用户头像
			score: 0 ##用户积分
		userBll.register user,(err, result)->
			if err
				res.send
					code: 1
					message: err.message
			else
				setSession(req, result[0])
				res.redirect '/explore'
	else
		res.render "register",
			isLogin: true


###
    登录
    @param email
    @param password
###
exports.login_GET_POST = (req, res) ->
	if req.method is "POST"
		user =
			email : req.body.userName
			password : req.body.pwd
		userBll.login user, (err, result)->
			if err
				res.send
					code: 1
					message: err.message
			else if !result
				res.send
					code: 1
					message: '用户不存在,请注册后登录'
			else
				setSession(req, result)
				res.send
					code: 0
					message: 'ok'
					result: result

###获取用户信息
    退出登录
###
exports.signOut = (req, res) ->
	res.session.clear();
	res.redirect "/explore"

###
	获取用户信息
###
exports.getUserInfo = (req, res) ->
	userId = req.query.id || req.session.userId
	userBll.getUserInfo userId, (err, user) ->
		if err
			res.send
				code: 1
				message: err.message
		else
			res.send
				code: 0
				message: "ok"
				user: user

###
	用户主页
###
exports.index = (req, res) ->
	id = req.params.id
	userBll.getUserInfo id, (err, user) ->
		if err
			res.send
				code: 1
				message: err.message
		else
			questionBll.getQuestionByUser id,(err, questions) ->
				if err
					res.send
						code: 1
						message: err.message
				else
					transTime(questions)
					commentsBll.getCommentByUser id,(err, ansQuestions) ->
						if err
							res.send
								code: 1
								message: err.message
						else
							transTime(ansQuestions)
							res.render "index",
								questions: questions
								ansQuestions: ansQuestions
								user: user
								isLogin: userHelper.isLogin(req, res)


###
	转换时间
###
transTime = (obj) ->
	obj.map (item) ->
		item.addTime = moment(item.addTime).fromNow()
		item.updateTime = moment(item.updateTime).fromNow()


###
    创建session
###
setSession = (req, result) ->
	req.session.userId = result._id.toString()
	req.session.userName = result.name
	req.session.userEmail = result.email
	req.session.userAvatar = result.avatar

