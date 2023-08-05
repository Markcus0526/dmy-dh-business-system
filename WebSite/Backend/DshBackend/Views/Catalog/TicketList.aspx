<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<div class="page-header">
	<h1>
		订单查询
		<%--<small>
			<i class="ace-icon fa fa-angle-double-right"></i>
			通过管理员设置，您可以进行编辑管理员资料、权限、密码以及删除管理员等操作。
		</small>--%>
	</h1>
</div>
<div class="row">
	<div class="col-xs-12">
        <%--<p class="alert alert-info">
	        <i class="ace-icon fa fa-exclamation-triangle"></i>
            修改管理员权限后 需管理员重新登录后生效
        </p>--%>
		
        <div style="margin-bottom:10px;">
           <span>时间范围：</span>
		        <div id="date_range" class="btn white">
			        <i class="fa fa-calendar"></i>
			        &nbsp;<span><%--<% =ViewData["startdate"] %>~<% =ViewData["enddate"] %>--%></span>
			        <b class="fa fa-angle-down"></b>
		        </div>
         </div>
		<div>
        
			<table id="tbldata" class="table table-striped table-bordered table-hover">
				<thead>
					<tr>						
						<th style="min-width:150px;width:250px;">团购码</th>
						<th class="hidden-480" style="width:150px;">姓名</th>
						<th>联系方式</th>
                        <th>日期时间</th>
                        <th>团购商品</th>
						<th>团购商家</th>
						<th>详情</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
	</div>
</div>


</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageStyle" runat="server">
    <link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.min.css" />
	<link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-daterangepicker/daterangepicker-bs3.css" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" runat="server">
<script src="<%= ViewData["rootUri"] %>Content/js/jquery.dataTables.min.js"></script>
	<script src="<%= ViewData["rootUri"] %>Content/js/jquery.dataTables.bootstrap.js"></script>
	<script src="<%= ViewData["rootUri"] %>Content/js/bootbox.min.js"></script>
	<script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.js"></script>  
    <script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-daterangepicker/moment.min.js" type="text/javascript"></script>
	<script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-daterangepicker/daterangepicker.js" type="text/javascript"></script> 
  
		<script type="text/javascript">
		    var selected_id = "";
		    var oTable;
		    var enddate = moment();
		    var startdate = moment().subtract('days', enddate.date()-1);
		    jQuery(function ($) {
		        handleDateRangePickers();
		        oTable =
				$('#tbldata')
				.dataTable({
				    "bServerSide": true,
				    "bProcessing": true,
				    "sAjaxSource": rootUri + "Catalog/RetrieveTicketList?startdate=" + startdate.format("YYYY-MM-DD") + "&enddate=" + enddate.format("YYYY-MM-DD"),
				    "oLanguage": {
				        "sUrl": rootUri + "Content/i18n/dataTables.chinese.txt"
				    },
				    //bAutoWidth: false,
				    "aoColumns": [
					  { "bSortable": false },
					  { "bSortable": false },
					  { "bSortable": false },
					  { "bSortable": false },
                      { "bSortable": false },
                      { "bSortable": false },
					  { "bSortable": false }
					],
				    "aLengthMenu": [
                        [10, 20, 50, -1],
                        [10, 20, 50, "All"] // change per page values here
                    ],
				    "iDisplayLength": 10,
				    "aoColumnDefs": [
                    {
				        aTargets: [6],    // Column number which needs to be modified
				        fnRender: function (o, v) {   // o, v contains the object and value for the column
				            var rst = '<a class="btn btn-xs btn-info" href="' + rootUri + 'Catalog/OderDetail/' + o.aData[6] + '">' +
                                    '<i class="ace-icon fa fa-search  bigger-120"></i>' +
                                    '</a>&nbsp;&nbsp;';
				            return rst;
				        },
				        sClass: 'center'
				    }
                    ],
				    "fnDrawCallback": function (oSettings) {
				        showBatchBtn();
				    }

				});

		        $(document).on('click', 'th input:checkbox', function () {
		            var that = this;
		            $(this).closest('table').find('tr > td:first-child input:checkbox')
					.each(function () {
					    this.checked = that.checked;
					    $(this).closest('tr').toggleClass('selected');
					});

		            showBatchBtn();
		        });

		        $('[data-rel="tooltip"]').tooltip({ placement: tooltip_placement });
		        function tooltip_placement(context, source) {
		            var $source = $(source);
		            var $parent = $source.closest('table')
		            var off1 = $parent.offset();
		            var w1 = $parent.width();

		            var off2 = $source.offset();
		            //var w2 = $source.width();

		            if (parseInt(off2.left) < parseInt(off1.left) + parseInt(w1 / 2)) return 'right';
		            return 'left';
		        }

		    });

		    function showBatchBtn() {
		        selected_id = "";

		        $(':checkbox:checked').each(function () {
		            if ($(this).attr('name') == 'selcheckbox')
		                selected_id += $(this).attr('value') + ",";
		        });

		        if (selected_id != "") {
		            $("#btnbatchdel").show();
		            //$("#btnbatchdel").css("display", "normal");
		        } else {
		            $("#btnbatchdel").hide();
		            //$("#btnbatchdel").css("display", "none");
		        }
		    }

		    function refreshTable() {		        
		        oSettings = oTable.fnSettings();		        
		        oTable.dataTable().fnDraw();
		    }

		    function redirectToListPage(status) {
		        if (status.indexOf("error") != -1) {
		        } else {
		            refreshTable();
		        }
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
                    search_data(start.format("YYYY-MM-DD"), end.format("YYYY-MM-DD"));
                }

            );
		        //Set the initial state of the picker label
		        $('#date_range span').html(startdate.format('YYYY-MM-DD') + ' ~ ' + enddate.format('YYYY-MM-DD'));

		    }

		    function search_data(start,end) {
		       
		        oSettings = oTable.fnSettings();
		        oSettings.sAjaxSource = rootUri + "Catalog/RetrieveTicketList?startdate=" + start + "&enddate=" + end;

		        oTable.dataTable().fnDraw();
		    }
		    
        </script>
</asp:Content>
