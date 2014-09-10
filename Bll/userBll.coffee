dbUser = require("../Dal/dbUser")

###
    注册
###
exports.register = (user, cb) ->
	dbUser.register user, cb


###
    登录
###
exports.login = (user, cb) ->
	dbUser.login user, cb
