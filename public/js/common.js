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
    });
    $('.mc').click(function() {
        $('.mc').hide();
        $('.quiz').hide();
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
                $('.loginAndRegister').animate({
                    height: 0
                },function() {
                    var node = '<li><a href="/user/signout">退出</a></li>';
                    $('#header .navigation').append($(node));
                })
            }
        })

    });

    /* --------------------------------------------------------------------------- */
    /*  5. register
     /* --------------------------------------------------------------------------- */

    $('.register input').blur(function() {
        var name = $('.register .name input').val(),
            email = $('.register .email input').val(),
            pwd = $('.register .pwd input').val();
        if(name && email && pwd) {
            $('.register .submit input').removeAttr('disabled').attr('class', 'enabled');
        }
    });
});