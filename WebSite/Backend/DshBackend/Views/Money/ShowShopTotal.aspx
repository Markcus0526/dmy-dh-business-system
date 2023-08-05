<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="DshBackend.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <% var shopinfo = (tbl_shop)ViewData["shopinfo"]; %>
    <div class="page-header">
        <h1>
            商家收入情况 <small>
             </small><a class="btn btn-white btn-default btn-round" onclick="window.history.go(-1)"
                    style="float: right"><i class="ace-icon fa fa-times red2"></i>返回 </a>
        </h1>
    </div>

        <div class="widget-box" style="height:65px;padding-top:10px;">
			<table style="width:60%;margin-left:230px;">
				            <tr>
                                <td width="260px">
		                            <div id="date_range" class="btn white">
			                            <i class="fa fa-calendar"></i>
			                            &nbsp;<span></span>
			                            <b class="fa fa-angle-down"></b>
		                            </div>
                                </td>
					            <td width="80px">
						            <span class="btn btn-sm btn-info" onclick="getShopTotalMoney();" ><i class="fa fa-search"></i> 查询</span>
                                </td>   
                                <td>
                                        <label for="form-field-select-3">&nbsp;&nbsp;&nbsp;</label>
                                </td> 
			                </tr>
		                </table>
        </div>

    <div class="row">
        <div class="col-xs-12">
            <form class="form-horizontal" role="form" id="validation-form">
            <div class="space"></div>
            <div class="form-group">
				        <label class="col-sm-3 control-label no-padding-right" for="username">商家名称：</label>
				        <div class="col-sm-9">
                            <div class="clearfix">
					            <span id="Span1" class="bigger-150"><% if(shopinfo != null) { %><% =shopinfo.shopname %><% } %></span>
                            </div>
				        </div>
			        </div>
            <div class="form-group">
				        <label class="col-sm-3 control-label no-padding-right" for="username">商家总收入：</label>
				        <div class="col-sm-9">
                            <div class="clearfix">
					            <span id="total_money" class="bigger-150"><% =ViewData["total_money"] %></span>元
                            </div>
				        </div>
			        </div>
                    <div class="form-group">
				        <label class="col-sm-3 control-label no-padding-right" for="username">总补助金额：</label>
				        <div class="col-sm-9">
                            <div class="clearfix">
					            <span id="total_extra" class="bigger-150"><% =ViewData["total_extra"] %></span>元
                            </div>
				        </div>
			        </div>
            
            <input type="hidden" id="uid" name="uid" value="<% if (ViewData["uid"] != null) { %><%= ViewData["uid"] %><% } else { %>0<% } %>" />

            <div class="clearfix form-actions">
                <div class="col-md-offset-3 col-md-9">
                    <button class="btn btn-info loading-btn" type="button" data-loading-text="提交中..." onclick="window.history.go(-1)">
                        <i class="ace-icon fa fa-check bigger-110"></i>确认
                    </button>
                </div>
            </div>
            
            </form>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageStyle" runat="server">
    <link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.min.css" />
	<link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-daterangepicker/daterangepicker-bs3.css" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/jquery.validate.min.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/validate.messages_zh.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/ajaxupload.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-daterangepicker/moment.min.js" type="text/javascript"></script>
	<script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-daterangepicker/daterangepicker.js" type="text/javascript"></script> 
    <script type="text/javascript">

        var enddate = moment();
        var startdate = moment().subtract('days', enddate.date() - 1);

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

	        handleDateRangePickers();
	    });

	    function getShopTotalMoney() {
	        var shop_id = $("#uid").val();

	        $.ajax({
	            type: "GET",
	            url: rootUri + "Money/GetShopTotalMoney",
	            dataType: 'json',
	            data: {
	                shop_id: shop_id,
	                start: startdate.format('YYYY-MM-DD'),
	                end: enddate.format('YYYY-MM-DD')
	            },
	            success: function (data) {
	                if (data != null) {
	                    $("#total_money").html(data.total_money);
	                    $("#total_extra").html(data.total_extra);
	                }
	            }
	        });
	    }

		  var handleDateRangePickers = function () {
		      if (!jQuery().daterangepicker) {
		          return;
		      }

		      //	        enddate = parseInt('<% =ViewData["enddatereal"]%>', 10);
		      //	        startdate = parseInt('<% =ViewData["startdatereal"]%>', 10);

		      $('#date_range').daterangepicker({
		          opens: 'right',
		          startDate: startdate,
		          endDate: enddate,
		          minDate: '01/01/2012',
		          maxDate: '12/31/2020',
		          /*dateLimit: {
		          days: 60
		          },*/
		          showDropdowns: true,
		          showWeekNumbers: true,
		          timePicker: false,
		          timePickerIncrement: 1,
		          timePicker12Hour: true,
		          ranges: {
		              '今天': [moment(), moment()],
		              '昨天': [moment().subtract('days', 1), moment().subtract('days', 1)],
		              '最后7天': [moment().subtract('days', 6), moment()],
		              '最后30天': [moment().subtract('days', 29), moment()],
		              '本月': [moment().startOf('month'), moment().endOf('month')],
		              '上个月': [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]
		          },
		          buttonClasses: ['btn'],
		          applyClass: 'green',
		          cancelClass: 'default',
		          format: 'MM/DD/YYYY',
		          separator: ' to ',
		          locale: {
		              applyLabel: '确定',
		              cancelLabel: '取消',
		              fromLabel: '从',
		              toLabel: '到',
		              customRangeLabel: '自定义范围',
		              daysOfWeek: ['日', '一', '二', '三', '四', '五', '六'],
		              monthNames: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
		              firstDay: 1
		          }
		      },
                function (start, end) {
                    //console.log("Callback has been called!");
                    $('#date_range span').html(start.format('YYYY-MM-DD') + ' ~ ' + end.format('YYYY-MM-DD'));
                    startdate = start;
                    enddate = end;
                });
		      //Set the initial state of the picker label
		      $('#date_range span').html(startdate.format('YYYY-MM-DD') + ' ~ ' + enddate.format('YYYY-MM-DD'));
		  }

    </script>
</asp:Content>
