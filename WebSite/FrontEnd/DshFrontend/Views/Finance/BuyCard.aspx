<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="DshFrontend.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <table align="center" style="width: 1024px; font-size: 14px; margin-bottom:50px;">
        <tr>
            <td>
                <div class="page-content" style="margin-left: 0; margin-top: 20px;">
                    <!-- BEGIN PAGE HEADER-->
                    <div class="row">
                        <div class="col-md-12">
                            <h3 class="page-title">
                                <%  if (int.Parse(ViewData["cardtype"].ToString()) == 0)
                                    { %>银行卡受理<% }
                                    else if (int.Parse(ViewData["cardtype"].ToString()) == 1)
                                    { %>信用卡办理<% }
                                    else if (int.Parse(ViewData["cardtype"].ToString()) == 2)
                                    { %>保险业务<% }
                                    else if (int.Parse(ViewData["cardtype"].ToString()) == 3)
                                    { %>理财产品<% } %>
                            </h3>
                        </div>
                    </div>
                    <!-- END PAGE HEADER-->
                    <!-- BEGIN PAGE CONTENT-->
                    <div class="row ">
                        <div class="col-md-12">
                            <!--BEGIN TABS-->
                            <div class="tabbable tabbable-custom tabbable-full-width" id="mainContainerDiv">
                                <form class="form-horizontal" role="form" id="validation-form">
                                <div class="row">
                                    <div class="tab-content">
                                        <div class="portlet-body">
                                            <table width="700px" align="center" style="margin-top: 20px;">
                                                <tr>
                                                    <td>
                                                        <div class="form-group">
                                                            <label class="col-sm-5 control-label no-padding-right" for="name">
                                                                持卡人姓名：</label>
                                                            <div class="col-sm-5">
                                                                <div class="clearfix">
                                                                    <input type="text" id="name" name="name" placeholder="请输入持卡人姓名" class="input-large form-control"
                                                                        value="" />
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <div class="form-group">
                                                            <label class="col-sm-5 control-label no-padding-right" for="phonenum">
                                                                预留电话：</label>
                                                            <div class="col-sm-5">
                                                                <div class="clearfix">
                                                                    <input type="text" id="phonenum" name="phonenum" placeholder="请输入预留电话" class="input-large form-control"
                                                                        value="" />
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <div class="form-group">
                                                            <label class="col-sm-5 control-label no-padding-right" for="cardnum">
                                                                身份证号码：</label>
                                                            <div class="col-sm-5">
                                                                <div class="clearfix">
                                                                    <input type="text" id="cardnum" name="cardnum" placeholder="请输入身份证号码" class="input-large form-control"
                                                                        value="" />
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <div class="form-group">
                                                            <label class="col-sm-5 control-label no-padding-right" for="addr">
                                                                预留地址：</label>
                                                            <div class="col-sm-5">
                                                                <div class="clearfix">
                                                                    <input type="text" id="addr" name="addr" placeholder="请输入预留地址" class="input-large form-control"
                                                                        value="" />
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <div class="form-group">
                                                            <label class="col-sm-5 control-label no-padding-right" for="content">
                                                                留言信息：</label>
                                                            <div class="col-sm-5">
                                                                <div class="clearfix">
                                                                    <textarea id="content" name="content" placeholder="请输入留言信息" class="input-large form-control"
                                                                        style="height: 100px;"></textarea>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                                <input type="hidden" id="cardtype" name="cardtype" value="<%= ViewData["cardtype"] %>" />
                                <input type="hidden" id="cardid" name="cardid" value="<%= ViewData["cardid"] %>" />
                                <div class="clearfix form-actions">
                                    <table width="700px" align="center">
                                        <tr align="center">
                                            <td>
                                                <button class="btn btn-info loading-btn" type="submit" data-loading-text="提交中...">
                                                    <i class="ace-icon fa fa-check bigger-110"></i>确定
                                                </button>
                                                &nbsp; &nbsp;
                                                <button class="btn" type="button" onclick="window.history.go(-1);">
                                                    <i class="ace-icon fa fa-undo bigger-110"></i>返回
                                                </button>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                </form>
                            </div>
                            <div id="descriptionContainerDiv" style="display: none;">
                                <div class="row">
                                    <div class="tab-content">
                                        <table style="width:400px" align="center">
                                        <tr>
                                        <td style="padding-top:50px; max-width:400px" align="center" >
                                            <font size="4"><%= ViewData["description"]%></font>
                                        </td>
                                        </tr>
                                        <tr><td style="padding-top:50px; padding-bottom:50px;" align="center">
                                            <button class="btn" type="button" onclick="window.history.go(-1);">
                                                <i class="ace-icon fa fa-undo bigger-110"></i>申请成功
                                            </button>
                                        </td></tr>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            <!--END TABS-->
                        </div>
                    </div>
                    <!-- END PAGE CONTENT-->
                </div>
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageStyle" runat="server">
    <link href="<% =ViewData["rootUri"]%>Content/css/plugins.css" rel="stylesheet" type="text/css" />
    <link href="<% =ViewData["rootUri"]%>Content/css/themes/default.css" rel="stylesheet" type="text/css" id="style_color" />
    <link href="<% =ViewData["rootUri"]%>Content/css/pages/profile.css" rel="stylesheet" type="text/css" />
    <link href="<% =ViewData["rootUri"]%>Content/css/custom.css" rel="stylesheet" type="text/css" />
    <link href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.min.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/jquery.validate.min.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/validate.messages_zh.js"></script>
    <script>
        jQuery(document).ready(function () {
           
            $('#validation-form').validate({
                errorElement: 'span',
                errorClass: 'help-block',
                //focusInvalid: false,
                rules: {
                    name: {
                        required: true
                    },
                    phonenum: {
                        required: true,
                        number: true,
                        minlength: 8,
                        maxlength: 14,
                    },
                    cardnum: {
                        required: true
                    },
                    addr: {
                        required: true
                    },
                    content: {
                        required: true
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

        });

        function redirectToListPage(status) {
            if (status.indexOf("error") != -1) {
                $('.alert-success').hide();
                $('.loading-btn').button('reset');
            } else {
                $('.loading-btn').button('reset');
            }
        }

        function submitform() {
            $.ajax({
                async: false,
                type: "POST",
                url: rootUri + "Finance/SubmitBuyCard",
                dataType: "json",
                data: $('#validation-form').serialize(),
                success: function (data) {
                    if (data == "") {
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


                        $("#mainContainerDiv").hide();
                        $("#descriptionContainerDiv").show();

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
                        toastr["error"](data, "温馨敬告");

                    }
                },
                error: function (data) {
                    alert("Error: " + data.status);
                    $('.loading-btn').button('reset');
                }
            });
        }

    </script>
</asp:Content>
