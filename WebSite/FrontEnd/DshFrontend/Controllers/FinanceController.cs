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
    public class FinanceController : Controller
    {
        private FinanceModel financeModel = new FinanceModel();


        #region Finance
        [Authorize]
        public ActionResult Index()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["rootUri"] = rootUri;
            ViewData["backendUri"] = WebConfigurationManager.AppSettings["BackendUri"];

            ViewData["level1nav"] = "Finance";
            ViewData["level2nav"] = "Index";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);

            return View();
        }

        [Authorize]
        public ActionResult CardType(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["rootUri"] = rootUri;
            ViewData["backendUri"] = WebConfigurationManager.AppSettings["BackendUri"];

            ViewData["level1nav"] = "Finance";
            ViewData["level2nav"] = "CardType";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);
            ViewData["cardtype"] = id;

            return View();
        }

        [Authorize]
        public ActionResult BuyCard(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["rootUri"] = rootUri;
            ViewData["backendUri"] = WebConfigurationManager.AppSettings["BackendUri"];

            ViewData["level1nav"] = "Finance";
            ViewData["level2nav"] = "BuyCard";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);
            
            int nType = 0;
            try { nType = Convert.ToInt32(Request.QueryString["cardtype"]); }
            catch (Exception e) { }
            
            ViewData["cardtype"] = nType;
            ViewData["cardid"] = id;
            ViewData["description"] = financeModel.GetCardDescription(id);

            return View();
        }

        [Authorize]
        public ActionResult BuyCard1(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["rootUri"] = rootUri;
            ViewData["backendUri"] = WebConfigurationManager.AppSettings["BackendUri"];

            ViewData["level1nav"] = "Finance";
            ViewData["level2nav"] = "BuyCard";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);

            int nType = 0;
            try { nType = Convert.ToInt32(Request.QueryString["cardtype"]); }
            catch (Exception e) { }

            ViewData["cardtype"] = nType;
            ViewData["cardid"] = id;
            ViewData["description"] = financeModel.GetCardDescription(id);

            return View();
        }

        [AjaxOnly]
        public JsonResult RetrieveCardTypeList(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            int nType = 0;
            try { nType = Convert.ToInt32(Request.QueryString["cardtype"]); }
            catch (Exception e) { }

            JqDataTableInfo rst = financeModel.GetCardTypeDataTable(param, Request.QueryString, rootUri, nType);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        [AjaxOnly]
        public JsonResult SubmitBuyCard(String name, String phonenum, String cardnum, String addr, String content, int cardtype, long cardid)
        {
            string rst = "";

            long user_id = CommonModel.GetCurrentUserId();
            rst = financeModel.InsertOrUpdateBuyCard(name, phonenum, cardnum, addr, content, cardtype, cardid, user_id);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        [AjaxOnly]
        public JsonResult SubmitBuyCard1(String org_name, String name, String cardnum, String phonenum, String org_user, String org_phonenum, String org_addr, String content, int cardtype, long cardid)
        {
            string rst = "";

            long user_id = CommonModel.GetCurrentUserId();
            rst = financeModel.InsertOrUpdateBuyCard1(org_name, name, cardnum, phonenum, org_user, org_phonenum, org_addr, content, cardtype, cardid, user_id);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }
        #endregion
    }
}
