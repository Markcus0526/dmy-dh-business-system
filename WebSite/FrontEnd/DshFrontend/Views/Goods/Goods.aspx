<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="DshFrontend.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <table align="center" style="width: 1024px; font-size: 14px;">
        <tr>
            <td>
                <div class="page-content" style="margin-left: 0; margin-top: 20px;">
                    <!-- BEGIN PAGE HEADER-->
                    <div class="row">
                        <div class="col-md-12">
                            <h3 class="page-title">
                            <% if ((int)ViewData["goodstype"] == 1)
                               { %>
                                精彩团购
                            <% } else { %>
                                特惠商户
                            <% } %>
                            </h3>
                        </div>
                    </div>
                    <!-- END PAGE HEADER-->
                    <div class="tabbable tabbable-custom tabbable-full-width">
                        <div class="tab-content">
                            <div class="" style="width: 100%; height: 34px; background: none; margin-bottom:10px" align="right">
                                <table>
                                    <tr>
                                        <td>
                                            <input type="text" id="search_txt" name="search_txt" placeholder="请输入关键语" class="form-control"
                                                style="width: 208px;" />
                                        </td>
                                        <td>
                                            <button type="button" class="width-100 btn btn-sm btn-primary" onclick="onClickSearchBtn();">
                                                <i class="ace-icon fa fa-search bigger-110"></i><span class="bigger-110">查看</span>
                                            </button>
                                        </td>
                                </table>
                            </div>
                            <div class="tabbable">

                                <ul class="nav nav-tabs padding-16">

                                <%
                                    List<tbl_kind> kindlist = (List<tbl_kind>)ViewData["kindlist"];
                                    if (kindlist != null)
                                    {
                                        var index = kindlist.Count();
                                        if (index > 5) index = 5;
                                        for (int i = 0; i < index; i++)
                                        {
                                            var item = kindlist.ElementAt(i);
                                 %>

                                    <li <% if ( i == 0 ) { %>class="active"<% } %>>
                                    <a data-toggle="tab" href="#edit-<%= i %>" id="tabA-<%=i %>" onclick="TabChanged(<%= i %>);"><img src="<%= ViewData["backendUri"] %><%= item.image %>" width="24px" height="24px" />&nbsp;<font style="line-height:24px"><%= item.name %></font></a></li>
                                <%
                                        }
                                        if (index < kindlist.Count())
                                        {                                 
                                    
                                %>
                                <li class="dropdown" style="height:44px">
									<a href="#" data-toggle="dropdown" style="height:44px">更多</a>
									<ul class="dropdown-menu" role="menu">
                                    <% for (int i = index; i < kindlist.Count(); i++)
                                       {
                                           var item = kindlist.ElementAt(i);
                                            %>
										<li><a data-toggle="tab" href="#edit-<%=i %>" id="tabA-<%=i %>" onclick="TabChanged(<%= i %>);"><img src="<%= ViewData["backendUri"] %><%= item.image %>" width="24px" height="24px" />&nbsp;<font style="line-height:24px"><%= item.name%></font></a></li>										
                                    <%
                                      } %>
									</ul>
								</li>
                                <%
                                        }
                                    } %>
                                </ul>

                                <div class="tab-content profile-edit-tab-content" id="TabContentDiv">

                                <%
                                    List<List<GoodsCatalogList>> firstpagelist = (List<List<GoodsCatalogList>>)ViewData["cataloglist"];
                                    if (firstpagelist != null)
                                    {
                                        for (int i = 0; i < firstpagelist.Count(); i++)
                                        {
                                            List<GoodsCatalogList> itemlist = firstpagelist.ElementAt(i);
                                %>    
                                    <div id="edit-<%= i %>" class="tab-pane <% if (i == 0) { %> in active <% } %>">
                                        <div class="bigmid" id="mainDiv-<%=i %>" style="height: 550px; overflow: scroll;">
                                            <div class="exchangelist" id="wrapperDiv-<%=i %>" style="padding-left: 15px;">
                                                <ul class="clear">
                                <%
                                            for(int j = 0; j < itemlist.Count; j++)
                                            {
                                                GoodsCatalogList item = itemlist.ElementAt(j);
                                %>
                                        
                                                    <li align="center"><a href="<%= ViewData["rootUri"] %>Goods/ShowGoods/<%=item.uid %>">
                                                        <img src="<%= ViewData["backendUri"] %><%= item.image %>" width="137" height="137" /></a>
                                                        <h4 style="margin-top:10px">
                                                            <%= item.name %></h4>
                                                        <p style="margin-top:10px">
                                                            <div style="color: #c90000; text-align: left; float: left; margin-left: 20px;">
                                                                ¥<%= item.price %></div>
                                                            <div style="color: #dfa300; text-align: right; margin-right: 20px;">
                                                                <%= item.buy_count %>人贷款</div>
                                                        </p>
                                                        <p style="margin-top:10px; margin-left:10px; margin-right:10px; height:40px;">
                                                            <span><%= item.sale_desc %></span>
                                                        </p>
                                                        <div class="rating herating" id="rating-<%=i %>-0-<%=j %>"></div>
                                                    </li>
                                                
                                <%
                                            }

                                %>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                <%
                                        }
                                    }
                                %>

                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageStyle" runat="server">
    <link href="<%= ViewData["rootUri"] %>content/css/css.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/plugins/rating/rating.css">
    <style type="text/css">
        .herating
        {
            margin-top: 10px;
            margin-left: 60px;
            margin-right: 48px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" runat="server">
    <script type="text/javascript" src="<%= ViewData["rootUri"] %>Content/js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="<%= ViewData["rootUri"] %>Content/plugins/rating/jquery.rating.js"></script>
    <script type="text/javascript">


    var goods_type = <%= ViewData["goodstype"] %>;
    var cur_tab = 0;
    var cur_pagenum = 0;
    var pagenumlist = [];
    var tab_count = 0;

    <% List<List<GoodsCatalogList>> firstpagelist = (List<List<GoodsCatalogList>>)ViewData["cataloglist"]; %>

    tab_count = <%= firstpagelist.Count %>;

     $(document).ready(function () {
        $contentLoadTriggered = false;
        
        for ( i = 0; i < tab_count; i++ )
        {
            $("#mainDiv-"+i).scroll(

                function () {

                var ind = $(this).attr("id");
                ind = ind.replace(/mainDiv-/g,"");

                    if ($("#mainDiv-"+ind).scrollTop() >= ($("#wrapperDiv-"+ind).height() - $("#mainDiv-"+ind).height() - 10) && $contentLoadTriggered == false) {
                        $contentLoadTriggered = true;
                        $.ajax(
                            {
                                type: "GET",
                                url: "<%= ViewData["rootUri"] %>Goods/GetMoreDataFromServer",
                                data: { 
                                    tabnum: ind,
                                    type: goods_type
                                },
                                dataType: "json",
                                async: true,
                                cache: false,
                                success: function (msg) {
                                    $contentLoadTriggered = false;
                                    if ( msg != "" )
                                    {
                                        cur_pagenum = cur_pagenum + 1;
                                        pagenumlist[cur_tab] = cur_pagenum;
                                    
                                        $("#wrapperDiv-"+ind+" .clear").append(msg);
                                        showRating(cur_tab, cur_pagenum);
                                    }
                                },
                                error: function (x, e) {
                                    //alert("The call to the server side failed. " + x.responseText);
                                }
                            }
                        );
                    }
                });
                pagenumlist[i] = 0;
                showRating(i, 0);
            }
        });

        function showRating(tabnum, pagenum) {

            $.ajax(
                {
                    type: "GET",
                    url: "<%= ViewData["rootUri"] %>Goods/GetRatingList",
                    data: { 
                        tabnum: tabnum, 
                        pagenum: pagenum,
                        type: goods_type
                    },
                    dataType: "json",
                    async: true,
                    cache: false,
                    success: function (datalist) {
                        
                        if (datalist != null && datalist != "") {
                            for ( i = 0; i < datalist.length; i++ )
                            {
                                if ( $("#rating-"+tabnum+"-"+pagenum+"-"+i).html().length == 0 )
                                {
                                    $("#rating-"+tabnum+"-"+pagenum+"-"+i).rating('', { maxvalue: 5, curvalue: datalist[i] });
                                }
                            }
                        }
                    },
                    error: function (x, e) {
                        //alert("The call to the server side failed. " + x.responseText);
                    }
                }
            );

        }

        function TabChanged(tabnum)
        {
            cur_tab = tabnum;
            cur_pagenum = pagenumlist[cur_tab];
        }

        function onClickSearchBtn()
        {
            var txt = $("#search_txt").val();

            $.ajax(
                {
                    type: "GET",
                    url: "<%= ViewData["rootUri"] %>Goods/GetFirstPagesWithSearchText",
                    data: {
                        type: goods_type,
                        search_txt: txt,
                        cur_tab: cur_tab
                    },
                    dataType: "json",
                    async: true,
                    cache: false,
                    success: function (msg) {
                        $("#TabContentDiv").html(msg);

                        for ( i = 0; i < tab_count; i++ )
                        {
                            $("#mainDiv-"+i).scroll(

                                function () {

                                var ind = $(this).attr("id");
                                ind = ind.replace(/mainDiv-/g,"");

                                    if ($("#mainDiv-"+ind).scrollTop() >= ($("#wrapperDiv-"+ind).height() - $("#mainDiv-"+ind).height() - 10) && $contentLoadTriggered == false) {
                                        $contentLoadTriggered = true;
                                        $.ajax(
                                            {
                                                type: "GET",
                                                url: "<%= ViewData["rootUri"] %>Goods/GetMoreDataFromServer",
                                                data: { 
                                                    tabnum: ind,
                                                    type: goods_type
                                                },
                                                dataType: "json",
                                                async: true,
                                                cache: false,
                                                success: function (msg) {
                                                    $contentLoadTriggered = false;
                                                    if ( msg != "" )
                                                    {
                                                        cur_pagenum = cur_pagenum + 1;
                                                        pagenumlist[cur_tab] = cur_pagenum;
                                    
                                                        $("#wrapperDiv-"+ind+" .clear").append(msg);
                                                        showRating(cur_tab, cur_pagenum);
                                                    }
                                                },
                                                error: function (x, e) {
                                                    //alert("The call to the server side failed. " + x.responseText);
                                                }
                                            }
                                        );
                                    }
                                });
                                pagenumlist[i] = 0;
                                showRating(i, 0);
                            }
                    },
                    error: function (x, e) {
                        //alert("The call to the server side failed. " + x.responseText);
                    }
                }
            );
        }

    </script>
</asp:Content>
