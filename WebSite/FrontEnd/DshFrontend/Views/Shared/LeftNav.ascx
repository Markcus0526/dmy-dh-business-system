<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<ul class="nav nav-list">

    <li class="<% if (ViewData["level1nav"] != null && ViewData["level1nav"] == "Home") { %>active <% } %>"
        style="width: 130px;"><a href="<%= ViewData["rootUri"] %>Home/Main">
            <i class="menu-icon fa fa-tachometer" style="line-height:24px; font-size:24px;" ></i>
            <p style="min-width:100px" align="center">首页</p>
        </a><b class="arrow"></b></li>

    <li class="<% if (ViewData["level1nav"] != null && ViewData["level1nav"] == "Goods" && ViewData["level2nav"] != null && ViewData["level2nav"] == "Goods") { %>active <% } %>"
        style="width: 130px;"><a href="<%= ViewData["rootUri"] %>Goods/Goods">
            <i class="menu-icon fa fa-archive" style="line-height:24px; font-size:24px;"></i>
            <p style="min-width:100px" align="center">精彩团购</p>
        </a><b class="arrow"></b></li>
    <li class="<% if (ViewData["level1nav"] != null && ViewData["level1nav"] == "Goods" && ViewData["level2nav"] != null && ViewData["level2nav"] == "Favour") { %>active <% } %>"
        style="width: 130px;"><a href="<%= ViewData["rootUri"] %>Goods/Favour">
            <i class="menu-icon fa fa-gift" style="line-height:24px; font-size:24px;"></i>
            <p style="min-width:100px" align="center">特惠商户</p>
        </a><b class="arrow"></b></li>
    <li class="<% if (ViewData["level1nav"] != null && ViewData["level1nav"] == "Finance") { %>active <% } %>"
        style="width: 130px;"><a href="<%= ViewData["rootUri"] %>Finance/Index">
            <i class="menu-icon fa fa-yen" style="line-height:24px; font-size:24px;"></i>
            <p style="min-width:100px" align="center">金融超市</p>
        </a><b class="arrow"></b></li>
    <li class="<% if (ViewData["level1nav"] != null && ViewData["level1nav"] == "User") { %>active <% } %>"
        style="width: 130px;"><a href="<%= ViewData["rootUri"] %>User/Profile">
            <i class="menu-icon fa fa-user" style="line-height:24px; font-size:24px;"></i>
            <p style="min-width:100px" align="center">会员服务</p>
        </a><b class="arrow"></b></li>
</ul>
