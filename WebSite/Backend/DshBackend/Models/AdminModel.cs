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
    public class AdminInfo
    {
        public long uid { get; set; }
        public string username { get; set; }
        public string rolename { get; set; }
        public string role { get; set; }
        public DateTime createtime { get; set; }
        //public DateTime? lasttime { get; set; }
        //public string lastip { get; set; }
    }
    
    public class AdminModel
    {
        static DshDBModelDataContext db = new DshDBModelDataContext();

        #region User CRUD
        public List<AdminInfo> GetAdminList()
        {
            return db.tbl_admins
                .Where(m => m.deleted == 0 && m.uid > 1)
                .OrderByDescending(m => m.uid)
                .Join(db.tbl_adminroles, m => m.roleid , r => r.uid, (m, r) => new {user = m, role = r})
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

        public JqDataTableInfo GetAdminDataTable(JQueryDataTableParamModel param, NameValueCollection Request, String rootUri)
        {
            JqDataTableInfo rst = new JqDataTableInfo();
            IEnumerable<AdminInfo> filteredCompanies;

            List<AdminInfo> alllist = GetAdminList();

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
            Func<AdminInfo, string> orderingFunction = (c => sortColumnIndex == 1 && isNameSortable ? c.username :
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
                c.username,
                String.Format("{0:yyyy-MM-dd HH:mm:ss}", c.createtime),
                c.rolename,
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

        public tbl_admin GetAdminById(long uid)
        {
            return db.tbl_admins
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

        public string UpdateAdmin(long uid, string username, string userpwd, long rolename)
        {
            string rst = "";
            tbl_admin edititem = GetAdminById(uid);

            if (edititem != null)
            {
                if (userpwd != null && edititem.password != userpwd)
                    edititem.password = CommonModel.GetMD5Hash(userpwd);
                edititem.roleid = rolename;

                db.SubmitChanges();
                rst = "";
            }
            else
            {
                rst = "用户不存在";
            }

            return rst;
        }

        public bool CheckDuplicateName(long rid, string username)
        {
            bool rst = true;
            rst = ((from m in db.tbl_admins
                    where m.deleted == 0 && m.username == username && m.uid != rid
                    select m).FirstOrDefault() == null) &&
                    ((from m in db.tbl_shops
                        where m.deleted == 0 && m.shopid == username
                        select m).FirstOrDefault() == null);

            return rst;
        }

        public string UpdatePwd(long uid, string newpwd)
        {
            try
            {
                var aInfo = GetAdminById(uid);
                if (aInfo != null)
                {
                    aInfo.password = CommonModel.GetMD5Hash(newpwd);
                    db.SubmitChanges();

                    return "";
                }
            }
            catch (System.Exception ex)
            {
                CommonModel.WriteLogFile("MerchantModel", "UpdatePwd()", ex.ToString());
                return ex.ToString();
            }

            return "";
        }
        #endregion
        
        #region Role CRUD
        public List<tbl_adminrole> GetRoleList()
        {
            return db.tbl_adminroles
                .Where(m => m.deleted == 0 && m.uid > 1)
                .OrderByDescending(m => m.uid)
                .ToList();
        }

        public JqDataTableInfo GetRoleDataTable(JQueryDataTableParamModel param, NameValueCollection Request, String rootUri)
        {
            JqDataTableInfo rst = new JqDataTableInfo();
            IEnumerable<tbl_adminrole> filteredCompanies;

            List<tbl_adminrole> alllist = GetRoleList();

            //Check whether the companies should be filtered by keyword
            if (!string.IsNullOrEmpty(param.sSearch))
            {
                //Used if particulare columns are filtered 
                var nameFilter = Convert.ToString(Request["sSearch_1"]);

                //Optionally check whether the columns are searchable at all 
                var isNameSearchable = Convert.ToBoolean(Request["bSearchable_1"]);

                filteredCompanies = alllist
                   .Where(c => isNameSearchable && c.rolename != null && c.rolename.ToLower().Contains(param.sSearch.ToLower()));
            }
            else
            {
                filteredCompanies = alllist;
            }

            var isNameSortable = Convert.ToBoolean(Request["bSortable_1"]);
            var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
            Func<tbl_adminrole, string> orderingFunction = (c => sortColumnIndex == 1 && isNameSortable ? c.rolename :
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
                c.rolename,
                GetRoleStringByRoleList(c.roledata),
                Convert.ToString(c.uid)
            };

            rst.sEcho = param.sEcho;
            rst.iTotalRecords = alllist.Count();
            rst.iTotalDisplayRecords = filteredCompanies.Count();
            rst.aaData = result;

            return rst;
        }

        public bool DeleteRole(long[] items)
        {
            try
            {
                string delSql = "UPDATE tbl_adminrole SET deleted = 1 WHERE ";
                string whereSql = "";
                foreach (long uid in items)
                {
                    if (whereSql != "") whereSql += " OR";
                    whereSql += " uid = " + uid;
                }

                delSql += whereSql;

                db.ExecuteCommand(delSql);

                return true;

                /*var dellist = db.tbl_adminroles
                    .Where(m => items.Contains(m.uid))
                    .ToList();

                db.tbl_adminroles.DeleteAllOnSubmit(dellist);

                db.SubmitChanges();*/
            }
            catch (System.Exception ex)
            {
                return false;
            }
        }

        public tbl_adminrole GetRoleById(long uid)
        {
            return db.tbl_adminroles
                .Where(m => m.deleted == 0 && m.uid == uid)
                .FirstOrDefault();
        }

        public string InsertRole(string rolename, string role)
        {
            tbl_adminrole newitem = new tbl_adminrole();

            newitem.rolename= rolename;
            newitem.roledata = role;

            db.tbl_adminroles.InsertOnSubmit(newitem);

            db.SubmitChanges();

            return "";
        }

        public string UpdateRole(long uid, string rolename, string role)
        {
            string rst = "";
            tbl_adminrole edititem = GetRoleById(uid);

            if (edititem != null)
            {
                edititem.rolename = rolename;
                edititem.roledata = role;

                db.SubmitChanges();
                rst = "";
            }
            else
            {
                rst = "数据不存在";
            }

            return rst;
        }

        public bool CheckDuplicateRoleName(long rid, string rolename)
        {   
            bool rst = true;
            rst = ((from m in db.tbl_adminroles
                    where m.deleted == 0 && m.rolename == rolename && m.uid != rid
                    select m).FirstOrDefault() == null);

            return rst;
        }

        public string GetRoleStringByRoleList(string roles)
        {
            string retstr = "";
            string[] rolelist = roles.Split(new char[] { ',' });
            for (int i = 0; i < rolelist.Count(); i++)
            {
                if (i > 0)
                    retstr += ", ";

                string role = rolelist[i];
                string rolename = null;
                if (role == "business")
                    rolename = "业务办理";
                else if (role == "shop")
                    rolename = "商户管理";
                else if (role == "catalog")
                    rolename = "商品管理";
                else if (role == "money")
                    rolename = "财务信息管理";
                else if (role == "user")
                    rolename = "会员管理";
                else if (role == "device")
                    rolename = "机具添加管理";
                else // if (role == "role")
                    rolename = "权限添加管理";

                retstr += rolename;
            }

            return retstr;
        }

        #endregion
        
    }
}