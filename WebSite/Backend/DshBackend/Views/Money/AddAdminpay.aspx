<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="DshBackend.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <% var payinfo = (tbl_adminpayment)ViewData["payinfo"]; %>
    <div class="page-header">
        <h1>
            应收应付 <small><i class="ace-icon fa fa-angle-double-right"></i>
                <% if (ViewData["uid"] == null)
                   { %>
                添加
                <% }
                   else
                   { %>
                编辑
                <% } %>
                 </small><a class="btn btn-white btn-default btn-round" onclick="window.history.go(-1)"
                    style="float: right"><i class="ace-icon fa fa-times red2"></i>返回 </a>
        </h1>
    </div>
    <div class="row">
        <div class="col-xs-12">
            <form class="form-horizontal" role="form" id="validation-form">
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="show">
                    类型选择：</label>
                <div class="col-xs-12 col-sm-9">
                    <div class="clearfix">
                        <select class="input-large form-control" id="type" name="type">
                            <option value="0" <% if (payinfo != null && payinfo.type == 0) { %>
                                                selected<% } %>>应收</option>
                            <option value="1" <% if (payinfo != null && payinfo.type == 1) { %>
                                                selected<% } %>>应付</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="content">
                    名称：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <input type="text" id="name" name="name" placeholder="请输入名称" class="input-large form-control"
                            <% if (payinfo != null) { %>value="<%= payinfo.name %>" <% } %> />
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="content">
                    联系号码：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <input type="text" id="phonenum" name="phonenum" placeholder="请输入联系号码" class="input-large form-control"
                            <% if (payinfo != null) { %>value="<%= payinfo.phonenum %>" <% } %> />
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="content">
                    理由：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <textarea class="form-control col-md-4 adjust-left" name="reason" id="reason"
                            style="width: 360px; height: 100px; max-width: 370px; min-width: 370px;"><% if (payinfo != null)
                                                                                                        { %><%= payinfo.reason%><% } %></textarea>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="content">
                    应收/应付金额：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <input type="text" id="price" name="price" placeholder="请输入应收/应付金额" class="input-large form-control"
                            <% if (payinfo != null) { %>value="<%= payinfo.price %>" <% } %> />
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="content">
                    实收/实付金额：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <input type="text" id="real_price" name="real_price" placeholder="请输入实收/实付金额" class="input-large form-control"
                            <% if (payinfo != null) { %>value="<%= payinfo.real_price %>" <% } %> />
                    </div>
                </div>
            </div>
            
            <input type="hidden" id="uid" name="uid" value="<% if (ViewData["uid"] != null) { %><%= ViewData["uid"] %><% } else { %>0<% } %>" />

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

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageStyle" runat="server">
    <link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.min.css" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/jquery.validate.min.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/validate.messages_zh.js"></script>
    <script type="text/javascript">

	    function redirectToListPage(status) {
	        if (status.indexOf("error") != -1) {
	            $('.loading-btn').button('reset');
	        } else {
	            window.location = rootUri + "Money/AdminpayList";
	        }
	    }        

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
	                type: {
	                    required: true
	                },
	                name: {
	                    required: true
	                },
	                phonenum: {
	                    required: true,
	                    number: true,
                        minlength: 8,
                        maxlength: 14
	                },
	                reason: {
	                    required: true
	                },
	                price: {
	                    required: true,
                        number: true
                    },
                    real_price: {
                        //required: true,
                        number: true
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
	            url: rootUri + "Money/SubmitAdminpay",
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
