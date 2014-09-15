##simple-mvc
simple-mvc is a light mvc framework based on express.

##Install
`npm install simple-mvc`

##Useage

###config
1. app=express()
2. require('simple-mvc')(app)
3. done!

###project structure

      |-- app.js
        |-- controllers
        |   |-- home.js
        |   |-- user.js
        |-- views
        |   |-- home
        |   |   |-- index.html
        |   |-- user
        |   |   |-- index.html
        |   |   |-- login.html
        |-- filter.js

###GET

    exports.user_GET=function(req,res){
        var user={
            name:"massimo",
            email:"email"
        };
        res.render("user",{
            user:user
        });
    };

`GET` represent http method is get,this is the default method,you can omit it:

    exports.user=function(req,res){
        var user={
            name:"massimo",
            email:"email"
        };
        res.render("user",{
            user:user
        });
    };

###POST

    exports.new_POST=function(req,res){
        var name=req.body.name;
        var password=req.body.password;
        var userId=1; //insert into db and get user id
        res.render("success",{
            userId:userId
        });
    };

You can't omit `POST`.

##Route example

####http://example.com

*/controller/home.js:*

    exports.index=function(req,res){
        res.render("index",{
            title:"welcome"    
        });
    };

####http://example.com/blog

*/controller/blog.js:*
    
    exports.index=function(req,res){
        res.render("index");
    };

####http://example.com/blog/post?id=15

*/controller/blog.js*
    
    exports.post=function(req,res){
        var blogId=req.query.id;
        var blog={}; //get blog from database
        res.render("post",{
            blog:blog
        });
    };

##Filter
`$` in function represent filter,default filter should place in `appRootDirectory/filter.js`.For example:

*appRootDirectory/filter.js:*

    exports.$auth=(req,res,next){
        if(req.session && req.session.userId>0){
            next();
        }
        else{
            res.redirect('/user/login');
        }
    };

*appRootDirectory/controller/user.js:*

    exports.account_$auth=(req,res){
        var userId=req.session.userId;
        var user={}; //get user info from database
        res.render("account",{
            user:user
        });
    };

##Advanced
###Coustom config

Below is default simple-mvc config,you can custom it easily:

*appRootDirectory/app.js:*
    
    var app=express();
    require("simple-mvc")({
        controllerPath: "controllers",
        viewPath: "views",
        defaultEngine: "swig",
        defaultViewEngine: "html",
        filter:require("filter.js")
    },app);

###Custom route

Add `$mvcConfig` in controller can custom route:

*appRootDirectory/blog.js:*

    exports.$mvcConfig={
        route:{
            post:{
                path:"/post/:id"
            }
        }
    }
    
    exports.post=(req,res){
        var postId=req.params.id;
        var post={}; //get post from db
        res.render("post",{
            post:post
        });
    };
