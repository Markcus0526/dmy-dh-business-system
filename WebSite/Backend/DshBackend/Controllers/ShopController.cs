using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DshBackend.Models;
using DshBackend.Models.Library;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DshBackend.Controllers
{
    public class ShopController : Controller
    {
        private SaleModel saleModel = new SaleModel();
        private OtherpayModel otherpayModel = new OtherpayModel();

        #region Admin Shop
        [Authorize(Roles = "shop")]
        public ActionResult ShopList()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Shop";
            ViewData["level2nav"] = "";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);

            return View();
        }
        #endregion

        #region Sale

        [Authorize(Roles = "ownshop")]
        public ActionResult SaleList()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Sale";
            ViewData["level2nav"] = "Sale";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);

            long user_id = CommonModel.GetCurrentUserId();
            DateTime start = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            DateTime end = DateTime.Now;
            ViewData["total_money"] = saleModel.GetTotalMoneyByShopId(user_id, start, end);
            ViewData["total_extra"] = saleModel.GetTotalExtraByShopId(user_id, start, end);

            return View();
        }

        [Authorize(Roles = "ownshop")]
        [AjaxOnly]
        public JsonResult GetTotalMoney(string start, string end)
        {
            long user_id = CommonModel.GetCurrentUserId();
            DateTime starttime = Convert.ToDateTime(start);
            DateTime endtime = Convert.ToDateTime(end);
            var total_money = saleModel.GetTotalMoneyByShopId(user_id, starttime, endtime);
            var total_extra = saleModel.GetTotalExtraByShopId(user_id, starttime, endtime);

            return Json(new { total_money = total_money, total_extra = total_extra }, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "ownshop")]
        [AjaxOnly]
        public JsonResult RetrieveSaleList(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            
            DateTime start = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            if (Request.QueryString["start"] != null)
                start = Convert.ToDateTime(Request.QueryString["start"]);

            DateTime end = DateTime.Now;
            if (Request.QueryString["end"] != null)
                end = Convert.ToDateTime(Request.QueryString["end"]);

            JqDataTableInfo rst = saleModel.GetOwnSaleDataTable(param, Request.QueryString, rootUri, start, end);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region Shoppay
        [Authorize(Roles = "ownshop")]
        public ActionResult ShoppayList()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Shoppay";
            ViewData["level2nav"] = "Shoppay";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);

            DateTime start = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            DateTime end = DateTime.Now;
            ViewData["total_gain"] = otherpayModel.GetTotalShopGain(start, end);
            ViewData["total_pay"] = otherpayModel.GetTotalShopPay(start, end);

            return View();
        }

        [Authorize(Roles = "ownshop")]
        [AjaxOnly]
        public JsonResult GetTotalShoppay(string start, string end)
        {
            DateTime starttime = Convert.ToDateTime(start);
            DateTime endtime = Convert.ToDateTime(end);
            var total_gain = otherpayModel.GetTotalShopGain(starttime, endtime);
            var total_pay = otherpayModel.GetTotalShopPay(starttime, endtime);

            return Json(new { total_gain = total_gain, total_pay = total_pay }, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "ownshop")]
        [AjaxOnly]
        public JsonResult RetrieveShoppayList(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            byte type = 2;
            if (Request.QueryString["type"] != null)
                type = Convert.ToByte(Request.QueryString["type"]);

            byte real = 0;
            try { real = Convert.ToByte(Request.QueryString["real"]); }
            catch (Exception e) { }

            DateTime start = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            if (Request.QueryString["start"] != null)
                start = Convert.ToDateTime(Request.QueryString["start"]);

            DateTime end = DateTime.Now;
            if (Request.QueryString["end"] != null)
                end = Convert.ToDateTime(Request.QueryString["end"]);

            JqDataTableInfo rst = otherpayModel.GetShoppayDataTable(param, Request.QueryString, rootUri, type, real, start, end);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "ownshop")]
        public ActionResult AddShoppay()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Shoppay";
            ViewData["level2nav"] = "Shoppay";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "AddShoppay", "", rootUri);

            return View();
        }

        [Authorize(Roles = "ownshop")]
        public ActionResult EditShoppay(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Shoppay";
            ViewData["level2nav"] = "Shoppay";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "EditShoppay", "", rootUri);

            var payinfo = otherpayModel.GetShoppayById(id);
            ViewData["payinfo"] = payinfo;
            ViewData["uid"] = payinfo.uid;

            return View("AddShoppay");
        }

        [Authorize(Roles = "ownshop")]
        [HttpPost]
        [AjaxOnly]
        public JsonResult SubmitShoppay(long uid, byte type, string name, string phonenum, string reason, int price, int? real_price)
        {
            string rst = "";

            if (uid == 0)
            {
                rst = otherpayModel.InsertShoppay(type, name, phonenum, reason, price, real_price);
            }
            else
            {
                rst = otherpayModel.UpdateShoppay(uid, type, name, phonenum, reason, price, real_price);
            }

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "ownshop")]
        [HttpPost]
        public JsonResult DeleteShoppay(string delids)
        {
            string[] ids = delids.Split(',');
            long[] selcheckbox = ids.Where(m => !String.IsNullOrWhiteSpace(m)).Select(m => long.Parse(m)).ToArray();
            bool rst = otherpayModel.DeleteShoppay(selcheckbox);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region Ticket

        [Authorize(Roles = "ownshop")]
        public ActionResult TicketList()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Ticket";
            ViewData["level2nav"] = "Ticket";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);

            return View();
        }

        [Authorize(Roles = "ownshop")]
        [AjaxOnly]
        public JsonResult RetrieveTicketList(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            byte identify = 3;
            if (Request.QueryString["identify"] != null)
                identify = Convert.ToByte(Request.QueryString["identify"]);

            JqDataTableInfo rst = saleModel.GetOwnTicketDataTable(param, Request.QueryString, rootUri, identify);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "ownshop")]
        [HttpPost]
        public JsonResult DeleteTicket(string delids)
        {
            string[] ids = delids.Split(',');
            long[] selcheckbox = ids.Where(m => !String.IsNullOrWhiteSpace(m)).Select(m => long.Parse(m)).ToArray();
            bool rst = saleModel.DeleteTicket(selcheckbox);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "ownshop")]
        [HttpPost]
        public JsonResult IdentifyTicket(string delids, byte identify)
        {
            string[] ids = delids.Split(',');
            long[] selcheckbox = ids.Where(m => !String.IsNullOrWhiteSpace(m)).Select(m => long.Parse(m)).ToArray();
            bool rst = saleModel.IdentifyTicket(selcheckbox, identify);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public void ExportTicketList(byte identify)
        {

            DateTime starttime = DateTime.Now.AddDays(-DateTime.Now.Day);
            
            var datalist = saleModel.ExportTicketInfoList(identify);
            var grid = new GridView();

            grid.DataSource = datalist;
            grid.DataBind();

            Response.ClearContent();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment; filename=订单查询_" + String.Format("{0:yyyy-MM-dd_HHmmss}", DateTime.Now) + ".xls");
            Response.ContentType = "application/ms-excel";
            Response.Charset = "UTF-8";

            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);

            //Response.ContentEncoding = Encoding.UTF8;

            Response.ContentEncoding = System.Text.Encoding.Unicode;
            Response.BinaryWrite(System.Text.Encoding.Unicode.GetPreamble());

            grid.RenderControl(htw);

            Response.Output.Write(sw.ToString());
            Response.Flush();
            Response.End();
        }
        #endregion

        #region changepassword

        [Authorize(Roles = "ownshop")]
        public ActionResult ChangePwd()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "";
            ViewData["level2nav"] = "";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);
            ShopModel shopmodel = new ShopModel();

            ViewData["userinfo"] = shopmodel.GetShopById(CommonModel.GetCurrentUserId());

            return View();
        }

        [HttpPost]
        [AjaxOnly]
        public JsonResult SetChangePwd(string userpwd)
        {
            ShopModel shopmodel = new ShopModel();
            bool rst = shopmodel.ChangePwd(CommonModel.GetCurrentUserId(), userpwd);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }
        #endregion

    }
}
