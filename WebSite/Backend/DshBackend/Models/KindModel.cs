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
    public class KindModel
    {
        static DshDBModelDataContext db = new DshDBModelDataContext();

        #region Kind CRUD
        public List<tbl_kind> GetKindList()
        {
            return db.tbl_kinds
                .Where(m => m.deleted == 0)
                .OrderByDescending(m => m.uid)
                .ToList();
        }

        public JqDataTableInfo GetKindDataTable(JQueryDataTableParamModel param, NameValueCollection Request, String rootUri)
        {
            JqDataTableInfo rst = new JqDataTableInfo();
            IEnumerable<tbl_kind> filteredCompanies;

            List<tbl_kind> alllist = GetKindList();

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
            Func<tbl_kind, string> orderingFunction = (c => sortColumnIndex == 1 && isNameSortable ? c.name :
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
                c.image,
                Convert.ToString(c.uid)
            };

            rst.sEcho = param.sEcho;
            rst.iTotalRecords = alllist.Count();
            rst.iTotalDisplayRecords = filteredCompanies.Count();
            rst.aaData = result;

            return rst;
        }

        public bool DeleteKind(long[] items)
        {
            try
            {
                string delSql = "UPDATE tbl_kind SET deleted = 1 WHERE ";
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
            catch (System.Exception ex)
            {
                return false;
            }
        }

        public tbl_kind GetKindById(long uid)
        {
            return db.tbl_kinds
                .Where(m => m.deleted == 0 && m.uid == uid)
                .FirstOrDefault();
        }

        public string InsertKind(string kindname, string image)
        {
            tbl_kind newitem = new tbl_kind();

            newitem.name = kindname;
            newitem.image = image;

            db.tbl_kinds.InsertOnSubmit(newitem);

            db.SubmitChanges();

            return "";
        }

        public string UpdateKind(long uid, string kindname, string image)
        {
            string rst = "";
            tbl_kind edititem = GetKindById(uid);

            if (edititem != null)
            {
                edititem.name = kindname;
                edititem.image = image;

                db.SubmitChanges();
                rst = "";
            }
            else
            {
                rst = "类型不存在";
            }

            return rst;
        }

        public bool CheckDuplicateKindName(long rid, string kindname)
        {
            bool rst = true;
            rst = ((from m in db.tbl_kinds
                    where m.deleted == 0 && m.name == kindname && m.uid != rid
                    select m).FirstOrDefault() == null);

            return rst;
        }
        #endregion

    }
}
