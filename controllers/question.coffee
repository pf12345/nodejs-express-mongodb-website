
questionBll = require("../Bll/questionBll")

###
mvc配置
@type {{}}
###
exports.$mvcConfig = route:
	single:
		path: "/single/:id"
		httpVerbs: ["get"]


###
    添加问题
###
exports.add_POST = (req, res) ->
	info =
		title: req.body.title
		content: req.body.content
		userId: 0
	questionBll.add info, (err,question) ->
		if err
			res.send
				code: 1
				message: err.message
		else
			res.redirect '/single/'+question[0]._id.toString()


###
    获取单个问题
    id
###
exports.single = (req, res) ->
	id =  req.params.id
	questionBll.single id, (err, question) ->
		if err
			res.send
				code: 1
				message: err.message
		else
			questionBll.all (err, items) ->
				if err
					res.send
						code: 1
						message: err.message
				else
					res.render "single",
						question: question
						items: items

###
    获取所有问题
###
exports.all = (req, res) ->
	questionBll.all (err, items) ->
		if err
			res.send
				code: 1
				message: err.message
		else
			res.send
				code: 0
				items: items
