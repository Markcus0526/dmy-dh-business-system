<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta charset="utf-8" />
    <title>鼎圣汇前台</title>
    <meta name="description" content="User Register page" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />

    <link rel="stylesheet" href="<%= ViewData["rootUri"] %>content/css/bootstrap.min.css" />
    <link rel="stylesheet" href="<%= ViewData["rootUri"] %>content/css/font-awesome.min.css" />
    <link rel="stylesheet" href="<%= ViewData["rootUri"] %>content/css/ace.min.css" />
    <link rel="stylesheet" href="<%= ViewData["rootUri"] %>content/css/ace-rtl.min.css" />
    <link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.min.css" />
    <link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/plugins/jquery-ui/jquery-ui-1.10.1.custom.min.css" />
    <link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/css/style-metronic.css" />
    <link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/css/style.css" />
    <link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/css/style-responsive.css" />
    <link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/css/plugins.css" />
</head>
<body style="background-color: White;">
    <table align="center" style="width:1024px;">
    <tr>
    <td>
    <div style="padding: 50px 50px 50px;">
        <div class="row">
            <div class="col-md-12">
                <h3 class="page-title">
                    <span class="glyphicon glyphicon-edit"></span>用户注册
                    <button type="button" class="btn default" style="float: right" onclick="window.history.go(-1);">
                        返回</button>
                </h3>
                <hr />
            </div>
        </div>
        <div class="portlet-body form" id="form_wizard_1">
            <div class="col-md-12">
                <form class="form-horizontal" role="form" id="validation-form">
                <div class="form-wizard">
                    <div class="form-body">
                        <ul class="nav nav-pills nav-justified steps">
                            <li><a href="#tab1" data-toggle="tab" class="step active"><span class="number">1</span>
                                <span class="desc"><i class="fa fa-check"></i>手机号码</span> </a></li>
                            <li><a href="#tab2" data-toggle="tab" class="step"><span class="number">2</span> <span
                                class="desc"><i class="fa fa-check"></i>验证码</span> </a></li>
                            <li><a href="#tab3" data-toggle="tab" class="step"><span class="number">3</span> <span
                                class="desc"><i class="fa fa-check"></i>注册成功</span> </a></li>
                        </ul>
                        <div id="bar" class="progress progress-striped" role="progressbar">
                            <div class="progress-bar progress-bar-success">
                            </div>
                        </div>
                        <div class="tab-content">
                            <div class="alert alert-danger display-none">
                                <button class="close" data-dismiss="alert">
                                </button>
                                您还未完成填写信息，请确认下面的内容。
                            </div>
                            <div class="alert alert-success display-none">
                                <button class="close" data-dismiss="alert">
                                </button>
                                提交中，请稍等...
                            </div>
                            <div class="tab-pane active" id="tab1">
                                <h3 class="block" style="text-shadow:3px 3px 10px #75c982;color:#35aa47;"><b>手机号码</b></h3>
                                    <div class="form-group alert alert-info">
                                        <label class="col-sm-3 control-label no-padding-right" for="phonenum">
                                            手机号码：</label>
                                        <div class="col-sm-5">
                                            <div class="clearfix">
											    <span class="block input-icon input-icon-right">
                                                <input type="text" id="phonenum" name="phonenum" placeholder="请输入手机号码" class="form-control" />
                                                <i class="ace-icon fa fa-phone"></i>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                <div class="space">
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label no-padding-right">
                                    </label>
                                    <input type="checkbox" class="ace" id="agree_liscense" />
                                    <span class="lbl">同意【鼎盛汇服务协议】和【支付宝服务协议】</span>
                                </div>
                            </div>
                            <div class="tab-pane" id="tab2">
                                <h3 class="block" style="text-shadow:3px 3px 10px #75c982;color:#35aa47;"><b>填写验证码</b></h3>
                                <div class="form-group">
                                    <label class="control-label col-md-3">
                                    </label>
                                    <p class="alert alert-warning">
	                                    <i class="ace-icon fa fa-exclamation-triangle"></i>
                                        验证码已发送到你的手机，3分钟内输入有效，请《不知道的文字》
                                    </p>
                                </div>
                                <div class="alert alert-info">
                                <div class="form-group">
                                    <label class="control-label col-md-3">
                                    </label>
                                    <div class="col-sm-4">
                                        <h5>手机号码：<span id="phonenum_display"></span></h5>
                                    </div>
                                </div>
                                <div class="space">
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label no-padding-right">
                                        验证码：</label>
                                    <div class="col-sm-4">
                                        <div class="clearfix">
											<span class="block input-icon input-icon-right">
                                            <input type="text" class="input-large form-control" id="verify_code" placeholder="请输入验证码"
                                                name="verify_code" />
                                            <i class="ace-icon fa fa-key"></i>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="col-sm-7" id="time_display">
                                            <button type="button" class="width-150 btn btn-sm btn-default" style="background-color:#fcf8e3 !important;color:#8a6d3b !important;">
                                                <i class="ace-icon fa  fa-clock-o"></i><span class="bigger-110">3分后可重新操作</span>
                                            </button>
                                        </div>
                                        <div class="col-sm-7" style="display: none;" id="button_verify">
                                            <button type="button" class="width-100 btn btn-sm btn-primary" onclick="submitPhonenum();">
                                                <i class="ace-icon fa fa-asterisk"></i><span class="bigger-110">重新邀请</span>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                </div>
                            </div>
                            <div class="tab-pane" id="tab3">
                                <h3 class="block" style="text-shadow:3px 3px 10px #75c982;color:#35aa47;"><b>用户信息</b></h3>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label no-padding-right" for="username">
                                        用户名：</label>
                                    <div class="col-sm-4">
                                        <div class="clearfix">
											<span class="block input-icon input-icon-right">
                                            <input type="text" id="username" name="username" placeholder="请输入用户名" class="input-large form-control" />
                                            <i class="ace-icon fa fa-user"></i>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label no-padding-right" for="userpwd">
                                        密码：</label>
                                    <div class="col-sm-4">
                                        <div class="clearfix">
											<span class="block input-icon input-icon-right">
                                            <input type="password" id="userpwd" name="userpwd" placeholder="请输入密码" class="input-large form-control" />
                                            <i class="ace-icon fa fa-lock"></i>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label no-padding-right" for="confirmpwd">
                                        确认密码：</label>
                                    <div class="col-sm-4">
                                        <div class="clearfix">
											<span class="block input-icon input-icon-right">
                                            <input type="password" id="confirmpwd" name="confirmpwd" placeholder="请输入确认密码" class="input-large form-control" />
                                            <i class="ace-icon fa fa-lock"></i>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="form-actions fluid">
                        <!--밑단부분-->
                        <div class="row">
                            <div class="col-md-12">
                                <div class="col-md-offset-3 col-md-9">
                                    <a href="javascript:;" class="btn blue button-previous" style="background-color:#e92727 !important;"><i class="ace-icon fa fa-arrow-left"></i>上一步 </a>&nbsp;&nbsp;&nbsp;
                                    <a href="javascript:;" class="btn blue button-next" style="background-color:#ac59d6 !important;">下一步 <i class="ace-icon fa fa-arrow-right"></i></a>
                                    <a href="javascript:;" class="btn btn-info loading-btn button-submit" data-loading-text="提交中..." style="background-color:#16a5d7 !important;"><i class="ace-icon fa fa-check bigger-110"></i>保存</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                </form>
            </div>
        </div>
    </div>
    </td>
    </tr>
    </table>
    <script type="text/javascript" src="<%= ViewData["rootUri"] %>Content/js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="<%= ViewData["rootUri"] %>Content/js/ui/jquery.ui.core.js"></script>
    <script type="text/javascript" src="<%= ViewData["rootUri"] %>Content/js/ui/jquery.ui.widget.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/plugins/jquery.cookie.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-wizard/jquery.bootstrap.wizard.min.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/jquery.validate.min.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/validate.messages_zh.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/ajaxupload.js"></script>
    <script>
    
        var rootUri = "<%= ViewData["rootUri"] %>";
        var isSubmittingPhonenum = 0;

        var currenttime = 180;
        function leftTimeFunc() {
            if(currenttime <= 0) {
               $("#time_display").hide();
               $("#button_verify").show();
            } else {
                $("#time_display button span").html(getTimeString(currenttime) + "后可重新操作");
                currenttime --;
                setTimeout("leftTimeFunc()",1000);
            }
        }

        function getTimeString(sec) {
            if(sec < 60)
                return sec + "秒";
            else {
                if (sec % 60 == 0)
                    return Math.floor(sec/60) + "分"
                else
                    return Math.floor(sec/60) + "分" + (sec % 60) + "秒";
            }                
        }

	    jQuery(document).ready(function () {

	        $('.loading-btn')
		      .click(function () {
		          var btn = $(this)
		          btn.button('loading')
		      });

	        var form = $('#validation-form');
	        var error = $('.alert-danger', form);
	        var success = $('.alert-success', form);
	        $('#validation-form').validate({
	            errorElement: 'span',
	            errorClass: 'help-block',
	            //focusInvalid: false,
	            rules: {
	                phonenum: {
	                    required: true,
                        number: true,
                        minlength: 8,
                        maxlength: 14,
	                    uniquephonenum: true
	                },
	                verify_code: {
	                    required: true,
                        number: true,
                        minlength: 6,
                        maxlength: 6,
	                    rightcode: true,
                        codeavailable: true
	                },
	                username: {
	                    required: true,
                        uniquename: true
	                },
	                userpwd: {
	                    minlength: 6,
	                    maxlength: 16,
	                    required: true
	                },
	                confirmpwd: {
	                    equalTo: "#userpwd",
	                    required: true
	                }
	            },
	            highlight: function (e) {
	                $(e).closest('.form-group').removeClass('has-info').addClass('has-error');
	            },

	            success: function (e) {
	                $(e).closest('.form-group').removeClass('has-error'); //.addClass('has-info');
	                $(e).remove();
	            },

	            errorPlacement: function (error, element) {
	                if (element.is(':checkbox') || element.is(':radio')) {
	                    var controls = element.closest('div[class*="col-"]');
	                    if (controls.find(':checkbox,:radio').length > 1) controls.append(error);
	                    else error.insertAfter(element.nextAll('.lbl:eq(0)').eq(0));
	                }
	                else if (element.is('.select2')) {
	                    error.insertAfter(element.siblings('[class*="select2-container"]:eq(0)'));
	                }
	                else if (element.is('.chosen-select')) {
	                    error.insertAfter(element.siblings('[class*="chosen-container"]:eq(0)'));
	                }
	                else error.insertAfter(element.parent());
	            },

	            submitHandler: function (form) {
	                submitform();
	                return false;
	            },
	            invalidHandler: function (form) {
	                $('.loading-btn').button('reset');
	            }
	        });
	        $.validator.addMethod("uniquename", function (value, element) {
	            return checkUsername();
	        }, "用户已存在");
	        $.validator.addMethod("uniquephonenum", function (value, element) {
	            return checkPhonenum();
	        }, "手机号码已存在");
	        $.validator.addMethod("rightcode", function (value, element) {
	            return checkVerifyCode();
	        }, "输入的效验码错误！");
	        $.validator.addMethod("codeavailable", function (value, element) {
	            return checkVerifyCodeAvailable();
	        }, "效验码不能使用，有效时间超过了！");
	       
	        if (!jQuery().bootstrapWizard) {
	            return;
	        }

	        var handleTitle = function (tab, navigation, index) {
	            var total = navigation.find('li').length;
	            var current = index + 1;
	            // set wizard title
	            $('.step-title', $('#form_wizard_1')).text('Step ' + (index + 1) + ' of ' + total);
	            // set done steps
	            jQuery('li', $('#form_wizard_1')).removeClass("done");
	            var li_list = navigation.find('li');
	            for (var i = 0; i < index; i++) {
	                jQuery(li_list[i]).addClass("done");
	            }

	            if (current == 1) {
	                $('#form_wizard_1').find('.button-previous').hide();
	            } else {
	                $('#form_wizard_1').find('.button-previous').show();
	            }

	            if (current >= total) {
	                $('#form_wizard_1').find('.button-next').hide();
	                $('#form_wizard_1').find('.button-submit').show();
	            } else {
	                $('#form_wizard_1').find('.button-next').show();
	                $('#form_wizard_1').find('.button-submit').hide();
	            }
	            //App.scrollTo($('.page-title'));
	        }

	        $('#form_wizard_1').bootstrapWizard({
	            'nextSelector': '.button-next',
	            'previousSelector': '.button-previous',
	            onTabClick: function (tab, navigation, index, clickedIndex) {
	                /*success.hide();
	                error.hide();
	                if (form.valid() == false) {
	                    return false;
	                }
	                handleTitle(tab, navigation, clickedIndex);*/

                    return false;
	            },
	            onNext: function (tab, navigation, index) {
	                success.hide();
	                error.hide();

	                if (form.valid() == false) {
	                    return false;
	                }

                    if(index == 1) {
                        if(!document.getElementById("agree_liscense").checked) {
                            toastr.options = {
	                            "closeButton": false,
	                            "debug": true,
	                            "positionClass": "toast-top-center",
	                            "onclick": null,
	                            "showDuration": "3",
	                            "hideDuration": "3",
	                            "timeOut": "1500",
	                            "extendedTimeOut": "1000",
	                            "showEasing": "swing",
	                            "hideEasing": "linear",
	                            "showMethod": "fadeIn",
	                            "hideMethod": "fadeOut"
	                        };
	                        toastr["error"]("你必须要同意【鼎盛汇服务协议】和【支付宝服务协议】", "温馨敬告");

                            return false;
                        } else {
                            submitPhonenum();
                        }
                    }

	                handleTitle(tab, navigation, index);
	            },
	            onPrevious: function (tab, navigation, index) {
	                success.hide();
	                error.hide();

	                handleTitle(tab, navigation, index);
	            },
	            onTabShow: function (tab, navigation, index) {
                    setTimeout(function() {
	                    var total = navigation.find('li').length;
	                    var current = index + 1;
	                    var $percent = (current / total) * 100;
	                    $('#form_wizard_1').find('.progress-bar').css({
	                        width: $percent + '%'
	                    });
                    }, 100);
	            }
	        });

	        $('#form_wizard_1').find('.button-previous').hide();
	        $('#form_wizard_1 .button-submit').click(function () {
	            submitform();
	        }).hide();
	    });
             
	    function redirectToListPage(status) {
	        if (status.indexOf("error") != -1) {
	            $('.alert-success').hide();
	            $('.loading-btn').button('reset');
	        } else {
                if(isSubmittingPhonenum != 1)
                    window.history.go(-1);
	        }
	    }

	    function submitform() {
            isSubmittingPhonenum = 0;

	        $.ajax({
	            async: false,
	            type: "POST",
	            url: rootUri + "Account/SubmitUser",
	            dataType: "json",
	            data: $('#validation-form').serialize(),
	            success: function (data) {
	                if (data == "") {
	                    toastr.options = {
	                        "closeButton": false,
	                        "debug": true,
	                        "positionClass": "toast-top-center",
	                        "onclick": null,
	                        "showDuration": "3",
	                        "hideDuration": "3",
	                        "timeOut": "1500",
	                        "extendedTimeOut": "1000",
	                        "showEasing": "swing",
	                        "hideEasing": "linear",
	                        "showMethod": "fadeIn",
	                        "hideMethod": "fadeOut"
	                    };
	                    toastr["success"]("操作成功!", "恭喜您");
	                } else {
	                    toastr.options = {
	                        "closeButton": false,
	                        "debug": true,
	                        "positionClass": "toast-top-center",
	                        "onclick": null,
	                        "showDuration": "3",
	                        "hideDuration": "3",
	                        "timeOut": "1500",
	                        "extendedTimeOut": "1000",
	                        "showEasing": "swing",
	                        "hideEasing": "linear",
	                        "showMethod": "fadeIn",
	                        "hideMethod": "fadeOut"
	                    };
	                    toastr["error"](data, "温馨敬告");

	                }
	            },
	            error: function (data) {
	                alert("Error: " + data.status);
	                $('.loading-btn').button('reset');
	            }
	        });
	    }

	    function checkPhonenum() {
	        var phonenum = $("#phonenum").val();
	        var retval = false;

	        $.ajax({
	            async: false,
	            type: "GET",
	            url: rootUri + "Account/CheckUniquePhonenum",
	            dataType: "json",
	            data: {
	                phonenum: phonenum
	            },
	            success: function (data) {
	                if (data == true) {
	                    retval = true;
	                } else {
	                    retval = false;
	                }
	            }
	        });

	        return retval;
	    }

	    function submitPhonenum() {
            isSubmittingPhonenum = 1;

	        var phonenum = $("#phonenum").val();
	        var retval = false;

	        $.ajax({
	            async: false,
	            type: "POST",
	            url: rootUri + "Account/SubmitPhonenum",
	            dataType: "json",
	            data: {
	                phonenum: phonenum
	            },
	            success: function (data) {
	                if (data == "") {
	                    toastr.options = {
	                        "closeButton": false,
	                        "debug": true,
	                        "positionClass": "toast-top-center",
	                        "onclick": null,
	                        "showDuration": "3",
	                        "hideDuration": "3",
	                        "timeOut": "3500",
	                        "extendedTimeOut": "1000",
	                        "showEasing": "swing",
	                        "hideEasing": "linear",
	                        "showMethod": "fadeIn",
	                        "hideMethod": "fadeOut"
	                    };
	                    toastr["success"]("效验码已发送了!", "恭喜您");                        

                        $("#button_verify").hide();
                        $("#time_display").show();
                        currenttime = 180;
                        setTimeout("leftTimeFunc()",1000);

	                } else {
	                    toastr.options = {
	                        "closeButton": false,
	                        "debug": true,
	                        "positionClass": "toast-top-center",
	                        "onclick": null,
	                        "showDuration": "3",
	                        "hideDuration": "3",
	                        "timeOut": "3500",
	                        "extendedTimeOut": "1000",
	                        "showEasing": "swing",
	                        "hideEasing": "linear",
	                        "showMethod": "fadeIn",
	                        "hideMethod": "fadeOut"
	                    };
	                    toastr["error"](data, "温馨敬告");

	                }
	            }
	        });

            $("#phonenum_display").html(phonenum);
	    }

	    function checkVerifyCode() {
	        var phonenum = $("#phonenum").val();
	        var verify_code = $("#verify_code").val();
	        var retval = false;

	        $.ajax({
	            async: false,
	            type: "GET",
	            url: rootUri + "Account/CheckRightVerifyCode",
	            dataType: "json",
	            data: {
	                phonenum: phonenum,
	                verify_code: verify_code
	            },
	            success: function (data) {
	                if (data == true) {
	                    retval = true;
	                } else {
	                    retval = false;
	                }
	            }
	        });

	        return retval;
	    }

	    function checkVerifyCodeAvailable() {
	        var phonenum = $("#phonenum").val();
	        var verify_code = $("#verify_code").val();
	        var retval = false;

	        $.ajax({
	            async: false,
	            type: "GET",
	            url: rootUri + "Account/CheckVerifyCodeAvailable",
	            dataType: "json",
	            data: {
	                phonenum: phonenum,
	                verify_code: verify_code
	            },
	            success: function (data) {
	                if (data == true) {
	                    retval = true;
	                } else {
	                    retval = false;
	                }
	            }
	        });

	        return retval;
	    }

	    function checkUsername() {
	        var username = $("#username").val();
	        var retval = false;

	        $.ajax({
	            async: false,
	            type: "GET",
	            url: rootUri + "Account/CheckUniqueUsername",
	            dataType: "json",
	            data: {
	                username: username
	            },
	            success: function (data) {
	                if (data == true) {
	                    retval = true;
	                } else {
	                    retval = false;
	                }
	            }
	        });

	        return retval;
	    }
            
    </script>
</body>
</html>
