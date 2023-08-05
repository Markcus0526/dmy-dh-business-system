<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="DshBackend.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<% var orderinfo = (SaleInfo)ViewData["shopinfo"]; %>

    <table align="center" style="width: 1024px; font-size: 14px;">
        <tr>
            <td>
                <div class="page-content" style="margin-left: 0; margin-top: 20px;">
                    <!-- BEGIN PAGE HEADER-->
                    <div class="row">
                        <div class="col-md-12">
                            <h3 class="page-title">
                           订单详情
                            </h3>
                        </div>
                    </div>
                    <div class="mb-dti">   
                     <% 
                    if (orderinfo != null)
                    {
                        %><ul class="c-list"> 
							<li> 
								<label> 下单时间: </label> &nbsp
								<span class="c-ls-multi"><%= orderinfo.regtime%></span> 
							</li>
							<li> 
								<label> 购买用户: </label>&nbsp
								<span><%= orderinfo.username%></span> 
							</li> 
							<li> 
								<label> 手机号码: </label> &nbsp
								<span class="blue"><%= orderinfo.phonenum%></span> 
							</li> 
						</ul>   
                       <% 
                        } %>
					</div> 
                    	<div>
							<table class="table table-striped table-bordered">
								<thead>
									<tr>
										<th class="center">#</th>
										<th>商品名称</th>
										<th class="hidden-xs">销售商</th>
										<th>数量</th>
										<th>销售价</th>
										<th>使用积分</th>
										<th>合计</th>
									</tr>
								</thead>

								<tbody>
                                    <% 
                                        if (orderinfo != null)
                                       {
                                           
                                          %>
									<tr>
										<td class="center"></td>

										<td>
											<%= orderinfo.catalogname%>
										</td>
										<td>
											<%= orderinfo.shopname%>
										</td>
										<td>
											<%= orderinfo.count%>
										</td>
										<td>
											￥<%= orderinfo.price%>
										</td>
                                        <td>
                                        <%if(orderinfo.score!=null) {%>
                                            <%= orderinfo.score%>
                                          <%}%>
											
										</td>
										<td>￥<%= orderinfo.totalprice%></td>
                                       
									</tr>

                                        <% 
                                          
                                    } %>
								</tbody>
							</table>
						</div>

						<div class="hr hr8 hr-double hr-dotted"></div>

			<%--			<div class="row">
							<div class="col-sm-5 pull-right">
								<h4 class="pull-right">
									总金额 :
									<span class="red">$<%= totalprice %></span>
								</h4>
							</div>
							<div class="col-sm-7 pull-left"> 其他信息 </div>
						</div>--%>
                    <!-- END PAGE HEADER-->
                </div>
            </td>
        </tr>
    </table>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageStyle" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" runat="server">
</asp:Content>
