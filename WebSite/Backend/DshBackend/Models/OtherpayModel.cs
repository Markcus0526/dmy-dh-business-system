using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections.Specialized;
using System.Security.Cryptography;
using System.Text;
using System.Web.Security;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;
using System.Globalization;
using DshBackend.Models.Library;


namespace DshBackend.Models
{
    public class OtherpayModel
    {
        const int MAX_REASON_LENGTH = 20;

        static DshDBModelDataContext db = new DshDBModelDataContext();
        
        #region Adminpay CRUD
        public List<tbl_adminpayment> GetAdminpayList(byte type, byte real, DateTime start, DateTime end)
        {
            long user_id = CommonModel.GetCurrentUserId();

            return db.tbl_adminpayments
                .Where(m => m.deleted == 0 && m.adminid == user_id &&
                    (type == 2 || (type != 2 && m.type == type)) &&
                    (real == 0 || (real != 0 && m.real_regtime != null)) &&
                    m.regtime.Date >= start.Date && m.regtime.Date <= end.Date)
                .OrderByDescending(m => m.uid)
                .ToList();
        }

        public JqDataTableInfo GetAdminpayDataTable(JQueryDataTableParamModel param, NameValueCollection Request, String rootUri, byte type, byte real, DateTime start, DateTime end)
        {
            JqDataTableInfo rst = new JqDataTableInfo();
            IEnumerable<tbl_adminpayment> filteredCompanies;

            List<tbl_adminpayment> alllist = GetAdminpayList(type, real, start, end);

            //Check whether the companies should be filtered by keyword
            if (!string.IsNullOrEmpty(param.sSearch))
            {
                //Used if particulare columns are filtered 
                var nameFilter = Convert.ToString(Request["sSearch_1"]);

                //Optionally check whether the columns are searchable at all 
                var isNameSearchable = Convert.ToBoolean(Request["bSearchable_1"]);

                filteredCompanies = alllist
                   .Where(c => isNameSearchable && c.name != null && c.name.ToLower().Contains(param.sSearch.ToLower()));
            }
            else
            {
                filteredCompanies = alllist;
            }

            var isNameSortable = Convert.ToBoolean(Request["bSortable_1"]);
            var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
            Func<tbl_adminpayment, string> orderingFunction = (c => sortColumnIndex == 1 && isNameSortable ? c.name :
                                                           "");

            var sortDirection = Request["sSortDir_0"]; // asc or desc
            if (sortDirection == "asc")
                filteredCompanies = filteredCompanies.OrderBy(orderingFunction);
            else
                filteredCompanies = filteredCompanies.OrderByDescending(orderingFunction);

            var displayedCompanies = filteredCompanies.Skip(param.iDisplayStart);
            if (param.iDisplayLength > 0)
            {
                displayedCompanies = displayedCompanies.Take(param.iDisplayLength);
            }
            var result = from c in displayedCompanies
                         select new[] { 
                Convert.ToString(c.uid), 
                c.name,
                c.phonenum,
                c.reason.Length <= MAX_REASON_LENGTH ? c.reason : c.reason.Substring(0, MAX_REASON_LENGTH)+"...",
                Convert.ToString(c.type),
                Convert.ToString(c.price),
                c.real_price != null ? Convert.ToString(c.real_price) : "",
                c.real_regtime != null ? String.Format("{0:yyyy-MM-dd HH:mm:ss}", c.real_regtime) : "",
                Convert.ToString(c.uid)
            };

            rst.sEcho = param.sEcho;
            rst.iTotalRecords = alllist.Count();
            rst.iTotalDisplayRecords = filteredCompanies.Count();
            rst.aaData = result;

            return rst;
        }

        public bool DeleteAdminpay(long[] items)
        {
            string delSql = "UPDATE tbl_adminpayment SET deleted = 1 WHERE ";
            string whereSql = "";
            foreach (long uid in items)
            {
                if (whereSql != "") whereSql += " OR";
                whereSql += " uid = " + uid;
            }

            delSql += whereSql;

            db.ExecuteCommand(delSql);

            return true;
        }

        public tbl_adminpayment GetAdminpayById(long uid)
        {
            return db.tbl_adminpayments
                .Where(m => m.deleted == 0 && m.uid == uid)
                .FirstOrDefault();
        }

        public string InsertAdminpay(byte type, string name, string phonenum, string reason, int price, int? real_price)
        {
            tbl_adminpayment newitem = new tbl_adminpayment();

            newitem.type = type;
            newitem.name = name;
            newitem.phonenum = phonenum;
            newitem.reason = reason;
            newitem.price = price;
            newitem.real_price = real_price;
            if (real_price != null)
                newitem.real_regtime = DateTime.Now;
            newitem.regtime = DateTime.Now;
            newitem.adminid = CommonModel.GetCurrentUserId();

            db.tbl_adminpayments.InsertOnSubmit(newitem);

            db.SubmitChanges();

            return "";
        }

        public string UpdateAdminpay(long uid, byte type, string name, string phonenum, string reason, int price, int? real_price)
        {
            string rst = "";
            tbl_adminpayment edititem = GetAdminpayById(uid);

            if (edititem != null)
            {
                edititem.type = type;
                edititem.name = name;
                edititem.phonenum = phonenum;
                edititem.reason = reason;
                edititem.price = price;
                edititem.real_price = real_price;
                if (real_price != null && edititem.real_regtime == null)
                    edititem.real_regtime = DateTime.Now;

                db.SubmitChanges();
                rst = "";
            }
            else
            {
                rst = "商品不存在";
            }

            return rst;
        }

        //public bool CheckDuplicateCatalogName(long rid, string catalogname)
        //{
        //    bool rst = true;
        //    rst = ((from m in db.tbl_catalogs
        //            where m.deleted == 0 && m.name == catalogname && m.uid != rid
        //            select m).FirstOrDefault() == null);

        //    return rst;
        //}  

        public int GetTotalAdminGain(DateTime start, DateTime end)
        {
            long user_id = CommonModel.GetCurrentUserId();

            var list = db.tbl_adminpayments
                .Where(m => m.deleted == 0 && m.type == 0 && m.adminid == user_id &&
                    m.regtime.Date >= start.Date && m.regtime.Date <= end.Date)
                .ToList();

            if (list.Count() > 0)
                return list.Sum(m => m.price);
            else
                return 0;
        }

        public int GetTotalAdminPay(DateTime start, DateTime end)
        {
            long user_id = CommonModel.GetCurrentUserId();

            var list = db.tbl_adminpayments
                .Where(m => m.deleted == 0 && m.type == 1 && m.adminid == user_id &&
                    m.regtime.Date >= start.Date && m.regtime.Date <= end.Date)
                .ToList();

            if (list.Count() > 0)
                return list.Sum(m => m.price);
            else
                return 0;
        }
        #endregion

        #region Shoppay CRUD
        public List<tbl_shoppayment> GetShoppayList(byte type, byte real, DateTime start, DateTime end)
        {
            long user_id = CommonModel.GetCurrentUserId();

            return db.tbl_shoppayments
                .Where(m => m.deleted == 0 && m.shopid == user_id &&
                    (type == 2 || (type != 2 && m.type == type)) &&
                    (real == 0 || (real != 0 && m.real_regtime != null)) &&
                    m.regtime.Date >= start.Date && m.regtime.Date <= end.Date)
                .OrderByDescending(m => m.uid)
                .ToList();
        }

        public JqDataTableInfo GetShoppayDataTable(JQueryDataTableParamModel param, NameValueCollection Request, String rootUri, byte type, byte real, DateTime start, DateTime end)
        {
            JqDataTableInfo rst = new JqDataTableInfo();
            IEnumerable<tbl_shoppayment> filteredCompanies;

            List<tbl_shoppayment> alllist = GetShoppayList(type, real, start, end);

            //Check whether the companies should be filtered by keyword
            if (!string.IsNullOrEmpty(param.sSearch))
            {
                //Used if particulare columns are filtered 
                var nameFilter = Convert.ToString(Request["sSearch_1"]);

                //Optionally check whether the columns are searchable at all 
                var isNameSearchable = Convert.ToBoolean(Request["bSearchable_1"]);

                filteredCompanies = alllist
                   .Where(c => isNameSearchable && c.name != null && c.name.ToLower().Contains(param.sSearch.ToLower()));
            }
            else
            {
                filteredCompanies = alllist;
            }

            var isNameSortable = Convert.ToBoolean(Request["bSortable_1"]);
            var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
            Func<tbl_shoppayment, string> orderingFunction = (c => sortColumnIndex == 1 && isNameSortable ? c.name :
                                                           "");

            var sortDirection = Request["sSortDir_0"]; // asc or desc
            if (sortDirection == "asc")
                filteredCompanies = filteredCompanies.OrderBy(orderingFunction);
            else
                filteredCompanies = filteredCompanies.OrderByDescending(orderingFunction);

            var displayedCompanies = filteredCompanies.Skip(param.iDisplayStart);
            if (param.iDisplayLength > 0)
            {
                displayedCompanies = displayedCompanies.Take(param.iDisplayLength);
            }
            var result = from c in displayedCompanies
                         select new[] { 
                Convert.ToString(c.uid), 
                c.name,
                c.phonenum,
                c.reason.Length <= MAX_REASON_LENGTH ? c.reason : c.reason.Substring(0, MAX_REASON_LENGTH)+"...",
                Convert.ToString(c.type),
                Convert.ToString(c.price),
                c.real_price != null ? Convert.ToString(c.real_price) : "",
                c.real_regtime != null ? String.Format("{0:yyyy-MM-dd HH:mm:ss}", c.real_regtime) : "",
                Convert.ToString(c.uid)
            };

            rst.sEcho = param.sEcho;
            rst.iTotalRecords = alllist.Count();
            rst.iTotalDisplayRecords = filteredCompanies.Count();
            rst.aaData = result;

            return rst;
        }

        public bool DeleteShoppay(long[] items)
        {
            string delSql = "UPDATE tbl_shoppayment SET deleted = 1 WHERE ";
            string whereSql = "";
            foreach (long uid in items)
            {
                if (whereSql != "") whereSql += " OR";
                whereSql += " uid = " + uid;
            }

            delSql += whereSql;

            db.ExecuteCommand(delSql);

            return true;
        }

        public tbl_shoppayment GetShoppayById(long uid)
        {
            return db.tbl_shoppayments
                .Where(m => m.deleted == 0 && m.uid == uid)
                .FirstOrDefault();
        }

        public string InsertShoppay(byte type, string name, string phonenum, string reason, int price, int? real_price)
        {
            tbl_shoppayment newitem = new tbl_shoppayment();

            newitem.type = type;
            newitem.name = name;
            newitem.phonenum = phonenum;
            newitem.reason = reason;
            newitem.price = price;
            newitem.real_price = real_price;
            if (real_price != null)
                newitem.real_regtime = DateTime.Now;
            newitem.regtime = DateTime.Now;
            newitem.shopid = CommonModel.GetCurrentUserId();

            db.tbl_shoppayments.InsertOnSubmit(newitem);

            db.SubmitChanges();

            return "";
        }

        public string UpdateShoppay(long uid, byte type, string name, string phonenum, string reason, int price, int? real_price)
        {
            string rst = "";
            tbl_shoppayment edititem = GetShoppayById(uid);

            if (edititem != null)
            {
                edititem.type = type;
                edititem.name = name;
                edititem.phonenum = phonenum;
                edititem.reason = reason;
                edititem.price = price;
                edititem.real_price = real_price;
                if (real_price != null && edititem.real_regtime == null)
                    edititem.real_regtime = DateTime.Now;

                db.SubmitChanges();
                rst = "";
            }
            else
            {
                rst = "商品不存在";
            }

            return rst;
        }

        //public bool CheckDuplicateCatalogName(long rid, string catalogname)
        //{
        //    bool rst = true;
        //    rst = ((from m in db.tbl_catalogs
        //            where m.deleted == 0 && m.name == catalogname && m.uid != rid
        //            select m).FirstOrDefault() == null);

        //    return rst;
        //}  
        public int GetTotalShopGain(DateTime start, DateTime end)
        {
            long user_id = CommonModel.GetCurrentUserId();

            var list = db.tbl_shoppayments
                .Where(m => m.deleted == 0 && m.type == 0 && m.shopid == user_id &&
                    m.regtime.Date >= start.Date && m.regtime.Date <= end.Date)
                .ToList();

            if (list.Count() > 0)
                return list.Sum(m => m.price);
            else
                return 0;
        }

        public int GetTotalShopPay(DateTime start, DateTime end)
        {
            long user_id = CommonModel.GetCurrentUserId();

            var list = db.tbl_shoppayments
                .Where(m => m.deleted == 0 && m.type == 1 && m.shopid == user_id &&
                    m.regtime.Date >= start.Date && m.regtime.Date <= end.Date)
                .ToList();

            if (list.Count() > 0)
                return list.Sum(m => m.price);
            else
                return 0;
        }
        #endregion
    }
}
