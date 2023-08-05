using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DshBackend.Models;
using DshBackend.Models.Library;

namespace DshBackend.Controllers
{
    public class DeviceController : Controller
    {
        private DeviceModel deviceModel = new DeviceModel();

        #region Device

        [Authorize(Roles = "device")]
        public ActionResult DeviceList()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Device";
            ViewData["level2nav"] = "DeviceList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);
            
            return View();
        }

        [Authorize(Roles = "device")]
        [AjaxOnly]
        public JsonResult RetrieveDeviceList(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            JqDataTableInfo rst = deviceModel.GetDeviceDataTable(param, Request.QueryString, rootUri);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "device")]
        public ActionResult AddDevice()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Device";
            ViewData["level2nav"] = "DeviceList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "AddDevice", "", rootUri);

            ViewData["datetime"] = String.Format("{0:yyyy-MM-dd}", DateTime.Now);

            return View();
        }

        [Authorize(Roles = "device")]
        public ActionResult EditDevice(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Device";
            ViewData["level2nav"] = "DeviceList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "EditDevice", "", rootUri);
            
            var deviceinfo = deviceModel.GetDeviceById(id);
            ViewData["deviceinfo"] = deviceinfo;
            ViewData["uid"] = deviceinfo.uid;
            ViewData["imagelist"] = deviceModel.GetDeviceImageListById(deviceinfo.uid);
            ViewData["datetime"] = String.Format("{0:yyyy-MM-dd}", deviceinfo.regtime);

            return View("AddDevice");
        }

        [Authorize(Roles = "device")]
        [HttpPost]
        public JsonResult DeleteDevice(string delids)
        {
            string[] ids = delids.Split(',');
            long[] selcheckbox = ids.Where(m => !String.IsNullOrWhiteSpace(m)).Select(m => long.Parse(m)).ToArray();
            bool rst = deviceModel.DeleteDevice(selcheckbox);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "device")]
        [HttpPost]
        [AjaxOnly]
        public JsonResult SubmitDevice(long uid, string name, string description, string imagelist)
        {
            string rst = "";

            if (uid == 0)
            {
                rst = deviceModel.InsertDevice(name, description, imagelist.Split(new char[] { ',' }));
            }
            else
            {
                rst = deviceModel.UpdateDevice(uid, name, description, imagelist.Split(new char[] { ',' }));
            }

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [AjaxOnly]
        public JsonResult CheckUniqueDevicename(long rid, string devicename)
        {
            bool rst = deviceModel.CheckDuplicateDeviceName(rid, devicename);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }
        #endregion
    }
}
