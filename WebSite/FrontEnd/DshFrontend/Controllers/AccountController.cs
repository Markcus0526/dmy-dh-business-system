using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

using DshFrontend.Models.Library;
using DshFrontend.Models;
namespace DshFrontend.Controllers
{
    public class AccountController : Controller
    {
        private AccountModel accountModel = new AccountModel();
        private UserModel userModel = new UserModel();


        [Authorize(Roles = "logon")]
        public ActionResult Index()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Account";
            ViewData["level2nav"] = "LogOn";

            return View();
        }

        public ActionResult LogOn(string returnUrl)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["rootUri"] = rootUri;
            ViewData["isUsingCaptcha"] = "none";
            ViewData["Message"] = "";

            if (User.Identity.IsAuthenticated)
            {
                return RedirectToAction("Main", "Home");
            }

            return View("LogOn");
        }

        [HttpPost]
        public ActionResult LogOn(LogOnModel model, string captcha, string isUsingCaptcha, string returnUrl)
        {
            ViewData["rootUri"] = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["base_url"] = ViewData["rootUri"] + "Account";           

            string addr = Request.UserHostAddress;

            if (isUsingCaptcha != null && isUsingCaptcha.CompareTo("inline") == 0)
            {
                if (captcha.ToUpper() != HttpContext.Session["captcha"].ToString())
                {
                    ViewData["isUsingCaptcha"] = "inline";

                    ModelState.AddModelError("modelerror", "您输入的验证码错误！");

                    return View("LogOn", model);
                }
                else
                    accountModel.UpdateFailedCount(addr, false);
            }
            
            ViewData["curdate"] = DateTime.Today.ToString("yyyy年MM月dd日");
            ViewData["isUsingCaptcha"] = "none";

            if (ModelState.IsValid)
            {
                var userInfo = accountModel.ValidateUser(model.UserName, CommonModel.GetMD5Hash(model.Password));
                if (userInfo != null)
                {
                    //accountModel.SetLoginInfo(userInfo.id, Request.UserHostAddress);
                    //string userRole = accountModel.GetRolesById(userInfo.role);

                    accountModel.UpdateFailedCount(addr, false);
                    FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(1,
                                userInfo.userid,
                                DateTime.Now,
                                DateTime.Now.AddMinutes(1440),
                                model.RememberMe == "on" ? true : false,
                                "|" + userInfo.uid,
                                FormsAuthentication.FormsCookiePath);

                    // Encrypt the ticket.
                    string encTicket = FormsAuthentication.Encrypt(ticket);

                    // Create the cookie.
                    Response.Cookies.Add(new HttpCookie(FormsAuthentication.FormsCookieName, encTicket));

                    userModel.InsertUserLog(userInfo.uid, Request.UserHostAddress);

                    if (!String.IsNullOrEmpty(returnUrl))
                    {
                        return Redirect(returnUrl);
                    }
                    else
                    {
                        return RedirectToAction("Main", "Home");
                    }
                }
                else
                {
                    /*var deluser = UserModel.GetDelUser(model.UserName, model.Password);

                    if (deluser != null)
                        ModelState.AddModelError("modelerror", "你帐号删除了");
                    else*/
                        ModelState.AddModelError("modelerror", "账号或密码错误，请重新输入");

                    int faildcount = accountModel.UpdateFailedCount(addr, true);
                    if (faildcount >= 3)
                        ViewData["isUsingCaptcha"] = "inline";
                }

                return View("LogOn", model);
            }
            else
            {
                ModelState.AddModelError("modelerror", "账号或密码错误，账号和密码必须要真写");
            }

            return View("LogOn", model);
        }

        public CaptchaResult GetCaptcha()
        {
            Captcha captcha = new Captcha();
            string captchaText = captcha.GenerateRandomText();

            HttpContext.Session.Add("captcha", captchaText);
            return new CaptchaResult(captchaText);
        }

        public ActionResult LogOff()
        {
            FormsAuthentication.SignOut();

            return RedirectToAction("LogOn", "Account");
        }

        public ActionResult Register()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["rootUri"] = rootUri;

            return View();
        }

        [AjaxOnly]
        public JsonResult CheckUniqueUsername(string username)
        {
            bool rst = userModel.CheckDuplicateName(0, username);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [AjaxOnly]
        public JsonResult CheckUniquePhonenum(string phonenum)
        {
            bool rst = userModel.CheckDuplicatePhonenum(0, phonenum);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [AjaxOnly]
        public JsonResult CheckRightVerifyCode(string phonenum, string verify_code)
        {
            bool rst = userModel.CheckRightVerifyCode(phonenum, verify_code);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [AjaxOnly]
        public JsonResult CheckVerifyCodeAvailable(string phonenum, string verify_code)
        {
            bool rst = userModel.CheckVerifyCodeAvailable(phonenum, verify_code);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        [AjaxOnly]
        public JsonResult SubmitPhonenum(string phonenum)
        {
            string rst = "";

            rst = userModel.InsertOrUpdatePhonenum(phonenum);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        [AjaxOnly]
        public JsonResult SubmitUser(string phonenum, string verify_code, string username, string userpwd)
        {
            string rst = "";

            rst = userModel.InsertUserByPhonenum(phonenum, username, userpwd);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        public ActionResult ChangePassword()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Account";
            ViewData["level2nav"] = "ChangePassword";
            long uid = CommonModel.GetCurrentUserId();
            ViewData["uid"] = uid;
            ViewData["userinfo"] = userModel.GetUserById(uid);

            return View();
        }

        [HttpPost]
        [AjaxOnly]
        public JsonResult SetPassword(long uid, string userpwd)
        {
            string rst = "";

            rst = userModel.UpdateUserPassword(uid, userpwd);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }
    }
}

