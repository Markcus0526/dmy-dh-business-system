<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="DshBackend.Models" %>
<%@ Import Namespace="DshBackend.Models.Library" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <% var deviceinfo = (tbl_device)ViewData["deviceinfo"]; %>
    <div class="page-header">
        <h1>
            机具管理 <small><i class="ace-icon fa fa-angle-double-right"></i>
                <% if (ViewData["uid"] == null)
                   { %>
                添加
                <% }
                   else
                   { %>
                编辑
                <% } %>
                机具 </small><a class="btn btn-white btn-default btn-round" onclick="window.history.go(-1)"
                    style="float: right"><i class="ace-icon fa fa-times red2"></i>返回 </a>
        </h1>
    </div>
    <div class="row">
        <div class="col-xs-12">
            <form class="form-horizontal" role="form" id="validation-form">
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="addr">
                    机具名称：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <input type="text" id="name" name="name" placeholder="请输入机具名称" class="input-large form-control"
                            <% if (deviceinfo != null) { %>value="<%= deviceinfo.name %>" <% } %> />
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="content">
                    机具描述：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <textarea id="description" name="description" class="col-md-4 adjust-left form-control" style="width: 370px;
                            height: 100px; max-width: 370px; min-width: 370px;"><% if (deviceinfo != null) { %><%= deviceinfo.description %><% } %></textarea>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="addr">
                    上传时间：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <input type="text" placeholder="请输入上传时间" class="input-large form-control" value="<% =ViewData["datetime"] %>" disabled/>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="imagelist">
                    机具图片：</label>
                <div class="col-sm-9" id="divimagelist">
                    <div class="clearfix">
                        <input type="button" class="btn btn-sm" id="upload_btn" value="选择图片" />
                    </div>
                    <%
                        var imagelist = (List<string>)ViewData["imagelist"];
                        if (imagelist != null)
                        {
                            for (int i = 0; i < imagelist.Count(); i++)
                            {
                                string imgurl = imagelist.ElementAt(i);
                    %>
                    <div style="margin: 10px 0px;">
                        <input type="hidden" class="divimglist" value="<% =imgurl %>" />
                        <div style='float: left; padding: 5px;'>
                            <img src='<%= ViewData["rootUri"] %><% =imgurl %>' style="border: 1px solid #ccc;"
                                width='100px' height='100px' onmouseover='over_img(this)' onmouseout='out_img(this)'>
                            <a href='javascript:void(0);'>
                                <img src='<%= ViewData["rootUri"] %>content/img/imgdel.png' class='close_btn' onclick="removeMe(this, 'fname')"
                                    onmouseover='over_close(this)' style='visibility: hidden; margin-top: -100px;
                                    margin-left: -10px; width: 20px; height: 20px;' onmouseout='out_close(this)'></a>
                        </div>
                    </div>
                    <% 
                        }
                    }
                    %>
                </div>
            </div>
            <input type="hidden" id="uid" name="uid" value="<% if (ViewData["uid"] != null) { %><%= ViewData["uid"] %><% } else { %>0<% } %>" />
            <input type="hidden" id="imagelist" name="imagelist" value="<% if (ViewData["imagelist"] != null) { %><%= ViewData["imagelist"] %><% } %>" />


            <div class="clearfix form-actions">
                <div class="col-md-offset-3 col-md-9">
                    <button class="btn btn-info loading-btn" type="submit" data-loading-text="提交中...">
                        <i class="ace-icon fa fa-check bigger-110"></i>提交
                    </button>
                    &nbsp; &nbsp; &nbsp;
                    <button class="btn" type="reset">
                        <i class="ace-icon fa fa-undo bigger-110"></i>重置
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
    
    <link href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-modal/css/bootstrap-modal-bs3patch.css" rel="stylesheet" type="text/css"/>
	<link href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-modal/css/bootstrap-modal.css" rel="stylesheet" type="text/css"/>
	<link href="<%= ViewData["rootUri"] %>Content/plugins/jcrop/css/jquery.Jcrop.min.css" rel="stylesheet" type="text/css"/>
	<link href="<%= ViewData["rootUri"] %>Content/css/pages/image-crop.css" rel="stylesheet" type="text/css"/>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/jquery.validate.min.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/validate.messages_zh.js"></script>
    <%--<script src="<%= ViewData["rootUri"] %>Content/plugins/upload/jquery.form.js"></script>--%>
    <script src="<%= ViewData["rootUri"] %>Content/js/ajaxupload.js"></script>

	<script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-modal/js/bootstrap-modal.js" type="text/javascript"></script>
	<script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-modal/js/bootstrap-modalmanager.js" type="text/javascript"></script>
	<script src="<%= ViewData["rootUri"] %>Content/plugins/jcrop/js/jquery.color.js" type="text/javascript"></script>
	<script src="<%= ViewData["rootUri"] %>Content/plugins/jcrop/js/jquery.Jcrop.min.js" type="text/javascript"></script>
    <script type="text/javascript">

        var $modal = $('#ajax-modal');
        var cropw = 100, croph = 100;


	    function redirectToListPage(status) {
	        if (status.indexOf("error") != -1) {
	            $('.loading-btn').button('reset');
	        } else {
	            window.location = rootUri + "Device/DeviceList";
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
//	                    if ($('input.divimglist').length >= 4) {
//	                        toastr.options = {
//	                            "closeButton": false,
//	                            "debug": true,
//	                            "positionClass": "toast-bottom-right",
//	                            "onclick": null,
//	                            "showDuration": "3",
//	                            "hideDuration": "3",
//	                            "timeOut": "3500",
//	                            "extendedTimeOut": "1000",
//	                            "showEasing": "swing",
//	                            "hideEasing": "linear",
//	                            "showMethod": "fadeIn",
//	                            "hideMethod": "fadeOut"
//	                        };

//	                        toastr["error"]("商品图片能最大4片", "溫馨警告");

//	                        return;
//	                    }

//	                    var htmlstr = '<div style="margin:10px 0px;">' +
//	                                '<input type="hidden" class="divimglist" value="' + filepath + '" />' +
//	                                '<div style="float:left; padding:5px;">' +
//	                                '<img src="' + rootUri + filepath + '" style="border:1px solid #ccc;" width="100px" height="100px" onmouseover="over_img(this)" onmouseout="out_img(this)" >' +
//	                                '<a href="javascript:void(0);"><img src="<%= ViewData["rootUri"] %>content/img/imgdel.png" class="close_btn" onclick="removeMe(this, \'fname\')" onmouseover="over_close(this)" style="visibility:hidden; margin-top:-100px; margin-left:-10px; width:20px; height:20px;" onmouseout="out_close(this)"></a>' +
//	                                '</div>'
//	                    '</div>';

//	                    $("#divimagelist").append(htmlstr);
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
              
	        $('#validation-form').validate({
	            errorElement: 'span',
	            errorClass: 'help-block',
	            //focusInvalid: false,
	            rules: {
	                name: {
	                    required: true,
                        uniquename: true
	                },
	                description: {
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
	            return checkDeviceName();
	        }, "机具已存在");       
            

//	        initFormUpload();
//	        $("#imagebutton").click(function () {
//                isRecommend = false;
//	            $('#uploadfile').trigger("click");
//	        });

	        $modal = $('#ajax-modal');
	        handleCropModal();
	    });

	    function submitform() {            
            var selected_id ="";
	        $('input.divimglist').each(function () {
	            if ($(this).attr('class') == 'divimglist')
	                selected_id += $(this).attr('value') + ",";
	        });

	        $("#imagelist").val(selected_id);

	        if (selected_id == "") {
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

	            toastr["error"]("没有机具图片", "溫馨警告");

	            return;
	        }

	        $.ajax({
	            type: "POST",
	            url: rootUri + "Device/SubmitDevice",
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

	    function checkDeviceName() {
	        var devicename = $("#name").val();
	        var retval = false;
	        var rid = $("#uid").val();

	        $.ajax({
	            async: false,
	            type: "GET",
	            url: rootUri + "Device/CheckUniqueDevicename",
	            dataType: "json",
	            data: {
	                devicename: devicename,
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

	    
	    function removeMe(obj, f_name) {
	        var pic_div = obj.parentNode.parentNode.parentNode;
	        $(pic_div).remove();
	    }
	    function over_img(obj) {
	        clearTimeout(timeoutID);
	        timer_flag = false;
	        if (img_parent_div)
	            $(img_parent_div).find(".close_btn").css('visibility', 'hidden');
	        var obj_parent = $(obj).parent();
	        //$(obj_parent).find(".close_btn").show(); 
	        $(obj_parent).find(".close_btn").css('visibility', 'visible');
	    }
	    var img_parent_div = null;
	    var timeoutID;
	    function out_img(obj) {
	        img_parent_div = $(obj).parent();
	        timeoutID = setTimeout("timerProc( )", 500);
	        timer_flag = true;
	    }
	    var timer_flag = false;
	    var close_flag = false;
	    function timerProc() {
	        if (!close_flag) {
	            $(img_parent_div).find(".close_btn").css('visibility', 'hidden');
	        }
	        timer_flag = false;
	    }
	    function over_close(obj) {
	        close_flag = true;
	    }
	    function out_close(obj) {
	        close_flag = false;

	        if (!timer_flag)
	            $(obj).css('visibility', 'hidden');
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
	                kind: "<%= UpImageCategory.DEVICE %>",
	                size: "<%= CropImageSizes.DEVICE %>"
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
	                    var filepath = rst;

	                    if ($('input.divimglist').length >= 1) {
	                        toastr.options = {
	                            "closeButton": false,
	                            "debug": true,
	                            "positionClass": "toast-bottom-right",
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

	                        toastr["error"]("商品图片能最大只一片", "溫馨警告");

	                        $modal.modal('hide');

	                        return;
	                    }

	                    var htmlstr = '<div style="margin:10px 0px;">' +
	                                '<input type="hidden" class="divimglist" value="' + filepath + '" />' +
	                                '<div style="float:left; padding:5px;">' +
	                                '<img src="' + rootUri + filepath + '" style="border:1px solid #ccc;" width="100px" height="100px" onmouseover="over_img(this)" onmouseout="out_img(this)" >' +
	                                '<a href="javascript:void(0);"><img src="<%= ViewData["rootUri"] %>content/img/imgdel.png" class="close_btn" onclick="removeMe(this, \'fname\')" onmouseover="over_close(this)" style="visibility:hidden; margin-top:-100px; margin-left:-10px; width:20px; height:20px;" onmouseout="out_close(this)"></a>' +
	                                '</div>'
	                    '</div>';

	                    $("#divimagelist").append(htmlstr);

	                    $modal.modal('hide');
	                }
	            }
	        });
	    }


    </script>
</asp:Content>
