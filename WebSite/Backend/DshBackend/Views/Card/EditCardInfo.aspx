<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="DshBackend.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<% var cardinfo = (tbl_cardinfo)ViewData["cardinfo"]; %>
<div class="page-header">
	<h1>
		业务办理
		<small>
			<i class="ace-icon fa fa-angle-double-right"></i>
             编辑业务办理
		</small>
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
                <label class="col-sm-3 control-label no-padding-right" for="name">
                    持卡人姓名：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <input type="text" id="name" name="name" placeholder="请输入持卡人姓名" class="input-large form-control"
                            <% if (cardinfo != null) { %>value="<%= cardinfo.name %>" <% } %> />
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="phonenum">
                    预留电话：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <input type="text" id="phonenum" name="phonenum" placeholder="请输入预留电话" class="input-large form-control"
                            <% if (cardinfo != null) { %>value="<%= cardinfo.phonenum %>" <% } %> />
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="cardnum">
                    身份证号码：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <input type="text" id="cardnum" name="cardnum" placeholder="请输入身份证号码" class="input-large form-control"
                            <% if (cardinfo != null) { %>value="<%= cardinfo.cardnum %>" <% } %> />
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="name">
                    预留地址：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <input type="text" id="addr" name="addr" placeholder="请输入预留地址" class="input-large form-control"
                            <% if (cardinfo != null) { %>value="<%= cardinfo.addr %>" <% } %> />
                    </div>
                </div>
            </div>
			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="content">留言信息：</label>
				<div class="col-sm-9">
                    <div class="clearfix">
					 <textarea id="content" name="content" class="col-md-4 adjust-left form-control" style="width: 370px;
                            height: 100px; max-width: 370px; min-width: 370px;"><% if (cardinfo != null)
                                                                                   {%><%=cardinfo.content%><% } %></textarea>
                    </div>
				</div>
			</div>			
            <input type="hidden" id="uid" name="uid" value="<% if (ViewData["uid"] != null) { %><%= ViewData["uid"] %><% } else { %>0<% } %>" />
            <input type="hidden" id="type" name="type" value=<%= ViewData["type"] %> />

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

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageStyle" runat="server">
	<link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.min.css" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" runat="server">
	<script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.js"></script>  
	<script src="<%= ViewData["rootUri"] %>Content/js/jquery.validate.min.js"></script>
	<script src="<%= ViewData["rootUri"] %>Content/js/validate.messages_zh.js"></script>
	<script type="text/javascript">
    var type = "<%=ViewData["type"] %>";
	    function redirectToListPage(status) {
	        if (status.indexOf("error") != -1) {
	            $('.loading-btn').button('reset');
	        } else {
                if (type == 0)
	                window.location = rootUri + "Card/BankCard";
                else if (type == 1)
	                window.location = rootUri + "Card/CreditCard";
                else if (type == 2)
	                window.location = rootUri + "Card/InsuranceCard";
                else if (type == 3)
	                window.location = rootUri + "Card/FinanceCard";
                else if (type == 4)
	                window.location = rootUri + "Card/LendCard";
	        }
	    }
	    jQuery(function ($) {
	        $('.loading-btn')
		      .click(function () {
		          var btn = $(this)
		          btn.button('loading')
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
	                name: {
	                    required: true	                   
	                },
	                phonenum: {
	                    required: true,
                        number: true,
                        minlength: 8,
                        maxlength: 14
	                },
	                cardnum: {
	                    required: true
	                },
	                addr: {
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
	            url: rootUri + "Card/SubmitCardInfo",
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