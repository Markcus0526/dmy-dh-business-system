using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Excel = Microsoft.Office.Interop.Excel;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using DshBackend.Models;
using DshBackend.Models.Library;

namespace DshBackend.Controllers
{
    public class MoneyController : Controller
    {
        private SaleModel saleModel = new SaleModel();
        private OtherpayModel otherpayModel = new OtherpayModel();
        private ShopModel shopModel = new ShopModel();

        public static string tmpUserFile;

        #region Sale

        [Authorize(Roles = "money")]
        public ActionResult SaleList()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Money";
            ViewData["level2nav"] = "SaleList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);

            ViewData["shoplist"] = shopModel.GetShopList();
            DateTime start = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            DateTime end = DateTime.Now;
            ViewData["total_money"] = saleModel.GetTotalMoney(start, end);
            ViewData["total_extra"] = saleModel.GetTotalExtra(start, end);

            return View();
        }

        [Authorize(Roles = "money")]
        [AjaxOnly]
        public JsonResult RetrieveSaleList(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            long shop_id = 0;
            try { shop_id = Convert.ToByte(Request.QueryString["shopid"]); }
            catch (Exception e) { }

            byte process = 2;
            if (Request.QueryString["process"] != null)
                process = Convert.ToByte(Request.QueryString["process"]);

            DateTime start = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            if(Request.QueryString["start"] != null)
                start = Convert.ToDateTime(Request.QueryString["start"]);

            DateTime end = DateTime.Now;
            if (Request.QueryString["end"] != null)
                end = Convert.ToDateTime(Request.QueryString["end"]);

            JqDataTableInfo rst = saleModel.GetSaleDataTable(param, Request.QueryString, rootUri, shop_id, process, start, end);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "money")]
        [AjaxOnly]
        public JsonResult GetTotalMoney(string start, string end)
        {
            DateTime starttime = Convert.ToDateTime(start);
            DateTime endtime = Convert.ToDateTime(end);
            var total_money = saleModel.GetTotalMoney(starttime, endtime);
            var total_extra = saleModel.GetTotalExtra(starttime, endtime);

            return Json(new { total_money = total_money, total_extra = total_extra }, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "money")]
        public ActionResult ShowSale(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Money";
            ViewData["level2nav"] = "SaleList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "ShowSale", "", rootUri);

            var saleInfo = saleModel.GetSaleInfoById(id);
            ViewData["saleInfo"] = saleInfo;
            ViewData["uid"] = saleInfo.uid;

            return View();
        }

        [Authorize(Roles = "money")]
        [HttpPost]
        public JsonResult ProcessSale(string delids)
        {
            string[] ids = delids.Split(',');
            long[] selcheckbox = ids.Where(m => !String.IsNullOrWhiteSpace(m)).Select(m => long.Parse(m)).ToArray();
            bool rst = saleModel.ProcessSale(selcheckbox);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "money")]
        public ActionResult ShowShopTotal(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Money";
            ViewData["level2nav"] = "SaleList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "ShowShopTotal", "", rootUri);

            var shopinfo = shopModel.GetShopById(id);
            if(shopinfo == null)
                return RedirectToAction("SaleList", "Money");

            ViewData["shopinfo"] = shopinfo;
            ViewData["uid"] = shopinfo.uid;
            DateTime start = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            DateTime end = DateTime.Now;
            ViewData["total_money"] = saleModel.GetTotalMoneyByShopId(id, start, end);
            ViewData["total_extra"] = saleModel.GetTotalExtraByShopId(id, start, end);

            return View();
        }

        [Authorize(Roles = "money")]
        [AjaxOnly]
        public JsonResult GetShopTotalMoney(long shop_id, string start, string end)
        {
            DateTime starttime = Convert.ToDateTime(start);
            DateTime endtime = Convert.ToDateTime(end);
            var total_money = saleModel.GetTotalMoneyByShopId(shop_id, starttime, endtime);
            var total_extra = saleModel.GetTotalExtraByShopId(shop_id, starttime, endtime);

            return Json(new { total_money = total_money, total_extra = total_extra }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public void ExportSaleList(long shop_id, byte process, string start, string end)
        {

            DateTime starttime = DateTime.Now.AddDays(-DateTime.Now.Day);
            if (!string.IsNullOrEmpty(start))
            {
                try { starttime = Convert.ToDateTime(start); }
                catch (Exception e) { }
            }
            DateTime endtime = DateTime.Now;
            if (!string.IsNullOrEmpty(end))
            {
                try { endtime = Convert.ToDateTime(end); }
                catch (Exception e) { }
            }

            var datalist = saleModel.ExportSaleInfoList(shop_id, process, starttime, endtime);
            var grid = new GridView();

            grid.DataSource = datalist;
            grid.DataBind();

            Response.ClearContent();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment; filename=财务信息_" + String.Format("{0:yyyy-MM-dd_HHmmss}", DateTime.Now) + ".xls");
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

        //[HttpPost]
        //public ActionResult ExportSaleList(long shop_id, byte process, string start, string end)
        //{
        //    Excel.Application xlApp;
        //    Excel.Workbook xlWorkBook;
        //    Excel.Worksheet xlWorkSheet;
        //    object misValue = System.Reflection.Missing.Value;
        //    Excel.Range chartRange;

        //    xlApp = new Excel.Application();
        //    xlWorkBook = xlApp.Workbooks.Add(misValue);
        //    xlWorkSheet = (Excel.Worksheet)xlWorkBook.Worksheets.get_Item(1);

        //    #region Add Columns
        //    int idx = 2;
        //    xlWorkSheet.Cells[1, 1] = "";
        //    xlWorkSheet.Cells[1, idx++] = "商家名称";
        //    xlWorkSheet.Cells[1, idx++] = "商品名称";
        //    xlWorkSheet.Cells[1, idx++] = "商品货号";
        //    xlWorkSheet.Cells[1, idx++] = "商品价格";
        //    xlWorkSheet.Cells[1, idx++] = "是否是补偿商品";
        //    xlWorkSheet.Cells[1, idx++] = "补偿价格";
        //    xlWorkSheet.Cells[1, idx++] = "商品购买日期";
        //    xlWorkSheet.Cells[1, idx++] = "商品购买数量";
        //    xlWorkSheet.Cells[1, idx++] = "是否处理";
        //    #endregion

        //    #region Add Rows
        //    List<SaleInfo> data = saleModel.GetSaleInfoList(shop_id, process, Convert.ToDateTime(start), Convert.ToDateTime(end));
        //    long row_index = 2;
        //    foreach (SaleInfo item in data)
        //    {
        //        xlWorkSheet.Cells[row_index, 2] = item.shopname;
        //        xlWorkSheet.Cells[row_index, 3] = item.catalogname;
        //        xlWorkSheet.Cells[row_index, 4] = item.catalognum;
        //        xlWorkSheet.Cells[row_index, 5] = item.price + "元";
        //        xlWorkSheet.Cells[row_index, 6] = item.type == 0 ? "是" : "否";
        //        xlWorkSheet.Cells[row_index, 7] = item.extra + "元";
        //        xlWorkSheet.Cells[row_index, 8] = String.Format("{0:yyyy-MM-dd HH:mm}", item.regtime);
        //        xlWorkSheet.Cells[row_index, 9] = Convert.ToString(item.count);
        //        xlWorkSheet.Cells[row_index, 10] = item.process == 0 ? "未处理" : "已处理";
        //        row_index++;
        //    }
        //    #endregion

        //    chartRange = xlWorkSheet.get_Range("a1", "v1");
        //    chartRange.Font.Bold = true;

        //    tmpUserFile = "~/Content/uploads/tempexcel/财务信息_" + String.Format("{0:yyyy-MM-dd_HHmmss}", DateTime.Now) + ".xls";
        //    string physicalpath = Server.MapPath(tmpUserFile);
        //    if (!Directory.Exists(Path.GetDirectoryName(physicalpath)))
        //    {
        //        Directory.CreateDirectory(Path.GetDirectoryName(physicalpath));
        //    }
        //    xlWorkBook.SaveAs(physicalpath, Excel.XlFileFormat.xlWorkbookNormal, misValue, misValue, misValue, misValue, Excel.XlSaveAsAccessMode.xlExclusive, misValue, misValue, misValue, misValue, misValue);
        //    xlWorkBook.Close(true, misValue, misValue);
        //    xlApp.Quit();

        //    CommonModel.releaseObject(xlApp);
        //    CommonModel.releaseObject(xlWorkBook);
        //    CommonModel.releaseObject(xlWorkSheet);

        //    return Redirect("Download");
        //}

        public ActionResult Download()
        {
            String[] ff = tmpUserFile.Split('/');
            String tmp = "";
            if (ff.Length == 5) tmp = ff[4];
            Response.ContentType = "Application/x-msexcel";
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + tmp);
            Response.TransmitFile(Server.MapPath(tmpUserFile));
            Response.End();

            return View();
        }
        #endregion

        #region Adminpay
        [Authorize(Roles = "money")]
        public ActionResult AdminpayList()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Money";
            ViewData["level2nav"] = "AdminpayList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);

            DateTime start = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            DateTime end = DateTime.Now;
            ViewData["total_gain"] = otherpayModel.GetTotalAdminGain(start, end);
            ViewData["total_pay"] = otherpayModel.GetTotalAdminPay(start, end);

            return View();
        }

        [Authorize(Roles = "money")]
        [AjaxOnly]
        public JsonResult GetTotalAdminpay(string start, string end)
        {
            DateTime starttime = Convert.ToDateTime(start);
            DateTime endtime = Convert.ToDateTime(end);
            var total_gain = otherpayModel.GetTotalAdminGain(starttime, endtime);
            var total_pay = otherpayModel.GetTotalAdminPay(starttime, endtime);

            return Json(new { total_gain = total_gain, total_pay = total_pay }, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "money")]
        [AjaxOnly]
        public JsonResult RetrieveAdminpayList(JQueryDataTableParamModel param)
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

            JqDataTableInfo rst = otherpayModel.GetAdminpayDataTable(param, Request.QueryString, rootUri, type, real, start, end);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "money")]
        public ActionResult AddAdminpay()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Money";
            ViewData["level2nav"] = "AdminpayList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "AddAdminpay", "", rootUri);
            
            return View();
        }

        [Authorize(Roles = "money")]
        public ActionResult EditAdminpay(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Money";
            ViewData["level2nav"] = "AdminpayList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "EditGeneralCatalog", "", rootUri);
            
            var payinfo = otherpayModel.GetAdminpayById(id);
            ViewData["payinfo"] = payinfo;
            ViewData["uid"] = payinfo.uid;

            return View("AddAdminpay");
        }

        [Authorize(Roles = "money")]
        [HttpPost]
        [AjaxOnly]
        public JsonResult SubmitAdminpay(long uid, byte type, string name, string phonenum, string reason, int price, int? real_price)
        {
            string rst = "";

            if (uid == 0)
            {
                rst = otherpayModel.InsertAdminpay(type, name, phonenum, reason, price, real_price);
            }
            else
            {
                rst = otherpayModel.UpdateAdminpay(uid, type, name, phonenum, reason, price, real_price);
            }

            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "money")]
        [HttpPost]
        public JsonResult DeleteAdminpay(string delids)
        {
            string[] ids = delids.Split(',');
            long[] selcheckbox = ids.Where(m => !String.IsNullOrWhiteSpace(m)).Select(m => long.Parse(m)).ToArray();
            bool rst = otherpayModel.DeleteAdminpay(selcheckbox);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region Score
        [Authorize(Roles = "money")]
        public ActionResult UserList()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Money";
            ViewData["level2nav"] = "UserList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);

            return View();
        }

        [Authorize(Roles = "money")]
        [AjaxOnly]
        public JsonResult RetrieveUserList(JQueryDataTableParamModel param)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));

            UserModel usermodel = new UserModel();

            JqDataTableInfo rst = usermodel.GetUserScoreDataTable(param, Request.QueryString, rootUri);
            return Json(rst, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "money")]
        public ActionResult EditUser(long id)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["userrole"] = CommonModel.GetUserRoleInfo();

            ViewData["rootUri"] = rootUri;
            ViewData["level1nav"] = "Money";
            ViewData["level2nav"] = "UserList";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "EditUser", "", rootUri);

            UserModel usermodel = new UserModel();

            var userinfo = usermodel.GetUserInfoById(id);
            ViewData["userinfo"] = userinfo;
            ViewData["uid"] = userinfo.uid;

            return View("EditUser");
        }

        [Authorize(Roles = "money")]
        [HttpPost]
        [AjaxOnly]
        public JsonResult SubmitScore(long uid, int score)
        {
            string rst = "";

            UserModel usermodel = new UserModel();

            rst = usermodel.UpdateScore(uid, score);

            return Json(rst, JsonRequestBehavior.AllowGet);
        }
        #endregion
    }
}
