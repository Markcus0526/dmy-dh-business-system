using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DshBackend.Models;
using DshBackend.Models.Library;

namespace DshBackend.Controllers
{
    public class CardController : Controller
    {
        //
        // GET: /Card/
        public CardModel cardmodel = new CardModel();

        public ActionResult Index()
        {
            return View();
        }

        [Authorize(Roles = "business")]
        public ActionResult BankCard()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Card";
            ViewData["level2nav"] = "BankCard";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);
            return View();
        }

        [Authorize(Roles = "business")]
        public ActionResult AddBankCard()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
           
            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Card";
            ViewData["level2nav"] = "BankCard";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "AddBankCard", "", rootUri);
            ViewData["type"] = 0;     

            return View("AddCard");
        }

        [Authorize(Roles = "business")]
        public ActionResult EditBankCard(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            
            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Card";
            ViewData["level2nav"] = "BankCard";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "EditBankCard", "", rootUri);
            ViewData["type"] = 0;    
            var card = cardmodel.GetCardById(id);
            ViewData["card"] = card;
            ViewData["uid"] = card.uid;
            

            return View("AddCard");
        }

        [Authorize(Roles = "business")]
        public ActionResult EditBankCardInfo(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Card";
            ViewData["level2nav"] = "BankCard";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "EditBankCardInfo", "", rootUri);
            ViewData["type"] = 0;
            var card = cardmodel.GetCardInfoById(id);
            ViewData["cardinfo"] = card;
            ViewData["uid"] = card.uid;


            return View("EditCardInfo");
        }

        [Authorize(Roles = "business")]
        [AjaxOnly]
        public JsonResult RetrieveBankCardInfoList(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            JqDataTableInfo rst = cardmodel.GetCardInfoDataTable(param, Request.QueryString, rootUri, 0);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "business")]
        [AjaxOnly]
        public JsonResult RetrieveBankCardDataist(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            JqDataTableInfo rst = cardmodel.GetCardDataTable(param, Request.QueryString, rootUri, 0);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "business")]
        [HttpPost]
        [AjaxOnly]
        public JsonResult SubmitCard(long uid, int type, string title,string content)
        {
            string rst = "";
            if (uid == 0)
            {
                rst = cardmodel.InsertCard(type, title, content);
            }
            else
            {
                rst = cardmodel.UpdateCard(uid, type, title, content);
            }          


            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "business")]
        [HttpPost]
        [AjaxOnly]
        public JsonResult SubmitCardInfo(long uid, string name, string phonenum, string cardnum, string addr, string content)
        {
            string rst = "";
            
            rst = cardmodel.UpdateCardInfo(uid, name, phonenum, cardnum, addr, content);
            
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "business")]
        [HttpPost]
        public JsonResult DeleteCard(string delids)
        {
            string[] ids = delids.Split(',');
            long[] selcheckbox = ids.Where(m => !String.IsNullOrWhiteSpace(m)).Select(m => long.Parse(m)).ToArray();
            bool rst = cardmodel.DeleteCard(selcheckbox);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "business")]
        [HttpPost]
        public JsonResult DeleteCardInfo(string delids)
        {
            string[] ids = delids.Split(',');
            long[] selcheckbox = ids.Where(m => !String.IsNullOrWhiteSpace(m)).Select(m => long.Parse(m)).ToArray();
            bool rst = cardmodel.DeleteCardInfo(selcheckbox);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "business")]
        [HttpPost]
        public JsonResult DeleteOrgLendCard(string delids)
        {
            string[] ids = delids.Split(',');
            long[] selcheckbox = ids.Where(m => !String.IsNullOrWhiteSpace(m)).Select(m => long.Parse(m)).ToArray();
            bool rst = cardmodel.DeleteOrgLendCard(selcheckbox);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "business")]
        public ActionResult CreditCard()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Card";
            ViewData["level2nav"] = "CreditCard";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);
            return View();
        }

        [Authorize(Roles = "business")]
        public ActionResult AddCreditCard()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Card";
            ViewData["level2nav"] = "CreditCard";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "AddCreditCard", "", rootUri);
            ViewData["type"] = 1;

            return View("AddCard");
        }

        [Authorize(Roles = "business")]
        public ActionResult EditCreditCard(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Card";
            ViewData["level2nav"] = "CreditCard";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "EditCreditCard", "", rootUri);
            ViewData["type"] = 1;
            var card = cardmodel.GetCardById(id);
            ViewData["card"] = card;
            ViewData["uid"] = card.uid;


            return View("AddCard");
        }

        [Authorize(Roles = "business")]
        public ActionResult EditCreditCardInfo(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Card";
            ViewData["level2nav"] = "CreditCard";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "EditCreditCardInfo", "", rootUri);
            ViewData["type"] = 1;
            var card = cardmodel.GetCardInfoById(id);
            ViewData["cardinfo"] = card;
            ViewData["uid"] = card.uid;


            return View("EditCardInfo");
        }

        [Authorize(Roles = "business")]
        [AjaxOnly]
        public JsonResult RetrieveCreditCardInfoList(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            JqDataTableInfo rst = cardmodel.GetCardInfoDataTable(param, Request.QueryString, rootUri, 1);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "business")]
        [AjaxOnly]
        public JsonResult RetrieveCreditCardDataist(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            JqDataTableInfo rst = cardmodel.GetCardDataTable(param, Request.QueryString, rootUri, 1);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "business")]
        public ActionResult InsuranceCard()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Card";
            ViewData["level2nav"] = "InsuranceCard";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);
            return View();
        }

        [Authorize(Roles = "business")]
        public ActionResult AddInsuranceCard()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Card";
            ViewData["level2nav"] = "InsuranceCard";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "AddInsuranceCard", "", rootUri);
            ViewData["type"] = 2;

            return View("AddCard");
        }

        [Authorize(Roles = "business")]
        public ActionResult EditInsuranceCard(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Card";
            ViewData["level2nav"] = "InsuranceCard";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "EditInsuranceCard", "", rootUri);
            ViewData["type"] = 2;
            var card = cardmodel.GetCardById(id);
            ViewData["card"] = card;
            ViewData["uid"] = card.uid;


            return View("AddCard");
        }

        [Authorize(Roles = "business")]
        public ActionResult EditInsuranceCardInfo(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Card";
            ViewData["level2nav"] = "InsuranceCard";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "EditInsuranceCardInfo", "", rootUri);
            ViewData["type"] = 2;
            var card = cardmodel.GetCardInfoById(id);
            ViewData["cardinfo"] = card;
            ViewData["uid"] = card.uid;


            return View("EditCardInfo");
        }

        [Authorize(Roles = "business")]
        [AjaxOnly]
        public JsonResult RetrieveInsuranceCardInfoList(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            JqDataTableInfo rst = cardmodel.GetCardInfoDataTable(param, Request.QueryString, rootUri, 2);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "business")]
        [AjaxOnly]
        public JsonResult RetrieveInsuranceCardDataist(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            JqDataTableInfo rst = cardmodel.GetCardDataTable(param, Request.QueryString, rootUri, 2);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "business")]
        public ActionResult FinanceCard()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Card";
            ViewData["level2nav"] = "FinanceCard";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);
            return View();
        }

        [Authorize(Roles = "business")]
        public ActionResult AddFinanceCard()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Card";
            ViewData["level2nav"] = "FinanceCard";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "AddFinanceCard", "", rootUri);
            ViewData["type"] = 3;

            return View("AddCard");
        }

        [Authorize(Roles = "business")]
        public ActionResult EditFinanceCard(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Card";
            ViewData["level2nav"] = "FinanceCard";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "EditFinanceCard", "", rootUri);
            ViewData["type"] = 3;
            var card = cardmodel.GetCardById(id);
            ViewData["card"] = card;
            ViewData["uid"] = card.uid;


            return View("AddCard");
        }

        [Authorize(Roles = "business")]
        public ActionResult EditFinanceCardInfo(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Card";
            ViewData["level2nav"] = "FinanceCard";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "EditFinanceCardInfo", "", rootUri);
            ViewData["type"] = 3;
            var card = cardmodel.GetCardInfoById(id);
            ViewData["cardinfo"] = card;
            ViewData["uid"] = card.uid;


            return View("EditCardInfo");
        }

        [Authorize(Roles = "business")]
        [AjaxOnly]
        public JsonResult RetrieveFinanceCardInfoList(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            JqDataTableInfo rst = cardmodel.GetCardInfoDataTable(param, Request.QueryString, rootUri, 3);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "business")]
        [AjaxOnly]
        public JsonResult RetrieveFinanceCardDataist(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            JqDataTableInfo rst = cardmodel.GetCardDataTable(param, Request.QueryString, rootUri, 3);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "business")]
        public ActionResult LendCard()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Card";
            ViewData["level2nav"] = "LendCard";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);
            return View();
        }

        [Authorize(Roles = "business")]
        public ActionResult AddUserLendCard()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Card";
            ViewData["level2nav"] = "LendCard";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "AddLendCard", "", rootUri);
            ViewData["type"] = 4;

            return View("AddCard");
        }

        [Authorize(Roles = "business")]
        public ActionResult EditUserLendCard(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Card";
            ViewData["level2nav"] = "LendCard";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "EditLendCard", "", rootUri);
            ViewData["type"] = 4;
            var card = cardmodel.GetCardById(id);
            ViewData["card"] = card;
            ViewData["uid"] = card.uid;


            return View("AddCard");
        }

        [Authorize(Roles = "business")]
        public ActionResult EditUserLendCardInfo(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Card";
            ViewData["level2nav"] = "LendCard";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "EditLendCard", "", rootUri);
            ViewData["type"] = 4;
            var card = cardmodel.GetCardInfoById(id);
            ViewData["cardinfo"] = card;
            ViewData["uid"] = card.uid;


            return View("EditCardInfo");
        }

        [Authorize(Roles = "business")]
        public ActionResult EditOrgLendCardInfo(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Card";
            ViewData["level2nav"] = "LendCard";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "EditLendCardInfo", "", rootUri);

            var card = cardmodel.GetOrgLendCardInfoById(id);
            ViewData["cardinfo"] = card;
            ViewData["uid"] = card.uid;


            return View("EditOrgLendCardInfo");
        }

        [Authorize(Roles = "business")]
        [HttpPost]
        [AjaxOnly]
        public JsonResult SubmitOrgLendCardInfo(long uid, string org_name, string name, string cardnum, string phonenum, string org_user, string org_phonenum, string org_addr, string content)
        {
            string rst = "";

            rst = cardmodel.UpdateOrgLendCardInfo(uid, org_name, name, cardnum, phonenum, org_user, org_phonenum, org_addr, content);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }


        [Authorize(Roles = "business")]
        [AjaxOnly]
        public JsonResult RetrieveUserLendCardInfoList(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            JqDataTableInfo rst = cardmodel.GetCardInfoDataTable(param, Request.QueryString, rootUri, 4);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "business")]
        [AjaxOnly]
        public JsonResult RetrieveUserLendCardDataist(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            JqDataTableInfo rst = cardmodel.GetCardDataTable(param, Request.QueryString, rootUri, 4);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "business")]
        [AjaxOnly]
        public JsonResult RetrieveOrgLendCardInfoList(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            JqDataTableInfo rst = cardmodel.GetOrgLendCardInfoDataTable(param, Request.QueryString, rootUri);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }



    }
}
