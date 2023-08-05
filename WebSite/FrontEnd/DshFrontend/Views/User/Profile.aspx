<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="DshFrontend.Models" %>
<%@ Import Namespace="DshFrontend.Models.Library" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <% var userinfo = (tbl_user)ViewData["userinfo"]; %>
    <table align="center" style="width: 1024px;">
        <tr>
            <td>
                <div class="page-content" style="margin-left: 0; margin-top: 20px;">
                    <!-- BEGIN PAGE HEADER-->
                    <div class="row">
                        <div class="col-md-12">
                            <h3 class="page-title">
                                会员服务
                            </h3>
                        </div>
                    </div>
                    <!-- END PAGE HEADER-->
                    <!-- BEGIN PAGE CONTENT-->
                    <div class="row profile">
                        <div class="col-md-12">
                            <!--BEGIN TABS-->
                            <div class="tabbable tabbable-custom tabbable-full-width">
                                <div class="tab-content">
                                    <form class="form-horizontal" role="form" id="validation-form">
                                    
                                    <div class="row">
                                    <table align="center" width="100%"><tr><td align="center">
                                    <div class="col-md-2"></div>
                                        <div class="col-md-3">
                                            <ul class="list-unstyled profile-nav">
                                                <li>
                                                    <img src="<% if (userinfo != null && userinfo.image != null && userinfo.image != "") { %><%= ViewData["rootUri"] %><%= userinfo.image %><% } else { %><%= ViewData["rootUri"] %>Content/img/profile-img.png<% } %>"
                                                        class="img-responsive" alt="" id="previewimg" width="240px" height="240px" />
                                                    <input type="hidden" id="image" name="image" value="<% if (userinfo != null) { %><%= userinfo.image %><% } %>" />
                                                    <a href="#" class="profile-edit" id="upload_btn">修改</a> </li>
                                            </ul>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="row">
                                                <div class="form-group" style="margin-top: 32px;">
                                                    <label class="col-sm-3 control-label no-padding-right" for="userid">
                                                        用户名：</label>
                                                    <div class="col-sm-5">
                                                        <div class="clearfix">
                                                            <input type="text" id="userid" name="userid" placeholder="请输入用户名" class="input-large form-control"
                                                                <% if (userinfo != null) { %>value="<%= userinfo.userid %>" <% } %> readonly />
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group" style="margin-top: 32px;">
                                                    <label class="col-sm-3 control-label no-padding-right" for="score">
                                                        您的积分是：</label>
                                                    <div class="col-sm-5">
                                                        <div class="clearfix">
                                                            <input type="text" id="score" <% if (userinfo != null) { %>value="<%= userinfo.score %>"
                                                                <% } %> class="input-large form-control" readonly />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        </td></tr></table>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="tab-content">
                                            <div class="portlet-body">
                                            <table width="700px" align="center" style="margin-top: 20px;">
                                                <tr><td>
                                                <div class="form-group">
                                                    <label class="col-sm-5 control-label no-padding-right" for="username">
                                                        用户姓名：</label>
                                                    <div class="col-sm-5">
                                                        <div class="clearfix">
                                                            <input type="text" id="username" name="username" placeholder="请输入姓名" class="input-large form-control"
                                                                <% if (userinfo != null) { %>value="<%= userinfo.username %>" <% } %> readonly />
                                                        </div>
                                                    </div>
                                                </div>
                                                </td></tr>
                                                <tr><td>
                                                <div class="form-group">
                                                    <label class="col-sm-5 control-label no-padding-right" for="birthday">
                                                        生日：</label>
                                                    <div class="col-sm-5">
                                                        <div class="input-medium" style="width:210px">
                                                            <div class="input-group">
                                                                <input class="input-medium date-picker" name="birthday" id="birthday" type="text"
                                                                    data-date-format="yyyy-mm-dd" placeholder="yyyy-mm-dd" <% if (userinfo != null) { %>
                                                                    value="<% =String.Format("{0:yyyy-MM-dd}", userinfo.birthday) %>" <% } %> style="width:172px;" />
                                                                <span class="input-group-addon"><i class="ace-icon fa fa-calendar"></i></span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                </td></tr>
                                                <tr><td>
                                                <div class="space-30">
                                                </div>
                                                </td></tr>
                                                <tr><td>
                                                <div class="form-group">
                                                    <label class="col-sm-5 control-label no-padding-right" for="email">
                                                        邮箱地址：</label>
                                                    <div class="col-sm-5">
                                                        <div class="clearfix">
                                                            <input type="text" id="email" name="email" placeholder="请输入邮箱地址" class="input-large form-control"
                                                                <% if (userinfo != null) { %>value="<%= userinfo.email %>" <% } %> />
                                                        </div>
                                                    </div>
                                                </div>
                                                </td></tr>
                                                <tr><td>
                                                <div class="form-group">
                                                    <label class="col-sm-5 control-label no-padding-right" for="salecount">
                                                        我的订单：</label>
                                                    <div class="col-sm-5">
                                                        <div class="clearfix">
                                                            <a href="<% =ViewData["rootUri"] %>User/Sale" class="btn btn-sm btn-primary" style="width:210px;">
                                                                <span class="bigger-110">
                                                                    <% if (userinfo != null)
                                                                       { %><%= userinfo.sale_cnt %>
                                                                    <% } %>笔</span> </a>
                                                        </div>
                                                    </div>
                                                </div>
                                                </td></tr>
                                                <tr><td>
                                                <div class="form-group">
                                                    <label class="col-sm-5 control-label no-padding-right" for="phonenum">
                                                        我的手机号码：</label>
                                                    <div class="col-sm-5">
                                                        <div class="clearfix">
                                                            <input type="text" id="phonenum" name="phonenum" placeholder="请输入手机号码" class="input-large form-control"
                                                                <% if (userinfo != null) { %>value="<%= userinfo.phonenum %>" <% } %>  />
                                                        </div>
                                                    </div>
                                                </div>
                                                </td></tr>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                    <input type="hidden" id="uid" name="uid" value="<% if (ViewData["uid"] != null) { %><%= ViewData["uid"] %><% } else { %>0<% } %>" />
                                    <div class="clearfix form-actions">
                                    <table width="700px" align="center">
                                        <tr align="center">
                                            <td>
                                        <div class="col-md-offset-3 col-md-5">
                                            <button class="btn btn-info loading-btn" type="submit" data-loading-text="提交中...">
                                                <i class="ace-icon fa fa-check bigger-110"></i>确定
                                            </button>
                                            &nbsp; &nbsp;
                                            <button class="btn" type="button" onclick="window.location='<%=ViewData["rootUri"] %>User/Profile'">
                                                <i class="ace-icon fa fa-undo bigger-110"></i>重置
                                            </button>
                                        </div>
                                        </td></tr></table>
                                    </div>
                                    </form>
                                </div>
                            </div>
                            <!--END TABS-->
                        </div>
                    </div>
                    <!-- END PAGE CONTENT-->
                </div>
            </td>
        </tr>
    </table>
    <%--    <form name="form_upload" action="<%= ViewData["rootUri"] %>Upload/UploadImage" method="post" enctype="multipart/form-data">
                    <input type="file" id="uploadfile" name="uploadfile" onchange="SubmitUploadForm();" style="display:none;" />
                    <span class="help-block" id="uploadstatus" style="display:none;"></span>
                </form>--%>
    <input type="hidden" id="crop_x" name="x" />
    <input type="hidden" id="crop_y" name="y" />
    <input type="hidden" id="crop_w" name="w" />
    <input type="hidden" id="crop_h" name="h" />
    <div id="ajax-modal" class="modal fade" tabindex="-1">
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageStyle" runat="server">
    <link href="<% =ViewData["rootUri"]%>Content/css/plugins.css" rel="stylesheet" type="text/css" />
    <link href="<% =ViewData["rootUri"]%>Content/css/themes/default.css" rel="stylesheet"
        type="text/css" id="style_color" />
    <link href="<% =ViewData["rootUri"]%>Content/css/pages/profile.css" rel="stylesheet"
        type="text/css" />
    <link href="<% =ViewData["rootUri"]%>Content/css/custom.css" rel="stylesheet" type="text/css" />
    <link href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.min.css"
        rel="stylesheet" type="text/css" />
    <link href="<%= ViewData["rootUri"] %>Content/css/datepicker.css" rel="stylesheet" />
    <link href="<%= ViewData["rootUri"] %>Content/plugins/jcrop/css/jquery.Jcrop.min.css"
        rel="stylesheet" type="text/css" />
    <link href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-modal/css/bootstrap-modal-bs3patch.css"
        rel="stylesheet" type="text/css" />
    <link href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-modal/css/bootstrap-modal.css"
        rel="stylesheet" type="text/css" />
    <link href="<%= ViewData["rootUri"] %>Content/plugins/jcrop/css/jquery.Jcrop.min.css"
        rel="stylesheet" type="text/css" />
    <link href="<%= ViewData["rootUri"] %>Content/css/pages/image-crop.css" rel="stylesheet"
        type="text/css" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/jquery.validate.min.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/validate.messages_zh.js"></script>
    <%--<script src="<%= ViewData["rootUri"] %>Content/plugins/upload/jquery.form.js"></script>--%>
    <script src="<%= ViewData["rootUri"] %>Content/js/date-time/bootstrap-datepicker.min.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/date-time/bootstrap-datepicker.zh-CN.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-modal/js/bootstrap-modal.js" type="text/javascript"></script>
    <script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-modal/js/bootstrap-modalmanager.js" type="text/javascript"></script>
    <script src="<%= ViewData["rootUri"] %>Content/plugins/jcrop/js/jquery.color.js" type="text/javascript"></script>
    <script src="<%= ViewData["rootUri"] %>Content/plugins/jcrop/js/jquery.Jcrop.min.js"type="text/javascript"></script>
     <script type="text/javascript" src="<%= ViewData["rootUri"] %>Content/js/ajaxupload.js"></script>
    <script type="text/jscript">
        var $modal = $('#ajax-modal');
        var cropw = 240, croph = 240;
        //        var initFormUpload = function () {
        //            var bar = $('.bar');
        //            var percent = $('.percent');
        //            var status = $('#status');

        //            $('form[name=form_upload]').ajaxForm({
        //                dataType: 'json',
        //                beforeSend: function () {
        //                    status.empty();
        //                    $(".progress").css("display", "block");
        //                    $('#uploadstatus').html("正在上传图片...");
        //                    $("#uploadstatus").css("display", "block");
        //                    var percentVal = '0%';
        //                    bar.width(percentVal);
        //                    percent.html(percentVal);
        //                },
        //                uploadProgress: function (event, position, total, percentComplete) {
        //                    var percentVal = percentComplete + '%';
        //                    bar.width(percentVal);
        //                    percent.html(percentVal);
        //                },
        //                success: function () {
        //                    var percentVal = '100%';
        //                    bar.width(percentVal);
        //                    percent.html(percentVal);
        //                },
        //                complete: function (xhr, status) {
        //                    $(".progress").css("display", "none");
        //                    $("#uploadstatus").css("display", "none");

        //                    if (status == "success") {
        //                        //alert(xhr.responseText);
        //                        var filepath = xhr.responseText.substring(1, xhr.responseText.length - 1);
        //                        $("#previewimg").attr("src", rootUri + filepath);
        //                        $("#image").val(filepath);
        //                    }
        //                }
        //            });
        //        };

        //        function SubmitUploadForm() {
        //            var ext = $('#uploadfile').val().split('.').pop().toLowerCase();
        //            if ($.inArray(ext, ['png', 'jpg', 'jpeg']) == -1) {
        //                alert("请选择图片格式文件");
        //            } else {
        //                $("form[name=form_upload]").submit();
        //            }
        //        }


        jQuery(document).ready(function () {
            $('.loading-btn')
		      .click(function () {
		          var btn = $(this)
		          btn.button('loading')
		      });
            $('.date-picker').datepicker({
                language: 'zh-CN'
            });


            $('#validation-form').validate({
                errorElement: 'span',
                errorClass: 'help-block',
                //focusInvalid: false,
                rules: {
                    userid: {
                        required: true,
                        uniquename: true
                    },
                    username: {
                        required: true
                    },
                    birthday: {
                        required: true
                    },
                    email: {
                        required: true,
                        email: true
                    },
                    phonenum: {
                        required: true,
                        number: true,
                        minlength: 8,
                        maxlength: 14,
                        uniquephonenum: true
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

            $('#validation-form').find('.date-picker').datepicker();

            //            initFormUpload();
            //            $("#imagebutton").click(function () {
            //                $('#uploadfile').trigger("click");
            //            });

            $modal = $('#ajax-modal');

            new AjaxUpload('#upload_btn', {
                action: rootUri + 'Upload/UploadImage',
                onSubmit: function (file, ext) {
                    $('#loading_photo').show();
                    if (!(ext && /^(JPG|PNG|JPEG|GIF)$/.test( ext.toUpperCase() ))) {
                        // extensiones permitidas
                        alert('错误: 只能上传图片', '');
                        $('#loading_photo').hide();
                        return false;
                    }
                },
                onComplete: function (file,response) {
                 //   $('#loading_photo').hide();
                    //alert(file + " | " + " | " + response);
                  //  var f_name = response;
                    $('#loading_photo').hide();
                    showCropDialog(response);
                }
            });

            /*---------- Image Crop Dialog setup ---------*/
            $.fn.modalmanager.defaults.resize = true;
            $.fn.modalmanager.defaults.spinner = '<div class="loading-spinner fade" style="width: 200px; margin-left: -100px;"><img src="' + rootUri + 'Content/img/ajax-modal-loading.gif" align="middle">&nbsp;<span style="font-weight:300; color: #eee; font-size: 18px; font-family:Open Sans;">&nbsp;Loading...</span></div>';
        });

        function redirectToListPage(status) {
            if (status.indexOf("error") != -1) {
                $('.alert-success').hide();
                $('.loading-btn').button('reset');
            } else {
                $('.loading-btn').button('reset');
            }
        }

        function submitform() {
            $.ajax({
                async: false,
                type: "POST",
                url: rootUri + "User/SubmitUser",
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
            var rid = $("#uid").val();

            $.ajax({
                async: false,
                type: "GET",
                url: rootUri + "User/CheckUniquePhonenum",
                dataType: "json",
                data: {
                    phonenum: phonenum,
                    rid: rid
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
            var rid = $("#uid").val();

            $.ajax({
                async: false,
                type: "GET",
                url: rootUri + "User/CheckUniqueUsername",
                dataType: "json",
                data: {
                    username: username,
                    rid: rid
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

        var $modal = $('#ajax-modal');
        function handleCropModal() {
           
        }

        function showCropDialog(fname) {
            // create the backdrop and wait for next modal to be triggered
            $('body').modalmanager('loading');
            setTimeout(function () {
                $modal.load(rootUri + "Upload/RetrieveCropDialogHtml?cropfile=" + fname, '', function () {
                    cropimage();
                    $modal.modal({
                        backdrop: 'static',
                        keyboard: true,
                        width: parseInt($("#imgcrop").css("width"), 10) + 400
                    })

                        .on("hidden", function () {
                            $modal.empty();
                        });
                });
            }, 1000);
        }

        var cropimage = function () {
            // Create variables (in this scope) to hold the API and image size
            //alert(parseInt($("#imgcrop").css("width"), 10) + 300);
            //$("#ajax-modal").css("width", parseInt($("#imgcrop").css("width"), 10) + 300);
            var jcrop_api,
                boundx,
                boundy,
            // Grab some information about the preview pane
                $preview = $('#preview-pane'),
                $pcnt = $('#preview-pane .preview-container'),
                $pimg = $('#preview-pane .preview-container img');
            $preview.css("right", "-300px");

            $pcnt.width(cropw);
            $pcnt.height(croph);

            var xsize = $pcnt.width(),
                ysize = $pcnt.height();

            //console.log('init', [xsize, ysize]);

            $('#imgcrop').Jcrop({
                onChange: updatePreview,
                onSelect: updatePreview,
                aspectRatio: cropw / croph,
                setSelect: [0, 0, cropw, croph]
            }, function () {
                // Use the API to get the real image size
                var bounds = this.getBounds();
                boundx = bounds[0];
                boundy = bounds[1];
                // Store the API in the jcrop_api variable
                jcrop_api = this;
                // Move the preview into the jcrop container for css positioning
                $preview.appendTo(jcrop_api.ui.holder);
            });

            function updatePreview(c) {
                $('#crop_x').val(c.x);
                $('#crop_y').val(c.y);
                $('#crop_w').val(c.w);
                $('#crop_h').val(c.h);

                if (parseInt(c.w) > 0) {
                    var rx = xsize / c.w;
                    var ry = ysize / c.h;

                    $pimg.css({
                        width: Math.round(rx * boundx) + 'px',
                        height: Math.round(ry * boundy) + 'px',
                        marginLeft: '-' + Math.round(rx * c.x) + 'px',
                        marginTop: '-' + Math.round(ry * c.y) + 'px'
                    });
                }
            };
        }

        var submitCrop = function (cropfile) {
            $modal.modal('loading');
            $.ajax({
                url: rootUri + "Upload/ResizeImage",
                data: {
                    x: $('#crop_x').val(),
                    y: $('#crop_y').val(),
                    w: $('#crop_w').val(),
                    h: $('#crop_h').val(),
                    imgpath: cropfile,
                    kind: "<%= UpImageCategory.USER %>",
                    size: "<%= CropImageSizes.USER %>"
                },
                type: "POST",
                success: function (rst) {
                    $modal.modal('loading');
                    if (rst == "") {
                        $modal.find('.modal-body')
		                    .prepend('<div class="alert alert-error fade in">' +
		                    '操作失败：原图不存在！<button type="button" class="close" data-dismiss="alert"></button>' +
		                    '</div>');
                    } else {
                        $("#previewimg").attr("src", rootUri + rst);
                        $('#image').val(rst);
                        $modal.modal('hide');
                    }
                }
            });
        }

    </script>
</asp:Content>
