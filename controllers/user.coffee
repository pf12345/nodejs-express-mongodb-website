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
		userBll.register user,(err, result)->
			if err
				res.send
					code: 1
					message: err.message
			else
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
				res.send
					code: 0
					message: "登录成功"
					result: result

