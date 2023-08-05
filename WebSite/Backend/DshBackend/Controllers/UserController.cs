using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Configuration;
using DshBackend.Models;
using DshBackend.Models.Library;

namespace DshBackend.Controllers
{
    public class UserController : Controller
    {
        //
        // GET: /User/

        public UserModel usermodel = new UserModel();
        public ActionResult Index()
        {
            return View();
        }

        [Authorize(Roles = "User")]
        public ActionResult UserList()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "User";
            ViewData["level2nav"] = "";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);
            
            ViewData["frontend"] = WebConfigurationManager.AppSettings["FrontendUri"];

            return View();
        }

        [Authorize(Roles = "User")]
        [AjaxOnly]
        public JsonResult RetrieveUserList(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            JqDataTableInfo rst = usermodel.GetUserDataTable(param, Request.QueryString, rootUri);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "User")]
        public ActionResult EditUser(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            
            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "User";
            ViewData["level2nav"] = "";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "EditUser", "", rootUri);

            ViewData["frontend"] = WebConfigurationManager.AppSettings["FrontendUri"];

            var userinfo = usermodel.GetUserInfoById(id);
            ViewData["userinfo"] = userinfo;
            ViewData["uid"] = userinfo.uid;
            //ViewData["config"] = SystemModel.GetMailConfig();

            return View("EditUser");
        }

        [AjaxOnly]
        public JsonResult CheckUniqueUserid(string userid)
        {
            bool rst = usermodel.CheckDuplicateId(userid);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "User")]
        [HttpPost]
        [AjaxOnly]
        public JsonResult SubmitUser(long uid, string username, string birthday, string userid, string email, string score, string image)
        {
            string rst = "";

            rst = usermodel.UpdateUser(uid, username, birthday, userid, email, score, image);
            

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "User")]
        [HttpPost]
        public JsonResult DeleteUser(string delids)
        {
            string[] ids = delids.Split(',');
            long[] selcheckbox = ids.Where(m => !String.IsNullOrWhiteSpace(m)).Select(m => long.Parse(m)).ToArray();
            bool rst = usermodel.DeleteUser(selcheckbox);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

    }
}
