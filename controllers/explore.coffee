questionBll = require("../Bll/questionBll")

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
			res.render "index",
				loopExplore: true
				items: items