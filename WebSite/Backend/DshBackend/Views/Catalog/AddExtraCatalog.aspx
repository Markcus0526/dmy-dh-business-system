<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="DshBackend.Models" %>
<%@ Import Namespace="DshBackend.Models.Library" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <% var cataloginfo = (tbl_catalog)ViewData["cataloginfo"]; %>
    <div class="page-header">
        <h1>
            商品管理 <small><i class="ace-icon fa fa-angle-double-right"></i>
                <% if (ViewData["uid"] == null)
                   { %>
                添加
                <% }
                   else
                   { %>
                编辑
                <% } %>
                商品 </small><a class="btn btn-white btn-default btn-round" onclick="window.history.go(-1)"
                    style="float: right"><i class="ace-icon fa fa-times red2"></i>返回 </a>
        </h1>
    </div>
    <div class="row">
        <div class="col-xs-12">
            <form class="form-horizontal" role="form" id="validation-form">
            <div align="center">
                <table width="880px">
                    <tr>
                        <td width="50%">
                            <div class="form-group">
                                <label class="col-sm-3 control-label no-padding-right" for="shop_id">
                                    商户名称：</label>
                                <div class="col-xs-12 col-sm-9">
                                    <div class="clearfix">
                                        <select class="input-large form-control" id="shop_id" name="shop_id">
                                            <%
                                                var shoplist = (List<tbl_shop>)ViewData["shoplist"];
                                                long shop_id = 0;
                                                if (cataloginfo != null)
                                                {
                                                    shop_id = cataloginfo.shopid;
                                                }
                                                foreach (var item in shoplist)
                                                { %>
                                            <option value="<%= item.uid %>" <% if (shop_id == item.uid) { %> selected<% } %>>
                                                <%= item.shopname %></option>
                                            <% } %>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="form-group">
                                <label class="col-sm-3 control-label no-padding-right" for="price">
                                    商品价格：</label>
                                <div class="col-sm-9">
                                    <div class="clearfix">
                                        <input type="text" id="price" name="price" placeholder="请输入商品价格" class="input-large form-control"
                                            <% if (cataloginfo != null) { %>value="<%= cataloginfo.price %>" <% } %> />
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="form-group">
                                <label class="col-sm-3 control-label no-padding-right" for="name">
                                    商品名称：</label>
                                <div class="col-sm-9">
                                    <div class="clearfix">
                                        <input type="text" id="name" name="name" placeholder="请输入商品名称" class="input-large form-control"
                                            <% if (cataloginfo != null) { %>value="<%= cataloginfo.name %>" <% } %> />
                                    </div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="form-group">
                                <label class="col-sm-3 control-label no-padding-right" for="profit">
                                    商户应付费用：</label>
                                <div class="col-sm-9">
                                    <div class="clearfix">
                                        <input type="text" id="profit" name="profit" placeholder="请输入商户应付费用" class="input-large form-control"
                                            <% if (cataloginfo != null) { %>value="<%= cataloginfo.profit %>" <% } %> />
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="form-group">
                                <label class="col-sm-3 control-label no-padding-right" for="kind_id">
                                    商品类型：</label>
                                <div class="col-xs-12 col-sm-9">
                                    <div class="clearfix">
                                        <select class="input-large form-control" id="kind_id" name="kind_id">
                                            <%
                                                var kindlist = (List<tbl_kind>)ViewData["kindlist"];
                                                long kind_id = 0;
                                                if (cataloginfo != null)
                                                {
                                                    kind_id = cataloginfo.kindid;
                                                }
                                                foreach (var item in kindlist)
                                                { %>
                                            <option value="<%= item.uid %>" <% if (kind_id == item.uid) { %> selected<% } %>>
                                                <%= item.name %></option>
                                            <% } %>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="form-group" <% if(ViewData["type"] != null && Convert.ToByte(ViewData["type"]) == 1) { %>
                                style="display: none;" <% } %>>
                                <label class="col-sm-3 control-label no-padding-right" for="extra">
                                    补贴金额：</label>
                                <div class="col-sm-9">
                                    <div class="clearfix">
                                        <input type="text" id="extra" name="extra" placeholder="请输入补贴金额" class="input-large form-control"
                                            value="<% if (cataloginfo != null) { %><%= cataloginfo.extra %><% } else { %>0<% } %>" />
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="form-group">
                                <label class="col-sm-3 control-label no-padding-right" for="using_score">
                                    是否使用积分：</label>
                                <div class="col-xs-12 col-sm-9">
                                    <div class="clearfix">
                                        <select class="input-large form-control" id="using_score" name="using_score" onchange="changeUsingScore()">
                                            <option value="1" <% if (cataloginfo != null && cataloginfo.using_score == 1) { %>
                                                selected<% } %>>使用积分</option>
                                            <option value="0" <% if (cataloginfo != null && cataloginfo.using_score == 0) { %>
                                                selected<% } %>>不使用积分</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="form-group">
                                <label class="col-sm-3 control-label no-padding-right" for="count">
                                    商品数量：</label>
                                <div class="col-sm-9">
                                    <div class="clearfix">
                                        <input type="text" id="count" name="count" placeholder="请输入商品数量" class="input-large form-control"
                                            <% if (cataloginfo != null) { %>value="<%= cataloginfo.count %>" <% } %> />
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="form-group">
                                <label class="col-sm-3 control-label no-padding-right" for="score_limit">
                                    积分使用限制：</label>
                                <div class="col-sm-9">
                                    <div class="clearfix">
                                        <input type="text" id="score_limit" name="score_limit" placeholder="请输入积分使用限制(99)" class="input-large form-control"
                                            <% if (cataloginfo != null) { %>value="<%= cataloginfo.score_limit %>" <% } %> />
                                    </div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="form-group">
                                <label class="col-sm-3 control-label no-padding-right" for="addr">
                                    商品地址：</label>
                                <div class="col-sm-9">
                                    <div class="clearfix">
                                        <input type="text" id="addr" name="addr" placeholder="请输入商品地址" class="input-large form-control"
                                            <% if (cataloginfo != null) { %>value="<%= cataloginfo.addr %>" <% } %> />
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <div class="form-group">
                                <label class="col-sm-3 control-label no-padding-right" for="back">
                                    是否可以退货：</label>
                                <div class="col-xs-12 col-sm-9">
                                    <div class="clearfix">
                                        <select class="input-large form-control" id="back" name="back">
                                            <option value="0" <% if (cataloginfo != null && cataloginfo.back == 0) { %> selected<% } %>>
                                                不可以退货</option>
                                            <option value="1" <% if (cataloginfo != null && cataloginfo.back == 1) { %> selected<% } %>>
                                                可以退货</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="form-group">
                                <label class="col-sm-3 control-label no-padding-right" for="sale_desc">
                                    购买须知：</label>
                                <div class="col-sm-9">
                                    <div class="clearfix">
                                        <textarea class="form-control col-md-4 adjust-left" name="sale_desc" id="sale_desc"
                                            style="width: 360px; height: 100px; max-width: 370px; min-width: 370px;"><% if (cataloginfo != null)
                                                                                                                        { %><%= cataloginfo.sale_desc %><% } %></textarea>
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>

            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="show">
                    是否上架：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <label>
                            <input id="show" name="show" class="ace ace-switch ace-switch-3" type="checkbox"
                                <% if (cataloginfo != null) { if( cataloginfo.show == 1) { %>checked<% } } else { %>checked<% } %> />
                            <span class="lbl">
                                <!--[if IE]>启用<![endif]-->
                            </span>
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group">
			    <label class="col-sm-3 control-label no-padding-right" for="startdate">开始时间：</label>
			    <div class="col-sm-9">
				    <div class="input-medium">
					    <div class="input-group">
						    <input class="input-medium date-picker" name = "startdate" id="startdate" type="text" data-date-format="yyyy-mm-dd" placeholder="yyyy-mm-dd" <% if (cataloginfo != null) { %> value="<%= String.Format("{0:yyyy-MM-dd}", cataloginfo.startdate) %>"<% } %> />
						    <span class="input-group-addon">
							    <i class="ace-icon fa fa-calendar"></i>
						    </span>
					    </div>
				    </div>
			    </div>
		    </div>
            <div class="form-group">
			    <label class="col-sm-3 control-label no-padding-right" for="enddate">截至时间：</label>
			    <div class="col-sm-9">
				    <div class="input-medium">
					    <div class="input-group">
						    <input class="input-medium date-picker" name = "enddate" id="enddate" type="text" data-date-format="yyyy-mm-dd" placeholder="yyyy-mm-dd" <% if (cataloginfo != null) { %> value="<%= String.Format("{0:yyyy-MM-dd}", cataloginfo.enddate) %>"<% } %> />
						    <span class="input-group-addon">
							    <i class="ace-icon fa fa-calendar"></i>
						    </span>
					    </div>
				    </div>
			    </div>
		    </div>
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="content">
                    商品描述：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <textarea id="content" name="content" class="col-md-4 adjust-left form-control" style="width: 370px;
                            height: 100px; max-width: 370px; min-width: 370px;"></textarea>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="recommend">
                    是否推荐：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <label>
                            <input id="recommend" name="recommend" class="ace ace-switch ace-switch-3" type="checkbox"
                                <% if (cataloginfo != null) { if(cataloginfo.recommend == 1) { %>checked<% } } else { %>
                                <% } %> />
                            <span class="lbl">
                                <!--[if IE]>启用<![endif]-->
                            </span>
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="recommend_image">
                    推荐图片：</label>
                <div class="col-sm-9">
                    <div class="clearfix">
                        <img id="recommend_previewimg" src="<% if (cataloginfo != null && cataloginfo.recommend_image != null && cataloginfo.recommend_image != "") { %><%= ViewData["rootUri"] %><%= cataloginfo.recommend_image %><% } else { %><%= ViewData["rootUri"] %>Content/img/noimage.gif<% } %>"
                            style="max-width: 100px; max-height: 45px;" />
                        <input type="text" id="recommend_image" name="recommend_image" value="<% if (cataloginfo != null) { %><%= cataloginfo.recommend_image %><% } %>"
                            style="border: none; width: 0;color:White;" readonly />
                        <input type="button" class="btn btn-sm" id="recommend_imagebutton" value="选择图片" />
                    </div>
                    <span class="help-inline col-xs-12 col-sm-7"><span class="middle">建议大少：660*290px</span>
                    </span>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label no-padding-right" for="imagelist">
                    商品图片：</label>
                <div class="col-sm-9" id="divimagelist">
                    <div class="clearfix">
                        <input type="button" class="btn btn-sm" id="imagebutton" value="选择图片" />
                    </div>
                    <%
                        var imagelist = (List<string>)ViewData["imagelist"];
                        if (imagelist != null)
                        {
                            for (int i = 0; i < imagelist.Count(); i++)
                            {
                                string imgurl = imagelist.ElementAt(i);
                    %>
                    <div style="margin: 10px 0px;">
                        <input type="hidden" class="divimglist" value="<% =imgurl %>" />
                        <div style='float: left; padding: 5px;'>
                            <img src='<%= ViewData["rootUri"] %><% =imgurl %>' style="border: 1px solid #ccc;"
                                width='100px' height='100px' onmouseover='over_img(this)' onmouseout='out_img(this)'>
                            <a href='javascript:void(0);'>
                                <img src='<%= ViewData["rootUri"] %>content/img/imgdel.png' class='close_btn' onclick="removeMe(this, 'fname')"
                                    onmouseover='over_close(this)' style='visibility: hidden; margin-top: -100px;
                                    margin-left: -10px; width: 20px; height: 20px;' onmouseout='out_close(this)'></a>
                        </div>
                    </div>
                    <% 
                        }
                    }
                    %>
                </div>
            </div>
            <input type="hidden" id="uid" name="uid" value="<% if (ViewData["uid"] != null) { %><%= ViewData["uid"] %><% } else { %>0<% } %>" />
            <input type="hidden" id="imagelist" name="imagelist" value="<% if (ViewData["imagelist"] != null) { %><%= ViewData["imagelist"] %><% } %>" />
            <input type="hidden" id="catalog_desc" name="catalog_desc" value="" />
            <input type="hidden" id="type" name="type" value="<% =ViewData["type"] %>" />
            <div class="clearfix form-actions">
                <div class="col-md-offset-3 col-md-9">
                    <button class="btn btn-info loading-btn" type="submit" data-loading-text="提交中...">
                        <i class="ace-icon fa fa-check bigger-110"></i>提交
                    </button>
                    &nbsp; &nbsp; &nbsp;
                    <button class="btn" type="reset">
                        <i class="ace-icon fa fa-undo bigger-110"></i>重置
                    </button>
                </div>
            </div>
            </form>
        </div>
    </div>
    <%--<form name="form_upload" action="<%= ViewData["rootUri"] %>Upload/UploadImage" method="post"
    enctype="multipart/form-data">
    <input type="file" id="uploadfile" name="uploadfile" onchange="SubmitUploadForm();"
        style="display: none;" />
    <span class="help-block" id="uploadstatus" style="display: none;"></span>
    </form>--%>
    
    <input type="hidden" id="crop_x" name="x" />
	<input type="hidden" id="crop_y" name="y" />
	<input type="hidden" id="crop_w" name="w" />
	<input type="hidden" id="crop_h" name="h" />
    <div id="ajax-modal" class="modal fade" tabindex="-1">
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageStyle" runat="server">
    <link href="<%= ViewData["rootUri"] %>Content/css/datepicker.css" rel="stylesheet" />
    	<link href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.min.css" rel="stylesheet" type="text/css" />
    <link href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-modal/css/bootstrap-modal-bs3patch.css" rel="stylesheet" type="text/css"/>
	<link href="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-modal/css/bootstrap-modal.css" rel="stylesheet" type="text/css"/>
	<link href="<%= ViewData["rootUri"] %>Content/plugins/jcrop/css/jquery.Jcrop.min.css" rel="stylesheet" type="text/css"/>
	<link href="<%= ViewData["rootUri"] %>Content/css/pages/image-crop.css" rel="stylesheet" type="text/css"/>    
    <link href="<% =ViewData["rootUri"] %>Content/css/plugins.css" rel="stylesheet" type="text/css" />
    <link href="<% =ViewData["rootUri"] %>Content/css/themes/default.css" rel="stylesheet" type="text/css" id="style_color" />
    <link href="<% =ViewData["rootUri"] %>Content/css/pages/profile.css" rel="stylesheet" type="text/css" />
    <link href="<% =ViewData["rootUri"] %>Content/css/custom.css" rel="stylesheet" type="text/css" />
    <link href="<%= ViewData["rootUri"] %>Content/css/datepicker.css" rel="stylesheet" />


</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-toastr/toastr.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/jquery.validate.min.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/validate.messages_zh.js"></script>
    <script charset="utf-8" src="<%= ViewData["rootUri"] %>Content/plugins/kindeditor-4.1.7/kindeditor-min.js"></script>
    <script charset="utf-8" src="<%= ViewData["rootUri"] %>Content/plugins/kindeditor-4.1.7/lang/zh_CN.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/date-time/bootstrap-datepicker.min.js"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/date-time/bootstrap-datepicker.zh-CN.js"></script>
	<script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-modal/js/bootstrap-modal.js" type="text/javascript"></script>
	<script src="<%= ViewData["rootUri"] %>Content/plugins/bootstrap-modal/js/bootstrap-modalmanager.js" type="text/javascript"></script>
	<script src="<%= ViewData["rootUri"] %>Content/plugins/jcrop/js/jquery.color.js" type="text/javascript"></script>
	<script src="<%= ViewData["rootUri"] %>Content/plugins/jcrop/js/jquery.Jcrop.min.js" type="text/javascript"></script>
    <script src="<%= ViewData["rootUri"] %>Content/js/ajaxupload.js"></script>

    <script type="text/javascript">

	    var $modal = $('#ajax-modal');
	    var cropw = 100, croph = 100;

	    function redirectToListPage(status) {
	        if (status.indexOf("error") != -1) {
	            $('.loading-btn').button('reset');
	        } else {
                <% if(ViewData["type"] != null && Convert.ToByte(ViewData["type"]) == 0) { %>
	            window.location = rootUri + "Catalog/ExtraCatalogList";
                <% } else { %>
	            window.location = rootUri + "Catalog/GeneralCatalogList";
                <% } %>
	        }
	    }        

        var editor1;

	    KindEditor.ready(function (K) {
	        editor1 = K.create('textarea[name="content"]', {
                uploadJson: "<%= ViewData["rootUri"] %>Upload/UploadKindEditorImage",
                fileManagerJson: "<%= ViewData["rootUri"] %>Upload/ProcessKindEditorRequest",
                allowFileManager: true,
                allowUpload: true,
                resizeType:1,
                afterChange:function(){
                    if (editor1 != null)
                    {
                        editor1.sync();
                    }
                }
	        });
	    });

        var isRecommend = true;
        
//	    var initFormUpload = function () {
//	        var bar = $('.bar');
//	        var percent = $('.percent');
//	        var status = $('#status');

//	        $('form[name=form_upload]').ajaxForm({
//	            dataType: 'json',
//	            beforeSend: function () {   
//	                status.empty();
//	                $(".progress").css("display", "block");
//	                $('#uploadstatus').html("正在上传图片...");
//	                $("#uploadstatus").css("display", "block");
//	                var percentVal = '0%';
//	                bar.width(percentVal);
//	                percent.html(percentVal);
//	            },
//	            uploadProgress: function (event, position, total, percentComplete) {
//	                var percentVal = percentComplete + '%';
//	                bar.width(percentVal);
//	                percent.html(percentVal);
//	            },
//	            success: function () {
//	                var percentVal = '100%';
//	                bar.width(percentVal);
//	                percent.html(percentVal);
//	            },
//	            complete: function (xhr, status) {
//	                $(".progress").css("display", "none");
//	                $("#uploadstatus").css("display", "none");

//	                if (status == "success") {
//	                    //alert(xhr.responseText);
//	                    var filepath = xhr.responseText.substring(1, xhr.responseText.length - 1);
//                        if(isRecommend) {
//	                        $("#recommend_previewimg").attr("src", rootUri + filepath);
//	                        $("#recommend_image").val(filepath);
//                        } else {
//                            if($('input.divimglist').length >= 4) {
//                                toastr.options = {
//	                                "closeButton": false,
//	                                "debug": true,
//	                                "positionClass": "toast-bottom-right",
//	                                "onclick": null,
//	                                "showDuration": "3",
//	                                "hideDuration": "3",
//	                                "timeOut": "3500",
//	                                "extendedTimeOut": "1000",
//	                                "showEasing": "swing",
//	                                "hideEasing": "linear",
//	                                "showMethod": "fadeIn",
//	                                "hideMethod": "fadeOut"
//	                            };

//	                            toastr["error"]("商品图片能最大4片", "溫馨警告");

//                                return;
//                            }

//                            var htmlstr = '<div style="margin:10px 0px;">' +
//	                                '<input type="hidden" class="divimglist" value="' + filepath + '" />' +
//	                                '<div style="float:left; padding:5px;">' +
//	                                '<img src="' + rootUri + filepath + '" style="border:1px solid #ccc;" width="100px" height="100px" onmouseover="over_img(this)" onmouseout="out_img(this)" >' +
//	                                '<a href="javascript:void(0);"><img src="<%= ViewData["rootUri"] %>content/img/imgdel.png" class="close_btn" onclick="removeMe(this, \'fname\')" onmouseover="over_close(this)" style="visibility:hidden; margin-top:-100px; margin-left:-10px; width:20px; height:20px;" onmouseout="out_close(this)"></a>' +
//	                                '</div>'
//	                            '</div>';

//	                        $("#divimagelist").append(htmlstr)
//                        }
//	                }
//	            }
//	        });
//	    };

//	    function SubmitUploadForm() {
//	        var ext = $('#uploadfile').val().split('.').pop().toLowerCase();
//	        if ($.inArray(ext, ['png', 'jpg', 'jpeg']) == -1) {
//	            alert("请选择图片格式文件");
//	        } else {
//	            $("form[name=form_upload]").submit();
//	        }
//	    }

	    jQuery(function ($) {
	        $('.loading-btn')
		      .click(function () {
		          var btn = $(this)
		          btn.button('loading')
		      });
              
	        $('.date-picker').datepicker({
	            language: 'zh-CN'
	        });

	        $('#validation-form').validate({
	            errorElement: 'span',
	            errorClass: 'help-block',
	            //focusInvalid: false,
	            rules: {
	                shop_id: {
	                    required: true
	                },
	                name: {
	                    required: true,
                        uniquename: true
	                },
	                kind_id: {
	                    required: true
	                },
	                score_limit: {
	                    validscorelimit: true,
                        number: true
	                },
	                price: {
	                    required: true,
                        number: true
	                },
	                profit: {
	                    required: true,
                        number: true,
                        smallprofittoprice: true
	                },
	                extra: {
	                    required: true,
                        number: true,
                        smalltoprice: true
	                },
	                count: {
	                    required: true,
                        number: true
	                },
	                addr: {
	                    required: true
	                },
	                sale_desc: {
	                    required: true
	                },
	                catalog_desc: {
	                    required: true
	                },
                    startdate: {
                        required: true
                    },
                    enddate: {
                        required: true
                    },
	                recommend_image: {
	                    selectimage: true
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
	        $.validator.addMethod("uniquename", function (value, element) {
	            return checkCatalogName();
	        }, "商品已存在");
	        $.validator.addMethod("selectimage", function (value, element) {
	            return checkSelectImage();
	        }, "必须选择推荐图片");
	        $.validator.addMethod("smalltoprice", function (value, element) {
	            return checkExtraToPrice();
	        }, "补贴金额不大於商品价格");
	        $.validator.addMethod("validscorelimit", function (value, element) {
	            return checkScoreLimit();
	        }, "请输入积分使用限制");
	        $.validator.addMethod("smallprofittoprice", function (value, element) {
	            return checkProfitToPrice();
	        }, "商户应付费用不大於商品价格");
            
            var content_data;
            <% if (ViewData["cataloginfo"] != null) { %>
                content_data = unescape('<%= ((tbl_catalog)ViewData["cataloginfo"]).catalog_desc %>');
            <% } %>

            $("#content").html(content_data);

//	        initFormUpload();
//	        $("#recommend_imagebutton").click(function () {
//                isRecommend = true;
//	            $('#uploadfile').trigger("click");
//	        });
//	        $("#imagebutton").click(function () {
//                isRecommend = false;
//	            $('#uploadfile').trigger("click");
//	        });

	        $modal = $('#ajax-modal');
	        handleCropModal();

            changeUsingScore();
	    });

	    function submitform() {
            $("#catalog_desc").attr("value", escape($("#content").val()));
            
            var selected_id ="";
	        $('input.divimglist').each(function () {
	            if ($(this).attr('class') == 'divimglist')
	                selected_id += $(this).attr('value') + ",";
	        });

	        $("#imagelist").val(selected_id);

            if(selected_id == "") {
                toastr.options = {
	                "closeButton": false,
	                "debug": true,
	                "positionClass": "toast-bottom-right",
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

	            toastr["error"]("没有商品图片", "溫馨警告");

                return;
            }

	        $.ajax({
	            type: "POST",
	            url: rootUri + "Catalog/SubmitCatalog",
	            dataType: "json",
	            data: $('#validation-form').serialize(),
	            success: function (data) {
	                if (data == "") {
	                    toastr.options = {
	                        "closeButton": false,
	                        "debug": true,
	                        "positionClass": "toast-bottom-right",
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
	                } else {
	                    toastr.options = {
	                        "closeButton": false,
	                        "debug": true,
	                        "positionClass": "toast-bottom-right",
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

	    function checkCatalogName() {
	        var catalogname = $("#name").val();
	        var retval = false;
	        var rid = $("#uid").val();

	        $.ajax({
	            async: false,
	            type: "GET",
	            url: rootUri + "Catalog/CheckUniqueCatalogname",
	            dataType: "json",
	            data: {
	                catalogname: catalogname,
	                rid: rid
	            },
	            success: function (data) {
	                if (data == true) {
	                    retval = true;
	                } else {
	                    retval = false;
	                }
	            }
	        });

	        return retval;
	    }

	    function checkSelectImage() {
	        if (document.getElementById("recommend").checked) {
                if($("#recommend_image").val() != null && $("#recommend_image").val().length > 0)
	                return true;
                else
                    return false;                    
	         } else
	            return true;
        }

	    function checkScoreLimit() {
	        if ($("#using_score").val() == 1) {
                if($("#score_limit").val() != null && $("#score_limit").val().length > 0)
	                return true;
                else
                    return false;                    
	         } else
	            return true;
        }

	    function checkExtraToPrice() {
	        if ($("#price").val() != null && $("#price").val().length > 0) {
                if($("#extra").val() != null && parseInt($("#extra").val(), 10) < parseInt($("#price").val(), 10))
	                return true;
                else
                    return false;                    
	         } else
	            return true;
        }

	    function checkProfitToPrice() {
	        if ($("#price").val() != null && $("#price").val().length > 0) {
                if($("#profit").val() != null && parseInt($("#profit").val(), 10) < parseInt($("#price").val(), 10))
	                return true;
                else
                    return false;                    
	         } else
	            return true;
        }
        
        function myescape(s) {
            s = s.replace(/</g, "%3C");
            s = s.replace(/>/g, "%3E");
            s = s.replace(/ /g, "%20");
            s = s.replace(/=/g, "%3D");
            s = s.replace(/"/g, "%22");
            s = s.replace(/:/g, "%3A");
            s = s.replace(/#/g, "%23");
            s = s.replace(/;/g, "%3B");
            //s = s.replace(/\r/g, "%3Cbr%3E");
            return s;
        }
        
	    function removeMe(obj, f_name) {
	        var pic_div = obj.parentNode.parentNode.parentNode;
	        $(pic_div).remove();
	    }
	    function over_img(obj) {
	        clearTimeout(timeoutID);
	        timer_flag = false;
	        if (img_parent_div)
	            $(img_parent_div).find(".close_btn").css('visibility', 'hidden');
	        var obj_parent = $(obj).parent();
	        //$(obj_parent).find(".close_btn").show(); 
	        $(obj_parent).find(".close_btn").css('visibility', 'visible');
	    }
	    var img_parent_div = null;
	    var timeoutID;
	    function out_img(obj) {
	        img_parent_div = $(obj).parent();
	        timeoutID = setTimeout("timerProc( )", 500);
	        timer_flag = true;
	    }
	    var timer_flag = false;
	    var close_flag = false;
	    function timerProc() {
	        if (!close_flag) {
	            $(img_parent_div).find(".close_btn").css('visibility', 'hidden');
	        }
	        timer_flag = false;
	    }
	    function over_close(obj) {
	        close_flag = true;
	    }
	    function out_close(obj) {
	        close_flag = false;

	        if (!timer_flag)
	            $(obj).css('visibility', 'hidden');
	    }

        function changeUsingScore() {
            if($("#using_score").val() == 1)
                $("#score_limit").removeAttr("disabled");
            else
                $("#score_limit").attr("disabled", "disabled");
        }

        
	    var $modal = $('#ajax-modal');
	    function handleCropModal() {
	        new AjaxUpload('#recommend_imagebutton', {
	            action: rootUri + 'Upload/UploadImage',
	            onSubmit: function (file, ext) {
                    isRecommend = true;
	                $('#loading_photo').show();
	                if (!(ext && /^(JPG|PNG|JPEG|GIF)$/.test(ext.toUpperCase()))) {
	                    // extensiones permitidas
	                    alert('错误: 只能上传图片', '');
	                    $('#loading_photo').hide();
	                    return false;
	                }
	            },
	            onComplete: function (file, response) {
	                //alert(file + " | " + " | " + response);
	                var f_name = response;
	                $('#loading_photo').hide();
	                showCropDialog(f_name);
	            }
	        });
            
	        new AjaxUpload('#imagebutton', {
	            action: rootUri + 'Upload/UploadImage',
	            onSubmit: function (file, ext) {
                    isRecommend = false;
	                $('#loading_photo').show();
	                if (!(ext && /^(JPG|PNG|JPEG|GIF)$/.test(ext.toUpperCase()))) {
	                    // extensiones permitidas
	                    alert('错误: 只能上传图片', '');
	                    $('#loading_photo').hide();
	                    return false;
	                }
	            },
	            onComplete: function (file, response) {
	                //alert(file + " | " + " | " + response);
	                var f_name = response;
	                $('#loading_photo').hide();
	                showCropDialog(f_name);
	            }
	        });

	        /*---------- Image Crop Dialog setup ---------*/
	        $.fn.modalmanager.defaults.resize = true;
	        $.fn.modalmanager.defaults.spinner = '<div class="loading-spinner fade" style="width: 200px; margin-left: -100px;"><img src="' + rootUri + 'Content/img/ajax-modal-loading.gif" align="middle">&nbsp;<span style="font-weight:300; color: #eee; font-size: 18px; font-family:Open Sans;">&nbsp;Loading...</span></div>';
	    }

	    function showCropDialog(fname) {
            if(isRecommend) {
                cropw = 100;
                croph = 45;
            } else {
                cropw = 100;
                croph = 100;
            }

	        // create the backdrop and wait for next modal to be triggered
	        $('body').modalmanager('loading');
	        setTimeout(function () {
	            $modal.load(rootUri + "Upload/RetrieveCropDialogHtml?cropfile=" + fname, '', function () {
	                cropimage();
	                $modal.modal({
	                    backdrop: 'static',
	                    keyboard: true,
	                    width: parseInt($("#imgcrop").css("width"), 10) + 400
	                })

                        .on("hidden", function () {
                            $modal.empty();
                        });
	            });
	        }, 100);
	    }

	    var cropimage = function () {
	        // Create variables (in this scope) to hold the API and image size
	        //alert(parseInt($("#imgcrop").css("width"), 10) + 300);
	        //$("#ajax-modal").css("width", parseInt($("#imgcrop").css("width"), 10) + 300);
	        var jcrop_api,
                boundx,
                boundy,
	        // Grab some information about the preview pane
                $preview = $('#preview-pane'),
                $pcnt = $('#preview-pane .preview-container'),
                $pimg = $('#preview-pane .preview-container img');

	        $pcnt.width(cropw);
	        $pcnt.height(croph);

	        var xsize = $pcnt.width(),
                ysize = $pcnt.height();

	        //console.log('init', [xsize, ysize]);

	        $('#imgcrop').Jcrop({
	            onChange: updatePreview,
	            onSelect: updatePreview,
	            aspectRatio: cropw / croph,
	            setSelect: [0, 0, cropw, croph]
	        }, function () {
	            // Use the API to get the real image size
	            var bounds = this.getBounds();
	            boundx = bounds[0];
	            boundy = bounds[1];
	            // Store the API in the jcrop_api variable
	            jcrop_api = this;
	            // Move the preview into the jcrop container for css positioning
	            $preview.appendTo(jcrop_api.ui.holder);
	        });

	        function updatePreview(c) {
	            $('#crop_x').val(c.x);
	            $('#crop_y').val(c.y);
	            $('#crop_w').val(c.w);
	            $('#crop_h').val(c.h);

	            if (parseInt(c.w) > 0) {
	                var rx = xsize / c.w;
	                var ry = ysize / c.h;

	                $pimg.css({
	                    width: Math.round(rx * boundx) + 'px',
	                    height: Math.round(ry * boundy) + 'px',
	                    marginLeft: '-' + Math.round(rx * c.x) + 'px',
	                    marginTop: '-' + Math.round(ry * c.y) + 'px'
	                });
	            }
	        };
	    }

	    var submitCrop = function (cropfile) {
	        $modal.modal('loading');
	        $.ajax({
	            url: rootUri + "Upload/ResizeImage",
	            data: {
	                x: $('#crop_x').val(),
	                y: $('#crop_y').val(),
	                w: $('#crop_w').val(),
	                h: $('#crop_h').val(),
	                imgpath: cropfile,
	                kind: isRecommend?"<%= UpImageCategory.RECOMMEND %>":"<%= UpImageCategory.CATALOG %>",
	                size: isRecommend?"<%= CropImageSizes.RECOMMEND %>":"<%= CropImageSizes.CATALOG %>"
	            },
	            type: "POST",
	            success: function (rst) {
	                $modal.modal('loading');
	                if (rst == "") {
	                    $modal.find('.modal-body')
		                    .prepend('<div class="alert alert-error fade in">' +
		                    '操作失败：原图不存在！<button type="button" class="close" data-dismiss="alert"></button>' +
		                    '</div>');
	                } else {
                        var filepath = rst;
	                    if(isRecommend) {
	                        $("#recommend_previewimg").attr("src", rootUri + filepath);
	                        $("#recommend_image").val(filepath);
                        } else {
                            if($('input.divimglist').length >= 4) {
                                toastr.options = {
	                                "closeButton": false,
	                                "debug": true,
	                                "positionClass": "toast-bottom-right",
	                                "onclick": null,
	                                "showDuration": "3",
	                                "hideDuration": "3",
	                                "timeOut": "3500",
	                                "extendedTimeOut": "1000",
	                                "showEasing": "swing",
	                                "hideEasing": "linear",
	                                "showMethod": "fadeIn",
	                                "hideMethod": "fadeOut"
	                            };

	                            toastr["error"]("商品图片能最大4片", "溫馨警告");

                                return;
                            }

                            var htmlstr = '<div style="margin:10px 0px;">' +
	                                '<input type="hidden" class="divimglist" value="' + filepath + '" />' +
	                                '<div style="float:left; padding:5px;">' +
	                                '<img src="' + rootUri + filepath + '" style="border:1px solid #ccc;" width="100px" height="100px" onmouseover="over_img(this)" onmouseout="out_img(this)" >' +
	                                '<a href="javascript:void(0);"><img src="<%= ViewData["rootUri"] %>content/img/imgdel.png" class="close_btn" onclick="removeMe(this, \'fname\')" onmouseover="over_close(this)" style="visibility:hidden; margin-top:-100px; margin-left:-10px; width:20px; height:20px;" onmouseout="out_close(this)"></a>' +
	                                '</div>'
	                            '</div>';

	                        $("#divimagelist").append(htmlstr)
                        }

	                    $modal.modal('hide');
	                }
	            }
	        });
	    }


    </script>
</asp:Content>
