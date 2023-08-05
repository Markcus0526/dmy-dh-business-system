<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

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
                                                    <label class="col-sm-3 control-label no-padding-right" for="phonenum">
                                                        卡号：</label>
                                                    <div class="col-sm-5">
                                                        <div class="clearfix">
                                                            <input type="text" id="cardnum" name="cardnum" placeholder="请输入卡号" class="input-large form-control" />
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="col-sm-3 control-label no-padding-right" for="phonenum">
                                                        密码：</label>
                                                    <div class="col-sm-5">
                                                        <div class="clearfix">
                                                            <input type="password" id="password" name="password" placeholder="请输入密码" class="input-large form-control" />
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="col-sm-3 control-label no-padding-right" for="phonenum">
                                                        银行预留电话号码：</label>
                                                    <div class="col-sm-5">
                                                        <div class="clearfix">
                                                            <input type="text" id="bankphone" name="bankphone" placeholder="请输入银行预留电话号码" class="input-large form-control" />
                                                        </div>
                                                    </div>
                                                </div>

                                    <div class="clearfix form-actions">
                                        <div class="col-md-offset-3 col-md-9">
                                            <button class="btn btn-info loading-btn" type="submit" data-loading-text="提交中...">
                                                下一步<i class="ace-icon fa fa-arrow-right bigger-110"></i>
                                            </button>
                                        </div>
                                    </div>
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
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/jquery.validate.min.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/validate.messages_zh.js"></script>
    <script type="text/javascript">
    
        jQuery(document).ready(function () {

            $('.loading-btn')
		      .click(function () {
		          var btn = $(this)
		          btn.button('loading')
		      });

            var form = $('#validation-form');
            var error = $('.alert-danger', form);
            var success = $('.alert-success', form);
            $('#validation-form').validate({
                errorElement: 'span',
                errorClass: 'help-block',
                //focusInvalid: false,
                rules: {
                    cardnum: {
                        required: true,
                        number: true
                    },
                    password: {
                        required: true,
                        number: true
                    },
                    bankphone: {
                        required: true,
                        number: true
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

        function submitform() {
            window.location = "<% =ViewData["rootUri"] %>Goods/Validation/1";
        }

    </script>
</asp:Content>
