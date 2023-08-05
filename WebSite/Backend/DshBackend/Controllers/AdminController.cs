using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DshBackend.Models;
using DshBackend.Models.Library;

namespace DshBackend.Controllers
{
    public class AdminController : Controller
    {
        private AdminModel adminModel = new AdminModel();
        private ShopModel shopModel = new ShopModel();
        private KindModel kindModel = new KindModel();

        #region Admin
        [Authorize(Roles = "admin")]
        public ActionResult AdminList()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "AdminList";
            ViewData["level2nav"] = "";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);

            return View();
        }

        [Authorize(Roles = "admin")]
        [AjaxOnly]
        public JsonResult RetrieveAdminList(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            JqDataTableInfo rst = adminModel.GetAdminDataTable(param, Request.QueryString, rootUri);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "admin")]
        public ActionResult AddAdmin()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "AdminList";
            ViewData["level2nav"] = "";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "AddAdmin", "", rootUri);
            ViewData["rolelist"] = adminModel.GetAdminRoleList();
            //ViewData["config"] = SystemModel.GetMailConfig();

            return View();
        }

        [Authorize(Roles = "admin")]
        public ActionResult EditAdmin(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "AdminList";
            ViewData["level2nav"] = "";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "EditAdmin", "", rootUri);
            ViewData["rolelist"] = adminModel.GetAdminRoleList();

            var userinfo = adminModel.GetAdminById(id);
            ViewData["userinfo"] = userinfo;
            ViewData["uid"] = userinfo.uid;

            return View("AddAdmin");
        }

        [Authorize(Roles = "admin")]
        [HttpPost]
        public JsonResult DeleteAdmin(string delids)
        {
            string[] ids = delids.Split(',');
            long[] selcheckbox = ids.Where(m => !String.IsNullOrWhiteSpace(m)).Select(m => long.Parse(m)).ToArray();

            long user_id = CommonModel.GetCurrentUserId();
            if(selcheckbox.Contains(user_id))
                return Json(false, JsonRequestBehavior.AllowGet);

            bool rst = adminModel.DeleteAdmin(selcheckbox);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "admin")]
        [HttpPost]
        [AjaxOnly]
        public JsonResult SubmitAdmin(long uid, string username, string userpwd, long userrole)
        {
            string rst = "";

            if (uid == 0)
            {
                rst = adminModel.InsertAdmin(username, userpwd, userrole);
            }
            else
            {
                rst = adminModel.UpdateAdmin(uid, username, userpwd, userrole);
            }

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [AjaxOnly]
        public JsonResult CheckUniqueAdminname(long rid, string username)
        {
            bool rst = adminModel.CheckDuplicateName(rid, username);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        //[Authorize(Roles = "role")]
        public ActionResult ChangePwd()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "ChangePwd";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), "", "", "", rootUri);

            ViewData["uid"] = CommonModel.GetCurrentUserId();

            return View();
        }

        //[Authorize(Roles = "role")]
        [HttpPost]
        [AjaxOnly]
        public JsonResult SetChangePwd(string userpwd)
        {
            string rst = "";
            long nId = 0;

            try
            {
                nId = CommonModel.GetCurrentUserId();
            }
            catch (System.Exception ex)
            {
                CommonModel.WriteLogFile("AdminController", "SetChangePwd()", ex.ToString());
            }
            rst = adminModel.UpdatePwd(nId, userpwd);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        #endregion

        #region UserRole
        [Authorize(Roles = "basedata,role")]
        public ActionResult RoleList()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Admin";
            ViewData["level2nav"] = "RoleList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);
            //ViewData["config"] = SystemModel.GetMailConfig();

            return View();
        }

        [Authorize(Roles = "basedata,role")]
        [AjaxOnly]
        public JsonResult RetrieveRoleList(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            JqDataTableInfo rst = adminModel.GetRoleDataTable(param, Request.QueryString, rootUri);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "basedata,role")]
        public ActionResult AddRole()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Admin";
            ViewData["level2nav"] = "RoleList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "AddRole", "", rootUri);

            return View();
        }

        [Authorize(Roles = "basedata,role")]
        public ActionResult EditRole(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Admin";
            ViewData["level2nav"] = "RoleList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "EditRole", "", rootUri);

            var roleinfo = adminModel.GetRoleById(id);
            ViewData["roleinfo"] = roleinfo;
            ViewData["uid"] = roleinfo.uid;
            ViewData["role"] = roleinfo.roledata;

            return View("AddRole");
        }

        [Authorize(Roles = "basedata,role")]
        [HttpPost]
        public JsonResult DeleteRole(string delids)
        {
            string[] ids = delids.Split(',');
            long[] selcheckbox = ids.Where(m => !String.IsNullOrWhiteSpace(m)).Select(m => long.Parse(m)).ToArray();
            bool rst = adminModel.DeleteRole(selcheckbox);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "basedata,role")]
        [HttpPost]
        [AjaxOnly]
        public JsonResult SubmitRole(long uid, string rolename, string[] configuration)
        {
            string rst = "";

            string role = "";

            if (configuration != null)
            {
                role = String.Join(",", configuration);
            }

            if (uid == 0)
            {
                rst = adminModel.InsertRole(rolename, role);
            }
            else
            {
                rst = adminModel.UpdateRole(uid, rolename, role);
            }

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [AjaxOnly]
        public JsonResult CheckUniqueRolename(long rid, string rolename)
        {
            bool rst = adminModel.CheckDuplicateRoleName(rid, rolename);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region Shop
        [Authorize(Roles = "basedata, shop")]
        public ActionResult ShopList()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Admin";
            ViewData["level2nav"] = "ShopList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);
            
            return View();
        }

        [Authorize(Roles = "basedata, shop")]
        [AjaxOnly]
        public JsonResult RetrieveShopList(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            JqDataTableInfo rst = shopModel.GetShopDataTable(param, Request.QueryString, rootUri);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "basedata, shop")]
        [AjaxOnly]
        public JsonResult CheckUniqueShopname(long rid, string shopname)
        {
            bool rst = shopModel.CheckDuplicateShopName(rid, shopname);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "basedata, shop")]
        public ActionResult AddShop()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Admin";
            ViewData["level2nav"] = "ShopList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "AddShop", "", rootUri);

            var provincelist = RegionModel.GetProvinceList();

            ViewData["provinces"] = provincelist;
            if (provincelist != null && provincelist.Count > 0)
            {
                var cities = RegionModel.GetCityList(provincelist.ElementAt(0).uid);
                if (cities == null || cities.Count() == 0)
                    cities = new List<tbl_ecsregion>(provincelist.Take(1));
                ViewData["cities"] = cities;

                var districts = RegionModel.GetDistrictList(cities.ElementAt(0).uid);
                if (districts != null && districts.Count() > 0)
                    ViewData["districts"] = districts;
                else
                    ViewData["districts"] = new List<tbl_ecsregion>(cities.Take(1));
            }
            return View();
        }

        [Authorize(Roles = "basedata, shop")]
        public ActionResult EditShop(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Admin";
            ViewData["level2nav"] = "ShopList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "EditShop", "", rootUri);

            var shopinfo = shopModel.GetShopById(id);
            ViewData["shopinfo"] = shopinfo;
            ViewData["uid"] = shopinfo.uid;


            var districtinfo = RegionModel.GetRegionInfo(shopinfo.regionid);
            var cityinfo = new tbl_ecsregion();
            var provininfo = new tbl_ecsregion();
            if (districtinfo != null)
            {
                cityinfo = RegionModel.GetRegionInfo(districtinfo.parentid);
                if (cityinfo != null)
                {
                    provininfo = RegionModel.GetRegionInfo(cityinfo.parentid);
                    if (provininfo == null)
                        provininfo = cityinfo;
                }
                else
                {
                    cityinfo = districtinfo;
                    provininfo = districtinfo;
                }
            }
            if (cityinfo != null)
                ViewData["hallcity"] = cityinfo.uid;
            if (provininfo != null)
                ViewData["hallprovince"] = provininfo.uid;


            var provincelist = RegionModel.GetProvinceList();
            ViewData["provinces"] = provincelist;
            if (provincelist != null && provincelist.Count() > 0)
            {
                if (provininfo != null)
                {
                    var cities = RegionModel.GetCityList(provininfo.uid);
                    if (cities != null && cities.Count() > 0)
                    {
                        ViewData["cities"] = cities;
                        var districts = RegionModel.GetDistrictList(cityinfo.uid);
                        if (districts != null && districts.Count() > 0)
                            ViewData["districts"] = districts;
                        else
                            ViewData["districts"] = new List<tbl_ecsregion>(cities.Take(1));
                    }
                    else
                    {
                        ViewData["cities"] = new List<tbl_ecsregion>(provincelist.Take(1));
                        ViewData["districts"] = new List<tbl_ecsregion>(provincelist.Take(1));
                    }
                }
            }
            return View("AddShop");
        }

        [Authorize(Roles = "basedata, shop")]
        [HttpPost]
        public JsonResult DeleteShop(string delids)
        {
            string[] ids = delids.Split(',');
            long[] selcheckbox = ids.Where(m => !String.IsNullOrWhiteSpace(m)).Select(m => long.Parse(m)).ToArray();
            bool rst = shopModel.DeleteShop(selcheckbox);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "basedata, shop")]
        [HttpPost]
        [AjaxOnly]
        public JsonResult SubmitShop(long uid, string shopid, string password, string province, string city, string district,
            string shopname, string addr, string phonenum, string bank, string counterid, string bankid)
        {
            string rst = "";

            if (uid == 0)
            {
                rst = shopModel.InsertShop(shopid, password, province, city, district, shopname, addr, phonenum, bank, counterid, bankid);
            }
            else
            {
                rst = shopModel.UpdateShop(uid, shopid, password, province, city, district, shopname, addr, phonenum, bank, counterid, bankid);
            }

            return Json(rst, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region Kind
        [Authorize(Roles = "basedata")]
        public ActionResult KindList()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Admin";
            ViewData["level2nav"] = "KindList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);

            return View();
        }

        [Authorize(Roles = "basedata")]
        [AjaxOnly]
        public JsonResult RetrieveKindList(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            JqDataTableInfo rst = kindModel.GetKindDataTable(param, Request.QueryString, rootUri);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "basedata")]
        public ActionResult AddKind()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Admin";
            ViewData["level2nav"] = "KindList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "AddKind", "", rootUri);

            return View();
        }

        [Authorize(Roles = "basedata")]
        public ActionResult EditKind(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Admin";
            ViewData["level2nav"] = "KindList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "EditKind", "", rootUri);

            var kindinfo = kindModel.GetKindById(id);
            ViewData["kindinfo"] = kindinfo;
            ViewData["uid"] = kindinfo.uid;

            return View("AddKind");
        }

        [Authorize(Roles = "basedata")]
        [HttpPost]
        public JsonResult DeleteKind(string delids)
        {
            string[] ids = delids.Split(',');
            long[] selcheckbox = ids.Where(m => !String.IsNullOrWhiteSpace(m)).Select(m => long.Parse(m)).ToArray();
            bool rst = kindModel.DeleteKind(selcheckbox);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "basedata")]
        [HttpPost]
        [AjaxOnly]
        public JsonResult SubmitKind(long uid, string kindname, string image)
        {
            string rst = "";

            if (uid == 0)
            {
                rst = kindModel.InsertKind(kindname, image);
            }
            else
            {
                rst = kindModel.UpdateKind(uid, kindname, image);
            }

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [AjaxOnly]
        public JsonResult CheckUniqueKindname(long rid, string kindname)
        {
            bool rst = kindModel.CheckDuplicateKindName(rid, kindname);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }
        #endregion
    }
}
