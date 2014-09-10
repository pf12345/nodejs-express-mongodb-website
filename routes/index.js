var  User = require('../node_modules/user');
var  QUESTION = require('../node_modules/questionapi');

/**
 * index page
 * @param req
 * @param res
 */
exports.index = function (req, res) {
    res.render('index', {
        loopIndex : true
    });
};

/**
 * home page
 * @param req
 * @param res
 */
exports.home = function (req, res) {
    var qestions = [];
  QUESTION.getAllRequst(function(err, resInfo) {
      if(resInfo !== null){
          qestions = resInfo.value;
      }

      for(var i= 0,_i=qestions.length;i<_i;i++){
          qestions[i]._id = JSON.stringify(qestions[i]._id);
      }

      res.render('home',{
          loopIndex : true,
          qestions : qestions
      });
  });
};

/**
 * topic page
 * @param req
 * @param res
 */
exports.license = function (req, res){
  res.render('license',{
      loopLicense : true
  });
};

/**
 * know page
 * @param req
 * @param res
 */
exports.know = function(req, res){
  res.render('know',{
      loopKnow : true
  });
};

/**
 * userInfo page
 * @param req
 * @param res
 */
exports.userInfo = function(req, res){
    res.render('userInfo',{
        loopUsInfo : true
    });
};

/**
 * 注册API
 * @param req
 * @param res
 */
exports.registerApi = function(req, res) {
    var user = {
      email : req.body.userName,
      password : req.body.pwd
    };
    User.register(user,res);
};

/**
 * 登录API
 * @param req
 * @param res
 */
exports.loginApi = function(req, res) {
    var user = {
        email : req.body.userName,
        password : req.body.pwd
    };
    User.login(user,res);
};

/**
 * 添加问题
 * @param req
 * @param res
 */
exports.addQuestion = function(req, res) {
    var question = {
      title: req.body.title,
      content: req.body.content
    };
   QUESTION.add(question, res);
};


/**
 * 获取单个问题
 * @param req
 * @param res
 */
exports.singleQestion = function(req, res) {
   var id = JSON.parse(req.params.id);
    QUESTION.getOneQestion(id, function(err, result) {
        if(err){
            res.send({
                code: 1,
                message: 'error'
            })
        }
        else{
            res.render('singlequestion',{
                question : result.value
            });
        }
    });
};

/**
 * 新闻
 * @param req
 * @param res
 */
exports.news = function(req, res) {
  res.render('news', {
      loopNews: true
  });
};
