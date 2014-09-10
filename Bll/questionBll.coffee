
questionBll = require("../Dal/dbQuestion")

###
    add question
    info:
        title
        content
        userId
###
exports.add = (info, cb) ->
	inf =
		title: info.title
		content: info.content
		userId: info.userId
		viewNum: 0
		resNum: 0
		updateTime: new Date()
		addTime: new Date()

	questionBll.add inf, cb

###
    获取单个问题
    id
###
exports.single = (id, cb) ->
	questionBll.single id,cb


###
	获取所有问题
###
exports.all = (cb) ->
	questionBll.all cb

