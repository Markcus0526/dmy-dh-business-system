<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="DshFrontend.Models" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <% var cataloginfo = (tbl_catalog)ViewData["cataloginfo"]; %>
    <table align="center" style="width: 964px; font-size: 14px;">
        <tr>
            <td>
                <div class="w964" style="margin-bottom: 50px;">
                    <div class="site clear">
                        <div class="bigtop exchange_bigtop">
                        </div>
                        <div class="bigmid">
                            <div class="row">
                                <div class="col-xs-12">
                                    <form class="form-horizontal" role="form" id="validation-form">
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label no-padding-right" for="username">
                                            产品名称：</label>
                                        <div class="col-sm-9">
                                            <span><span style="font-size: 24px;"><b>
                                                <%=cataloginfo.name %></b></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="font-size: 18px;
                                                    color: #c90000;"><b id="price">
                                                        <%=cataloginfo.price %>
                                                        元</b></span> </span>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label no-padding-right" for="userpwd">
                                            数量：</label>
                                        <div class="col-sm-9">
                                            <div id="spinner_count">
                                                <div class="input-group" style="width: 150px;">
                                                    <div class="spinner-buttons input-group-btn">
                                                        <button type="button" class="btn spinner-down red" style="border: none; background-color: #D84A38 !important">
                                                            <i class="fa fa-minus"></i>
                                                        </button>
                                                    </div>
                                                    <input type="text" id="count" name="count" onchange="insert_total();" class="spinner-input form-control"
                                                        maxlength="3" style="color: #000; background-color: #fff !important; text-align: center;"
                                                        value="1">
                                                    <div class="spinner-buttons input-group-btn">
                                                        <button type="button" class="btn spinner-up blue" style="border: none; background-color: #4D90FE !important">
                                                            <i class="fa fa-plus"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label no-padding-right" for="score">
                                        </label>
                                        <div class="col-sm-9">
                                            <span class="col-sm-2" style="padding-left:0;margin-top:6px;">
                                                <input type="checkbox" class="ace" id="using_score" name="using_score" onchange="changeUsingScore(this)" <%=ViewData["using_score"]%>/>
                                                <span class="lbl">&nbsp;积分使用</span>
                                                 </span>
                                                <span class="col-sm-3">
                                                    <input type="text" id="score" name="score" class="input medium form-control" placeholder="请输入积分" onkeyup="changeTotalPrice()" disabled>
                                                </span>
                                        </div>
                                   </div>
                                        <div class="space"></div>
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label no-padding-right" for="confirmpwd">
                                                总价：</label>
                                            <div class="col-sm-9">
                                                <span id="total" style="font-size: 18px; color: #dfa300;"><b>
                                                    <%=cataloginfo.price %>
                                                </b>元</span>

                                            </div>

                                        </div>
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label no-padding-right" for="confirmpwd">
                                            </label>
                                            <div class="col-sm-9">
                                                <span style="font-size: 18px;">您的绑定手机号码
                                                    <%=ViewData["phonenum"] %></span>
                                        </div>

                                        </div>
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label no-padding-right" for="confirmpwd">
                                                选择支付方式:</label>
                                            <div class="col-sm-9">
                                                <div>
                                                    <label class="radio-inline">
                                                        <input type="radio" name="paytype" id="paytype1" value="0" checked />
                                                        <img src="<%=ViewData["rootUri"] %>Content/img/mark_bank.png" />                                                        
                                                    </label>
                                                </div>                                               
                                            </div>
                                        </div>
                                        <div class="clearfix form-actions">
                                            <div class="col-md-offset-3 col-md-9">
                                                <button class="btn btn-info" type="submit">
                                                    <i class="ace-icon fa fa-check bigger-110"></i>提交订单</button>&nbsp; &nbsp; &nbsp;
                                                <button class="btn" type="submit" onclick="delete_sale();">
                                                    <i class="ace-icon fa fa-undo bigger-110"></i>购买取消
                                                </button>
                                            </div>
                                        </div>
                                        <input type="hidden" value="<%=cataloginfo.uid %>" name="uid" />
                                        <input type="hidden" value="0" name="buy" id="buy" />
                                    </form>
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
    <link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.min.css" />
    <link href="<%= ViewData["rootUri"] %>content/css/css.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.min.css" />
    <link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/plugins/jquery-ui/jquery-ui-1.10.1.custom.min.css" />
    <link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/css/style-metronic.css" />
    <link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/css/style.css" />
    <link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/css/style-responsive.css" />
    <link rel="stylesheet" type="text/css" href="<%= ViewData["rootUri"] %>Content/css/plugins.css" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/jquery.validate.min.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/validate.messages_zh.js"></script>
    <script type="text/javascript" src="<%= ViewData["rootUri"] %>Content/plugins/fuelux/js/spinner.min.js"></script>
    <script type="text/javascript">
   
        function redirectToListPage(status) {
            if (status.indexOf("error") != -1) {
                $('.loading-btn').button('reset');
            } else {
                window.location = rootUri + "Goods/Goods";
            }
        }
        jQuery(function ($) {
            $('.loading-btn')
		      .click(function () {
		          var btn = $(this)
		          btn.button('loading')
		      });

            $('#validation-form').validate({
                errorElement: 'span',
                errorClass: 'help-block',
                //focusInvalid: false,
                rules: {
                    count: {
                        required: true,
                        number: true
                    },
                    score: {                        
                        number: true,
                        check_score: true            
                    }
                },
                highlight: function (e) {
                    $(e).closest('.form-group').removeClass('has-info').addClass('has-error');
                },

                success: function (e) {
                    $(e).closest('.form-group').removeClass('has-error'); //.addClass('has-info');
                    $(e).remove();
                },

                errorPlacement: function (error, element) {
                    if (element.is(':checkbox') || element.is(':radio')) {
                        var controls = element.closest('div[class*="col-"]');
                        if (controls.find(':checkbox,:radio').length > 1) controls.append(error);
                        else error.insertAfter(element.nextAll('.lbl:eq(0)').eq(0));
                    }
                    else if (element.is('.select2')) {
                        error.insertAfter(element.siblings('[class*="select2-container"]:eq(0)'));
                    }
                    else if (element.is('.chosen-select')) {
                        error.insertAfter(element.siblings('[class*="chosen-container"]:eq(0)'));
                    }
                    else error.insertAfter(element.parent());
                },

                submitHandler: function (form) {                    
                    submitform();
                    return false;
                },
                invalidHandler: function (form) {
                    $('.loading-btn').button('reset');
                }
            });
            $.validator.addMethod("check_score", function (value, element) {
                return checkScore();
            }, "请输入积分");
           
            $.validator.addMethod("scoreoverflow", function (value, element) {
                return checkScoreOverflow();
            }, "超越您的积分");

            $('#spinner_count').spinner({ value: 0, step: 1, min: 1, max: 100 });
            $('#spinner_count').change(function () {
                var price = '<%=ViewData["price"] %>';
                changeTotalPrice();                
            });
        });


        function Insert_total() {
            var price = '<%=ViewData["price"] %>';
            changeTotalPrice();
            //$("#total b").html($("#count").val() * parseInt(price, 10));
        }

        function changeUsingScore(obj) {
            if (obj.checked)
                $("#score").removeAttr("disabled");
            else
                $("#score").attr("disabled", "disabled");
            changeTotalPrice();
        }

        function changeTotalPrice() {
      
            var total_price = 0;
            var price = '<%=ViewData["price"] %>';
            total_price = parseInt(price, 10) * parseInt($("#count").val(), 10);

            if ($("#using_score").attr("checked") == "checked") {                
                total_price -= Math.floor($("#score").val() * parseInt($("#count").val(), 10)/ 100);               
            }

             $("#total b").html(total_price);
        }

        function submitform() {

            $.ajax({
                async: false,
                type: "POST",
                url: rootUri + "Goods/SubmitSale",
                dataType: "json",
                data: $('#validation-form').serialize(),
                success: function (data) {
                    if (data == 0) {
                        toastr.options = {
                            "closeButton": false,
                            "debug": true,
                            "positionClass": "toast-top-center",
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
                        if ($("#buy").val() == 1)
                            window.location.href = rootUri + "Goods/Goods";
                        else
                            window.location.href = rootUri + "Goods/Paying/" + "<%=ViewData["uid"] %>";
                    } else {
                        toastr.options = {
                            "closeButton": false,
                            "debug": true,
                            "positionClass": "toast-top-center",
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

                        if (data == 1)
                            toastr["error"]("", "超越您的积分");
                       else if (data == 2)
                            toastr["error"]("", "不使用积分");
                       else if (data == 3)
                            toastr["error"]("", "超越积分使用限制");                            
                       else if (data == 4)
                            toastr["error"]("", "超越数量");                            

                    }
                },
                error: function (data) {
                    alert("Error: " + data.status);
                    $('.loading-btn').button('reset');
                }
            });
        }

        function delete_sale() {
            $("#buy").attr("value", 1);
        }

        function checkScore() {
            var rst = true;
            if ($("#using_score").attr("checked")) {
                if ($("#score").val().length == 0)
                return false;
            }

            return rst;

        }

    </script>
</asp:Content>
