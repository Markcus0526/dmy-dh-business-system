using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DshFrontend.Models.Library;
using System.Collections.Specialized;
using System.Security.Cryptography;
using System.Text;
using System.Web.Security;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;
using System.Globalization;

namespace DshFrontend.Models
{
    public class CardTypeInfo
    {
        public long uid { get; set; }
        public string title { get; set; }
        public string content { get; set; }
    }


    public class FinanceModel
    {
        DshDBModelDataContext db = new DshDBModelDataContext();

        public List<CardTypeInfo> GetCardTypeList(int nType)
        {
            var retlist = db.tbl_cards
                .Where(m => m.deleted == 0 && m.type == nType)
                .OrderByDescending(m => m.uid)
                .Select(m => new CardTypeInfo
                {
                    uid = m.uid,
                    title = m.title,
                    content = m.content
                })
                .ToList();
            
            return retlist;
        }

        public JqDataTableInfo GetCardTypeDataTable(JQueryDataTableParamModel param, NameValueCollection Request, String rootUri, int nType)
        {
            JqDataTableInfo rst = new JqDataTableInfo();
            IEnumerable<CardTypeInfo> filteredCompanies;

            List<CardTypeInfo> alllist = GetCardTypeList(nType);

            //Check whether the companies should be filtered by keyword
            if (!string.IsNullOrEmpty(param.sSearch))
            {
                //Used if particulare columns are filtered 
                var nameFilter = Convert.ToString(Request["sSearch_1"]);

                //Optionally check whether the columns are searchable at all 
                var isNameSearchable = Convert.ToBoolean(Request["bSearchable_1"]);

                filteredCompanies = alllist
                   .Where(c => isNameSearchable && c.content != null && c.content.ToLower().Contains(param.sSearch.ToLower()));
            }
            else
            {
                filteredCompanies = alllist;
            }

            var isNameSortable = Convert.ToBoolean(Request["bSortable_1"]);
            var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
            Func<CardTypeInfo, string> orderingFunction = (c => sortColumnIndex == 1 && isNameSortable ? c.content : "");

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
                Convert.ToString(i++),
                c.title,
                Convert.ToString(c.uid),
                c.content
            };

            rst.sEcho = param.sEcho;
            rst.iTotalRecords = alllist.Count();
            rst.iTotalDisplayRecords = filteredCompanies.Count();
            rst.aaData = result;

            return rst;
        }

        public string GetCardDescription(long uid)
        {
            var retlist = db.tbl_cards
                .Where(m => m.deleted == 0 && m.uid == uid)
                .FirstOrDefault();

            if (retlist != null)
                return retlist.content;
            else
                return "";
        }

        public string InsertOrUpdateBuyCard(String name, String phonenum, String cardnum, String addr, String content, int cardtype, long cardid, long user_id)
        {
            string rst = "";

            tbl_cardinfo newitem = new tbl_cardinfo();

            newitem.type = cardtype;
            newitem.name = name;
            newitem.phonenum = phonenum;
            newitem.cardnum = cardnum;
            newitem.addr = addr;
            newitem.content = content;
            newitem.userid = user_id;
            newitem.cardid = cardid;
            newitem.regtime = DateTime.Now;

            db.tbl_cardinfos.InsertOnSubmit(newitem);

            db.SubmitChanges();

            return rst;
        }

        public string InsertOrUpdateBuyCard1(String org_name, String name, String cardnum, String phonenum, String org_user, String org_phonenum, String org_addr, String content, int cardtype, long cardid, long user_id)
        {
            string rst = "";

            tbl_lend newitem = new tbl_lend();

            newitem.org_name = org_name;
            newitem.name = name;
            newitem.cardnum = cardnum;
            newitem.phonenum = phonenum;
            newitem.org_user = org_user;
            newitem.org_phonenum = org_phonenum;
            newitem.org_addr = org_addr;
            newitem.content = content;
            newitem.userid = user_id;
            newitem.cardid = cardid;
            newitem.regtime = DateTime.Now;

            db.tbl_lends.InsertOnSubmit(newitem);

            db.SubmitChanges();

            return rst;
        }
    }
}
