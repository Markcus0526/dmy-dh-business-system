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
    public class UserInfo
    {
        public long uid { get; set; }
        public string username { get; set; }
        public string rolename { get; set; }
        public string role { get; set; }
        public DateTime createtime { get; set; }
        //public DateTime? lasttime { get; set; }
        //public string lastip { get; set; }
    }
    
    public class UserModel
    {
        static DshDBModelDataContext db = new DshDBModelDataContext();

        #region User CRUD
        public List<tbl_user> GetUserList()
        {
            DshDBModelDataContext db = new DshDBModelDataContext();
            return db.tbl_users
                .Where(m => m.deleted == 0)
                .OrderByDescending(m => m.uid)                
                .ToList();
        }

        public AdminInfo GetAdminByNamePwd(string uname, string upwd)
        {
            return db.tbl_admins
                .Where(m => m.deleted == 0 && m.username == uname && m.password == upwd)
                .OrderBy(m => m.uid)
                .Join(db.tbl_adminroles, m => m.roleid, r => r.uid, (m, r) => new { user = m, role = r })
                .Select(m => new AdminInfo
                {
                    uid = m.user.uid,
                    username = m.user.username,
                    rolename = m.role.rolename,
                    role = m.role.roledata,
                    createtime = m.user.regtime/*,
                    lastip = m.user.lastip,
                    lasttime = m.user.lasttime*/
                })
                .FirstOrDefault();
        }

        public JqDataTableInfo GetUserDataTable(JQueryDataTableParamModel param, NameValueCollection Request, String rootUri)
        {
            JqDataTableInfo rst = new JqDataTableInfo();
            IEnumerable<tbl_user> filteredCompanies;

            List<tbl_user> alllist = GetUserList();

            //Check whether the companies should be filtered by keyword
            if (!string.IsNullOrEmpty(param.sSearch))
            {
                //Used if particulare columns are filtered 
                var nameFilter = Convert.ToString(Request["sSearch_1"]);

                //Optionally check whether the columns are searchable at all 
                var isNameSearchable = Convert.ToBoolean(Request["bSearchable_1"]);

                filteredCompanies = alllist
                   .Where(c => isNameSearchable && c.username != null && c.username.ToLower().Contains(param.sSearch.ToLower()));
            }
            else
            {
                filteredCompanies = alllist;
            }

            var isNameSortable = Convert.ToBoolean(Request["bSortable_1"]);
            var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
            Func<tbl_user, string> orderingFunction = (c => sortColumnIndex == 1 && isNameSortable ? c.username :
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
                String.Format("{0:yyyy-MM-dd}", c.regtime),
                Convert.ToString(c.username != null?c.username:""),
                String.Format("{0:yyyy/MM/dd}", c.birthday),
                c.email,
                c.userid,
                Convert.ToString(c.score),
                c.image,                
                Convert.ToString(c.uid)
            };

            rst.sEcho = param.sEcho;
            rst.iTotalRecords = alllist.Count();
            rst.iTotalDisplayRecords = filteredCompanies.Count();
            rst.aaData = result;

            return rst;
        }

        public bool DeleteAdmin(long[] items)
        {
            string delSql = "UPDATE tbl_admin SET deleted = 1 WHERE ";
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

        public List<tbl_adminrole> GetAdminRoleList()
        {
            return db.tbl_adminroles
                .Where(m => m.deleted == 0)
                .ToList();
        }

        public tbl_user GetUserInfoById(long uid)
        {
            return db.tbl_users
                .Where(m => m.deleted == 0 && m.uid == uid)
                .FirstOrDefault();
        }

        public string InsertAdmin(string username, string userpwd, long rolename)
        {
            tbl_admin newuser = new tbl_admin();

            newuser.username = username;
            newuser.password = CommonModel.GetMD5Hash(userpwd);
            newuser.roleid = rolename;
            newuser.regtime = DateTime.Now;

            db.tbl_admins.InsertOnSubmit(newuser);

            db.SubmitChanges();

            return "";
        }

        public string UpdateUser(long uid, string username, string birthday, string userid, string email, string score, string image)
        {
            string rst = "";
            tbl_user edititem = GetUserInfoById(uid);

            if (edititem != null)
            {
                edititem.username = username;
                edititem.birthday = Convert.ToDateTime(birthday);
                edititem.email = email;
                edititem.userid = userid;
                edititem.score = int.Parse(score);
                edititem.image = image;
               // edititem.roleid = rolename;

                db.SubmitChanges();
                rst = "";
            }
            else
            {
                rst = "用户不存在";
            }

            return rst;
        }

        public bool CheckDuplicateId(string userid)
        {
            bool rst = true;
            rst = ((from m in db.tbl_users
                    where m.deleted == 0 && m.userid == userid
                    select m).FirstOrDefault() == null);

            return rst;
        }

        public bool DeleteUser(long[] items)
        {
            string delSql = "UPDATE tbl_user SET deleted = 1 WHERE ";
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

        public JqDataTableInfo GetUserScoreDataTable(JQueryDataTableParamModel param, NameValueCollection Request, String rootUri)
        {
            JqDataTableInfo rst = new JqDataTableInfo();
            IEnumerable<tbl_user> filteredCompanies;

            List<tbl_user> alllist = GetUserList();

            //Check whether the companies should be filtered by keyword
            if (!string.IsNullOrEmpty(param.sSearch))
            {
                //Used if particulare columns are filtered 
                var nameFilter = Convert.ToString(Request["sSearch_1"]);

                //Optionally check whether the columns are searchable at all 
                var isNameSearchable = Convert.ToBoolean(Request["bSearchable_1"]);

                filteredCompanies = alllist
                   .Where(c => isNameSearchable && c.username != null && c.username.ToLower().Contains(param.sSearch.ToLower()));
            }
            else
            {
                filteredCompanies = alllist;
            }

            var isNameSortable = Convert.ToBoolean(Request["bSortable_1"]);
            var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
            Func<tbl_user, string> orderingFunction = (c => sortColumnIndex == 1 && isNameSortable ? c.username :
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
                Convert.ToString(c.username != null?c.username:""),
                c.phonenum,
                Convert.ToString(c.score),                
                Convert.ToString(c.uid)
            };

            rst.sEcho = param.sEcho;
            rst.iTotalRecords = alllist.Count();
            rst.iTotalDisplayRecords = filteredCompanies.Count();
            rst.aaData = result;

            return rst;
        }

        public string UpdateScore(long uid, int score)
        {
            string rst = "";
            tbl_user edititem = GetUserInfoById(uid);

            if (edititem != null)
            {
                edititem.score = score;
                
                db.SubmitChanges();
                rst = "";
            }
            else
            {
                rst = "用户不存在";
            }

            return rst;
        }

        #endregion
        
        
    }
}