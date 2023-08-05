<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="DshBackend.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <% var saleinfo = (SaleInfo)ViewData["saleinfo"]; %>
    <div class="page-header">
        <h1>
            财务信息详细 <small>
             </small><a class="btn btn-white btn-default btn-round" onclick="window.history.go(-1)"
                    style="float: right"><i class="ace-icon fa fa-times red2"></i>返回 </a>
        </h1>
    </div>
    <div class="row">
        <div class="col-xs-12">
            <form class="form-horizontal" role="form" id="validation-form">
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="show">
                    商家名称：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <label>
                            <% if (saleinfo != null)
                               { %><%= saleinfo.shopname%><% } %>
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="show">
                    货品名称：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <label>
                            <% if (saleinfo != null)
                               { %><%= saleinfo.catalogname%><% } %>
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="show">
                    货品序号：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <label>
                            <% if (saleinfo != null)
                               { %><%= saleinfo.catalognum%><% } %>
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="show">
                    货品价格：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <label>
                            <% if (saleinfo != null)
                               { %><%= saleinfo.price%><% } %>元
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="show">
                    是否补贴：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <label>
                            <% if (saleinfo != null && saleinfo.type == 0)
                               { %>是<% }
                               else
                               { %>否<% } %>
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="show">
                    补贴金额：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <label>
                            <% if (saleinfo != null)
                               { %><%= saleinfo.extra%><% } %>
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="show">
                    购买日期：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <label>
                            <% if (saleinfo != null)
                               { %><%= String.Format("{0:yyyy-MM-dd HH:mm}", saleinfo.regtime)%><% } %>
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="show">
                    购买数量：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <label>
                            <% if (saleinfo != null)
                               { %><%= saleinfo.count%><% } %>
                        </label>
                    </div>
                </div>
            </div>
            
            <input type="hidden" id="uid" name="uid" value="<% if (ViewData["uid"] != null) { %><%= ViewData["uid"] %><% } else { %>0<% } %>" />

            <div class="clearfix form-actions">
                <div class="col-md-offset-3 col-md-9">
                    <button class="btn btn-info loading-btn" type="button" data-loading-text="提交中..." onclick="submitform()">
                        <i class="ace-icon fa fa-check bigger-110"></i>处理
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
    <script src="<%= ViewData["rootUri"] %>Content/js/ajaxupload.js"></script>
    <script type="text/javascript">
    
	    function redirectToListPage(status) {
	        if (status.indexOf("error") != -1) {
	            $('.loading-btn').button('reset');
	        } else {
	            window.location = rootUri + "Money/SaleList";
	        }
	    }        

	    jQuery(function ($) {
	        $('.loading-btn')
		      .click(function () {
		          var btn = $(this)
		          btn.button('loading')
		      });              
	    });

	    function submitform() {
	        var uid = $("#uid").val();
	        processDel(uid);
	    }

	    function processDel(sel_id) {
	        var selected_id = "";

	        if (sel_id != null && sel_id.length != "") {
	            selected_id = sel_id;
	        } else {
	            $(':checkbox:checked').each(function () {
	                if ($(this).attr('name') == 'selcheckbox')
	                    selected_id += $(this).attr('value') + ",";
	            });
	        }

	        if (selected_id != "") {
	            $.ajax({
	                url: rootUri + "Money/ProcessSale",
	                data: {
	                    "delids": selected_id
	                },
	                type: "post",
	                success: function (message) {
	                    if (message == true) {
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
	                        toastr["success"]("处理成功！", "恭喜您");
	                    }
	                }
	            });
	        }
	        else {
	            //
	        }
	        return false;
	    }

    </script>
</asp:Content>
