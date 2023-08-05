using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DshBackend.Models;
using DshBackend.Models.Library;

namespace DshBackend.Controllers
{
    public class CatalogController : Controller
    {
        private CatalogModel catalogModel = new CatalogModel();
        private ShopModel shopModel = new ShopModel();
        private KindModel kindModel = new KindModel();

        #region Extra Catalog

        [Authorize(Roles = "catalog")]
        public ActionResult ExtraCatalogList()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Catalog";
            ViewData["level2nav"] = "ExtraCatalogList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);

            ViewData["kindlist"] = kindModel.GetKindList();

            return View();
        }

        [Authorize(Roles = "catalog")]
        [AjaxOnly]
        public JsonResult RetrieveCatalogList(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            byte type = 0;
            try { type = Convert.ToByte(Request.QueryString["type"]); }
            catch (Exception e) { }

            long kind_id = 0;
            try { kind_id = Convert.ToByte(Request.QueryString["kindid"]); }
            catch (Exception e) { }

            //string search = Request.QueryString["search"];

            JqDataTableInfo rst = catalogModel.GetCatalogDataTable(param, Request.QueryString, rootUri, type, kind_id);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "catalog")]
        public ActionResult AddExtraCatalog()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Catalog";
            ViewData["level2nav"] = "ExtraCatalogList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "AddExtraCatalog", "", rootUri);

            ViewData["kindlist"] = kindModel.GetKindList();
            ViewData["shoplist"] = shopModel.GetShopList();
            ViewData["type"] = 0;

            return View();
        }

        [Authorize(Roles = "catalog")]
        public ActionResult EditExtraCatalog(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Catalog";
            ViewData["level2nav"] = "ExtraCatalogList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "EditExtraCatalog", "", rootUri);

            ViewData["kindlist"] = kindModel.GetKindList();
            ViewData["shoplist"] = shopModel.GetShopList();
            ViewData["type"] = 0;

            var cataloginfo = catalogModel.GetCatalogById(id);
            ViewData["cataloginfo"] = cataloginfo;
            ViewData["uid"] = cataloginfo.uid;
            ViewData["imagelist"] = catalogModel.GetCatalogImageListById(cataloginfo.uid);

            return View("AddExtraCatalog");
        }

        [Authorize(Roles = "catalog")]
        [HttpPost]
        public JsonResult DeleteCatalog(string delids)
        {
            string[] ids = delids.Split(',');
            long[] selcheckbox = ids.Where(m => !String.IsNullOrWhiteSpace(m)).Select(m => long.Parse(m)).ToArray();
            bool rst = catalogModel.DeleteCatalog(selcheckbox);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "catalog")]
        [HttpPost]
        [AjaxOnly]
        public JsonResult SubmitCatalog(long uid, long shop_id, string name, long kind_id, byte using_score, int? score_limit, byte back,
            int price, int profit, int extra, int count, string addr, string sale_desc, string show, string catalog_desc,
            string recommend, string recommend_image, string imagelist, byte type, string startdate, string enddate)
        {
            string rst = "";

            try
            {
                DateTime dtStart = DateTime.Parse(startdate);
                DateTime dtEnd = DateTime.Parse(enddate);

                if (dtStart > dtEnd)
                    return Json("选择的开始时间和截至时间不正确.", JsonRequestBehavior.AllowGet);
            } catch{
                return Json("选择的开始时间和截至时间不正确.", JsonRequestBehavior.AllowGet);
            }

            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            catalog_desc = catalog_desc.Replace("img%20src%3D%22/", "img%20src%3D%22" + rootUri);

            if (uid == 0)
            {
                rst = catalogModel.InsertCatalog(shop_id, name, kind_id, using_score, score_limit,
                    back, price, profit, extra, count, addr,
                    sale_desc, (byte)(show == "on" ? 1 : 0), catalog_desc, (byte)(recommend == "on" ? 1 : 0), recommend_image,
                    imagelist.Split(new char[] { ',' }), type, startdate, enddate);
            }
            else
            {
                rst = catalogModel.UpdateCatalog(uid, shop_id, name, kind_id, using_score, score_limit,
                    back, price, profit, extra, count, addr,
                    sale_desc, (byte)(show == "on" ? 1 : 0), catalog_desc, (byte)(recommend == "on" ? 1 : 0), recommend_image,
                    imagelist.Split(new char[] { ',' }), type, startdate, enddate);
            }

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [AjaxOnly]
        public JsonResult CheckUniqueCatalogname(long rid, string catalogname)
        {
            bool rst = catalogModel.CheckDuplicateCatalogName(rid, catalogname);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region General Catalog
        [Authorize(Roles = "catalog")]
        public ActionResult GeneralCatalogList()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Catalog";
            ViewData["level2nav"] = "GeneralCatalogList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);

            ViewData["kindlist"] = kindModel.GetKindList();

            return View();
        }

        [Authorize(Roles = "catalog")]
        public ActionResult AddGeneralCatalog()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Catalog";
            ViewData["level2nav"] = "GeneralCatalogList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "AddGeneralCatalog", "", rootUri);

            ViewData["kindlist"] = kindModel.GetKindList();
            ViewData["shoplist"] = shopModel.GetShopList();
            ViewData["type"] = 1;

            return View("AddExtraCatalog");
        }

        [Authorize(Roles = "catalog")]
        public ActionResult EditGeneralCatalog(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Catalog";
            ViewData["level2nav"] = "GeneralCatalogList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "EditGeneralCatalog", "", rootUri);

            ViewData["kindlist"] = kindModel.GetKindList();
            ViewData["shoplist"] = shopModel.GetShopList();
            ViewData["type"] = 1;

            var cataloginfo = catalogModel.GetCatalogById(id);
            ViewData["cataloginfo"] = cataloginfo;
            ViewData["uid"] = cataloginfo.uid;
            ViewData["imagelist"] = catalogModel.GetCatalogImageListById(cataloginfo.uid);

            return View("AddExtraCatalog");
        }
        #endregion


        #region TicketList
        [Authorize(Roles = "catalog")]
        public ActionResult TicketList()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Catalog";
            ViewData["level2nav"] = "TicketList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);

            return View();
        }

        [Authorize(Roles = "catalog")]
        public ActionResult OderDetail(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Catalog";
            ViewData["level2nav"] = "TicketList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);
            SaleModel salemodel = new SaleModel();
            var shopinfo =salemodel.GetSaleInfoById(id);
            ViewData["shopinfo"] = shopinfo;
            return View();
        }

        [Authorize(Roles = "catalog")]
        [AjaxOnly]
        public JsonResult RetrieveTicketList(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            JqDataTableInfo rst = catalogModel.GetTicketDataTable(param, Request.QueryString, rootUri);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        #endregion

        #region BackList
        [Authorize(Roles = "catalog")]
        public ActionResult BackList()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Catalog";
            ViewData["level2nav"] = "BackList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);

            return View();
        }

        [Authorize(Roles = "catalog")]
        [AjaxOnly]
        public JsonResult RetrieveBackList(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            JqDataTableInfo rst = catalogModel.GetBackDataTable(param, Request.QueryString, rootUri);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        #endregion
    }
}
