using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Configuration;
using DshFrontend.Models;
using DshFrontend.Models.Library;

namespace DshFrontend.Controllers
{
    public class UserController : Controller
    {
        private UserModel userModel = new UserModel();
        private SaleModel saleModel = new SaleModel();
        private EvalModel evalModel = new EvalModel();

        #region User
        [Authorize]
        public ActionResult Profile()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["rootUri"] = rootUri;

            ViewData["level1nav"] = "User";
            ViewData["level2nav"] = "";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);
            
            ViewData["backendUri"] = WebConfigurationManager.AppSettings["BackendUri"];

            long user_id = CommonModel.GetCurrentUserId();
            var userinfo = userModel.GetUserById(user_id);
            ViewData["userinfo"] = userinfo;
            ViewData["uid"] = userinfo.uid;

            return View();
        }

        [HttpPost]
        [AjaxOnly]
        public JsonResult SubmitUser(long uid, string userid, string username, string birthday, string email, string phonenum, string image)
        {
            string rst = "";

            if (uid == 0)
            {
                //rst = adminModel.InsertAdmin(username, userpwd, userrole);
            }
            else
            {
                rst = userModel.UpdateUser(uid, userid, username, birthday, email, phonenum, image);
            }

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [AjaxOnly]
        public JsonResult CheckUniqueUsername(long rid, string username)
        {
            bool rst = userModel.CheckDuplicateName(rid, username);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [AjaxOnly]
        public JsonResult CheckUniquePhonenum(long rid, string phonenum)
        {
            bool rst = userModel.CheckDuplicatePhonenum(rid, phonenum);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }
        
        #endregion

        #region Sale

        [Authorize]
        public ActionResult Sale()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "User";
            ViewData["level2nav"] = "";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);
            
            ViewData["backendUri"] = WebConfigurationManager.AppSettings["BackendUri"];

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

        [AjaxOnly]
        public JsonResult GetEvalInfo(long uid, long catalog_id)
        {
            long user_id = CommonModel.GetCurrentUserId();
            var rst = evalModel.GetEvalInfoBySaleId(uid, catalog_id);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        
        [AjaxOnly]
        [Authorize]
        public JsonResult SubmitEval(long uid, long sale_id, long catalog_id, int eval)
        {
            string rst = "";
            rst = evalModel.InsertOrUpdateEval(sale_id, catalog_id, eval);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult DeleteSale(string delids)
        {
            string[] ids = delids.Split(',');
            long[] selcheckbox = ids.Where(m => !String.IsNullOrWhiteSpace(m)).Select(m => long.Parse(m)).ToArray();
            bool rst = saleModel.DeleteSale(selcheckbox);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }
        #endregion
    }
}
