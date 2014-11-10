

###
    判断是否登录
###
exports.isLogin = (req, res) ->
	if req.session
		isLogin = if req.session.userId then req.session.userId else false
		return isLogin
	else
		return false

###
    获取用户信息
###
exports.getUserInfo = (req) ->
	user =
		id: req.session.userId || 0
		email: req.session.userEmail || ''
		name: req.session.userName || '游客'
		avatar: req.session.userAvatar || '/images/avatar/default.jpg'
	return user