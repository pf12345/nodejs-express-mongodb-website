exports.$mvcConfig =
	engine: "jade"
	viewEngine: "jade"

exports.index = (req, res)->
	res.render "index",
		title: "hello,express mvc"