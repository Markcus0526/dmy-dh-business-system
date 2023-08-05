<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="DshBackend.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<% var roleinfo = (tbl_adminrole)ViewData["roleinfo"]; %>
<div class="page-header">
	<h1>
		用户权限
		<small>
			<i class="ace-icon fa fa-angle-double-right"></i>
            <% if (ViewData["uid"] == null)
               { %>
			添加
            <% }
               else
               { %>
               编辑
            <% } %>
            权限
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
				<label class="col-sm-3 control-label no-padding-right" for="rolename">权限名称：</label>
				<div class="col-sm-9">
                    <div class="clearfix">
					<input type="text" id="rolename" name="rolename" placeholder="请输入角色名称" class="input-large form-control" <% if (roleinfo != null) { %>value="<%= roleinfo.rolename %>"<% } %> />
                    </div>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="rolename">权限：</label>
				<div class="col-sm-5">
                    <div class="clearfix">
                    <table id="listTable" class="table table-bordered table-hover dataTable table-striped" style="clear:right; width:100%; margin:0px; padding:0px;">
                        <tbody>
                            <tr>
                                <td rowspan="8" style="width:200px; text-align:center;">
									<label>
										<input type="checkbox" class="ace setbtn ul-1" data-id="1" 
                                        <% if (ViewData["role"] != null && 
                                        ViewData["role"].ToString().Split(',').Contains("business") && 
                                        ViewData["role"].ToString().Split(',').Contains("shop") && 
                                        ViewData["role"].ToString().Split(',').Contains("catalog") && 
                                        ViewData["role"].ToString().Split(',').Contains("money") && 
                                        ViewData["role"].ToString().Split(',').Contains("user") && 
                                        ViewData["role"].ToString().Split(',').Contains("device") && 
                                        ViewData["role"].ToString().Split(',').Contains("basedata")
                                        ) { %> checked <% } %> />
										<span class="lbl"> 全部</span>
									</label>
						        </td>
				            </tr>
							<tr>
							    <td>
									<label>
										<input name="configuration" id="configuration1" type="checkbox" class="ace indbtn li-1" data-id="1" value="business"
                                        <% if (ViewData["role"] != null && ViewData["role"].ToString().Split(',').Contains("business")) { %> checked <% } %> />
										<span class="lbl"> 业务办理</span>
									</label>
							    </td>
				            </tr>
							<tr>
							    <td>
									<label>
										<input name="configuration" id="configuration2" type="checkbox" class="ace indbtn li-1" data-id="1" value="shop"
                                        <% if (ViewData["role"] != null && ViewData["role"].ToString().Split(',').Contains("shop")) { %> checked <% } %> />
										<span class="lbl"> 商户管理</span>
									</label>
								</td>
				            </tr>
							<tr>
							    <td>
									<label>
										<input name="configuration" id="configuration3" type="checkbox" class="ace indbtn li-1" data-id="1" value="catalog"
                                        <% if (ViewData["role"] != null && ViewData["role"].ToString().Split(',').Contains("catalog")) { %> checked <% } %> />
										<span class="lbl"> 商品管理</span>
									</label>
								</td>
				            </tr>
							<tr>
							    <td>
									<label>
										<input name="configuration" id="configuration4" type="checkbox" class="ace indbtn li-1" data-id="1" value="money"
                                        <% if (ViewData["role"] != null && ViewData["role"].ToString().Split(',').Contains("money")) { %> checked <% } %> />
										<span class="lbl"> 财务信息管理</span>
									</label>
								</td>
				            </tr>	
							<tr>
							    <td>
									<label>
										<input name="configuration" id="Checkbox1" type="checkbox" class="ace indbtn li-1" data-id="1" value="user"
                                        <% if (ViewData["role"] != null && ViewData["role"].ToString().Split(',').Contains("user")) { %> checked <% } %> />
										<span class="lbl"> 会员管理</span>
									</label>
								</td>
				            </tr>
							<tr>
							    <td>
									<label>
										<input name="configuration" id="Checkbox2" type="checkbox" class="ace indbtn li-1" data-id="1" value="device"
                                        <% if (ViewData["role"] != null && ViewData["role"].ToString().Split(',').Contains("device")) { %> checked <% } %> />
										<span class="lbl"> 机具添加管理</span>
									</label>
								</td>
				            </tr>
							<tr>
							    <td>
									<label>
										<input name="configuration" id="Checkbox3" type="checkbox" class="ace indbtn li-1" data-id="1" value="basedata"
                                        <% if (ViewData["role"] != null && ViewData["role"].ToString().Split(',').Contains("basedata")) { %> checked <% } %> />
										<span class="lbl"> 权限添加管理</span>
									</label>
								</td>
				            </tr>		
                
                        </tbody>
                    </table>					
                    </div>
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
	            window.location = rootUri + "Admin/RoleList";
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
	                rolename: {
	                    required: true,
	                    uniquerolename: true
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

	                if ($('#validation-form :checked').length == 0) {
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

	                    toastr["error"]("请选择角色", "温馨敬告");
	                    return false;
	                }
	                submitform();
	                return false;
	            },
	            invalidHandler: function (form) {
	                $('.loading-btn').button('reset');
	            }
	        });

	        $.validator.addMethod("uniquerolename", function (value, element) {
	            return checkRoleName();
	        }, "角色名已存在");

	        $(".setbtn").change(function (obj) {
	            var group_name = $(this).data("id");
	            var that = this;
	            $('.li-' + group_name)
					.each(function () {
					    this.checked = that.checked;
					});
	        });

	        $(".indbtn").change(function (obj) {
	            var group_name = $(this).data("id");
	            var check_all = true;

	            $('.li-' + group_name).each(function () {
	                if (this.checked == false) {
	                    check_all = false;
	                }
	            });

	            $('.ul-' + group_name)
	            .each(function () {
	                this.checked = check_all;
	            });

	        });


	    });

	    function submitform() {	       
              $.ajax({
	            type: "POST",
	            url: rootUri + "Admin/SubmitRole",
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

	    function checkRoleName() {
	        var rolename = $("#rolename").val();
	        var retval = false;
	        var roleid = '<%=ViewData["uid"]%>';
	        if (roleid == '')
	            roleid = '0';	       
	        $.ajax({
	            async: false,
	            type: "GET",
	            url: rootUri + "Admin/CheckUniqueRolename",
	            dataType: "json",
	            data: {
	                rid: roleid,
	                rolename: rolename
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
</asp:Content>