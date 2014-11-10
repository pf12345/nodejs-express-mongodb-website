questionBll = require("../Bll/questionBll");
userHelper = require("../helper/userHelper");
userBll = require("../Bll/userBll");
moment = require("moment");
moment.lang("zh-cn");

###
    index
    /explore
###
exports.index = (req, res) ->
	questionBll.all (err, items) ->
		if err
			res.send
				code: 1
				message: err.message
		else
			items.map (item) ->
				item.addTime = moment(item.addTime).fromNow()
				item.updateTime = moment(item.updateTime).fromNow()
			userBll.getAllUser (err, users) ->
				if err
					res.send
						code: 1
						message: err.message
				else
					res.render "index",
						loopIndex: true
						items: items
						users: users
						isLogin: userHelper.isLogin(req, res)







