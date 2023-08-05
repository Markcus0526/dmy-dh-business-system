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
    public class SaleInfo
    {
        public long uid { get; set; }
        public string shopname { get; set; }
        public string catalogname { get; set; }
        public string catalognum { get; set; }
        public int price { get; set; }
        public byte type { get; set; }
        public int? extra { get; set; }
        public DateTime regtime { get; set; }
        public int count { get; set; }
        public byte process { get; set; }
        public long shop_id { get; set; }
        public int? score { get; set; }
        public int totalprice { get; set; }
        public long userid { get; set; }
        public string username { get; set; }
        public string phonenum { get; set; }
    }

    public class OwnSaleInfo
    {
        public long uid { get; set; }
        public string catalogname { get; set; }
        public string kindname { get; set; }
        public DateTime regtime { get; set; }
        public string username { get; set; }
        public int price { get; set; }
        public byte type { get; set; }
        public int? extra { get; set; }
    }

    public class OwnTicketInfo
    {
        public long uid { get; set; }
        public string catalogname { get; set; }
        public DateTime regtime { get; set; }
        public string username { get; set; }
        public string phonenum { get; set; }
        public byte identfy { get; set; }
    }

    public class SaleModel
    {
        static DshDBModelDataContext db = new DshDBModelDataContext();
                
        #region Sale CRUD
        public List<tbl_sale> GetSaleList(long shop_id, byte process, DateTime start, DateTime end)
        {
            return db.tbl_sales
                .Where(m => m.deleted == 0 &&
                    (process == 2 || (process != 2 && m.process == process)) &&
                    m.regtime.Date >= start.Date && m.regtime.Date <= end.Date)
                .OrderByDescending(m => m.uid)
                .Join(db.tbl_catalogs, m => m.catalogid, l => l.uid, (m, l) => new { sale = m, catalog = l })
                .Where(m => m.catalog.deleted == 0 && (shop_id == 0 || (shop_id != 0 && m.catalog.shopid == shop_id)))
                .Select(m => m.sale)
                .ToList();
        }

        public List<SaleInfo> GetSaleInfoList(long shop_id, byte process, DateTime start, DateTime end)
        {
            return db.tbl_sales
                .Where(m => m.deleted == 0 && m.identify == 1 && m.status == 1 &&
                    (process == 2 || (process != 2 && m.process == process)) &&
                    m.regtime.Date >= start.Date && m.regtime.Date <= end.Date)
                .OrderByDescending(m => m.uid)
                .Join(db.tbl_catalogs, m => m.catalogid, l => l.uid, (m, l) => new { sale = m, catalog = l })
                .Where(m => m.catalog.deleted == 0 && (shop_id == 0 || (shop_id != 0 && m.catalog.shopid == shop_id)))
                .Join(db.tbl_shops, m => m.catalog.shopid, l => l.uid, (m, l) => new { salecatalog = m, shop = l })
                .Select(m => new SaleInfo {
                    uid = m.salecatalog.sale.uid,
                    shopname = m.shop.shopname,
                    catalogname = m.salecatalog.catalog.name,
                    catalognum = m.salecatalog.catalog.catalognum,
                    price = m.salecatalog.catalog.price,
                    type = m.salecatalog.catalog.type,
                    extra = m.salecatalog.catalog.extra,
                    regtime = m.salecatalog.sale.regtime,
                    count = m.salecatalog.sale.count,
                    process = m.salecatalog.sale.process,
                    shop_id = m.shop.uid
                })
                .ToList();
        }

        public JqDataTableInfo GetSaleDataTable(JQueryDataTableParamModel param, NameValueCollection Request, String rootUri, long shop_id, byte process, DateTime start, DateTime end)
        {
            JqDataTableInfo rst = new JqDataTableInfo();
            IEnumerable<SaleInfo> filteredCompanies;

            List<SaleInfo> alllist = GetSaleInfoList(shop_id, process, start, end);

            //Check whether the companies should be filtered by keyword
            if (!string.IsNullOrEmpty(param.sSearch))
            {
                //Used if particulare columns are filtered 
                var nameFilter = Convert.ToString(Request["sSearch_1"]);

                //Optionally check whether the columns are searchable at all 
                var isNameSearchable = Convert.ToBoolean(Request["bSearchable_1"]);

                filteredCompanies = alllist
                   .Where(c => isNameSearchable && c.catalogname != null && c.catalogname.ToLower().Contains(param.sSearch.ToLower()));
            }
            else
            {
                filteredCompanies = alllist;
            }

            var isNameSortable = Convert.ToBoolean(Request["bSortable_1"]);
            var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
            Func<SaleInfo, string> orderingFunction = (c => sortColumnIndex == 1 && isNameSortable ? c.catalogname :
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
                c.shopname,
                c.catalogname,
                c.catalognum,
                Convert.ToString(c.price) + "元",
                Convert.ToString(c.type),
                Convert.ToString(c.extra) + "元",
                String.Format("{0:yyyy-MM-dd HH:mm}", c.regtime),
                Convert.ToString(c.count),
                Convert.ToString(c.process),
                Convert.ToString(c.uid),
                Convert.ToString(c.shop_id)
            };

            rst.sEcho = param.sEcho;
            rst.iTotalRecords = alllist.Count();
            rst.iTotalDisplayRecords = filteredCompanies.Count();
            rst.aaData = result;

            return rst;
        }

        public System.Data.DataTable ExportTicketInfoList(byte identify)
        {
            var products = new System.Data.DataTable("订单查询");

            List<OwnTicketInfo> datalist = GetOwnTicketInfoList(identify);

            if (products != null)
            {
                products.Columns.Add("序号", typeof(string));
                products.Columns.Add("商品名称", typeof(string));
                products.Columns.Add("购买日期", typeof(string));
                products.Columns.Add("客户名称", typeof(string));
                products.Columns.Add("联系方式", typeof(string));
                products.Columns.Add("验证状态", typeof(string));

                int i = 1;
                foreach (var c in datalist)
                {
                    List<string> additem = new List<string>();

                    additem.Add(i.ToString());
                    additem.Add(c.catalogname);
                    additem.Add(String.Format("{0:yyyy-MM-dd HH:mm}", c.regtime));
                    additem.Add(c.username);
                    additem.Add(c.phonenum);
                    switch (c.identfy)
                    {
                        case 0:
                            additem.Add("待认证");
                            break;
                        case 1:
                            additem.Add("通过");
                            break;
                        case 2:
                            additem.Add("未通过");
                            break;
                    }

                    products.Rows.Add(additem.ToArray());
                    i++;
                }
            }

            return products;
        }

        public bool ProcessSale(long[] items)
        {
            string delSql = "UPDATE tbl_sale SET process = 1 WHERE ";
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

        public tbl_sale GetSaleById(long uid)
        {
            return db.tbl_sales
                .Where(m => m.deleted == 0 && m.uid == uid)
                .FirstOrDefault();
        }

        public SaleInfo GetSaleInfoById(long uid)
        {
            var rst= db.tbl_sales
                .Where(m => m.deleted == 0 && m.uid == uid)
                .Join(db.tbl_catalogs, m => m.catalogid, l => l.uid, (m, l) => new { sale = m, catalog = l })
                .Join(db.tbl_shops, m => m.catalog.shopid, l => l.uid, (m, l) => new { salecatalog = m, shop = l })
                .Select(m => new SaleInfo
                {
                    uid = m.salecatalog.sale.uid,
                    shopname = m.shop.shopname,
                    catalogname = m.salecatalog.catalog.name,
                    catalognum = m.salecatalog.catalog.catalognum,
                    price = m.salecatalog.catalog.price,
                    type = m.salecatalog.catalog.type,
                    extra = m.salecatalog.catalog.extra,
                    regtime = m.salecatalog.sale.regtime,
                    count = m.salecatalog.sale.count,
                    score = m.salecatalog.sale.score,
                    totalprice = m.salecatalog.sale.price,
                    userid = m.salecatalog.sale.userid,
                    process = m.salecatalog.sale.process
                })
                .FirstOrDefault();


                tbl_user user = (from n in db.tbl_users
                                 where n.deleted == 0 && n.uid == rst.userid
                                 select n).FirstOrDefault();

                if (user != null)
                {
                    rst.phonenum = user.phonenum;
                    rst.username = user.username;
                }

                return rst;
        }

        public int GetTotalMoneyByShopId(long shop_id, DateTime start, DateTime end)
        {
            var list = db.tbl_sales
                .Where(m => m.deleted == 0 &&
                    /**/ m.status == 1 && m.back == 0 && m.identify == 1 && m.process == 1 /**/ &&
                    m.regtime.Date >= start.Date && m.regtime.Date <= end.Date)
                .Join(db.tbl_catalogs, m => m.catalogid, l => l.uid, (m, l) => new { sale = m, catalog = l })
                .Where(m => m.catalog.shopid == shop_id)
                .ToList();

            if (list.Count() > 0)
                return list.Sum(m => m.sale.price - m.catalog.profit * m.sale.count +
                    (m.catalog.type == 0 ? (int)m.catalog.extra * m.sale.count : 0));
            else
                return 0;
        }

        public int GetTotalExtraByShopId(long shop_id, DateTime start, DateTime end)
        {
            var list = db.tbl_sales
                .Where(m => m.deleted == 0 &&
                    /**/ m.status == 1 && m.back == 0 && m.identify == 1 && m.process == 1 /**/ &&
                    m.regtime.Date >= start.Date && m.regtime.Date <= end.Date)
                .Join(db.tbl_catalogs, m => m.catalogid, l => l.uid, (m, l) => new { sale = m, catalog = l })
                .Where(m => m.catalog.shopid == shop_id && m.catalog.type == 0 && m.catalog.extra != null)
                .ToList();

            if (list.Count() > 0)
                return list.Sum(m => (int)m.catalog.extra * m.sale.count);
            else
                return 0;
        }

        public System.Data.DataTable ExportSaleInfoList(long shop_id, byte process, DateTime start, DateTime end)
        {
            var products = new System.Data.DataTable("财务信息");

            List<SaleInfo> datalist = GetSaleInfoList(shop_id, process, start, end);

            if (products != null)
            {
                products.Columns.Add("序号", typeof(string));
                products.Columns.Add("商家名称", typeof(string));
                products.Columns.Add("商品名称", typeof(string));
                products.Columns.Add("商品货号", typeof(string));
                products.Columns.Add("商品价格", typeof(string));
                products.Columns.Add("是否是补偿商品", typeof(string));
                products.Columns.Add("补偿价格", typeof(string));
                products.Columns.Add("商品购买日期", typeof(string));
                products.Columns.Add("商品购买数量", typeof(string));
                products.Columns.Add("是否处理", typeof(string));

                int i = 1;
                foreach (var c in datalist)
                {
                    List<string> additem = new List<string>();

                    additem.Add(i.ToString());
                    additem.Add(c.shopname);
                    additem.Add(c.catalogname);
                    additem.Add(c.catalognum);
                    additem.Add(c.price + "元");
                    additem.Add(c.type == 0 ? "是" : "否");
                    additem.Add(c.extra + "元");
                    additem.Add(String.Format("{0:yyyy-MM-dd HH:mm}", c.regtime));
                    additem.Add(Convert.ToString(c.count));
                    additem.Add(c.process == 0 ? "未处理" : "已处理");

                    products.Rows.Add(additem.ToArray());
                    i++;
                }
            }

            return products;
        }

        public int GetTotalMoney(DateTime start, DateTime end)
        {
            var list = db.tbl_sales
                .Where(m => m.deleted == 0 &&
                    /**/ m.status == 1 && m.identify == 1 && m.back == 0 && m.process == 1 /**/ &&
                    m.regtime.Date >= start.Date && m.regtime.Date <= end.Date)
                .Join(db.tbl_catalogs, m => m.catalogid, l => l.uid, (m, l) => new { sale = m, catalog = l })
                //.Where(m => m.catalog.shopid == shop_id)
                .ToList();

            if (list.Count() > 0)
            {
                int total = list.Sum(m => m.catalog.profit * m.sale.count);
                return total - GetTotalExtra(start, end);
            }
            else
                return 0;
        }

        public int GetTotalExtra(DateTime start, DateTime end)
        {
            var list = db.tbl_sales
                .Where(m => m.deleted == 0 &&
                    /**/ m.status == 1 && m.identify == 1 && m.back == 0 && m.process == 1 /**/ &&
                    m.regtime.Date >= start.Date && m.regtime.Date <= end.Date)
                .Join(db.tbl_catalogs, m => m.catalogid, l => l.uid, (m, l) => new { sale = m, catalog = l })
                .Where(m => /*m.catalog.shopid == shop_id &&*/ m.catalog.type == 0 && m.catalog.extra != null)
                .ToList();

            if (list.Count() > 0)
                return list.Sum(m => (int)m.catalog.extra * m.sale.count);
            else
                return 0;
        }
        #endregion

        #region OwnSale CRUD

        public List<OwnSaleInfo> GetOwnSaleInfoList( DateTime start, DateTime end)
        {
            long shop_id = CommonModel.GetCurrentUserId();

            return db.tbl_sales
                .Where(m => m.deleted == 0 && 
                    m.status == 1 && m.back == 0 && m.identify == 1 && m.process == 1 &&
                    m.regtime.Date >= start.Date && m.regtime.Date <= end.Date)
                .OrderByDescending(m => m.uid)
                .Join(db.tbl_catalogs, m => m.catalogid, l => l.uid, (m, l) => new { sale = m, catalog = l })
                .Where(m => m.catalog.deleted == 0 && m.catalog.shopid == shop_id)
                .Join(db.tbl_kinds, m => m.catalog.kindid, l => l.uid, (m, l) => new { salecatalog = m, kind = l })
                .Join(db.tbl_users, m => m.salecatalog.sale.userid, l => l.uid, (m, l) => new { salecatalogkind = m, user = l })
                .Select(m => new OwnSaleInfo
                {
                    uid = m.salecatalogkind.salecatalog.sale.uid,
                    catalogname = m.salecatalogkind.salecatalog.catalog.name,
                    kindname = m.salecatalogkind.kind.name,
                    regtime = m.salecatalogkind.salecatalog.sale.regtime,
                    username = m.user.username,
                    price = m.salecatalogkind.salecatalog.sale.price,
                    type = m.salecatalogkind.salecatalog.catalog.type,
                    extra = m.salecatalogkind.salecatalog.catalog.extra * m.salecatalogkind.salecatalog.sale.count
                })
                .ToList();
        }

        public JqDataTableInfo GetOwnSaleDataTable(JQueryDataTableParamModel param, NameValueCollection Request, String rootUri, DateTime start, DateTime end)
        {
            JqDataTableInfo rst = new JqDataTableInfo();
            IEnumerable<OwnSaleInfo> filteredCompanies;

            List<OwnSaleInfo> alllist = GetOwnSaleInfoList(start, end);

            //Check whether the companies should be filtered by keyword
            if (!string.IsNullOrEmpty(param.sSearch))
            {
                //Used if particulare columns are filtered 
                var nameFilter = Convert.ToString(Request["sSearch_1"]);

                //Optionally check whether the columns are searchable at all 
                var isNameSearchable = Convert.ToBoolean(Request["bSearchable_1"]);

                filteredCompanies = alllist
                   .Where(c => isNameSearchable && c.catalogname != null && c.catalogname.ToLower().Contains(param.sSearch.ToLower()));
            }
            else
            {
                filteredCompanies = alllist;
            }

            var isNameSortable = Convert.ToBoolean(Request["bSortable_1"]);
            var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
            Func<OwnSaleInfo, string> orderingFunction = (c => sortColumnIndex == 1 && isNameSortable ? c.catalogname :
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
                c.catalogname,
                c.kindname,
                String.Format("{0:yyyy-MM-dd HH:mm}", c.regtime),
                c.username,
                Convert.ToString(c.price) + "元",
                Convert.ToString(c.type),
                Convert.ToString(c.extra) + "元"
            };

            rst.sEcho = param.sEcho;
            rst.iTotalRecords = alllist.Count();
            rst.iTotalDisplayRecords = filteredCompanies.Count();
            rst.aaData = result;

            return rst;
        }

        #endregion

        #region OwnTicket CRUD

        public List<OwnTicketInfo> GetOwnTicketInfoList(byte identify)
        {
            long shop_id = CommonModel.GetCurrentUserId();

            return db.tbl_sales
                .Where(m => m.deleted == 0 && 
                    m.status == 1 && m.back == 0 && (identify == 3 || (identify != 3 && m.identify == identify)))
                .OrderByDescending(m => m.uid)
                .Join(db.tbl_catalogs, m => m.catalogid, l => l.uid, (m, l) => new { sale = m, catalog = l })
                .Where(m => m.catalog.deleted == 0 && m.catalog.shopid == shop_id)
                .Join(db.tbl_users, m => m.sale.userid, l => l.uid, (m, l) => new { salecatalog = m, user = l })
                .Select(m => new OwnTicketInfo
                {
                    uid = m.salecatalog.sale.uid,
                    catalogname = m.salecatalog.catalog.name,
                    regtime = m.salecatalog.sale.regtime,
                    username = m.user.username,
                    phonenum = m.user.phonenum,
                    identfy = m.salecatalog.sale.identify,
                })
                .ToList();
        }

        public JqDataTableInfo GetOwnTicketDataTable(JQueryDataTableParamModel param, NameValueCollection Request, String rootUri, byte identfy)
        {
            JqDataTableInfo rst = new JqDataTableInfo();
            IEnumerable<OwnTicketInfo> filteredCompanies;

            List<OwnTicketInfo> alllist = GetOwnTicketInfoList(identfy);

            //Check whether the companies should be filtered by keyword
            if (!string.IsNullOrEmpty(param.sSearch))
            {
                //Used if particulare columns are filtered 
                var nameFilter = Convert.ToString(Request["sSearch_1"]);

                //Optionally check whether the columns are searchable at all 
                var isNameSearchable = Convert.ToBoolean(Request["bSearchable_1"]);

                filteredCompanies = alllist
                   .Where(c => isNameSearchable && c.catalogname != null && c.catalogname.ToLower().Contains(param.sSearch.ToLower()));
            }
            else
            {
                filteredCompanies = alllist;
            }

            var isNameSortable = Convert.ToBoolean(Request["bSortable_1"]);
            var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
            Func<OwnTicketInfo, string> orderingFunction = (c => sortColumnIndex == 1 && isNameSortable ? c.catalogname :
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
                c.catalogname,
                String.Format("{0:yyyy-MM-dd HH:mm}", c.regtime),
                c.username,
                c.phonenum,
                "1234567890",
                Convert.ToString(c.identfy),
                Convert.ToString(c.uid)
            };

            rst.sEcho = param.sEcho;
            rst.iTotalRecords = alllist.Count();
            rst.iTotalDisplayRecords = filteredCompanies.Count();
            rst.aaData = result;

            return rst;
        }

        public bool DeleteTicket(long[] items)
        {
            string delSql = "UPDATE tbl_sale SET deleted = 1 WHERE ";
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

        public bool IdentifyTicket(long[] items, byte identify)
        {
            string delSql = "UPDATE tbl_sale SET identify = " + identify + " WHERE ";
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

        #endregion
    }
}
