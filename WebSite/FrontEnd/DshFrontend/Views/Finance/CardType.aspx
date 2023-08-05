<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <table align="center" style="width: 1024px; font-size: 14px; margin-bottom:80px;">
        <tr>
            <td>
                <div class="page-content" style="margin-left: 0; margin-top: 20px;">
                    <!-- BEGIN PAGE HEADER-->
                    <div class="row">
                        <div class="col-md-12">
                            <h3 class="page-title">
                            <%  if ( int.Parse(ViewData["cardtype"].ToString()) == 0 )
                               { %>银行卡受理<% }
                                else if (int.Parse(ViewData["cardtype"].ToString()) == 1)
                               { %>信用卡办理<% }
                                else if (int.Parse(ViewData["cardtype"].ToString()) == 2)
                               { %>保险业务<% }
                                else if (int.Parse(ViewData["cardtype"].ToString()) == 3)
                               { %>理财产品<% }
                                else if (int.Parse(ViewData["cardtype"].ToString()) == 4)
                               { %>小额贷款<% } %>
                               <a class="btn btn-white btn-default btn-round" onclick="window.history.go(-1)" style="float:right">
		                            <i class="ace-icon fa fa-undo bigger-110"></i>
		                            返回
	                            </a>
                            </h3>
                        </div>
                    </div>
                    <!-- END PAGE HEADER-->
                    <div class="bigmid">
                        <table id="tbldata0" class="table table-striped table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th style="min-width: 100px; width: 100px;">
                                        排序
                                    </th>
                                    <th class="hidden-480" style="width: 350px;">
                                        <%  if ( int.Parse(ViewData["cardtype"].ToString()) == 0 )
                                           { %>银行卡信息<% }
                                            else if (int.Parse(ViewData["cardtype"].ToString()) == 1)
                                           { %>信用卡信息<% }
                                            else if (int.Parse(ViewData["cardtype"].ToString()) == 2)
                                           { %>保险业务信息<% }
                                            else if (int.Parse(ViewData["cardtype"].ToString()) == 3)
                                           { %>理财产品信息<% }
                                            else if (int.Parse(ViewData["cardtype"].ToString()) == 4)
                                           { %>小额贷款信息<% } %>
                                    </th>
                                    <th class="hidden-480" style="width: 150px;">
                                        操作
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
            </td>
        </tr>
    </table>
    <div id="modal-detail" class="modal fade" tabindex="-1" data-width="512">
        <div class="modal-dialog" style="width: 400px">
            <div class="modal-content">
                <div class="modal-header">
                    <div>
                        <div style="text-align: center; font-size: 30px;">
                            详细
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="row" style="text-align: center; font-size: 18px;">
                        <div class="form-group">
                            <span id="modal_cardtype_detail"></span>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-info" data-dismiss="modal">
                        确定
                    </button>
                </div>
                <input type="hidden" id="dataid" value="" />
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageStyle" runat="server">
    
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%= ViewData["rootUri"] %>Content/js/jquery.dataTables.min.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/jquery.dataTables.bootstrap.js"></script>
    <script type="text/javascript">

        var card_type;
        card_type = <%= ViewData["cardtype"] %>;

        var oTable0;

        jQuery(function ($) {
            oTable0 =
				$('#tbldata0')
				.dataTable({
				    "bServerSide": true,
				    "bProcessing": true,
				    "sAjaxSource": rootUri + "Finance/RetrieveCardTypeList?cardtype=" + card_type,
				    "oLanguage": {
				        "sUrl": rootUri + "Content/i18n/dataTables.chinese.txt"
				    },
				    //bAutoWidth: false,
				    "aoColumns": [
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
				            aTargets: [2],    // Column number which needs to be modified
				            fnRender: function (o, v) {   // o, v contains the object and value for the column
				                var rst = "";

                                var tmp = o.aData[3].toString();
                                tmp = tmp.replace(/\r\n/g,"<br>");
                                tmp = tmp.replace(/\n/g,"<br>");
				                rst = "<a href='#modal-detail' data-toggle='modal'><button class='btn btn-info' onclick=\"$('#modal_cardtype_detail').html('" + tmp + "');\">详细</button></a>&nbsp;&nbsp;";
                                
                                <% if (int.Parse(ViewData["cardtype"].ToString()) != 4) { %>
                                    rst += "<a href='<%= ViewData["rootUri"] %>Finance/BuyCard/"+o.aData[2]+"?cardtype="+<%=ViewData["cardtype"] %>+"'><span class='btn btn-info'>我要办理</span></a>";
                                <% } else { %>
                                    rst += "<a href='<%= ViewData["rootUri"] %>Finance/BuyCard1/"+o.aData[2]+"?cardtype="+<%=ViewData["cardtype"] %>+"'><span class='btn btn-info'>我要办理</span></a>";
                                <% } %>
                                
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

        function refreshTable() {
            oSettings0 = oTable0.fnSettings();
            oTable0.dataTable().fnDraw();
        }

        function redirectToListPage(status) {
            if (status.indexOf("error") != -1) {
            } else {
                refreshTable();
            }
        }
    </script>
</asp:Content>
