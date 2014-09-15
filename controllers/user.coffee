userBll = require("../Bll/userBll")

###
    注册
    @param email
    @param password
###
exports.register_GET_POST = (req, res) ->
	if req.method is  "POST"
		user =
			name: req.body.name
			email : req.body.email
			password : req.body.password
			resNum: 0
			avatar: "http://img.mukewang.com/user/53b6219500010ef010001000-40-40.jpg"
		userBll.register user,(err, result)->
			console.log(result)
			if err
				res.send
					code: 1
					message: err.message
			else
				setSession(req, result[0])
				console.log(req.session)
				res.redirect '/explore'
	else
		res.render "register"


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
    创建session
###
setSession = (req, result) ->
	req.session.userId = result._id.toString()
	req.session.userName = result.name
	req.session.userEmail = result.email
	req.session.userAvatar = result.avatar

