nodemailer = require("nodemailer")
path = require("path")

logHelper = require("../helper/logHelper")
swig = require("swig")

emailInfo = require("./emailInfo.json")

###
    render email
###
renderEmail = (user,cb)->
  templatePath = path.join(__dirname, "../views/email", "invite.html")
  name = user.email.split('@')[0]
  swig.renderFile templatePath, {
    name: name
  }, (err, mailContent)->
    if err
      logHelper.errorLog("render email file:" + err)
    cb err, mailContent, user

###
    自己服务器邮件发送端口
###
netEaseMailTransport = nodemailer.createTransport({
  host: "www.chetansite.com"
  debug: true
})

sendEmail = (user, mailContent, emailInfoArr, cb)->
  mailOptions = {
    from: '驾考学习 <service@chetansite.com>', ##代发邮箱
    to: user.email, ##目的邮箱
    subject: "助车网，驾考学习", ##邮箱标题
    text: "我们是助车网，一个专注于汽车、驾照考试的问答社区，在这里，你可以提出你学车前，学车时，以至于学车后的问题，可以提出所有与汽车相关的问题,也希望你能回答。", ##文本内容
    html: mailContent ##html
  }
  netEaseMailTransport.sendMail(mailOptions, (error, info) ->
    if error
      logHelper.emailLog('send email error: ' + mailOptions.to + '   Message error: ' + error);
    else
      logHelper.emailLog('send successful email: ' + mailOptions.to + '   Message sent: ' + info.response);
      if cb and typeof cb is 'function'
        cb emailInfoArr
  )

emailInfoArr = emailInfo.emailArr
#emailInfoArr = [
#  {"email":"pengfeng91@163.com"},
#  {"email":"592893997@qq.com"},
#  {"email":"1429970147@qq.com"}
#]

###
  发送邮件
###
i = 0
send = (emailInfoArr)->
  if i is emailInfoArr.length
    netEaseMailTransport.close()
    logHelper.emailLog('all email send success')
    return true;
  renderEmail emailInfoArr[i],(err, mailContent, user) ->
    if err
      logHelper.errorLog('render email:' + err)
    else
      sendEmail user, mailContent, emailInfoArr, (emailInfoArr)->
        i = i + 1
        send emailInfoArr

send(emailInfoArr)

