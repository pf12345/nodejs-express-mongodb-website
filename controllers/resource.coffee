userHelper = require("../helper/userHelper");
resourceBll = require("../Bll/resourceBll");
moment = require("moment");
moment.lang("zh-cn");


###
mvc配置
@type {{}}
###
exports.$mvcConfig = route:
	single:
		path: "/resource/:id"
		httpVerbs: ["get"]


###
    主页
###
exports.index = (req, res) ->
	resourceBll.all (err, items) ->
		if err
			res.send
				code: 1
				message: err.message
		else
			items.map (item) ->
				item.addTime = moment(item.addTime).fromNow()
			res.render "index",
				loopResource: true
				items: items
				isLogin: userHelper.isLogin(req, res)

###
    add resource
###
exports.add_POST_GET = (req, res) ->
	if req.method is 'GET'
		res.render "add"
	else
		info =
			title: req.body.title
			content: req.body.content || ""
			filePath: req.body.path || ""
			type: req.body.type
			imagePath: req.body.imagePath
		resourceBll.add info,(err, source) ->
			if err
				res.send
					code: 1
					message: err.message
			else
				res.send
					code: 0
					message: 'ok'
					source: source

###
    获取单个资源
###
exports.single = (req, res) ->
	id =  req.params.id
	resourceBll.single id, (err, source) ->
		if err
			res.send
				code: 1
				message: err.message
		else
			type = source.type
			source.addTime = moment(source.addTime).fromNow()
			resourceBll.changeViewNum id, (err) ->
				if err
					console.log('resource change view num error:' +err)
				if type is 'pdf' or type is 'ppt'
					res.render "single_pdf",
						isLogin: userHelper.isLogin(req, res)
						source: source
				else
					res.render "single_text",
						isLogin: userHelper.isLogin(req, res)
						source: source
