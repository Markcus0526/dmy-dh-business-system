<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="DshBackend.Models" %>
<ul class="nav nav-list">
    <% var userrole = CommonModel.GetCurrentUserRole();
       var usertype = CommonModel.GetCurrentUserType();
       if (usertype == "admin")
       {
           if (userrole.Contains("business"))
           {
    %>
    <li class="hover <% if (ViewData["level1nav"] != null && ViewData["level1nav"] == "Card") { %>active open <% } %>">
        <a href="#" class="dropdown-toggle"><i class="menu-icon fa fa-credit-card bigger-180"></i><span class="menu-text">
            业务办理 </span><b class="arrow fa fa-angle-down"></b></a><b class="arrow"></b>
        <ul class="submenu">
            <li class="hover <% if (ViewData["level2nav"] != null && ViewData["level2nav"] == "BankCard") { %>active <% } %>">
                <a href="<%= ViewData["rootUri"] %>Card/BankCard"><i class="menu-icon fa fa-credit-card">
                </i>银行卡受理 </a><b class="arrow"></b></li>
            <li class="hover <% if (ViewData["level2nav"] != null && ViewData["level2nav"] == "CreditCard") { %>active <% } %>">
                <a href="<%= ViewData["rootUri"] %>Card/CreditCard"><i class="menu-icon fa fa-credit-card">
                </i>信用卡办理 </a><b class="arrow"></b></li>
            <li class="hover <% if (ViewData["level2nav"] != null && ViewData["level2nav"] == "InsuranceCard") { %>active <% } %>">
                <a href="<%= ViewData["rootUri"] %>Card/InsuranceCard"><i class="menu-icon fa fa-credit-card">
                </i>保险业务 </a><b class="arrow"></b></li>
            <li class="hover <% if (ViewData["level2nav"] != null && ViewData["level2nav"] == "FinanceCard") { %>active <% } %>">
                <a href="<%= ViewData["rootUri"] %>Card/FinanceCard"><i class="menu-icon fa fa-credit-card">
                </i>理财产品 </a><b class="arrow"></b></li>
            <li class="hover <% if (ViewData["level2nav"] != null && ViewData["level2nav"] == "LendCard") { %>active <% } %>">
                <a href="<%= ViewData["rootUri"] %>Card/LendCard"><i class="menu-icon fa fa-credit-card">
                </i>小额贷款业务 </a><b class="arrow"></b></li>
        </ul>
    </li>
    <% }
           if (userrole.Contains("shop"))
           { %>
        <li class="hover <% if (ViewData["level1nav"] != null && ViewData["level1nav"] == "Shop") { %>active open <% } %>">
        <a href="<%= ViewData["rootUri"] %>Shop/ShopList"><i class="menu-icon fa fa-plane bigger-180"></i><span class="menu-text">商户管理 </span><b class="arrow fa fa-angle-down">
            </b></a><b class="arrow"></b>
            </li>
    <% }
           if (userrole.Contains("catalog"))
           { %>
    <li class="hover <% if (ViewData["level1nav"] != null && ViewData["level1nav"] == "Catalog") { %>active open <% } %>">
        <a href="#" class="dropdown-toggle"><i class="menu-icon fa fa-shopping-cart bigger-180"></i><span class="menu-text">
            商品管理 </span><b class="arrow fa fa-angle-down"></b></a><b class="arrow"></b>
        <ul class="submenu">
            <li class="hover <% if (ViewData["level2nav"] != null && ViewData["level2nav"] == "ExtraCatalogList") { %>active <% } %>">
                <a href="<%= ViewData["rootUri"] %>Catalog/ExtraCatalogList"><i class="menu-icon fa fa-shopping-cart">
                </i>特惠商品管理 </a><b class="arrow"></b></li>
            <li class="hover <% if (ViewData["level2nav"] != null && ViewData["level2nav"] == "GeneralCatalogList") { %>active <% } %>">
                <a href="<%= ViewData["rootUri"] %>Catalog/GeneralCatalogList"><i class="menu-icon fa fa-shopping-cart">
                </i>精彩团购管理 </a><b class="arrow"></b></li>
            <li class="hover <% if (ViewData["level2nav"] != null && ViewData["level2nav"] == "TicketList") { %>active <% } %>">
                <a href="<%= ViewData["rootUri"] %>Catalog/TicketList"><i class="menu-icon fa fa-shopping-cart">
                </i>订单查询 </a><b class="arrow"></b></li>
            <li class="hover <% if (ViewData["level2nav"] != null && ViewData["level2nav"] == "BackList") { %>active <% } %>">
                <a href="<%= ViewData["rootUri"] %>Catalog/BackList"><i class="menu-icon fa fa-shopping-cart">
                </i>退货信息 </a><b class="arrow"></b></li>
        </ul>
    </li>
    <%}
           if (userrole.Contains("money"))
           { %>
    <li class="hover <% if (ViewData["level1nav"] != null && ViewData["level1nav"] == "Money") { %>active open  <% } %>">
        <a href="#" class="dropdown-toggle"><i class="menu-icon fa fa-yen bigger-180"></i><span
            class="menu-text">财务信息管理</span> <b class="arrow fa fa-angle-down"></b></a><b class="arrow">
            </b>
        <ul class="submenu">
            <li class="hover <% if (ViewData["level2nav"] != null && ViewData["level2nav"] == "SaleList") { %>active <% } %>">
                <a href="<%= ViewData["rootUri"] %>Money/SaleList"><i class="menu-icon fa fa-yen">
                </i>财务信息 </a><b class="arrow"></b></li>
            <li class="hover <% if (ViewData["level2nav"] != null && ViewData["level2nav"] == "AdminpayList") { %>active <% } %>">
                <a href="<%= ViewData["rootUri"] %>Money/AdminpayList"><i class="menu-icon fa fa-yen">
                </i>我的应受应付 </a><b class="arrow"></b></li>
            <li class="hover <% if (ViewData["level2nav"] != null && ViewData["level2nav"] == "UserList") { %>active <% } %>">
                <a href="<%= ViewData["rootUri"] %>Money/UserList"><i class="menu-icon fa fa-yen">
                </i>积分管理 </a><b class="arrow"></b></li>
        </ul>
    </li>
    <% }
           if (userrole.Contains("user"))
           { %>
    <li class="hover <% if (ViewData["level1nav"] != null && ViewData["level1nav"] == "User") { %>active open  <% } %>">
        <a href="<%= ViewData["rootUri"] %>User/UserList"><i class="menu-icon fa fa-male bigger-180"></i>
            <span class="menu-text">会员管理</span> </a><b class="arrow"></b></li>
    <%}
           if (userrole.Contains("device"))
           { %>
    <li class="hover <% if (ViewData["level1nav"] != null && ViewData["level1nav"] == "Device") { %>active <% } %>">
        <a href="<%= ViewData["rootUri"] %>Device/DeviceList"><i class="menu-icon fa fa-inbox bigger-180">
        </i><span class="menu-text">机具添加管理 </span></a><b class="arrow"></b></li>
    <%}
           if (userrole.Contains("admin"))
           { %>
    <li class="hover <% if (ViewData["level1nav"] != null && ViewData["level1nav"] == "AdminList") { %>active <% } %>">
        <a href="<%= ViewData["rootUri"] %>Admin/AdminList"><i class="menu-icon fa fa-user bigger-180">
        </i><span class="menu-text">用户设置 </span></a><b class="arrow"></b></li>
    <%}
           if (userrole.Contains("basedata"))
           { %>
    <li class="hover <% if (ViewData["level1nav"] != null && ViewData["level1nav"] == "Admin") { %>active open  <% } %>">
        <a href="#" class="dropdown-toggle"><i class="menu-icon fa fa-legal bigger-180"></i><span class="menu-text">
            基础管理</span> <b class="arrow fa fa-angle-down"></b></a><b class="arrow"></b>
        <ul class="submenu">
            <li class="hover <% if (ViewData["level2nav"] != null && ViewData["level2nav"] == "RoleList") { %>active <% } %>">
                <a href="<%= ViewData["rootUri"] %>Admin/RoleList"><i class="menu-icon fa fa-legal"></i>
                    权限添加 </a><b class="arrow"></b></li>
            <li class="hover <% if (ViewData["level2nav"] != null && ViewData["level2nav"] == "ShopList") { %>active <% } %>">
                <a href="<%= ViewData["rootUri"] %>Admin/ShopList"><i class="menu-icon fa fa-legal">
                </i>添加商户 </a><b class="arrow"></b></li>
            <li class="hover <% if (ViewData["level2nav"] != null && ViewData["level2nav"] == "KindList") { %>active <% } %>">
                <a href="<%= ViewData["rootUri"] %>Admin/KindList"><i class="menu-icon fa fa-legal">
                </i>添加类型 </a><b class="arrow"></b></li>
        </ul>
    </li>
    <%}
       }
       else
       { %>
       <li class="hover <% if (ViewData["level1nav"] != null && ViewData["level1nav"] == "Ticket") { %>active open <% } %>">
        <a href="<%= ViewData["rootUri"] %>Shop/TicketList"><i
            class="menu-icon fa fa-print bigger-180"></i><span class="menu-text">我的订单查看</span><b class="arrow fa fa-angle-down">
            </b></a><b class="arrow"></b>
            </li>

       <li class="hover <% if (ViewData["level1nav"] != null && ViewData["level1nav"] == "Sale") { %>active open <% } %>">
        <a href="<%= ViewData["rootUri"] %>Shop/SaleList"><i
            class="menu-icon fa fa-yen bigger-180"></i><span class="menu-text">我的财务查看</span><b class="arrow fa fa-angle-down">
            </b></a><b class="arrow"></b>
            </li>

       <li class="hover <% if (ViewData["level1nav"] != null && ViewData["level1nav"] == "Shoppay") { %>active open <% } %>">
        <a href="<%= ViewData["rootUri"] %>Shop/ShoppayList"><i
            class="menu-icon fa fa-trophy bigger-180"></i><span class="menu-text">应收应付 </span><b class="arrow fa fa-angle-down">
            </b></a><b class="arrow"></b>
            </li>
     <% } %>
</ul>
<!-- /.nav-list -->
