

###
    判断是否登录
###
exports.isLogin = (req, res) ->
	if req.session
		isLogin = if req.session.userId then true else false
		return isLogin
	else
		return false
