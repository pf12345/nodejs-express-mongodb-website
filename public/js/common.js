/**
 * Created by Administrator on 14-3-8.
 */
$(document).ready(function() {
    /* --------------------------------------------------------------------------- */
    /*  0.  showMsg
     /* --------------------------------------------------------------------------- */
    function showMsg(string, callback) {
        $('#showMsg').html(string).show();
        var timer = setTimeout(function() {
            $('#showMsg').html('').hide();
            if(callback && typeof callback === 'function') {
                callback();
            }
            clearTimeout(timer);
        }, 3000);
    }

    /* --------------------------------------------------------------------------- */
    /*  2.  header
     /* --------------------------------------------------------------------------- */
    $('.navigate li').each(function() {
        $(this).click(function() {
            $('.navigate li').each(function() {
                $(this).removeClass('current');
            });
            $(this).attr('class','current');
        });
    });

    /* --------------------------------------------------------------------------- */
    /*  3.  home page
     /* --------------------------------------------------------------------------- */
    $('#js-newques').click(function() {
        $('.mc').show();
        $('.quiz').show();
        var timer = setTimeout(function() {
            $('.mc').css('opacity', '1');
            $('.quiz').css('opacity', '1');
            clearTimeout(timer);
        }, 20);
    });
    var hide = function() {
        var timer = setTimeout(function() {
            $('.mc').hide();
            $('.quiz').hide();
            clearTimeout(timer);
        }, 300);
        $('.mc').css('opacity', '0');
        $('.quiz').css('opacity', '0');
    };
    $('.mc').click(function() {
        hide();
    });
    $('.quiz .close').click(function() {
        hide();
    });
    /* --------------------------------------------------------------------------- */
    /*  4. login
     /* --------------------------------------------------------------------------- */

    $('.login input[type=button]').click(function() {
        var email = $('.login input[type=text]').val(),
            pwd = $('.login input[type=password]').val();

        if(!email || email == '' || !pwd || pwd === '') {
            showMsg("请填入正确的用户信息");
            return;
        }

        $.post('/user/login', {
            userName: email,
            pwd: pwd
        }, function(data) {
            if(data.code === 0) {
                console.log(data)
                $('.loginAndRegister').animate({
                    height: 0
                },function() {
                    var node = '<li><a href="/user/'+data.result._id+'">用户中心</a></li>' +
                        '<li><a href="/user/signout">退出</a></li>';
                    $('#header .navigation').append($(node));
                })
            }else {
                showMsg(data.message);
            }
        })
    });

    /* --------------------------------------------------------------------------- */
    /*  5. register
     /* --------------------------------------------------------------------------- */

    $('.register input').keyup(function() {
        var name = $('.register .name input').val(),
            email = $('.register .email input').val(),
            pwd = $('.register .pwd input').val();

        if(name !== '' && email !== '' && pwd !== '') {
            $('.register .submit input').removeAttr('disabled').attr('class', 'enabled');
        }else{
            $('.register .submit input').attr('disabled', true).removeAttr('class');
        }
    });


    /* --------------------------------------------------------------------------- */
    /*  6.add comments
     /* --------------------------------------------------------------------------- */

    $('#js-wenda-ci-submit').click(function() {
        var content = $('#comment').html(),
            qId = $('#qId').val();
        if(!content || content === '') {
            showMsg("请添加评论信息");
            return
        }
        $.post("/comments/add", {
            qId: qId,
            content: content
        }, function(data) {
            if(data.code === 0) {
                window.location.reload();
            }else{
                showMsg(data.message);
            }
        })
    });

    $('.js-qa-tr-num').each(function(i) {
        $(this).click(function() {
            $('.qa-reply').each(function(j) {
                if(i === j) {
                    if($(this).css("display") === 'none') {
                        $(this).show();
                        var id;
                        $('.qa-comment input[type=hidden]').each(function(m) {
                            if(i === m) {
                                id = $(this).val();
                            }
                        });
                        $.get('/comments/getAllReply', {
                            cId: id
                        }, function(data) {
                            if(data.code === 0) {
                                $('.qa-reply-c').each(function(n) {
                                    if(i === n) {
                                        var html = ''
                                        for(var x = 0, _x = data.replies.length; x < _x; x ++) {
                                            var reply = data.replies[x];
                                            html += '<div class="qa-reply-item">' +
                                                '<a class="qa-reply-item-author" href="#" title="'+reply.user.name+'">' +
                                                '<img src="'+reply.user.avatar+'" width="40" height="40">' +
                                                '</a>' +
                                                '<div class="qa-reply-item-inner">' +
                                                '<p>' +
                                                '<a href="javascript:void(0)" class="qa-reply-nick">'+reply.user.name+'</a>' +
                                                '</p>' +
                                                '<p class="q-reply-item-c">'+reply.content+'</p>' +
                                                '<div class="qa-reply-item-foot clearfix">' +
                                                '<span class="reply-item-index r">#'+(x+1)+'</span>' +
                                                '<span>'+reply.addTime+'</span>' +
                                                '</div>' +
                                                '</div>' +
                                                '</div>';
                                        }
                                        $(this).html(html);
                                    }
                                });
                            }
                        })

                    }else{
                        $(this).hide();
                    }

                }
            })
        });
    })

    $('.qa-reply .js-ipt-submit').each(function(i){
       $(this).click(function() {
           var id, content;
           $('.qa-reply textarea').each(function(j) {
               if(i === j) {
                   content = $(this).val();
               }
           });

           $('.qa-comment input[type=hidden]').each(function(m) {
              if(i === m) {
                  id = $(this).val();
              }
           });

           $.post("/comments/addReply", {
               cId: id,
               content: content
           }, function(data) {
               console.log(data)
               if(data.code === 0) {
                   var reply = data.reply[0];
                   $('.qa-reply-c').each(function(n) {
                       if(i === n) {
                           var html = '<div class="qa-reply-item">' +
                               '<a class="qa-reply-item-author" href="#" title="'+reply.user.name+'">' +
                               '<img src="'+reply.user.avatar+'" width="40" height="40">' +
                               '</a>' +
                               '<div class="qa-reply-item-inner">' +
                               '<p>' +
                               '<a href="javascript:void(0)" class="qa-reply-nick">'+reply.user.name+'</a>' +
                               '</p>' +
                               '<p class="q-reply-item-c">'+reply.content+'</p>' +
                               '<div class="qa-reply-item-foot clearfix">' +
                               '<span>'+reply.addTime+'</span>' +
                               '</div>' +
                               '</div>' +
                               '</div>';
                           $(this).append(html);
                       }
                   });
               }
           })
       });
    });

    $('#user-question').click(function() {
        $(this).attr('class', 'quealltab onactive');
        $('#user-answer').attr('class', 'quealltab');
        if($('.user .question').css('display') === 'none') {
            $('.user .question').show();
        }
        if($('.user .answer').css('display') !== 'none') {
            $('.user .answer').hide();
        }
    });

    $('#user-answer').click(function() {
        $(this).attr('class', 'quealltab onactive');
        $('#user-question').attr('class', 'quealltab');
        if($('.user .question').css('display') !== 'none') {
            $('.user .question').hide();
        }
        if($('.user .answer').css('display') === 'none') {
            $('.user .answer').show();
        }
    });
});