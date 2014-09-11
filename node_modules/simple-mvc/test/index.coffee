#mvc = require('../lib/index')

exports.setDefaultTest = (test)->
	options =
		title: "title",
		count: 10,
		notify: ()->
			console.log "hello"

	defaultOptions =
		title: "test title"
		newCount: 20
		newNotify: ()->
			"new"

	setDefault options, defaultOptions

	test.ok options.title is "title"
	test.ok options.count is 10
	test.ok options.newCount is 20
	test.ok options.newNotify() is "new"
	test.done()

setDefault = (options, defaultOptions)->
	for key,value of defaultOptions
		console.log key
		options[key] = value unless options[key]