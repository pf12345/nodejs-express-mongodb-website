// Generated by CoffeeScript 1.8.0

/*
    判断是否登录
 */

(function() {
  exports.isLogin = function(req, res) {
    var isLogin;
    if (req.session) {
      isLogin = req.session.userId ? true : false;
      return isLogin;
    } else {
      return false;
    }
  };

}).call(this);

//# sourceMappingURL=userHelper.js.map
