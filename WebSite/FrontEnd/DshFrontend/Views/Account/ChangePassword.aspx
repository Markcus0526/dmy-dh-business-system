<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="DshFrontend.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<% var userinfo = (tbl_user)ViewData["userinfo"]; %>

<table align="center" style="width: 1024px; font-size: 14px;">
        <tr>
            <td>
                <div class="page-content" style="margin-left: 0; margin-top: 20px;">
                    <!-- BEGIN PAGE HEADER-->
                    <div class="row">
                        <div class="col-md-12">
                            <h3 class="page-title">
                                修改密码
                                <a class="btn btn-white btn-default btn-round" onclick="window.history.go(-1)" style="float:right">
		                            <i class="ace-icon fa fa-times red2"></i>
		                            返回
	                            </a>
                            </h3>
                        </div>
                    </div>
                    <!-- END PAGE HEADER-->
                    <!-- BEGIN PAGE CONTENT-->
                    <div class="row ">
                        <div class="col-md-12">
                            <!--BEGIN TABS-->
                            <div class="tabbable tabbable-custom tabbable-full-width" id="mainContainerDiv">
                                <form class="form-horizontal" role="form" id="validation-form">
                                <div class="row">
                                    <div class="tab-content">
                                        <div class="portlet-body">
                                            <table width="700px" align="center" style="margin-top: 20px;">
                                                <tr>
                                                    <td>
                                                        <div class="form-group">
                                                            <label class="col-sm-5 control-label no-padding-right" for="userpwd">密码：</label>
                                                            <div class="col-sm-5">
                                                                <div class="clearfix">
                                                                    <input type="password" id="userpwd" name="userpwd" placeholder="请输入密码" class="input-large form-control" <% if (userinfo != null) { %>value="<%= userinfo.password %>"<% } %> />
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <div class="form-group">
                                                            <label class="col-sm-5 control-label no-padding-right" for="confirmpwd">确认密码：</label>
                                                            <div class="col-sm-5">
                                                                <div class="clearfix">
                                                                    <input type="password" id="confirmpwd" name="confirmpwd" placeholder="请确认密码" class="input-large form-control" <% if (userinfo != null) { %>value="<%= userinfo.password %>"<% } %> />
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                                <input type="hidden" id="uid" name="uid" value="<% if (ViewData["uid"] != null) { %><%= ViewData["uid"] %><% } else { %>0<% } %>" />
                                <div class="clearfix form-actions">
                                    <table width="700px" align="center">
                                        <tr align="center">
                                            <td>
                                                <button class="btn btn-info loading-btn" type="submit" data-loading-text="提交中...">
                                                    <i class="ace-icon fa fa-check bigger-110"></i>提交
                                                </button>
                                                &nbsp; &nbsp;
                                                <button class="btn" type="button" onclick="window.history.go(-1);">
                                                    <i class="ace-icon fa fa-undo bigger-110"></i>重置
                                                </button>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                </form>
                            </div>
                            <!--END TABS-->
                        </div>
                    </div>
                    <!-- END PAGE CONTENT-->
                </div>
            </td>
        </tr>
    </table>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageStyle" runat="server">
	<link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.min.css" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" runat="server">
	<script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.js"></script>  
	<script src="<%= ViewData["rootUri"] %>Content/js/jquery.validate.min.js"></script>
	<script type="text/javascript">
	    function redirectToListPage(status) {
	        if (status.indexOf("error") != -1) {
	            $('.loading-btn').button('reset');
	        } else {
	            history.go(-1);
	        }
	    }
	    jQuery(function ($) {
	        $('.loading-btn')
		      .click(function () {
		          var btn = $(this)
		          btn.button('loading')
		      });

	        $.validator.messages.required = "必须要填写";
	        $.validator.messages.minlength = jQuery.validator.format("必须由至少{0}个字符组成.");
	        $.validator.messages.maxlength = jQuery.validator.format("必须由最多{0}个字符组成");
	        $.validator.messages.equalTo = jQuery.validator.format("密码不一致.");
	        $('#validation-form').validate({
	            errorElement: 'span',
	            errorClass: 'help-block',
	            //focusInvalid: false,
	            rules: {
	                userpwd: {
	                    minlength: 6,
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
	    });

	    function submitform() {
	        $.ajax({
	            type: "POST",
	            url: rootUri + "Account/SetPassword",
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
    </script>
</asp:Content>