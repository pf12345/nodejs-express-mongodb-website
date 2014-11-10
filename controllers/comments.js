// Generated by CoffeeScript 1.8.0
(function() {
  var commentsBll, moment, questionBll, userBll, userHelper;

  commentsBll = require("../Bll/commentsBll");

  questionBll = require("../Bll/questionBll");

  userBll = require("../Bll/userBll");

  moment = require("moment");

  moment.lang("zh-cn");

  userHelper = require("../helper/userHelper");


  /*
      添加评论
   */

  exports.add_POST = function(req, res) {
    var info, qId;
    qId = req.body.qId;
    info = {
      qId: qId,
      content: req.body.content,
      user: userHelper.getUserInfo(req)
    };
    return commentsBll.add(info, function(err, comment) {
      if (err) {
        return res.send({
          code: 1,
          message: err.message
        });
      } else {
        return questionBll.changeUpdateTime(qId, function(err) {
          if (err) {
            return res.send({
              code: 1,
              message: err.message
            });
          } else {
            return questionBll.changeResNum(qId, function(err) {
              if (err) {
                console.log('changeQuestionResNum error:' + err);
              }
              if (req.session.userId) {
                return userBll.changeResNum(req.session.userId, function(err) {
                  if (err) {
                    console.log('changeUserResNum error:' + err);
                  }
                  if (comment) {
                    comment.addTime = moment(comment.addTime).fromNow();
                    return res.send({
                      code: 0,
                      message: "ok",
                      comment: comment
                    });
                  }
                });
              }
            });
          }
        });
      }
    });
  };


  /*
      添加评论回复信息
   */

  exports.addReply_POST = function(req, res) {
    var info;
    info = {
      cId: req.body.cId,
      user: userHelper.getUserInfo(req),
      content: req.body.content
    };
    return commentsBll.addReply(info, function(err, reply) {
      if (err) {
        return res.send({
          code: 1,
          message: err.message
        });
      } else {
        return commentsBll.changeReplyNum(info.cId, function(err) {
          if (err) {
            console.log('changeReplyNum error:' + err);
          }
          return res.send({
            code: 0,
            message: "ok",
            reply: reply
          });
        });
      }
    });
  };


  /*
  	修改喜欢数量
   */

  exports.changeLikeNum = function(req, res) {
    var cId;
    cId = req.query.cId;
    return commentsBll.changeLikeNum(cId, function(err) {
      if (err) {
        return res.send({
          code: 1,
          message: err.message
        });
      } else {
        return res.send({
          code: 0,
          message: 'ok'
        });
      }
    });
  };


  /*
      获取评论所以回复
   */

  exports.getAllReply = function(req, res) {
    var cId;
    cId = req.query.cId;
    return commentsBll.getAllReply(cId, function(err, replies) {
      if (err) {
        return res.send({
          code: 1,
          message: err.message
        });
      } else {
        if (replies) {
          replies.map(function(reply) {
            return reply.addTime = moment(reply.addTime).fromNow();
          });
        }
        return res.send({
          code: 0,
          message: "ok",
          replies: replies
        });
      }
    });
  };

}).call(this);

//# sourceMappingURL=comments.js.map