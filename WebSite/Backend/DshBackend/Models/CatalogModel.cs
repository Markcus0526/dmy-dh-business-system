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
    public class CatalogModel
    {
        static DshDBModelDataContext db = new DshDBModelDataContext();

        ShopModel shopModel = new ShopModel();

        public class TicketInfo
        {
            public long uid { get; set; }
            public string catalognum { get; set; }
            public string username { get; set; }
            public string phonenum { get; set; }
            public DateTime regtime { get; set; }
            public string catalogname { get; set; }
            public string shopname { get; set; }
            public long shopid { get; set; }
            public long saleid { get; set; }
            public long userid { get; set; }
            
        }
        
        #region Catalog CRUD
        public List<tbl_catalog> GetCatalogList(byte type, long kind_id)
        {
            return db.tbl_catalogs
                .Where(m => m.deleted == 0 && m.type == type && (kind_id == 0 || (kind_id != 0 && m.kindid == kind_id)))
                .OrderByDescending(m => m.uid)
                .ToList();
        }

        public JqDataTableInfo GetCatalogDataTable(JQueryDataTableParamModel param, NameValueCollection Request, String rootUri, byte type, long kind_id)
        {
            JqDataTableInfo rst = new JqDataTableInfo();
            IEnumerable<tbl_catalog> filteredCompanies;

            List<tbl_catalog> alllist = GetCatalogList(type, kind_id);

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
            Func<tbl_catalog, string> orderingFunction = (c => sortColumnIndex == 1 && isNameSortable ? c.name :
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
            var result = type == 0 ? 
                from c in displayedCompanies
                         select new[] { 
                Convert.ToString(c.uid), 
                c.image1,
                shopModel.GetShopNameById(c.shopid),
                c.name,
                c.catalognum,
                Convert.ToString(c.price),
                Convert.ToString(c.profit),
                Convert.ToString(c.extra),
                Convert.ToString(c.show),
                Convert.ToString(EvalModel.GetEvalValueByCatalogId(c.uid)),
                Convert.ToString(c.uid)
            } : from c in displayedCompanies
                select new[] { 
                Convert.ToString(c.uid), 
                c.image1,
                shopModel.GetShopNameById(c.shopid),
                c.name,
                c.catalognum,
                Convert.ToString(c.price),
                Convert.ToString(c.profit) + "%",
                Convert.ToString(c.show),
                Convert.ToString(EvalModel.GetEvalValueByCatalogId(c.uid)),
                Convert.ToString(c.uid)
            };

            rst.sEcho = param.sEcho;
            rst.iTotalRecords = alllist.Count();
            rst.iTotalDisplayRecords = filteredCompanies.Count();
            rst.aaData = result;

            return rst;
        }

        public bool DeleteCatalog(long[] items)
        {
            string delSql = "UPDATE tbl_catalog SET deleted = 1 WHERE ";
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

        public tbl_catalog GetCatalogById(long uid)
        {
            return db.tbl_catalogs
                .Where(m => m.deleted == 0 && m.uid == uid)
                .FirstOrDefault();
        }

        public string InsertCatalog(long shop_id, string name, long kind_id, byte using_score, int? score_limit, byte back, 
            int price, int profit, int extra, int count, string addr, string sale_desc, byte show, string catalog_desc,
            byte recommend, string recommend_image, string[] imagelist, byte type, string startdate, string enddate)
        {
            tbl_catalog newitem = new tbl_catalog();

            newitem.shopid = shop_id;
            newitem.name = name;
            newitem.kindid = kind_id;
            newitem.using_score = using_score;
            newitem.score_limit = score_limit;
            newitem.back = back;
            newitem.price = price;
            newitem.profit = profit;
            newitem.extra = extra;
            newitem.count = count;
            newitem.addr = addr;
            newitem.sale_desc = sale_desc;
            newitem.show = show;
            newitem.catalog_desc = CommonModel.GetUnescapedString(catalog_desc);
            newitem.recommend = recommend;
            newitem.recommend_image = recommend_image;
            if (imagelist.Length > 0)
                newitem.image1 = imagelist[0];
            if (imagelist.Length > 1)
                newitem.image2 = imagelist[1];
            if (imagelist.Length > 2)
                newitem.image3 = imagelist[2];
            if (imagelist.Length > 3)
                newitem.image4 = imagelist[3];
            newitem.type = type;
            newitem.regtime = DateTime.Now;
            newitem.adminid = CommonModel.GetCurrentUserId();
            newitem.catalognum = GenerateCatalogNumber();
            newitem.startdate = DateTime.Parse(startdate);
            newitem.enddate = DateTime.Parse(enddate);

            db.tbl_catalogs.InsertOnSubmit(newitem);

            db.SubmitChanges();

            return "";
        }

        public string UpdateCatalog(long uid, long shop_id, string name, long kind_id, byte using_score, int? score_limit, byte back,
            int price, int profit, int extra, int count, string addr, string sale_desc, byte show, string catalog_desc,
            byte recommend, string recommend_image, string[] imagelist, byte type, string startdate, string enddate)
        {
            string rst = "";
            tbl_catalog edititem = GetCatalogById(uid);

            if (edititem != null)
            {
                edititem.shopid = shop_id;
                edititem.name = name;
                edititem.kindid = kind_id;
                edititem.using_score = using_score;
                edititem.score_limit = score_limit;
                edititem.back = back;
                edititem.price = price;
                edititem.profit = profit;
                edititem.extra = extra;
                edititem.count = count;
                edititem.addr = addr;
                edititem.sale_desc = sale_desc;
                edititem.show = show;
                edititem.catalog_desc = CommonModel.GetUnescapedString(catalog_desc);
                edititem.recommend = recommend;
                edititem.recommend_image = recommend_image;
                if (imagelist.Length > 0)
                    edititem.image1 = imagelist[0];
                if (imagelist.Length > 1)
                    edititem.image2 = imagelist[1];
                if (imagelist.Length > 2)
                    edititem.image3 = imagelist[2];
                if (imagelist.Length > 3)
                    edititem.image4 = imagelist[3];
                edititem.startdate = DateTime.Parse(startdate);
                edititem.enddate = DateTime.Parse(enddate);

                db.SubmitChanges();
                rst = "";
            }
            else
            {
                rst = "商品不存在";
            }

            return rst;
        }

        public bool CheckDuplicateCatalogName(long rid, string catalogname)
        {
            bool rst = true;
            rst = ((from m in db.tbl_catalogs
                    where m.deleted == 0 && m.name == catalogname && m.uid != rid
                    select m).FirstOrDefault() == null);

            return rst;
        }                

        public string GenerateCatalogNumber()
        {
            return "HH" + String.Format("{0:yyyyMMddHHmmss}", DateTime.Now) + CommonModel.GetRandVerify();
        }

        public List<string> GetCatalogImageListById(long uid)
        {
            var item = GetCatalogById(uid);
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

        #region Ticket
        public List<TicketInfo> GetTicketList(string startdate, string enddate)
        {
            List<TicketInfo> rst = new List<TicketInfo>();
            rst =  db.tbl_sales
                .Where(m => m.deleted == 0 && m.regtime.Date >= Convert.ToDateTime(startdate).Date && m.regtime.Date <= Convert.ToDateTime(enddate))
                .OrderBy(m => m.uid)
                .Join(db.tbl_catalogs, m => m.catalogid, r => r.uid, (m, r) => new { sale = m, catalog = r })                
                .Select(m => new TicketInfo
                {
                    uid = m.catalog.uid,
                    userid = m.sale.userid,
                    regtime = m.sale.regtime,
                    catalogname = m.catalog.name,
                    catalognum = m.catalog.catalognum,
                    shopid = m.catalog.shopid,
                    saleid = m.sale.uid
                    
                })
                .ToList();

            foreach (TicketInfo m in rst)
            {
                tbl_shop shop = (from n in db.tbl_shops
                                 where n.deleted == 0 && n.uid == m.shopid
                                 select n).FirstOrDefault();

                if (shop != null)
                    m.shopname = shop.shopname;
                else
                    m.shopname = "";

                tbl_user user = (from n in db.tbl_users
                                 where n.deleted == 0 && n.uid == m.userid
                                 select n).FirstOrDefault();

                if (user != null)
                {
                    m.phonenum = user.phonenum;
                    m.username = user.username;
                }
                else
                    m.username = "";
            }



            return rst;
        }

        public JqDataTableInfo GetTicketDataTable(JQueryDataTableParamModel param, NameValueCollection Request, String rootUri)
        {
            JqDataTableInfo rst = new JqDataTableInfo();
            String startdate = Convert.ToString(Request["startdate"]);
            String enddate = Convert.ToString(Request["enddate"]);
            IEnumerable<TicketInfo> filteredCompanies;

            List<TicketInfo> alllist = GetTicketList(startdate, enddate);

            //Check whether the companies should be filtered by keyword
            if (!string.IsNullOrEmpty(param.sSearch))
            {
                //Used if particulare columns are filtered 
                var nameFilter = Convert.ToString(Request["sSearch_1"]);

                //Optionally check whether the columns are searchable at all 
                var isNameSearchable = Convert.ToBoolean(Request["bSearchable_1"]);

                filteredCompanies = alllist
                   .Where(c => isNameSearchable && c.catalognum != null && c.catalognum.ToLower().Contains(param.sSearch.ToLower()));
            }
            else
            {
                filteredCompanies = alllist;
            }

            var isNameSortable = Convert.ToBoolean(Request["bSortable_1"]);
            var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
            Func<TicketInfo, string> orderingFunction = (c => sortColumnIndex == 1 && isNameSortable ? c.username :
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
                Convert.ToString(c.catalognum), 
                c.username,
                c.phonenum,
                String.Format("{0:yyyy-MM-dd}", c.regtime),
                c.catalogname,
                c.shopname,
                Convert.ToString(c.saleid)
            };

            rst.sEcho = param.sEcho;
            rst.iTotalRecords = alllist.Count();
            rst.iTotalDisplayRecords = filteredCompanies.Count();
            rst.aaData = result;

            return rst;
        }

        public List<TicketInfo> GetBackList(string startdate, string enddate)
        {
            List<TicketInfo> rst = new List<TicketInfo>();
            rst = db.tbl_sales
                .Where(m => m.deleted == 0 && m.regtime.Date >= Convert.ToDateTime(startdate).Date && m.regtime.Date <= Convert.ToDateTime(enddate) && m.back == 1)
                .OrderBy(m => m.uid)
                .Join(db.tbl_catalogs, m => m.catalogid, r => r.uid, (m, r) => new { sale = m, catalog = r })
                .Select(m => new TicketInfo
                {
                    uid = m.catalog.uid,
                    userid = m.sale.userid,
                    regtime = m.sale.regtime,
                    catalogname = m.catalog.name,
                    catalognum = m.catalog.catalognum,
                    shopid = m.catalog.shopid

                })
                .ToList();

            foreach (TicketInfo m in rst)
            {
                tbl_shop shop = (from n in db.tbl_shops
                                 where n.deleted == 0 && n.uid == m.shopid
                                 select n).FirstOrDefault();

                if (shop != null) 
                    m.shopname = shop.shopname;
                else
                    m.shopname = "";

                tbl_user user = (from n in db.tbl_users
                                 where n.deleted == 0 && n.uid == m.userid
                                 select n).FirstOrDefault();

                if (user != null)
                {
                    m.phonenum = user.phonenum;
                    m.username = user.username;
                }
                else
                    m.username = "";
            }


            return rst;
        }

        public JqDataTableInfo GetBackDataTable(JQueryDataTableParamModel param, NameValueCollection Request, String rootUri)
        {
            JqDataTableInfo rst = new JqDataTableInfo();
            String startdate = Convert.ToString(Request["startdate"]);
            String enddate = Convert.ToString(Request["enddate"]);
            IEnumerable<TicketInfo> filteredCompanies;

            List<TicketInfo> alllist = GetBackList(startdate, enddate);

            //Check whether the companies should be filtered by keyword
            if (!string.IsNullOrEmpty(param.sSearch))
            {
                //Used if particulare columns are filtered 
                var nameFilter = Convert.ToString(Request["sSearch_1"]);

                //Optionally check whether the columns are searchable at all 
                var isNameSearchable = Convert.ToBoolean(Request["bSearchable_1"]);

                filteredCompanies = alllist
                   .Where(c => isNameSearchable && c.catalognum != null && c.catalognum.ToLower().Contains(param.sSearch.ToLower()));
            }
            else
            {
                filteredCompanies = alllist;
            }

            var isNameSortable = Convert.ToBoolean(Request["bSortable_1"]);
            var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
            Func<TicketInfo, string> orderingFunction = (c => sortColumnIndex == 1 && isNameSortable ? c.username :
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
                Convert.ToString(c.catalognum), 
                c.username,
                c.phonenum,
                String.Format("{0:yyyy-MM-dd}", c.regtime),
                c.catalogname,
                c.shopname                
            };

            rst.sEcho = param.sEcho;
            rst.iTotalRecords = alllist.Count();
            rst.iTotalDisplayRecords = filteredCompanies.Count();
            rst.aaData = result;

            return rst;
        }
        #endregion
    }
}
