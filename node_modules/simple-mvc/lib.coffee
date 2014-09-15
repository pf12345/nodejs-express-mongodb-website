###
Created by massimo on 2014/4/12.
express-mvc framework
###

fs = require "fs"
express = require "express"
path = require "path"
cons = require "consolidate"

PROJECT_DIR = path.join(__dirname, "../../")

###
配置路由
@param options
@param {String} [options.controllerPath="controller"] controller path
@pram {String} [options.viewPath="views"] views path
@param parentApp app
###
module.exports = (options, parentApp) ->
	unless parentApp
		parentApp = options
		options = {}

	setOptions options,
		controllerPath: "controllers"
		viewPath: "views"
		defaultEngine: "swig"
		defaultViewEngine: "html"

	unless options.filter
		defaultFilterPath = path.join(PROJECT_DIR, "filter.js")
		if fs.existsSync defaultFilterPath
			options.filter = require defaultFilterPath
		else
			options.filter = {}

	fs.readdirSync(path.join(PROJECT_DIR, options.controllerPath)).forEach (fileName) ->
		if fileName.slice(-3) is ".js" # file extension is `.js`
			controllerName = fileName.slice 0, -3 #去掉后缀名
			controller = require(path.join(PROJECT_DIR, options.controllerPath, controllerName))

			app = express()

			$mvcConfig = controller.$mvcConfig

			if options.viewPath
				engine = options.defaultEngine
				engine = $mvcConfig.engine if typeof $mvcConfig isnt "undefined" and $mvcConfig.engine
				viewEngine = ($mvcConfig.viewEngine if typeof $mvcConfig isnt "undefined" and $mvcConfig.viewEngine) or options.defaultViewEngine
				app.engine "html", cons[engine]
				app.set "view engine", viewEngine
				app.set "views", path.join(PROJECT_DIR, options.viewPath, controllerName)

			for methodName,method of controller
				continue if methodName[0] is "$" #内部使用的方法以$开头

				methodInfo = resolveMethod methodName

				setOptions methodInfo, $mvcConfig?.route?[methodInfo.action], true
				pathOverrideByConfig = true if $mvcConfig?.route?[methodInfo.action]?.path
				methodInfo.path = "/#{controllerName}/#{methodInfo.action}" unless methodInfo.path

				if methodInfo.middleware
					for itemMiddleware in methodInfo.middleware
						func = controller[itemMiddleware] or options.filter[itemMiddleware]
						if typeof func is "function"
							configRoute app, "all", "/", func  if controllerName is "home"
							configRoute app, "all", "/" + controllerName, func  if methodInfo.action is "index"
							configRoute app, "all", methodInfo.path, func
						else
							throw new Error "can not find filter", itemMiddleware

				for itemMethod in methodInfo.httpVerbs
					unless pathOverrideByConfig
						configRoute app, itemMethod, "/", method if controllerName is "home"
						configRoute app, itemMethod, "/#{controllerName}", method if methodInfo.action is "index"
					configRoute app, itemMethod, methodInfo.path, method

			parentApp.use app

###
配置路由
@param app application
@param {String} method http request method
@param {String} path route path
@param {Function} func function
###
configRoute = (app, method, path, func) ->
	app[method] path, func

###
通过解析方法名获取方法支持的HTTP方法和中间件信息
@param {String} methodName method name
###
resolveMethod = (methodName) ->
	arr = methodName.split "_"

	httpVerbs = []
	middleware = []
	arr.slice(1).forEach (item) ->
		if item[0] is "$"
			middleware.push item #middle ware is start with `$`
		else
			if validHttpMethod(item) then httpVerbs.push item.toLowerCase() else throw new Error("not support method:#{item}")

	httpVerbs.push "get" if httpVerbs.length <= 0
	action: arr[0]
	httpVerbs: httpVerbs
	middleware: middleware

###
    detect if a method is a valid http method
###
validHttpMethod = (method)->
	method.toLowerCase() in [
		"get",
		"post",
		"options",
		"delete",
		"put",
		"head",
		"trace"
	]

###
    set default options
    @param {Boolean} override override options by defaultOptions or not
###
setOptions = (options, defaultOptions, override)->
	unless defaultOptions
		return
	unless options
		options = defaultOptions
	else
		for key,value of defaultOptions
			if override
				options[key] = value if defaultOptions[key]
			else
				options[key] = value unless options[key]