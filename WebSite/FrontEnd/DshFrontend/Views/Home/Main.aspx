<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="DshFrontend.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <table width="100%" style="margin-bottom:70px;">
        <tr>
            <td align="center" height="340px">
                <div class="box1l">
                    <div class="box1lcon">
                        <ul style="margin-left: 0px">
                            <%
                                List<tbl_catalog> cataloglist = (List<tbl_catalog>)ViewData["cataloglist"];
                                if (cataloglist != null)
                                {
                                    for (int i = 0; i < cataloglist.Count(); i++)
                                    {
                                        var item = cataloglist.ElementAt(i);
                                 %>

                            <li>
                                <p>
                                    <a href="<% =ViewData["rootUri"] %>Goods/ShowGoods/<% =item.uid %>">
                                        <img src="<%= ViewData["backendUri"] %><% =item.recommend_image %>" width="600" height="300"
                                            alt="" />
                                    </a>
                                </p>
                                <h2>
                                    <a href="#"><% =item.name%></a>
                                </h2>
                            </li>
                            <% }
                                }
                                %>
                        </ul>
                    </div>
                    <div class="box1btn">
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td align="center" height="120px">
                <div style="margin-top: 40px">
                    <div>
                        <a href="<%=ViewData["rootUri"] %>Goods/Goods">
                            <img src="<%= ViewData["rootUri"] %>Content/img/main_btn1.png" width="130px" height="105px" alt="" /></a>&nbsp;
                        &nbsp; <a href="<%=ViewData["rootUri"] %>Goods/Favour">
                            <img src="<%= ViewData["rootUri"] %>Content/img/main_btn2.png" width="130px" height="105px" alt="" /></a>&nbsp;
                        &nbsp; <a href="<%=ViewData["rootUri"] %>Finance/Index">
                            <img src="<%= ViewData["rootUri"] %>Content/img/main_btn3.png" width="130px" height="105px" alt="" /></a>&nbsp;
                        &nbsp; <a href="<%=ViewData["rootUri"] %>User/Profile">
                            <img src="<%= ViewData["rootUri"] %>Content/img/main_btn4.png" width="130px" height="105px" alt="" /></a>
                    </div>
                </div>
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageStyle" runat="server">
    <link href="<%= ViewData["rootUri"] %>content/css/css.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" runat="server">
    <script type="text/javascript">
        var j = 0;
        var timer;
        var listN = $(".box1lcon li").size();
        $(function () {
            //IndexNews


            $(".box1lcon ul").width(listN * 600);
            for (i = 0; i < listN; i++) {
                $(".box1btn").append('<span class="png span' + i + '"></span>');
            }
            $(".box1btn span").eq(0).addClass("on")
            var sw = 1;
            $(".box1btn span").mouseover(function () {
                sw = $(".box1btn span").index(this);
                clearTimeout(timer);
                newsChange(sw);
                j = sw;
                timer = setTimeout("Change()", 5000);
            });


            $(document).ready(function () {
                timer = setTimeout("Change()", 5000);
            });
        });
        function newsChange(i) {
            $(".box1lcon ul").stop().animate({ left: -600 * i }, 500);
            $(".box1btn span").eq(i).addClass("on").siblings("span").removeClass("on");
        }
        function Change() {

            j++;
            if (j == listN) {

                j = 0;
            }
            newsChange(j);
            clearTimeout(timer);
            timer = setTimeout("Change()", 5000);
        }
    
    </script>
</asp:Content>
