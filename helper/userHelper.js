// Generated by CoffeeScript 1.8.0

/*
    判断是否登录
 */

(function() {
  exports.isLogin = function(req, res) {
    var isLogin;
    if (req.session) {
      isLogin = req.session.userId ? req.session.userId : false;
      return isLogin;
    } else {
      return false;
    }
  };


  /*
      获取用户信息
   */

  exports.getUserInfo = function(req) {
    var user;
    user = {
      id: req.session.userId || 0,
      email: req.session.userEmail || '',
      name: req.session.userName || '游客',
      avatar: req.session.userAvatar || '/images/avatar/default.jpg'
    };
    return user;
  };

}).call(this);

//# sourceMappingURL=userHelper.js.map
