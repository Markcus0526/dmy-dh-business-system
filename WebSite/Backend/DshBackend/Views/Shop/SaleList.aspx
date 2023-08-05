<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="DshBackend.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<div class="page-header">
	<h1>
		我的财务查看
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
		<%--<div>
            <p>
                <a class="btn btn-white btn-info btn-bold" href="#">
	                <i class="ace-icon fa fa-plus bigger-120 blue"></i>导出EXCEL
                </a>
                <a class="btn btn-white btn-warning btn-bold" style="display:none;" id="btnbatchdel" onclick="processDel();">
                    <i class="ace-icon fa fa-trash-o bigger-120 orange"></i>批量处理
                </a>
            </p>
		</div>--%>

        <div class="widget-box" style="height:65px;padding-top:10px;">

			<table style="width:100%;">
				<tr>                    
                    <td width="100px" align="right">
                        <label for="form-field-select-3">时间范围:&nbsp;&nbsp;&nbsp;</label>
                    </td>
                    <td width="260px">
		                <div id="date_range" class="btn white">
			                <i class="fa fa-calendar"></i>
			                &nbsp;<span><%--<% =ViewData["startdate"] %>~<% =ViewData["enddate"] %>--%></span>
			                <b class="fa fa-angle-down"></b>
		                </div>
                    </td>
					<td width="80px">
						<span class="btn btn-sm btn-info" onclick="refreshTable();" ><i class="fa fa-search"></i> 搜索</span>
                    </td>   
                    <td>
                            <label for="form-field-select-3">&nbsp;&nbsp;&nbsp;</label>
                    </td> 
			    </tr>
		    </table>
        </div>

		<div>
			<table id="tbldata" class="table table-striped table-bordered table-hover">
				<thead>
					<tr>
						<th class="center" style="width:60px;">
							<label class="position-relative">
								<input type="checkbox" class="ace" />
								<span class="lbl"></span>
							</label>
						</th>
						<th>商品名称</th>
						<th>商品类型</th>
						<th>购买时间</th>
						<th>客户名称</th>
						<th>金额</th>
						<th>是否补贴</th>
						<th>补贴金额</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
        <div class="bigger-180">
        <table style="width:100%;">
				<tr>                
                    <td style="width:50%;">
                        <label >&nbsp;&nbsp;&nbsp;</label>
                    </td> 
                    <td width="100px" align="right">
                        <label >总收入：&nbsp;&nbsp;&nbsp;</label>
                    </td>
                    <td width="260px">						
                        <span><span id="total_money"><% =ViewData["total_money"] %></span>元</span>
                    </td>
                    <td width="100px" align="right">
                        <label >总补助：&nbsp;&nbsp;&nbsp;</label>
                    </td>
                    <td width="260px">
                        <span><span id="total_extra"><% =ViewData["total_extra"] %></span>元</span>
                    </td>    
			    </tr>
		    </table>
        </div>
	</div>
</div>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageStyle" runat="server">
	<link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.min.css" />
	<link rel="stylesheet" href="<%= ViewData["rootUri"] %>Content/css/select2.css" />
	<link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-daterangepicker/daterangepicker-bs3.css" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" runat="server">
	<script src="<%= ViewData["rootUri"] %>Content/js/jquery.dataTables.min.js"></script>
	<script src="<%= ViewData["rootUri"] %>Content/js/jquery.dataTables.bootstrap.js"></script>
	<script src="<%= ViewData["rootUri"] %>Content/js/bootbox.min.js"></script>
	<script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.js"></script>  
	<script src="<%= ViewData["rootUri"] %>Content/js/select2.min.js"></script>
	<script src="<%= ViewData["rootUri"] %>Content/js/jquery.validate.min.js"></script>
	<script src="<%= ViewData["rootUri"] %>Content/js/validate.messages_zh.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-daterangepicker/moment.min.js" type="text/javascript"></script>
	<script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-daterangepicker/daterangepicker.js" type="text/javascript"></script> 
		<script type="text/javascript">

		    var enddate = moment();
		    var startdate = moment().subtract('days', enddate.date()-1);

		    var selected_id = "";
		    var oTable;
		    jQuery(function ($) {
		        oTable =
				$('#tbldata')
				.dataTable({
				    "bServerSide": true,
				    "bProcessing": true,
				    "sAjaxSource": rootUri + "Shop/RetrieveSaleList",
				    "oLanguage": {
				        "sUrl": rootUri + "Content/i18n/dataTables.chinese.txt"
				    },
				    //bAutoWidth: false,
				    "aoColumns": [
					  { "bSortable": false },
					  null,
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
				            aTargets: [0],    // Column number which needs to be modified
				            fnRender: function (o, v) {   // o, v contains the object and value for the column
				                return '<label class="position-relative">' +
								    '<input type="checkbox" value="' + o.aData[0] + '" name="selcheckbox" class="ace" onclick="showBatchBtn()" />' +
								    '<span class="lbl"></span>' +
							        '</label>';
				            },
				            sClass: 'center'
				        },
				        {
				            aTargets: [6],    // Column number which needs to be modified
				            fnRender: function (o, v) {   // o, v contains the object and value for the column
				                var rst = '';
				                if (parseInt(o.aData[6], 10) == 0)
				                    rst = '<span class="label label-info">是</span>';
				                else
				                    rst = '<span class="label label-warning">否</span>';
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

		        $(".select2").css('width', '250px').select2({ allowClear: true })

		        handleDateRangePickers();
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
		        oSettings.sAjaxSource = rootUri + "Shop/RetrieveSaleList?start=" + startdate.format('YYYY-MM-DD') + "&end=" + enddate.format('YYYY-MM-DD');

		        oTable.dataTable().fnDraw();

		        getTotalMoney();
		    }
		    function redirectToListPage(status) {
		        if (status.indexOf("error") != -1) {
		        } else {
		            refreshTable();
		        }
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
		            bootbox.dialog({
		                message: "您确定要处理吗？",
		                buttons: {
		                    danger: {
		                        label: "取消",
		                        className: "btn-danger",
		                        callback: function () {
		                            return true;
		                        }
		                    },
		                    main: {
		                        label: "确定",
		                        className: "btn-primary",
		                        callback: function () {
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
		                                        toastr["success"]("批量删除成功！", "恭喜您");
		                                    }
		                                }
		                            });
		                        }
		                    }
		                }
		            });
		        }
		        else {
		            //
		        }
		        return false;
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
                }

            );
		        //Set the initial state of the picker label
		        $('#date_range span').html(startdate.format('YYYY-MM-DD') + ' ~ ' + enddate.format('YYYY-MM-DD'));

		    }

		    function getTotalMoney() {
		        $.ajax({
		            type: "GET",
		            url: rootUri + "Shop/GetTotalMoney",
		            dataType: 'json',
		            data: {
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


        </script>
</asp:Content>
