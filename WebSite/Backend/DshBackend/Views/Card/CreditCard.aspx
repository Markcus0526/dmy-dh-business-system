<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="page-header">
        <h1>     
            信用卡业务办理

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
            <div class="tabbable tabbable-custom tabbable-full-width">
                <div class="tab-content">
                    <div class="tabbable">
                        <ul class="nav nav-tabs padding-16">
                            <li class="active"><a data-toggle="tab" href="#status0">信用卡业务办理</a></li>
                            <li><a data-toggle="tab" href="#status1">添加信息内容</a></li>                            
                        </ul>
                        <div class="tab-content profile-edit-tab-content">
                            <div id="status0" class="tab-pane in active">
                                <div>
                                    <p>                                       
                                        <a class="btn btn-white btn-warning btn-bold" style="display:none;" id="btnbatchdel0" onclick="processDel0();">
                                            <i class="ace-icon fa fa-trash-o bigger-120 orange"></i>批量删除
                                        </a>
                                    </p>
		                        </div>
                                <div class="bigmid">
                                    <table id="tbldata0" class="table table-striped table-bordered table-hover">
                                        <thead>
                                            <tr>
                                                <th class="center" style="width:60px;">
							                        <label class="position-relative">
								                        <input type="checkbox" class="ace" />
								                        <span class="lbl"></span>
							                        </label>
						                        </th>
                                                <th style="min-width: 100px; width: 100px;">
                                                    序号
                                                </th>
                                                <th>日期时间</th>
                                                <th>持卡人姓名</th>
                                                <th>预留电话</th>
                                                <th>身份证号码</th>
                                                <th>详细地址</th>
                                                <th>留言</th>
                                                <th style="min-width:80px;width:150px;">操作</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div id="status1" class="tab-pane">
                                 <div>
                                    <p>
                                       <a class="btn btn-white btn-info btn-bold" href="<%= ViewData["rootUri"] %>Card/AddCreditCard">
	                                        <i class="ace-icon fa fa-plus bigger-120 blue"></i>添加信息
                                        </a>
                                        <a class="btn btn-white btn-warning btn-bold" style="display:none;" id="btnbatchdel1" onclick="processDel1();">
                                            <i class="ace-icon fa fa-trash-o bigger-120 orange"></i>批量删除
                                        </a>
                                    </p>
		                        </div>
                                <div class="bigmid">
                                    <table id="tbldata1" class="table table-striped table-bordered table-hover">
                                        <thead>
                                           <tr>
                                                <th class="center" style="max-width:60px;">
							                        <label class="position-relative">
								                        <input type="checkbox" class="ace" />
								                        <span class="lbl"></span>
							                        </label>
						                        </th>
                                                <th style="min-width: 100px; width: 100px;">
                                                    序号
                                                </th>
                                                <th>题目</th>
                                                <th>内容</th>
                                                <th>注册时间</th>                                                
                                                <th style="min-width:80px;max-width:150px;">操作</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>
                                    </table>
                                </div>
                            </div>                            
                        </div>
                    </div>
                </div>
            </div>
        </div> 

    </div>  
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageStyle" runat="server">
    <link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.min.css" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%= ViewData["rootUri"] %>Content/js/jquery.dataTables.min.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/jquery.dataTables.bootstrap.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/bootbox.min.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.js"></script>
    <script type="text/javascript">
        var selected_id = "";
        var oTable0, oTable1;
        jQuery(function ($) {
            oTable0 =
				$('#tbldata0')
				.dataTable({
				    "bServerSide": true,
				    "bProcessing": true,
				    "sAjaxSource": rootUri + "Card/RetrieveCreditCardInfoList",
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
								    '<input type="checkbox" value="' + o.aData[0] + '" name="selcheckbox" class="ace" onclick="showBatchBtn0()" />' +
								    '<span class="lbl"></span>' +
							        '</label>';
				            },
				            sClass: 'center'
				        },
				        {
				            aTargets: [8],    // Column number which needs to be modified
				            fnRender: function (o, v) {   // o, v contains the object and value for the column
				                var rst = '<a class="btn btn-xs btn-info" href="' + rootUri + 'Card/EditCreditCardInfo/' + o.aData[8] + '">' +
                                    '<i class="ace-icon fa fa-pencil bigger-120"></i>' +
                                    '</a>&nbsp;&nbsp;';
				                rst += '<a class="btn btn-xs btn-danger" onclick="processDel0(' + o.aData[8] + ')">' +
                                    '<i class="ace-icon fa fa-trash-o bigger-120"></i>' +
                                    '</a>';
				                return rst;
				            },
				            sClass: 'center'
				        }
                    ],
				    "fnDrawCallback": function (oSettings) {
				        showBatchBtn0();
				    }

				});

				oTable1 =
				$('#tbldata1')
				.dataTable({
				    "bServerSide": true,
				    "bProcessing": true,
				    "sAjaxSource": rootUri + "Card/RetrieveCreditCardDataist",
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
								    '<input type="checkbox" value="' + o.aData[0] + '" name="selcheckbox" class="ace" onclick="showBatchBtn1()" />' +
								    '<span class="lbl"></span>' +
							        '</label>';
				            },
				            sClass: 'center'
				        },
				        {
				            aTargets: [5],    // Column number which needs to be modified
				            fnRender: function (o, v) {   // o, v contains the object and value for the column
				                var rst = '<a class="btn btn-xs btn-info" href="' + rootUri + 'Card/EditCreditCard/' + o.aData[5] + '">' +
                                    '<i class="ace-icon fa fa-pencil bigger-120"></i>' +
                                    '</a>&nbsp;&nbsp;';
				                rst += '<a class="btn btn-xs btn-danger" onclick="processDel1(' + o.aData[5] + ')">' +
                                    '<i class="ace-icon fa fa-trash-o bigger-120"></i>' +
                                    '</a>';
				                return rst;
				            },
				            sClass: 'center'
				        }
                    ],
				    "fnDrawCallback": function (oSettings) {
				        showBatchBtn1();
				    }

				});

				$(document).on('click', '#tbldata0 thead th input:checkbox', function () {
                var that = this;
                $(this).closest('table').find('tr > td:first-child input:checkbox')
					.each(function () {
					    this.checked = that.checked;
					    $(this).closest('tr').toggleClass('selected');
					});

                showBatchBtn0();
            });

            $(document).on('click', '#tbldata1 thead th input:checkbox', function () {
                var that = this;
                $(this).closest('table').find('tr > td:first-child input:checkbox')
					.each(function () {
					    this.checked = that.checked;
					    $(this).closest('tr').toggleClass('selected');
					});

                showBatchBtn1();
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

        function showBatchBtn0() {
            selected_id = "";

            $(':checkbox:checked').each(function () {
                if ($(this).attr('name') == 'selcheckbox')
                    selected_id += $(this).attr('value') + ",";
            });

            if (selected_id != "") {
                $("#btnbatchdel0").show();
                //$("#btnbatchdel").css("display", "normal");
            } else {
                $("#btnbatchdel0").hide();
                //$("#btnbatchdel").css("display", "none");
            }
        }

        function showBatchBtn1() {
            selected_id = "";

            $(':checkbox:checked').each(function () {
                if ($(this).attr('name') == 'selcheckbox')
                    selected_id += $(this).attr('value') + ",";
            });

            if (selected_id != "") {
                $("#btnbatchdel1").show();
                //$("#btnbatchdel").css("display", "normal");
            } else {
                $("#btnbatchdel1").hide();
                //$("#btnbatchdel").css("display", "none");
            }
        }

        function refreshTable() {
            oSettings0 = oTable0.fnSettings();

            oTable0.dataTable().fnDraw();

            oSettings1 = oTable1.fnSettings();

            oTable1.dataTable().fnDraw();
        }
        function redirectToListPage(status) {
            if (status.indexOf("error") != -1) {
            } else {
                refreshTable();
            }
        }

        function processDel0(sel_id) {
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
                    message: "您确定要删除吗？",
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
                                    url: rootUri + "Card/DeleteCardInfo",
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

        function processDel1(sel_id) {
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
                    message: "您确定要删除吗？",
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
                                    url: rootUri + "Card/DeleteCard",
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
    </script>
</asp:Content>
