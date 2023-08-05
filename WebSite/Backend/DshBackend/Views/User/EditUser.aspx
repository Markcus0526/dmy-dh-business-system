<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="DshBackend.Models" %>
<%@ Import Namespace="DshBackend.Models.Library" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<% var userinfo = (tbl_user)ViewData["userinfo"]; %>
<div class="page-header">
	<h1>
		会员信息		
        <a class="btn btn-white btn-default btn-round" onclick="window.history.go(-1)" style="float:right">
		    <i class="ace-icon fa fa-times red2"></i>
		    返回
	    </a>
	</h1>
</div>
<div class="row">
	<div class="col-xs-12">
		<form class="form-horizontal" role="form" id="validation-form">
			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="username">会员姓名：</label>
				<div class="col-sm-9">
                    <div class="clearfix">
					<input type="text" id="username" name="username" placeholder="请输入会员姓名" class="input-large form-control" <% if (userinfo != null) { %>value="<%= userinfo.username %>"<% } %> />
                    </div>
				</div>
			</div>
            <div class="form-group">
			    <label class="col-sm-3 control-label no-padding-right" for="birthday">会员生日：</label>

			    <div class="col-sm-9">
				    <div class="input-medium">
					    <div class="input-group">
						    <input class="input-medium date-picker" name = "birthday" id="birthday" type="text" data-date-format="yyyy-mm-dd" placeholder="yyyy-mm-dd" <% if (userinfo != null) { %> value="<%= String.Format("{0:yyyy-MM-dd}", userinfo.birthday) %>"<% } %> />
						    <span class="input-group-addon">
							    <i class="ace-icon fa fa-calendar"></i>
						    </span>
					    </div>
				    </div>
			    </div>
		    </div>
            <div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="email">会员邮箱地址：</label>
				<div class="col-sm-9">
                    <div class="clearfix">
					<input type="text" id="email" name="email" placeholder="请输入会员邮箱地址" class="input-large form-control" <% if (userinfo != null) { %>value="<%= userinfo.email %>"<% } %> />
                    </div>
				</div>
			</div>
            <div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="userid">会员用户名：</label>
				<div class="col-sm-9">
                    <div class="clearfix">
					<input type="text" id="userid" name="userid" placeholder="请输入会员用户名" class="input-large form-control" <% if (userinfo != null) { %>value="<%= userinfo.userid %>"<% } %> />
                    </div>
				</div>
			</div>
            <div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="score">会员积分：</label>
				<div class="col-sm-9">
                    <div class="clearfix">
					<input type="text" id="score" name="score" placeholder="请输入会员积分" class="input-large form-control" <% if (userinfo != null) { %>value="<%= userinfo.score %>"<% } %> />
                    </div>
				</div>
			</div>
            			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="videoname">图片：</label>
				<div class="col-sm-9">
                    <div class="clearfix">
                        <img id="previewimg" src="<% if (userinfo != null && userinfo.image != null && userinfo.image != "") { %><%= ViewData["rootUri"] %><%= userinfo.image %><% } else { %><%= ViewData["rootUri"] %>Content/img/noimage.gif<% } %>" style="max-width:238px;max-height:179px;" />
                        <input type="hidden" id="image" name="image" value="<% if (userinfo != null) { %><%= userinfo.image %><% } %>" />
                        <input type="button" class="btn btn-sm" id="upload_btn" value="选择图片" style="display:none;" />
                    </div>
                    <%--<span class="help-inline col-xs-12 col-sm-7">
						<span class="middle">建議大小：128*128px</span>
					</span>--%>
				</div>
            </div>             
			

            <input type="hidden" id="uid" name="uid" value="<% if (ViewData["uid"] != null) { %><%= ViewData["uid"] %><% } else { %>0<% } %>" />

			<div class="clearfix form-actions">
				<div class="col-md-offset-3 col-md-9">
					<button class="btn btn-info loading-btn" type="submit" data-loading-text="提交中...">
						<i class="ace-icon fa fa-check bigger-110"></i>
						提交
					</button>

					&nbsp; &nbsp; &nbsp;
					<button class="btn" type="reset">
						<i class="ace-icon fa fa-undo bigger-110"></i>
						重置
					</button>
				</div>
			</div>
        </form>
	</div>
</div>
<%--                <form name="form_upload" action="<%= ViewData["rootUri"] %>Upload/UploadImage" method="post" enctype="multipart/form-data">
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
	<link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.min.css" />
    <link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/plugins/jquery-ui/jquery-ui-1.10.1.custom.min.css" />
    <link rel="stylesheet" href="<%= ViewData["rootUri"] %>Content/css/datepicker.css" />
    
    <link href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-modal/css/bootstrap-modal-bs3patch.css" rel="stylesheet" type="text/css"/>
	<link href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-modal/css/bootstrap-modal.css" rel="stylesheet" type="text/css"/>
	<link href="<%= ViewData["rootUri"] %>Content/plugins/jcrop/css/jquery.Jcrop.min.css" rel="stylesheet" type="text/css"/>
	<link href="<%= ViewData["rootUri"] %>Content/css/pages/image-crop.css" rel="stylesheet" type="text/css"/>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" runat="server">

    <script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.js"></script>  
	<script src="<%= ViewData["rootUri"] %>Content/js/jquery.validate.min.js"></script>
	<script src="<%= ViewData["rootUri"] %>Content/js/validate.messages_zh.js"></script>

    <script src="<%= ViewData["rootUri"] %>Content/js/date-time/bootstrap-datepicker.min.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/date-time/bootstrap-datepicker.zh-CN.js"></script>
        <%--<script src="<%= ViewData["rootUri"] %>Content/plugins/upload/jquery.form.js"></script>--%>
    <script src="<%= ViewData["rootUri"] %>Content/js/ajaxupload.js"></script>

	<script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-modal/js/bootstrap-modal.js" type="text/javascript"></script>
	<script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-modal/js/bootstrap-modalmanager.js" type="text/javascript"></script>
	<script src="<%= ViewData["rootUri"] %>Content/plugins/jcrop/js/jquery.color.js" type="text/javascript"></script>
	<script src="<%= ViewData["rootUri"] %>Content/plugins/jcrop/js/jquery.Jcrop.min.js" type="text/javascript"></script>
	<script type="text/javascript">

	    var $modal = $('#ajax-modal');
	    var cropw = 128, croph = 128;

	    function redirectToListPage(status) {
	        if (status.indexOf("error") != -1) {
	            $('.loading-btn').button('reset');
	        } else {
	            window.location = rootUri + "User/UserList";
	        }
	    }
//	    var initFormUpload = function () {
//	        var bar = $('.bar');
//	        var percent = $('.percent');
//	        var status = $('#status');

//	        $('form[name=form_upload]').ajaxForm({
//	            dataType: 'json',
//	            beforeSend: function () {
//	                status.empty();
//	                $(".progress").css("display", "block");
//	                $('#uploadstatus').html("正在上传图片...");
//	                $("#uploadstatus").css("display", "block");
//	                var percentVal = '0%';
//	                bar.width(percentVal);
//	                percent.html(percentVal);
//	            },
//	            uploadProgress: function (event, position, total, percentComplete) {
//	                var percentVal = percentComplete + '%';
//	                bar.width(percentVal);
//	                percent.html(percentVal);
//	            },
//	            success: function () {
//	                var percentVal = '100%';
//	                bar.width(percentVal);
//	                percent.html(percentVal);
//	            },
//	            complete: function (xhr, status) {
//	                $(".progress").css("display", "none");
//	                $("#uploadstatus").css("display", "none");

//	                if (status == "success") {
//	                    //alert(xhr.responseText);
//	                    var filepath = xhr.responseText.substring(1, xhr.responseText.length - 1);
//	                    $("#previewimg").attr("src", rootUri + filepath);
//	                    $("#image").val(filepath);
//	                }
//	            }
//	        });
//	    };

//	    function SubmitUploadForm() {
//	        var ext = $('#uploadfile').val().split('.').pop().toLowerCase();
//	        if ($.inArray(ext, ['png', 'jpg', 'jpeg']) == -1) {
//	            alert("请选择图片格式文件");
//	        } else {
//	            $("form[name=form_upload]").submit();
//	        }
//	    }
	    jQuery(function ($) {
	        $('.loading-btn')
		      .click(function () {
		          var btn = $(this)
		          btn.button('loading')
		      });
	        $('.date-picker').datepicker({
	            language: 'zh-CN'
	        });
	       
	        /*$.validator.messages.required = "必须要填写";
	        $.validator.messages.minlength = jQuery.validator.format("必须由至少{0}个字符组成.");
	        $.validator.messages.maxlength = jQuery.validator.format("必须由最多{0}个字符组成");
	        $.validator.messages.equalTo = jQuery.validator.format("密码不一致.");*/
	        $('#validation-form').validate({
	            errorElement: 'span',
	            errorClass: 'help-block',
	            //focusInvalid: false,
	            rules: {
	                userid: {
	                    required: true,
	                    uniquename: true
	                },
	                birthday: {
                        required: true
                    },
	                email: {
                        email: true
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
	        return checkUserName();
	    }, "用户名已存在");
//	    initFormUpload();
//	    $("#imagebutton").click(function () {
//	        $('#uploadfile').trigger("click");
//	    });

	    $modal = $('#ajax-modal');
	    handleCropModal();
	});

	    function submitform() {
	        $.ajax({
	            type: "POST",
	            url: rootUri + "User/SubmitUser",
	            dataType: "json",
	            data: $('#validation-form').serialize(),
	            success: function (data) {
	                if (data == "") {
	                    toastr.options = {
	                        "closeButton": false,
	                        "debug": true,
	                        "positionClass": "toast-bottom-right",
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
	                        "positionClass": "toast-bottom-right",
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

	    function checkUserName() {
	        var username = $("#userid").val();
	        var retval = false;

	        $.ajax({
	            async: false,
	            type: "GET",
	            url: rootUri + "User/CheckUniqueUserid",
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


	    var $modal = $('#ajax-modal');
	    function handleCropModal() {
	        new AjaxUpload('#upload_btn', {
	            action: rootUri + 'Upload/UploadImage',
	            onSubmit: function (file, ext) {
	                $('#loading_photo').show();
	                if (!(ext && /^(JPG|PNG|JPEG|GIF)$/.test(ext.toUpperCase()))) {
	                    // extensiones permitidas
	                    alert('错误: 只能上传图片', '');
	                    $('#loading_photo').hide();
	                    return false;
	                }
	            },
	            onComplete: function (file, response) {
	                //alert(file + " | " + " | " + response);
	                var f_name = response;
	                $('#loading_photo').hide();
	                showCropDialog(f_name);
	            }
	        });

	        /*---------- Image Crop Dialog setup ---------*/
	        $.fn.modalmanager.defaults.resize = true;
	        $.fn.modalmanager.defaults.spinner = '<div class="loading-spinner fade" style="width: 200px; margin-left: -100px;"><img src="' + rootUri + 'Content/img/ajax-modal-loading.gif" align="middle">&nbsp;<span style="font-weight:300; color: #eee; font-size: 18px; font-family:Open Sans;">&nbsp;Loading...</span></div>';
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
	        }, 100);
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