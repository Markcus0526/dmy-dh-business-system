<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="DshFrontend.Models" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<% var cataloginfo = (tbl_catalog)ViewData["cataloginfo"]; %>

    <table align="center" style="width: 964px; font-size: 14px;">
        <tr>
            <td>
                <div class="w964" style="margin-bottom:50px;">
                    <div class="site clear">
                        <div class="bigtop exchange_bigtop">
                        </div>
                        <div class="bigmid">
                            <div class="exchangetop clear">
                                <div class="exchange_pic fle">
                                    <div class="exchange_picshow" style="width:339px;height:350px;">
                                        <img src="/Content/img/tran.gif" width="339" height="350" alt="" />
                                    </div>
                                    <div class="exchange_thumb mar15" align="center">
                                        <ul style="width: 220px;">
                                            <li>
                                                <img src="<%=ViewData["BackendUri"] %><%=cataloginfo.image1 %>" dataimg="<%=ViewData["BackendUri"] %><%=cataloginfo.image1 %>"
                                                    width="47" height="47" alt=""></li>
                                            <% if (cataloginfo.image2 != "")
                                               {%>
                                            <li>
                                                <img src="<%=ViewData["BackendUri"] %><%=cataloginfo.image2 %>" dataimg="<%=ViewData["BackendUri"] %><%=cataloginfo.image2 %>"
                                                    width="47" height="47" alt=""></li>
                                                    <%}
                                                        if (cataloginfo.image3 != "")
                                                        {
                                                      %>
                                            <li>
                                                <img src="<%=ViewData["BackendUri"] %><%=cataloginfo.image3 %>" dataimg="<%=ViewData["BackendUri"] %><%=cataloginfo.image3 %>"
                                                    width="47" height="47" alt=""></li>
                                                    <%}
                                                        if (cataloginfo.image4 != "")
                                                        {%>
                                            <li>
                                                <img src="<%=ViewData["BackendUri"] %><%=cataloginfo.image4 %>" dataimg="<%=ViewData["BackendUri"] %><%=cataloginfo.image4 %>"
                                                    width="47" height="47" alt=""></li>
                                                    <%} %>
                                        </ul>
                                    </div>
                                </div>
                                <div class="exchange_info fri">
                                    <h4>
                                       <%=cataloginfo.name %></h4>
                                    <table width="100%" class="exchange_tab01">
                                        <tr >
                                            <td align="right" width="20%">
                                                价格：
                                            </td>
                                            <td align="left" width="80%">
                                                <span style="color: #c90000;"><%=cataloginfo.price %> 元</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" width="20%">
                                                评价值：
                                            </td>
                                            <td align="left" width="80%">
                                                <div id="starrate" class="rating" style="margin-left:5px;"></div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" valign="top" width="20%" nowrap>
                                                产品说明：
                                            </td>
                                            <td align="left" width="80%">
                                                <div id="catalog_desc_frame" style="overflow: scroll; height:220px; width:290px"></div>
                                            </td>
                                        </tr>
                                        <tr>
                                        </tr>
                                    </table>
                                    <div class="exchange_btn singler mar" align="center">
                                        <a href="<% =ViewData["rootUri"] %>Goods/BuyGoods/<%=cataloginfo.uid %>">立即购买</a>
                                       <!-- <a href="#" onclick="buycatalog('<%=cataloginfo.uid %>')">加入购物车</a>   -->
                                    </div>
                                </div>
                            </div>
                            <div class="exchangebot clear">
                                <div class="exchangebot_tit">
                                    购买详情</div>
                                <div class="exchangebot_info" align="center">
                                    <table width="80%" style="border-bottom: #e2e2e2 1px solid;" class="exchange_tab01">
                                        <tr>
                                            <td align="right" width="120px">
                                                店家地址：
                                            </td>
                                            <td align="left">
                                                <%=cataloginfo.addr %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" valign="top" width="120px">
                                                店家电话号码：
                                            </td>
                                            <td align="left">
                                                <%=ViewData["phonenum"] %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" valign="top" width="120px">
                                                购买通知：
                                            </td>
                                            <td align="left">
                                                <%=cataloginfo.sale_desc %>
                                                <!--Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod bibendum
                                                laoreet. Proin gravida dolor sit amet lacus accumsan et viverra-->
                                            </td>
                                        </tr>
                                        
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="bigbot">
                        </div>
                    </div>
                </div>
            </td>
        </tr>
    </table>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageStyle" runat="server">
    <link href="<%= ViewData["rootUri"] %>content/css/css.css" rel="stylesheet" type="text/css" />
     <link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.min.css" />
    <link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/plugins/rating/rating.css">
	<link href="<%= ViewData["rootUri"] %>Content/plugins/gritter/css/jquery.gritter.css" rel="stylesheet" type="text/css"/>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" runat="server">
    <script type="text/javascript" src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.js"></script>
   <!-- <script type="text/javascript" src="<%= ViewData["rootUri"] %>Content/js/jquery-1.10.2.min.js"></script>    -->
    <script type="text/javascript" src="<%= ViewData["rootUri"] %>Content/plugins/rating/jquery.rating.js"></script> 
	<script src="<%= ViewData["rootUri"] %>Content/plugins/gritter/js/jquery.gritter.js" type="text/javascript"></script>

    <script type="text/javascript">
        //    $(function () {
        //        $(".includeDom").each(function () {
        //            var html = $(this).attr("include");
        //            $(this).load(html, function () {
        //                $(".menu li a").eq(6).addClass("now").css("color", "#c50e50");
        //                $(".toptit span a").eq(1).addClass("now");
        //            });
        //        })
        //    })
    </script>
    <script type="text/javascript">
    <% var cataloginfo = (tbl_catalog)ViewData["cataloginfo"]; %>
        $(function () {
            objLi = $(".exchange_thumb li");
            objImg = $(".exchange_picshow").find("img");
            objLi.click(function () {
                proSlideRun(objLi.index(this));
            })
            function proSlideRun(n) {
                objLi.removeClass("active").eq(n).addClass("active");
                objImg.fadeTo(300, 0, function () {
                    objImg.fadeTo(300, 1, function () {
                        objImg.attr("src", objLi.eq(n).children("img").attr("dataimg"));
                    });
                })
            }
            proSlideRun(0);

            $('.rating').rating('', { maxvalue: 5, curvalue: <%=ViewData["eval"] %> });

            //$("#catalog_desc_frame").html('askdjf');
            $("#catalog_desc_frame").html(unescape('<%=cataloginfo.catalog_desc %>'));
        });

        function redirectToListPage(status) {
            if (status.indexOf("error") != -1) {
            } else {
                //refreshTable();
            }
        }

        function buycatalog(catalog_id)
        {          
                  $.ajax({
                    async: false,
                    type: "POST",
                    url: rootUri + "Goods/BuyCatalog",
                    dataType: "json",
                    data: {id: catalog_id},
                    success: function (data) {    
                            setTimeout(function () {
                                var unique_id = $.gritter.add({
                                    // (string | mandatory) the heading of the notification
                                    title: '恭喜您!',
                                    // (string | mandatory) the text inside the notification
                                    text: '加入商品购物车成功了!',
                                    // (string | optional) the image to display on the left
                                    image: '<%= ViewData["rootUri"] %>Content/avatars/user.jpg',
                                    // (bool | optional) if you want it to fade out on its own or just sit there
                                    sticky: true,
                                    // (int | optional) the time you want it to be alive for before fading out
                                    time: '',
                                    // (string | optional) the class name you want to apply to that specific message
                                    class_name: 'my-sticky-class'
                                });

                                // You can have it return a unique id, this can be used to manually remove it later using
                                setTimeout(function () {
                                    $.gritter.remove(unique_id, {
                                        fade: true,
                                        speed: 'slow'
                                    });
                                }, 3500);
                            }, 100);
                           
                    },
                    error: function (data) {
                        alert("Error: " + data.status);
                        $('.loading-btn').button('reset');
                    }
                });
        }
    </script>
</asp:Content>
