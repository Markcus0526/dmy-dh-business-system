<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="DshFrontend.Models" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <table width="600px" style="margin-top: 100px; margin-bottom: 70px;" align="center">
        <tr>
            <td align="center">
                <table style="width:200px;">
                    <tr>
                        <td align="center">
                            <a href="<%=ViewData["rootUri"] %>Finance/CardType/0">
                                <img src="<%= ViewData["rootUri"] %>Content/img/finance_btn1.png" width="145px" height="144px"
                                    alt="" /></a>
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <font size="3" color="#626262"><b>银行卡受理</b></font>
                        </td>
                    </tr>
                </table>
            </td>
            <td align="center">
                <table style="width:200px;">
                    <tr>
                        <td align="center">
                            <a href="<%=ViewData["rootUri"] %>Finance/CardType/1">
                                <img src="<%= ViewData["rootUri"] %>Content/img/finance_btn2.png" width="145px" height="144px"
                                    alt="" /></a>
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <font size="3" color="#626262"><b>信用卡办理</b></font>
                        </td>
                    </tr>
                </table>
            </td>   
            <td align="center">
                <table style="width:200px;">
                    <tr>
                        <td align="center">
                            <a href="<%=ViewData["rootUri"] %>Finance/CardType/2">
                                <img src="<%= ViewData["rootUri"] %>Content/img/finance_btn3.png" width="145px" height="144px"
                                    alt="" /></a>
                        </td>
                    </tr>
                    <tr>    
                        <td align="center">
                            <font size="3" color="#626262"><b>保险业务</b></font>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td align="center">
                <table style="width:200px; margin-top:40px;">
                    <tr>
                        <td align="center">
                            <a href="<%=ViewData["rootUri"] %>Finance/CardType/3">
                                <img src="<%= ViewData["rootUri"] %>Content/img/finance_btn4.png" width="145px" height="144px"
                                    alt="" /></a>
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <font size="3" color="#626262"><b>理财产品</b></font>
                        </td>
                    </tr>
                </table>
            </td>
            <td align="center">
                <table style="width:200px; margin-top:40px;">
                    <tr>
                        <td align="center">
                            <a href="<%=ViewData["rootUri"] %>Finance/CardType/4">
                                <img src="<%= ViewData["rootUri"] %>Content/img/finance_btn5.png" width="145px" height="144px"
                                    alt="" /></a>
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <font size="3" color="#626262"><b>小额贷款</b></font>
                        </td>
                    </tr>
                </table>
            </td>
            <td align="center">

            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageStyle" runat="server">
    <link href="<%= ViewData["rootUri"] %>content/css/css.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" runat="server">
    <script type="text/javascript">
        
    </script>
</asp:Content>
