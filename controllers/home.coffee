
QUESTION = require('../node_modules/questionapi');

###
  index page
  localhost:8080
###
exports.index = (req, res)->
  res.render "index"

###
  home page
  localhost:8080/home
###
exports.all = (req, res) ->
    res.render 'home'








