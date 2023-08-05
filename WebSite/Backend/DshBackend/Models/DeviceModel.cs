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
    public class DeviceModel
    {
        const int MAX_DESC_LENGTH = 20;

        static DshDBModelDataContext db = new DshDBModelDataContext();
        
        #region Device CRUD
        public List<tbl_device> GetDeviceList()
        {
            return db.tbl_devices
                .Where(m => m.deleted == 0)
                .OrderByDescending(m => m.uid)
                .ToList();
        }

        public JqDataTableInfo GetDeviceDataTable(JQueryDataTableParamModel param, NameValueCollection Request, String rootUri)
        {
            JqDataTableInfo rst = new JqDataTableInfo();
            IEnumerable<tbl_device> filteredCompanies;

            List<tbl_device> alllist = GetDeviceList();

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
            Func<tbl_device, string> orderingFunction = (c => sortColumnIndex == 1 && isNameSortable ? c.name :
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
                c.image1,
                c.description.Length <= MAX_DESC_LENGTH ? c.description : c.description.Substring(0, MAX_DESC_LENGTH)+"...",
                String.Format("{0:yyyy-MM-dd}", c.regtime),
                Convert.ToString(c.uid)
            };

            rst.sEcho = param.sEcho;
            rst.iTotalRecords = alllist.Count();
            rst.iTotalDisplayRecords = filteredCompanies.Count();
            rst.aaData = result;

            return rst;
        }

        public bool DeleteDevice(long[] items)
        {
            string delSql = "UPDATE tbl_device SET deleted = 1 WHERE ";
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

        public tbl_device GetDeviceById(long uid)
        {
            return db.tbl_devices
                .Where(m => m.deleted == 0 && m.uid == uid)
                .FirstOrDefault();
        }

        public string InsertDevice(string name, string description, string[] imagelist)
        {
            tbl_device newitem = new tbl_device();

            newitem.name = name;
            newitem.description = description;
            if (imagelist.Length > 0)
                newitem.image1 = imagelist[0];
            if (imagelist.Length > 1)
                newitem.image2 = imagelist[1];
            if (imagelist.Length > 2)
                newitem.image3 = imagelist[2];
            if (imagelist.Length > 3)
                newitem.image4 = imagelist[3];
            newitem.regtime = DateTime.Now;
            newitem.adminid = CommonModel.GetCurrentUserId();

            db.tbl_devices.InsertOnSubmit(newitem);

            db.SubmitChanges();

            return "";
        }

        public string UpdateDevice(long uid, string name, string description, string[] imagelist)
        {
            string rst = "";
            tbl_device edititem = GetDeviceById(uid);

            if (edititem != null)
            {
                edititem.name = name;
                edititem.description = description;
                if (imagelist.Length > 0)
                    edititem.image1 = imagelist[0];
                if (imagelist.Length > 1)
                    edititem.image2 = imagelist[1];
                if (imagelist.Length > 2)
                    edititem.image3 = imagelist[2];
                if (imagelist.Length > 3)
                    edititem.image4 = imagelist[3];

                db.SubmitChanges();
                rst = "";
            }
            else
            {
                rst = "机具不存在";
            }

            return rst;
        }

        public bool CheckDuplicateDeviceName(long rid, string devicename)
        {
            bool rst = true;
            rst = ((from m in db.tbl_devices
                    where m.deleted == 0 && m.name == devicename && m.uid != rid
                    select m).FirstOrDefault() == null);

            return rst;
        }      

        public List<string> GetDeviceImageListById(long uid)
        {
            var item = GetDeviceById(uid);
            if (item != null)
            {
                List<string> list = new List<string>();
                if (!string.IsNullOrEmpty(item.image1))
                    list.Add(item.image1);
                if (!string.IsNullOrEmpty(item.image2))
                    list.Add(item.image2);
                if (!string.IsNullOrEmpty(item.image3))
                    list.Add(item.image3);
                if (!string.IsNullOrEmpty(item.image4))
                    list.Add(item.image4);

                return list;
            }
            else
                return null;
        }
        #endregion
    }
}
