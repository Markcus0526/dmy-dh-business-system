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
    public class ShopModel
    {
        static DshDBModelDataContext db = new DshDBModelDataContext();

        #region Shop CRUD
        public List<tbl_shop> GetShopList()
        {
            return (from m in db.tbl_shops
                    where m.deleted == 0
                    orderby m.uid descending
                    select m).ToList();
        }

        public tbl_shop GetShopById(long uid)
        {
            return (from m in db.tbl_shops
                    where m.uid == uid && m.deleted == 0
                    select m).FirstOrDefault();
        }

        public bool CheckDuplicateShopName(long rid, string shopname)
        {
            bool rst = true;
            rst = ((from m in db.tbl_shops
                    where m.deleted == 0 && m.shopid == shopname && m.uid != rid
                    select m).FirstOrDefault() == null) &&
                    ((from m in db.tbl_admins
                      where m.deleted == 0 && m.username == shopname
                      select m).FirstOrDefault() == null);

            return rst;
        }

        public JqDataTableInfo GetShopDataTable(JQueryDataTableParamModel param, NameValueCollection Request, String rootUri)
        {
            JqDataTableInfo rst = new JqDataTableInfo();
            IEnumerable<tbl_shop> filteredCompanies;

            List<tbl_shop> alllist = GetShopList();

            //Check whether the companies should be filtered by keyword
            if (!string.IsNullOrEmpty(param.sSearch))
            {
                //Used if particulare columns are filtered 
                var nameFilter = Convert.ToString(Request["sSearch_1"]);

                //Optionally check whether the columns are searchable at all 
                var isNameSearchable = Convert.ToBoolean(Request["bSearchable_1"]);

                filteredCompanies = alllist
                   .Where(c => isNameSearchable && c.shopid != null && c.shopid.ToLower().Contains(param.sSearch.ToLower()));
            }
            else
            {
                filteredCompanies = alllist;
            }

            var isNameSortable = Convert.ToBoolean(Request["bSortable_1"]);
            var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
            Func<tbl_shop, string> orderingFunction = (c => sortColumnIndex == 1 && isNameSortable ? c.shopid :
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
                c.shopid,
                RegionModel.GetFullAddress(c.regionid, ""),
                c.shopname,
                c.addr,
                c.phonenum,
                c.bank,
                c.counterid,
                c.bankid,
                Convert.ToString(c.uid),
            };

            rst.sEcho = param.sEcho;
            rst.iTotalRecords = alllist.Count();
            rst.iTotalDisplayRecords = filteredCompanies.Count();
            rst.aaData = result;

            return rst;
        }

        public bool DeleteShop(long[] items)
        {
            string delSql = "UPDATE tbl_shop SET deleted = 1 WHERE ";
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

        public string InsertShop(string shopid, string password, string province, string city, string district,
            string shopname, string addr, string phonenum, string bank, string counterid, string bankid)
        {
            tbl_shop newitem = new tbl_shop();

            newitem.shopid = shopid;
            newitem.password = CommonModel.GetMD5Hash(password);
            newitem.regionid = Convert.ToInt32(district);
            newitem.shopname = shopname;
            newitem.addr = addr;
            newitem.phonenum = phonenum;
            newitem.bank = bank;
            newitem.counterid = counterid;
            newitem.bankid = bankid;
            newitem.adminid = CommonModel.GetCurrentUserId();
            newitem.regtime = DateTime.Now;

            db.tbl_shops.InsertOnSubmit(newitem);
            db.SubmitChanges();

            return "";
        }

        public string UpdateShop(long uid, string shopid, string password, string province, string city, string district,
            string shopname, string addr, string phonenum, string bank, string counterid, string bankid)
        {
            string rst = "";
            tbl_shop edititem = GetShopById(uid);

            if (edititem != null)
            {
                edititem.shopid = shopid;
                if (password != edititem.password)
                    edititem.password = CommonModel.GetMD5Hash(password);
                edititem.regionid = Convert.ToInt64(district);
                edititem.shopname = shopname;
                edititem.addr = addr;
                edititem.phonenum = phonenum;
                edititem.bank = bank;
                edititem.counterid = counterid;
                edititem.bankid = bankid;
                db.SubmitChanges();

                rst = "";
            }
            else
            {
                rst = "商户不存在";
            }

            return rst;
        }

        public string GetShopNameById(long uid)
        {
            tbl_shop item = GetShopById(uid);
            if (item != null)
                return item.shopname;
            else
                return "";
        }

        public bool ChangePwd(long uid, string password)
        {
            tbl_shop item = GetShopById(uid);
            if (item != null)
            {
                if (item.password != password)
                {
                    item.password = CommonModel.GetMD5Hash(password);
                    db.SubmitChanges();
                    return true;
                }
                return true;
            }
            
            return false;              
        }

        #endregion

    }
}
