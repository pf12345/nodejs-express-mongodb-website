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


###
	获取用户信息
###
exports.getUserInfo = (id, cb) ->
	dbUser.getUserInfo id, cb

###
    获取所有用户
###
exports.getAllUser = (cb) ->
	dbUser.getAllUser cb

###
    修改提出问题数量
###
exports.changeAnsNum = (userId, cb) ->
	dbUser.changeAnsNum userId, cb


###
    修改回答问题数量
###
exports.changeResNum = (userId, cb) ->
	dbUser.changeResNum userId, cb
