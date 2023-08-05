<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="DshBackend.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<div class="page-header">
	<h1>
		特惠商品管理
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
		<div>
            <p>
                <a class="btn btn-white btn-info btn-bold" href="<%= ViewData["rootUri"] %>Catalog/AddExtraCatalog">
	                <i class="ace-icon fa fa-plus bigger-120 blue"></i>添加新商品
                </a>
                <a class="btn btn-white btn-warning btn-bold" style="display:none;" id="btnbatchdel" onclick="processDel();">
                    <i class="ace-icon fa fa-trash-o bigger-120 orange"></i>批量删除
                </a>
            </p>
		</div>

        <div class="widget-box" style="height:55px;padding-top:10px;">

			<table style="width:100%;">
				<tr>
                    <td width="100px" align="right">
                            <label for="form-field-select-3">搜索选择:&nbsp;&nbsp;&nbsp;</label>
                    </td>
                    <td width="260px">
						    <select class="select2" id="kindlist" data-placeholder="Click to Choose..." onchange="refreshTable()">
                                <option value="0">全部</option>
                                <% 
                                    List<tbl_kind> kindlist = (List<tbl_kind>)ViewData["kindlist"];
                                    if (kindlist != null)
                                    {
                                        for (int i = 0; i < kindlist.Count(); i++)
                                        {
                                            tbl_kind item = kindlist.ElementAt(i);
                                            %>
                                            <option value="<% =item.uid %>"><% =item.name %></option>
                                            <%
                                        }
                                    }
                                %>
				            </select>
                    </td>
                    <td>
                            <label for="form-field-select-3">&nbsp;&nbsp;&nbsp;</label>
                    </td>
                    <%--<td width="220px">
						    <input type="text" id="search" placeholder="请输入关键字搜索" class="input-large form-control" />
                    </td>
					<td width="80px">
						<span class="btn btn-sm btn-info" onclick="search_data();" ><i class="fa fa-search"></i> 搜索</span>
                    </td>
                    <td align="right">    
                        <a class="btn btn-white btn-info btn-bold" href="<%= ViewData["rootUri"] %>Catalog/AddExtraCatalog">
	                        <i class="ace-icon fa fa-plus bigger-120 blue"></i>添加新商品
                        </a>
                        <a class="btn btn-white btn-warning btn-bold" style="display:none;" id="btnbatchdel" onclick="processDel();">
                            <i class="ace-icon fa fa-trash-o bigger-120 orange"></i>批量删除
                        </a>
					</td>--%>       
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
						<th>商品图片</th>
						<th>商户名称</th>
						<th>特惠商品名称</th>
						<th>货号</th>
						<th>商品价格</th>
						<th>商户应付金额</th>
						<th>特惠补贴价格</th>
						<th>上架</th>
						<th>评论次数</th>
						<th style="min-width:80px;width:150px;">操作</th>
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
	<link rel="stylesheet" href="<%= ViewData["rootUri"] %>Content/css/select2.css" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" runat="server">
	<script src="<%= ViewData["rootUri"] %>Content/js/jquery.dataTables.min.js"></script>
	<script src="<%= ViewData["rootUri"] %>Content/js/jquery.dataTables.bootstrap.js"></script>
	<script src="<%= ViewData["rootUri"] %>Content/js/bootbox.min.js"></script>
	<script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.js"></script>  
	<script src="<%= ViewData["rootUri"] %>Content/js/select2.min.js"></script>
	<script src="<%= ViewData["rootUri"] %>Content/js/jquery.validate.min.js"></script>
	<script src="<%= ViewData["rootUri"] %>Content/js/validate.messages_zh.js"></script>
		<script type="text/javascript">
		    var selected_id = "";
		    var oTable;
		    jQuery(function ($) {
		        oTable =
				$('#tbldata')
				.dataTable({
				    "bServerSide": true,
				    "bProcessing": true,
				    "sAjaxSource": rootUri + "Catalog/RetrieveCatalogList?type=0",
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
				            aTargets: [1],    // Column number which needs to be modified
				            fnRender: function (o, v) {   // o, v contains the object and value for the column
				                var rst = '';
				                if (o.aData[1] == null || (o.aData[1] + ''.length < 1))
				                    rst = '<img src="/Content/img/noimage.gif" width = "60" height="60"/>';
				                else
				                    rst = '<img src ="' + rootUri + o.aData[1] + '" width = "60" height="60">';
				                return rst;
				            },
				            sClass: 'center'
				        },
				        {
				            aTargets: [8],    // Column number which needs to be modified
				            fnRender: function (o, v) {   // o, v contains the object and value for the column
				                var rst = "";
				                if (parseInt(o.aData[8], 10) == 1)
				                    rst = '<img src="/Content/img/check_yes.gif" width = "25" height="25"/>';
				                else
				                    rst = '<img src="/Content/img/check_no.gif" width = "25" height="25"/>';
				                return rst;

				            },
				            sClass: 'center'
				        },
				        {
				            aTargets: [10],    // Column number which needs to be modified
				            fnRender: function (o, v) {   // o, v contains the object and value for the column
				                var rst = '<a class="btn btn-xs btn-info" href="' + rootUri + 'Catalog/EditExtraCatalog/' + o.aData[10] + '">' +
                                    '<i class="ace-icon fa fa-pencil bigger-120"></i>' +
                                    '</a>&nbsp;&nbsp;';
				                rst += '<a class="btn btn-xs btn-danger" onclick="processDel(' + o.aData[10] + ')">' +
                                    '<i class="ace-icon fa fa-trash-o bigger-120"></i>' +
                                    '</a>';
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
		        var kind_id = $("#kindlist").val();

		        oSettings = oTable.fnSettings();
		        oSettings.sAjaxSource = rootUri + "Catalog/RetrieveCatalogList?type=0" + "&kindid=" + kind_id;

		        oTable.dataTable().fnDraw();
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
		                                url: rootUri + "Catalog/DeleteCatalog",
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
