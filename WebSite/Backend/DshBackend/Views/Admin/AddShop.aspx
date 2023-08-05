<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="DshBackend.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<% var shopinfo = (tbl_shop)ViewData["shopinfo"]; %>
<div class="page-header">
	<h1>
		商户
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
            商户
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
				<label class="col-sm-3 control-label no-padding-right" for="username">商户帐号：</label>
				<div class="col-sm-9">
                    <div class="clearfix">
					<input type="text" id="shopid" name="shopid" placeholder="请输入商户帐号" class="input-large form-control" <% if (shopinfo != null) { %>value="<%= shopinfo.shopid %>"<% } %> />
                    </div>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="userpwd">商户密码：</label>
				<div class="col-sm-9">
                    <div class="clearfix">
					<input type="password" id="password" name="password" placeholder="请输入商户密码" class="input-large form-control" <% if (shopinfo != null) { %>value="<%= shopinfo.password %>"<% } %> />
                    </div>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="confirmpwd">确认密码：</label>
				<div class="col-sm-9">
                    <div class="clearfix">
					<input type="password" id="confirmpwd" name="confirmpwd" placeholder="请输入确认密码" class="input-large form-control" <% if (shopinfo != null) { %>value="<%= shopinfo.password %>"<% } %> />
                    </div>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="confirmpwd">所在城市：</label>
				<div class="col-sm-9">
                    <div class="clearfix" style="margin-bottom:10px;">
                        <select class="col-xs-10 col-sm-2" id="province" name="province" onchange="ChangeProvince();">
						    <% 
                                List<tbl_ecsregion> provinces = (List<tbl_ecsregion>)ViewData["provinces"];
                                if (provinces != null)
                                {
                                    for (int i = 0; i < provinces.Count; i++)
                                    {
                                        tbl_ecsregion item = provinces.ElementAt(i);
                                        if (ViewData["shopprovince"] != null && item.uid == (long)ViewData["shopprovince"])
                                        {
                                        %>
                                        <option value="<% =item.uid %>" selected><% =item.regionname%></option>
                                        <%
                                        }
                                        else
                                        {
                                        %>
                                        <option value="<% =item.uid %>"><% =item.regionname%></option>
                                        <%
                                        }
                                    }
                                }
                            %>
					    </select>
                        <span style="float:left;">&nbsp;&nbsp;</span>
                        <select class="col-xs-10 col-sm-2" id="city" name="city" onchange="ChangeCity();">
						    <% 
                                List<tbl_ecsregion> cities = (List<tbl_ecsregion>)ViewData["cities"];
                                if (cities != null)
                                {
                                    for (int i = 0; i < cities.Count; i++)
                                    {
                                        tbl_ecsregion item = cities.ElementAt(i);
                                        if (ViewData["shopcity"] != null && item.uid == (long)ViewData["shopcity"])
                                        {
                                        %>
                                        <option value="<% =item.uid %>" selected><% =item.regionname %></option>
                                        <%
                                        } else {
                                        %>
                                        <option value="<% =item.uid %>"><% =item.regionname %></option>
                                        <%
                                        }
                                    }
                                }
                            %>
					    </select>
                        <span style="float:left;">&nbsp;&nbsp;</span>
                        <select class="col-xs-10 col-sm-2" id="district" name="district">
                            <% 
                                List<tbl_ecsregion> districts = (List<tbl_ecsregion>)ViewData["districts"];
                                if (districts != null)
                                {
                                    for (int i = 0; i < districts.Count; i++)
                                    {
                                        tbl_ecsregion item = districts.ElementAt(i);
                                        if (shopinfo != null && item.uid == shopinfo.regionid)
                                        {
                                        %>
                                        <option value="<% =item.uid %>" selected><% =item.regionname %></option>
                                        <%
                                        } else {
                                        %>
                                        <option value="<% =item.uid %>"><% =item.regionname %></option>
                                        <%
                                        }
                                    }
                                }
                            %>
					    </select>
                    </div>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="username">商家名称：</label>
				<div class="col-sm-9">
                    <div class="clearfix">
					<input type="text" id="shopname" name="shopname" placeholder="请输入商家名称" class="input-large form-control" <% if (shopinfo != null) { %>value="<%= shopinfo.shopname %>"<% } %> />
                    </div>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="username">商家地址：</label>
				<div class="col-sm-9">
                    <div class="clearfix">
					<input type="text" id="addr" name="addr" placeholder="请输入商家地址" class="input-large form-control" <% if (shopinfo != null) { %>value="<%= shopinfo.addr %>"<% } %> />
                    </div>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="username">商家电话：</label>
				<div class="col-sm-9">
                    <div class="clearfix">
					<input type="text" id="phonenum" name="phonenum" placeholder="请输入商家电话" class="input-large form-control" <% if (shopinfo != null) { %>value="<%= shopinfo.phonenum %>"<% } %> />
                    </div>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="username">开户行：</label>
				<div class="col-sm-9">
                    <div class="clearfix">
					<input type="text" id="bank" name="bank" placeholder="请输入开户行" class="input-large form-control" <% if (shopinfo != null) { %>value="<%= shopinfo.bank %>"<% } %> />
                    </div>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="username">账户名称：</label>
				<div class="col-sm-9">
                    <div class="clearfix">
					<input type="text" id="counterid" name="counterid" placeholder="请输入账户名称" class="input-large form-control" <% if (shopinfo != null) { %>value="<%= shopinfo.counterid %>"<% } %> />
                    </div>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="username">银行帐号：</label>
				<div class="col-sm-9">
                    <div class="clearfix">
					<input type="text" id="bankid" name="bankid" placeholder="请输入银行帐号" class="input-large form-control" <% if (shopinfo != null) { %>value="<%= shopinfo.bankid %>"<% } %> />
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
	            window.location = rootUri + "Admin/ShopList";
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
	        function validphonenum(value) {
	            //return /^[0-9]\-[0-9]+$/.test(value);
	            return /^[0-9]+[\-]*[0-9]+$/.test(value);
	        }
	        function checkTel() {
	            var isPhone = /^([0-9]{3,4}-)?[0-9]{7,8}$/;
	            var isMob = /^[0-9]{11}$/;
	            var value = document.getElementById("phonenum").value.trim();
	            var bFlag = isMob.test(value);
	            bFlag = isPhone.test(value);
	            if (isMob.test(value) || isPhone.test(value))
	                return true;
	            else
	                return false;
	        }
	        $('#validation-form').validate({
	            errorElement: 'span',
	            errorClass: 'help-block',
	            //focusInvalid: false,
	            rules: {
	                shopid: {
	                    required: true,
	                    uniqueshopname: true
	                },
	                password: {
	                    minlength: 6,
	                    required: true
	                },
	                confirmpwd: {
	                    equalTo: "#password",
	                    required: true
	                },
	                shopname: {
	                    required: true
	                },
	                addr: {
	                    required: true
	                },
	                phonenum: {
	                    required: true,
	                    //minlength: 8,
	                    //maxlength: 14,
	                    isvalidphonenum: true
	                },
	                bank: {
	                    required: true
	                },
	                counterid: {
	                    required: true
	                },
	                bankid: {
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
	        $.validator.addMethod("uniqueshopname", function (value, element) {
	            return checkShopName();
	        }, "商户名已存在");

	        $.validator.addMethod("isvalidphonenum", function (value, element) {
	            return checkTel();
	        }, "电话号码格式不正确");
	    });	    
	    function submitform() {
	        $.ajax({
	            type: "POST",
	            url: rootUri + "Admin/SubmitShop",
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

	    function checkShopName() {
	        var shopname = $("#shopid").val();
	        var retval = false;
	        var rid = $("#uid").val();

	        $.ajax({
	            async: false,
	            type: "GET",
	            url: rootUri + "Admin/CheckUniqueShopname",
	            dataType: "json",
	            data: {
	                shopname: shopname,
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

	    function ChangeProvince() {
	        var provin = $("#province").val();
	        $.ajax({
	            async: false,
	            type: "GET",
	            url: rootUri + "Region/GetCityListFull",
	            dataType: "json",
	            data: {
	                provin: provin
	            },
	            success: function (data) {
	                if (data != null) {
	                    var cities = [];
	                    cities = data.city;
	                    var htmlStr = "";
	                    for (var i = 0; i < cities.length; i++) {
	                        htmlStr += '<option value="' + cities[i].uid + '">' + cities[i].regionname + '</option>';
	                    }
	                    $("#city").html(htmlStr);
	                    //ChangeCity();
	                } else {
	                    $("#city").html("");
	                    $("#district").html("");
	                }
	            }
	        });
	        ChangeCity();
	    }

	    function ChangeCity() {
	        var city = $("#city").val();
	        $.ajax({
	            async: false,
	            type: "GET",
	            url: rootUri + "Region/GetDistrictListFull",
	            dataType: "json",
	            data: {
	                city: city
	            },
	            success: function (data) {
	                if (data != null) {
	                    var districts = [];
	                    districts = data.district;
	                    var htmlStr = "";
	                    for (var i = 0; i < districts.length; i++) {
	                        htmlStr += '<option value="' + districts[i].uid + '">' + districts[i].regionname + '</option>';
	                    }
	                    $("#district").html(htmlStr);
	                } else {
	                    $("#district").html("");
	                }
	            }
	        });
	    }

    </script>
</asp:Content>