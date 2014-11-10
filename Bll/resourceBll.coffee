
dbResource = require("../Dal/dbResource");


###
    添加资源
###
exports.add = (info, cb) ->
	inf = info
	inf.addTime = new Date()
	inf.viewNum = 0
	dbResource.add info, cb



###
    获取所有资源
###
exports.all = (cb) ->
	dbResource.all cb

###
    获取单个资源
###
exports.single = (id, cb) ->
	dbResource.single id, cb

###
    修改查看数量
###
exports.changeViewNum = (resourceId, cb) ->
	dbResource.changeViewNum resourceId, cb