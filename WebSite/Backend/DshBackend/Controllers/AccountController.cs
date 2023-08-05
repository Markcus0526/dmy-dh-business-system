using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

using DshBackend.Models.Library;
using DshBackend.Models;
namespace DshBackend.Controllers
{
    public class AccountController : Controller
    {
        private AccountModel accountModel = new AccountModel();


        [Authorize(Roles = "logon")]
        public ActionResult Index()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Account";
            ViewData["level2nav"] = "Account";

            return View();
        }

        public ActionResult LogOn(string returnUrl)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["rootUri"] = rootUri;
            ViewData["isUsingCaptcha"] = "none";

            if (User.Identity.IsAuthenticated)
            {
                return RedirectToAction(CommonModel.GetFirstActionResultForRole(), CommonModel.GetFirstActionForRole());
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

                    ModelState.AddModelError("modelerror", "您输入的验证码有误！");

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
                    string userRole = accountModel.GetRolesById(userInfo.roleid);

                    accountModel.UpdateFailedCount(addr, false);
                    FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(1,
                                userInfo.username,
                                DateTime.Now,
                                DateTime.Now.AddMinutes(1440),
                                model.RememberMe == "on" ? true : false,
                                userRole + "|" + userInfo.uid + "|admin",
                                FormsAuthentication.FormsCookiePath);

                    // Encrypt the ticket.
                    string encTicket = FormsAuthentication.Encrypt(ticket);

                    // Create the cookie.
                    Response.Cookies.Add(new HttpCookie(FormsAuthentication.FormsCookieName, encTicket));

                    if (!String.IsNullOrEmpty(returnUrl))
                    {
                        return Redirect(returnUrl);
                    }
                    else
                    {
                        return RedirectToAction(CommonModel.GetFirstActionResultForRole(), CommonModel.GetFirstActionForRole());
                    }
                }
                else
                {
                    var shopInfo = accountModel.ValidateShop(model.UserName, CommonModel.GetMD5Hash(model.Password));
                    if (shopInfo != null)
                    {
                        string userRole = "ownshop";

                        accountModel.UpdateFailedCount(addr, false);
                        FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(1,
                                    shopInfo.shopid,
                                    DateTime.Now,
                                    DateTime.Now.AddMinutes(1440),
                                    model.RememberMe == "on" ? true : false,
                                    userRole + "|" + shopInfo.uid + "|shop",
                                    FormsAuthentication.FormsCookiePath);

                        // Encrypt the ticket.
                        string encTicket = FormsAuthentication.Encrypt(ticket);

                        // Create the cookie.
                        Response.Cookies.Add(new HttpCookie(FormsAuthentication.FormsCookieName, encTicket));

                        if (!String.IsNullOrEmpty(returnUrl))
                        {
                            return Redirect(returnUrl);
                        }
                        else
                        {
                            return RedirectToAction(CommonModel.GetFirstActionResultForRole(), CommonModel.GetFirstActionForRole());
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
                }

                return View("LogOn", model);
            }
            else
            {
                ModelState.AddModelError("modelerror", "账号或密码错误，账号或密码必须要真写");
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
    }
}

