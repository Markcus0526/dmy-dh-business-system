using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DshFrontend.Models;
using DshFrontend.Models.Library;
using System.Web.Configuration;

namespace DshFrontend.Controllers
{
    public class GoodsController : Controller
    {
        SaleModel salemodel = new SaleModel();

        private static int[] CurPageNumList;
        private static long[] TabIdList;
        private static String SearchText;

        #region Goods
        [Authorize]
        public ActionResult Goods()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["rootUri"] = rootUri;
            ViewData["backendUri"] = WebConfigurationManager.AppSettings["BackendUri"];

            ViewData["level1nav"] = "Goods";
            ViewData["level2nav"] = "Goods";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);
            ViewData["goodstype"] = 1;
            ViewData["cataloglist"] = CatalogModel.GetCatalogsFirstPageList(1, "");

            List<tbl_kind> kindlist = CatalogModel.GetKindList();
            ViewData["kindlist"] = kindlist;
            int count = kindlist.Count;
            CurPageNumList = new int[count];
            TabIdList = new long[count];

            for (int i = 0; i < count; i++)
            {
                CurPageNumList[i] = 0;
                TabIdList[i] = kindlist.ElementAt(i).uid;
            }

            SearchText = "";

            return View();
        }

        [Authorize]
        public ActionResult Favour()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["rootUri"] = rootUri;
            ViewData["backendUri"] = WebConfigurationManager.AppSettings["BackendUri"];

            ViewData["level1nav"] = "Goods";
            ViewData["level2nav"] = "Favour";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);
            ViewData["goodstype"] = 0;
            ViewData["cataloglist"] = CatalogModel.GetCatalogsFirstPageList(0, "");

            List<tbl_kind> kindlist = CatalogModel.GetKindList();
            ViewData["kindlist"] = kindlist;
            int count = kindlist.Count;
            CurPageNumList = new int[count];
            TabIdList = new long[count];

            for (int i = 0; i < count; i++)
            {
                CurPageNumList[i] = 0;
                TabIdList[i] = kindlist.ElementAt(i).uid;
            }

            SearchText = "";

            return View("Goods");
        }

        public JsonResult GetRatingList(int tabnum, int pagenum, int type)
        {
            var rst = EvalModel.GetCatalogRatingList(CatalogModel.GetKindList().ElementAt(tabnum).uid, pagenum, type, SearchText);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetMoreDataFromServer(int tabnum, int type)
        {
            CurPageNumList[tabnum]++;

            string resp = string.Empty;
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            List<GoodsCatalogList> reslist = CatalogModel.GetCatalogListWithKindPagenum(TabIdList[tabnum], CurPageNumList[tabnum], type, SearchText);

            if (reslist != null)
            {

                for (int i = 0; i < reslist.Count; i++)
                {
                    GoodsCatalogList item = reslist.ElementAt(i);

                    resp += "<li align='center'>";
                    resp += "<a href='" + rootUri + "Goods/ShowGoods/" + reslist.ElementAt(i).uid +"'><img src='" + rootUri + item.image + "' width='137' height='137' /></a>";
                    resp += "<h4 style='margin-top:10px'>"+item.name+"</h4>";
                    resp += "<p style='margin-top:10px'><div style='color: #c90000; text-align: left; float: left; margin-left: 20px;'>¥"+item.price+"</div><div style='color: #dfa300; text-align: right; margin-right: 20px;'>"+item.buy_count+"人贷款</div></p>";
                    resp += "<p style='margin-top:10px; margin-left:10px; margin-right:10px; height:40px;'><span>" + item.sale_desc + "</span></p>";
                    resp += "<div class='rating herating' id='rating-"+tabnum+"-"+CurPageNumList[tabnum]+"-"+i+"'></div>";
                    resp += "</li>";
                }

            }
            else
                resp = "";

            return Json(resp, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetFirstPagesWithSearchText(int type, String search_txt, int cur_tab)
        {
            SearchText = search_txt;

            int j;

            string result_str = string.Empty;

            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            for (j = 0; j < TabIdList.Count(); j++)
            {
                CurPageNumList[j] = 0;

                if ( j != cur_tab )
                    result_str += "<div id='edit-"+j+"' class='tab-pane'>";
                else
                    result_str += "<div id='edit-" + j + "' class='tab-pane in active'>";
                result_str += "<div class='bigmid' id='mainDiv-"+j+"' style='height: 550px; overflow: scroll;'>";
                result_str += "<div class='exchangelist' id='wrapperDiv-" + j + "' style='padding-left: 15px;'>";
                result_str += "<ul class='clear'>";
                


                string resp = string.Empty;
                List<GoodsCatalogList> reslist = CatalogModel.GetCatalogListWithKindPagenum(TabIdList[j], CurPageNumList[j], type, SearchText);
                if (reslist != null)
                {
                    for (int i = 0; i < reslist.Count; i++)
                    {
                        GoodsCatalogList item = reslist.ElementAt(i);

                        resp += "<li align='center'>";
                        resp += "<a href='" + rootUri + "Goods/ShowGoods/" + reslist.ElementAt(i).uid + "'><img src='" + rootUri + item.image + "' width='137' height='137' /></a>";
                        resp += "<h4 style='margin-top:10px'>" + item.name + "</h4>";
                        resp += "<p style='margin-top:10px'><div style='color: #c90000; text-align: left; float: left; margin-left: 20px;'>¥" + item.price + "</div><div style='color: #dfa300; text-align: right; margin-right: 20px;'>" + item.buy_count + "人贷款</div></p>";
                        resp += "<p style='margin-top:10px; margin-left:10px; margin-right:10px; height:40px;'><span>" + item.sale_desc + "</span></p>";
                        resp += "<div class='rating herating' id='rating-" + j + "-" + CurPageNumList[j] + "-" + i + "'></div>";
                        resp += "</li>";
                    }
                }
                else
                    resp = "";

                result_str += resp;
                result_str += "</ul></div></div></div>";
            }

            return Json(result_str, JsonRequestBehavior.AllowGet);
        }

        /*[AjaxOnly]
        public JsonResult RetrieveUserList(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            JqDataTableInfo rst = userModel.GetUserDataTable(param, Request.QueryString, rootUri);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }*/

        [Authorize]
        public ActionResult ShowGoods(long id)
        {
            long user_id = CommonModel.GetCurrentUserId();
            if(salemodel.IsCatalogOnSale(id, user_id))
                return RedirectToAction("BuyGoods", "Goods", new { id = id });

            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["rootUri"] = rootUri;

            ViewData["level1nav"] = "Goods";
            ViewData["level2nav"] = "ShowGoods";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);

            CatalogModel catalogModel = new CatalogModel();
            EvalModel evalmodel = new EvalModel();
            ViewData["cataloginfo"] = catalogModel.GetCatalogById(id);
            ViewData["phonenum"] = salemodel.GetShopPhonenum(((tbl_catalog)ViewData["cataloginfo"]).shopid);
            ViewData["eval"] = EvalModel.GetCatalogEval(id);

            ViewData["backendUri"] = WebConfigurationManager.AppSettings["BackendUri"];
            return View();
        }

        [Authorize]
        public ActionResult BuyGoods(long id)
        {
            salemodel.InsertSaleCatalog(id);

            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["rootUri"] = rootUri;

            ViewData["level1nav"] = "Goods";
            ViewData["level2nav"] = "BuyGoods";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);

            CatalogModel catalogModel = new CatalogModel();
            ViewData["cataloginfo"] = catalogModel.GetCatalogById(id);
            ViewData["price"] = ((tbl_catalog)ViewData["cataloginfo"]).price;
            ViewData["using_score"] = (((tbl_catalog)ViewData["cataloginfo"]).using_score == 1) ? "" : "disabled";

            ViewData["uid"] = id;
            String phonenum = CommonModel.GetCurrentUserPhonenum();


            String no_data = "";
            for (int i = 0; i < phonenum.Length - 7; i++)
            {
                no_data += "*";
            }

            ViewData["phonenum"] = phonenum.Substring(0, 3) + no_data + phonenum.Substring(phonenum.Length - 4, 4); 

            return View();
        }

        [HttpPost]
        [AjaxOnly]
        public JsonResult BuyCatalog(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["rootUri"] = rootUri;
           
            salemodel.InsertSaleCatalog(id);

            return Json("", JsonRequestBehavior.AllowGet);
        }

        [Authorize]
        public ActionResult Paying(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["rootUri"] = rootUri;

            ViewData["level1nav"] = "Goods";
            ViewData["level2nav"] = "Paying";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);

            return View();
        }

        [Authorize]
        public ActionResult Validation(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["rootUri"] = rootUri;

            ViewData["level1nav"] = "Goods";
            ViewData["level2nav"] = "Validation";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);

            return View();
        }

        [HttpPost]
        [AjaxOnly]
        public JsonResult SubmitSale(long uid, int count, string paytype, string using_score, string score, int buy)
        {
            string rst = "";

            byte using_score_flag = (byte)(using_score == "on" ? 1 : 0);
            int score_data = 0;
            int status = 0;

            long userid = CommonModel.GetCurrentUserId();

            if (buy == 0)
            {
                if (using_score_flag == 1)
                {
                    score_data = int.Parse(score);
                    status = salemodel.CheckScore(userid, uid, score_data, count);
                }

                if (status == 0)
                    status = salemodel.CheckCount(uid, count);

                if (status == 0)
                   salemodel.InsertSaleData(uid, score_data, count, int.Parse(paytype), using_score_flag);
            }
            else
            {
                salemodel.DeleteSale(uid);
            }

            return Json(status, JsonRequestBehavior.AllowGet);
        }

        #endregion
    }
}
