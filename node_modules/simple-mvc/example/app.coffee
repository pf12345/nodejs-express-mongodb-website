express = require "express"
http = require "http"
path = require "path"

app = express()

app.set "port", process.env.PORT or 3000
app.use express.favicon()
app.use express.logger("dev")
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use app.router

require('../lib')(app)

http.createServer(app).listen app.get("port"), ->
	console.log "Express server listening on port " + app.get("port")
	return
