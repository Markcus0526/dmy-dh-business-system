<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <table align="center" style="width: 1024px; font-size: 14px;">
        <tr>
            <td>
                <div class="page-content" style="margin-left: 0; margin-top: 20px;">
                    <!-- BEGIN PAGE HEADER-->
                    <div class="row">
                        <div class="col-md-12">
                            <h3 class="page-title">
                                我的订单 <a class="btn btn-white btn-default btn-round" onclick="window.history.go(-1)"
                                    style="float: right"><i class="ace-icon fa fa-undo bigger-110"></i>返回 </a>
                            </h3>
                        </div>
                    </div>
                    <!-- END PAGE HEADER-->
                    <div class="tabbable tabbable-custom tabbable-full-width">
                        <div class="tab-content">
                            <div class="tabbable">
                                <ul class="nav nav-tabs padding-16">
                                    <li class="active"><a data-toggle="tab" href="#status0"></i>已付款 </a></li>
                                    <li><a data-toggle="tab" href="#status1"></i>待付款 </a></li>
                                    <li><a data-toggle="tab" href="#status2"></i>我要退货 </a></li>
                                </ul>
                                <div class="tab-content profile-edit-tab-content">
                                    <div id="status0" class="tab-pane in active">
                                        <div class="bigmid">
                                            <table id="tbldata0" class="table table-striped table-bordered table-hover">
                                                <thead>
                                                    <tr>
                                                        <th style="min-width: 150px; width: 250px;">
                                                            产品图片
                                                        </th>
                                                        <th class="hidden-480" style="width: 150px;">
                                                            产品名称
                                                        </th>
                                                        <th>
                                                            产品内容
                                                        </th>
                                                        <th style="min-width: 80px; width: 150px;">
                                                            状态
                                                        </th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <div id="status1" class="tab-pane">
                                        <div class="bigmid">
                                            <table id="tbldata1" class="table table-striped table-bordered table-hover">
                                                <thead>
                                                    <tr>
                                                        <th style="min-width: 150px; width: 250px;">
                                                            产品图片
                                                        </th>
                                                        <th class="hidden-480" style="width: 150px;">
                                                            产品名称
                                                        </th>
                                                        <th>
                                                            产品内容
                                                        </th>
                                                        <th style="min-width: 80px; width: 150px;">
                                                            状态
                                                        </th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <div id="status2" class="tab-pane">
                                        <div class="bigmid">
                                            <table id="tbldata2" class="table table-striped table-bordered table-hover">
                                                <thead>
                                                    <tr>
                                                        <th style="min-width: 150px; width: 250px;">
                                                            产品图片
                                                        </th>
                                                        <th class="hidden-480" style="width: 150px;">
                                                            产品名称
                                                        </th>
                                                        <th>
                                                            产品内容
                                                        </th>
                                                        <th style="min-width: 80px; width: 150px;">
                                                            状态
                                                        </th>
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
            </td>
        </tr>
    </table>
    <div id="modal-eval" class="modal fade" tabindex="-1" data-width="512">
        <form class="form-horizontal" role="form" id="validation-form">
        <div class="modal-dialog" style="width: 400px">
            <div class="modal-content">
                <div class="modal-header">
                    <div>
                        <button type="button" class="close" data-dismiss="modal">
                            <span class="white">&times;</span>
                        </button>
                        <div style="text-align: center; font-size: 30px;">
                            评价
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="row" style="text-align: center; font-size: 18px;">
                        <div class="form-group">
                            <img id="modal_image" src="/Content/img/noimage.gif" width="300px" height="200px" />
                        </div>
                        <div class="form-group">
                            <span id="modal_catalogname">XXX</span>
                        </div>
                        <div class="form-group" align="center">
                            <div id="starrate" class="rating" style="margin-left: 70px; width: 100px; margin-top: 0;
                                margin-bottom: 0;">
                            </div>
                        </div>
                    </div>
                </div>
                <input type="hidden" id="modal_uid" name="uid" value="0" />
                <input type="hidden" id="modal_saleid" name="sale_id" value="0" />
                <input type="hidden" id="modal_catalogid" name="catalog_id" value="0" />
                <input type="hidden" id="modal_eval" name="eval" value="0" />
                <div class="modal-footer">
                    <button class="btn btn-info" data-dismiss="modal" onclick="submitform();">
                        确认
                    </button>
                    <button class="btn btn-default" data-dismiss="modal">
                        取消
                    </button>
                </div>
                <input type="hidden" id="dataid" value="" />
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
        </form>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageStyle" runat="server">
    <link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.min.css" />
    <link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/plugins/rating/rating.active.css">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%= ViewData["rootUri"] %>Content/js/jquery.dataTables.min.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/jquery.dataTables.bootstrap.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/bootbox.min.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.js"></script>
    <script type="text/javascript" src="<%= ViewData["rootUri"] %>Content/plugins/rating/jquery.rating.active.js"></script>
    <script type="text/javascript">

        var selected_id = "";
        var oTable0, oTable1, oTable2;
        jQuery(function ($) {
            oTable0 =
				$('#tbldata0')
				.dataTable({
				    "bServerSide": true,
				    "bProcessing": true,
				    "sAjaxSource": rootUri + "User/RetrieveSaleList?status=1",
				    "oLanguage": {
				        "sUrl": rootUri + "Content/i18n/dataTables.chinese.txt"
				    },
				    //bAutoWidth: false,
				    "aoColumns": [
					  { "bSortable": false },
					  null,
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
				                var rst = '';
				                if (o.aData[0] == null || (o.aData[0] + ''.length < 1))
				                    rst = '<img src="/Content/img/noimage.gif" width = "60" height="60"/>';
				                else
				                    rst = '<img src ="' + backendUri + o.aData[0] + '" width = "60" height="60">';
				                return rst;
				            },
				            sClass: 'center'
				        },
				        {
				            aTargets: [3],    // Column number which needs to be modified
				            fnRender: function (o, v) {   // o, v contains the object and value for the column
				                var rst = "";
				                if (parseInt(o.aData[3], 10) == 0)
				                    rst = '<a href="#modal-eval" data-toggle="modal" class="label label-success" onclick="evalCatalog(' + o.aData[4] + ',' + o.aData[5] + ');">待评价</a>';
				                else
				                    rst = '<a href="#modal-eval" data-toggle="modal" class="label label-info" onclick="evalCatalog(' + o.aData[4] + ',' + o.aData[5] + ');">已评价</a>';
                                    
				                return rst;
				            },
				            sClass: 'center'
				        }
                    ],
				    "fnDrawCallback": function (oSettings) {
				        //showBatchBtn();
				    }

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

            oTable1 =
				$('#tbldata1')
				.dataTable({
				    "bServerSide": true,
				    "bProcessing": true,
				    "sAjaxSource": rootUri + "User/RetrieveSaleList?status=0",
				    "oLanguage": {
				        "sUrl": rootUri + "Content/i18n/dataTables.chinese.txt"
				    },
				    //bAutoWidth: false,
				    "aoColumns": [
					  { "bSortable": false },
					  null,
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
				                var rst = '';
				                if (o.aData[0] == null || (o.aData[0] + ''.length < 1))
				                    rst = '<img src="/Content/img/noimage.gif" width = "60" height="60"/>';
				                else
				                    rst = '<img src ="' + backendUri + o.aData[0] + '" width = "60" height="60">';
				                return rst;
				            },
				            sClass: 'center'
				        },
				        {
				            aTargets: [3],    // Column number which needs to be modified
				            fnRender: function (o, v) {   // o, v contains the object and value for the column
				                //var rst = '<a href="' + rootUri + 'Goods/BuyGoods/' + o.aData[4] + '" class="label label-warning">去付款</a>';
				                var rst = '<span class="label label-warning">待付款</span>';
				                return rst;
				            },
				            sClass: 'center'
				        }
                    ],
				    "fnDrawCallback": function (oSettings) {
				        //showBatchBtn();
				    }

				});

            oTable2 =
				$('#tbldata2')
				.dataTable({
				    "bServerSide": true,
				    "bProcessing": true,
				    "sAjaxSource": rootUri + "User/RetrieveSaleList?status=2",
				    "oLanguage": {
				        "sUrl": rootUri + "Content/i18n/dataTables.chinese.txt"
				    },
				    //bAutoWidth: false,
				    "aoColumns": [
					  { "bSortable": false },
					  null,
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
				                var rst = '';
				                if (o.aData[0] == null || (o.aData[0] + ''.length < 1))
				                    rst = '<img src="/Content/img/noimage.gif" width = "60" height="60"/>';
				                else
				                    rst = '<img src ="' + backendUri + o.aData[0] + '" width = "60" height="60">';
				                return rst;
				            },
				            sClass: 'center'
				        },
				        {
				            aTargets: [3],    // Column number which needs to be modified
				            fnRender: function (o, v) {   // o, v contains the object and value for the column
				                var rst = '<a href="#" class="label label-danger" onclick="processDel(' + o.aData[5] + ');">去退货</a>';
				                return rst;
				            },
				            sClass: 'center'
				        }
                    ],
				    "fnDrawCallback": function (oSettings) {
				        //showBatchBtn();
				    }

				});

        });

        var type = 0;
        function refreshTable() {
            oSettings0 = oTable0.fnSettings();

            oTable0.dataTable().fnDraw();

            oSettings1 = oTable1.fnSettings();

            oTable1.dataTable().fnDraw();

            oSettings2 = oTable2.fnSettings();

            oTable2.dataTable().fnDraw();
        }
        function redirectToListPage(status) {
            if (status.indexOf("error") != -1) {
            } else {
                refreshTable();
            }
        }

        function evalCatalog(catalog_id, sale_id) {
            $("#modal_saleid").val(sale_id);
            $("#modal_catalogid").val(catalog_id);

            $.ajax({
                type: "GET",
                url: rootUri + "User/GetEvalInfo",
                dataType: 'json',
                data: {
                    uid: sale_id,
                    catalog_id: catalog_id
                },
                success: function (data) {
                    if (data != null) {
                        $("#modal_image").attr("src", backendUri + data.catalog_image);
                        $("#modal_catalogname").html(data.catalog_name);
                        var rate = parseInt(data.eval, 10);
                        $('.rating').html("");
                        $('.rating').rating('', { maxvalue: 5, curvalue: rate });

                        $("#modal_uid").val(data.uid);
                        $("#modal_eval").val(data.eval);
                    }
                }
            });

        }

        function submitform() {
            $("#modal_eval").val($('#validation-form').find(".star.on").length);

            $.ajax({
                type: "POST",
                url: rootUri + "User/SubmitEval",
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
                    message: "您确定要退货吗？",
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
                                    url: rootUri + "User/DeleteSale",
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
