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
    public class CardModel
    {
        DshDBModelDataContext db = new DshDBModelDataContext();

        public class CardInfo
        {
            public long uid { get; set; }
            public string username { get; set; }
            public long userid { get; set; }
            public DateTime regtime { get; set; }
            public string rolename { get; set; }
            public string role { get; set; }
            public DateTime createtime { get; set; }
            //public DateTime? lasttime { get; set; }
            //public string lastip { get; set; }
        }


        #region CARD CRUD
        public List<tbl_cardinfo> GetCardInfoList(int type)
        {
            return (from m in db.tbl_cardinfos
                    where m.deleted == 0 && m.type == type
                    orderby m.uid descending
                    select m).ToList();
        }

        public List<tbl_lend> GetOrgLendCardInfoList()
        {
            return (from m in db.tbl_lends
                    where m.deleted == 0 
                    orderby m.uid descending
                    select m).ToList();
        }

        public List<tbl_card> GetCardList(int type)
        {
            return (from m in db.tbl_cards
                    where m.deleted == 0 && m.type == type
                    orderby m.uid descending
                    select m).ToList();
        }

        public tbl_cardinfo GetCardInfoById(long uid)
        {
            return (from m in db.tbl_cardinfos
                    where m.uid == uid && m.deleted == 0
                    select m).FirstOrDefault();
        }

        public tbl_card GetCardById(long uid)
        {
            return (from m in db.tbl_cards
                    where m.uid == uid && m.deleted == 0
                    select m).FirstOrDefault();
        }

        public tbl_lend GetOrgLendCardInfoById(long uid)
        {
            return (from m in db.tbl_lends
                    where m.uid == uid && m.deleted == 0
                    select m).FirstOrDefault();
        }

        public JqDataTableInfo GetCardInfoDataTable(JQueryDataTableParamModel param, NameValueCollection Request, String rootUri, int type)
        {
            JqDataTableInfo rst = new JqDataTableInfo();
            IEnumerable<tbl_cardinfo> filteredCompanies;

            List<tbl_cardinfo> alllist = GetCardInfoList(type);

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
            Func<tbl_cardinfo, string> orderingFunction = (c => sortColumnIndex == 1 && isNameSortable ? c.name :
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

            int i = param.iDisplayStart + 1;

            var result = from c in displayedCompanies
                         select new[] { 
                Convert.ToString(c.uid),
                Convert.ToString(i++),
                Convert.ToString(String.Format("{0:yyyy-MM-dd}", c.regtime)),
                c.name,
                c.phonenum,
                c.cardnum,
                c.addr,
                GetSubContent(c.content),
                Convert.ToString(c.uid)                
            };

            rst.sEcho = param.sEcho;
            rst.iTotalRecords = alllist.Count();
            rst.iTotalDisplayRecords = filteredCompanies.Count();
            rst.aaData = result;

            return rst;
        }

        public JqDataTableInfo GetOrgLendCardInfoDataTable(JQueryDataTableParamModel param, NameValueCollection Request, String rootUri)
        {
            JqDataTableInfo rst = new JqDataTableInfo();
            IEnumerable<tbl_lend> filteredCompanies;

            List<tbl_lend> alllist = GetOrgLendCardInfoList();

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
            Func<tbl_lend, string> orderingFunction = (c => sortColumnIndex == 1 && isNameSortable ? c.name :
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

            int i = param.iDisplayStart + 1;

            var result = from c in displayedCompanies
                         select new[] { 
                Convert.ToString(c.uid),
                Convert.ToString(i++),
                Convert.ToString(String.Format("{0:yyyy-MM-dd}", c.regtime)),
                c.org_name,
                c.name,
                c.cardnum,
                c.phonenum,
                c.org_user,
                c.org_phonenum,
                c.org_addr,
                GetSubContent(c.content),
                Convert.ToString(c.uid)                
            };

            rst.sEcho = param.sEcho;
            rst.iTotalRecords = alllist.Count();
            rst.iTotalDisplayRecords = filteredCompanies.Count();
            rst.aaData = result;

            return rst;
        }        

        public JqDataTableInfo GetCardDataTable(JQueryDataTableParamModel param, NameValueCollection Request, String rootUri, int type)
        {
            JqDataTableInfo rst = new JqDataTableInfo();
            IEnumerable<tbl_card> filteredCompanies;

            List<tbl_card> alllist = GetCardList(type);

            //Check whether the companies should be filtered by keyword
            if (!string.IsNullOrEmpty(param.sSearch))
            {
                //Used if particulare columns are filtered 
                var nameFilter = Convert.ToString(Request["sSearch_1"]);

                //Optionally check whether the columns are searchable at all 
                var isNameSearchable = Convert.ToBoolean(Request["bSearchable_1"]);

                filteredCompanies = alllist;
                  // .Where(c => isNameSearchable && c.name.ToLower().Contains(param.sSearch.ToLower()));
            }
            else
            {
                filteredCompanies = alllist;
            }

            var isNameSortable = Convert.ToBoolean(Request["bSortable_1"]);
            var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
            /*Func<tbl_card, string> orderingFunction = (c => sortColumnIndex == 1 && isNameSortable ? c.uid :
                                                           "");

            var sortDirection = Request["sSortDir_0"]; // asc or desc
            if (sortDirection == "asc")
                filteredCompanies = filteredCompanies.OrderBy(orderingFunction);
            else
                filteredCompanies = filteredCompanies.OrderByDescending(orderingFunction);*/

            var displayedCompanies = filteredCompanies.Skip(param.iDisplayStart);
            if (param.iDisplayLength > 0)
            {
                displayedCompanies = displayedCompanies.Take(param.iDisplayLength);
            }
            int i = param.iDisplayStart + 1;

            var result = from c in displayedCompanies
                         select new[] { 
                Convert.ToString(c.uid),  
                Convert.ToString(i++),
                c.title,                
                GetSubContent(c.content),
                Convert.ToString(String.Format("{0:yyyy-MM-dd}", c.regtime)),
                Convert.ToString(c.uid)                
            };

            rst.sEcho = param.sEcho;
            rst.iTotalRecords = alllist.Count();
            rst.iTotalDisplayRecords = filteredCompanies.Count();
            rst.aaData = result;

            return rst;
        }

        public bool DeleteCardInfo(long[] items)
        {
            string delSql = "UPDATE tbl_cardinfo SET deleted = 1 WHERE ";
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
        
        public bool DeleteOrgLendCard(long[] items)
        {
            string delSql = "UPDATE tbl_lend SET deleted = 1 WHERE ";
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

        public bool DeleteCard(long[] items)
        {
            string delSql = "UPDATE tbl_card SET deleted = 1 WHERE ";
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

        public string InsertCard(int type, string title, string content)
        {
            tbl_card newitem = new tbl_card();

            newitem.type = type;
            newitem.content = content;
            newitem.title = title;
            newitem.adminid = CommonModel.GetCurrentUserId();
            newitem.regtime = DateTime.Now;
            
            db.tbl_cards.InsertOnSubmit(newitem);
            db.SubmitChanges();

            return "";
        }

        public string UpdateCard(long uid, int type, string title, string content)
        {
            string rst = "";
            tbl_card edititem = GetCardById(uid);

            if (edititem != null)
            {
                edititem.type = type;
                edititem.content = content;
                edititem.title = title;
                db.SubmitChanges();

                rst = "";
            }
            else
            {
                rst = "信息不存在";
            }

            return rst;
        }

        public string UpdateCardInfo(long uid, string name, string phonenum, string cardnum, string addr, string content)
        {
            string rst = "";
            tbl_cardinfo edititem = GetCardInfoById(uid);

            if (edititem != null)
            {
                edititem.name = name;
                edititem.phonenum = phonenum;
                edititem.cardnum = cardnum;
                edititem.addr = addr;
                edititem.content = content;
                db.SubmitChanges();

                rst = "";
            }
            else
            {
                rst = "信息不存在";
            }

            return rst;
        }

        public string UpdateOrgLendCardInfo(long uid, string org_name, string name, string cardnum, string phonenum, string org_user, string org_phonenum, string org_addr, string content)
        {
            string rst = "";
            tbl_lend edititem = GetOrgLendCardInfoById(uid);

            if (edititem != null)
            {
                edititem.org_name = org_name;
                edititem.phonenum = phonenum;
                edititem.cardnum = cardnum;
                edititem.name = name;
                edititem.org_user = org_user;
                edititem.org_addr = org_addr;
                edititem.org_phonenum = org_phonenum;
                edititem.content = content;
                db.SubmitChanges();

                rst = "";
            }
            else
            {
                rst = "信息不存在";
            }

            return rst;
        }

        public string GetSubContent(string content)
        {
            String tmp = content;
            if (tmp.Length > 20)
                tmp = tmp.Substring(0, 20) + "...";

            return tmp;
        }

        #endregion

    }
}
