using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DshFrontend.Models;
using DshFrontend.Models.Library;

namespace DshFrontend.Controllers
{
    public class SaleController : Controller
    {
        private SaleModel saleModel = new SaleModel();

        public ActionResult Sale()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "User";
            ViewData["level2nav"] = "";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);

            return View();
        }

        [AjaxOnly]
        public JsonResult RetrieveSaleList(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            byte status = 0;
            try { status = Convert.ToByte(Request.QueryString["status"]); }
            catch (Exception e) { }

            JqDataTableInfo rst = saleModel.GetSaleDataTable(param, Request.QueryString, rootUri, status);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

    }
}
