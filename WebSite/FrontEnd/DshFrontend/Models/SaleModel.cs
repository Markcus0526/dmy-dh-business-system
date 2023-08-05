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
    public class SaleInfo
    {
        public long uid { get; set; }
        public long catalog_id { get; set; }
        public string catalog_name { get; set; }
        public string catalog_image { get; set; }
        public string catalog_desc { get; set; }
        public byte status { get; set; }
        public byte eval { get; set; }
        public byte identify { get; set; }
    }

    public class SaleModel
    {
        DshDBModelDataContext db = new DshDBModelDataContext();

        public EvalModel evalModel = new EvalModel();
        public CatalogModel catalogModel = new CatalogModel();

        public List<SaleInfo> GetSaleList(byte status)
        {
            long user_id = CommonModel.GetCurrentUserId();

            var retlist = db.tbl_sales
                .Where(m => m.deleted == 0 && m.userid == user_id &&
                    ((status == 0 && m.status == 0) || (status != 0 && m.status == 1 && m.back == 0)))
                .OrderByDescending(m => m.uid)
                .Select(m => new SaleInfo { 
                    uid = m.uid,
                    catalog_id = m.catalogid,
                    catalog_name = catalogModel.GetCatalogNameById(m.catalogid),
                    catalog_image = catalogModel.GetCatalogImageById(m.catalogid),
                    catalog_desc = catalogModel.GetCatalogDescById(m.catalogid),
                    status = status,
                    eval = evalModel.GetEvalValueBySaleId(m.uid),
                    identify = m.identify
                })
                .ToList();
            if (status == 2)
                retlist = retlist
                    .Join(db.tbl_catalogs, m => m.catalog_id, l => l.uid, (m, l) => new { sale = m, catalog = l })
                    .Where(m => m.catalog.deleted == 0 && m.catalog.back == 1 && m.sale.identify == 1)
                    .Select(m => m.sale)
                    .ToList();

            return retlist;
        }
                
        public JqDataTableInfo GetSaleDataTable(JQueryDataTableParamModel param, NameValueCollection Request, String rootUri, byte status)
        {
            JqDataTableInfo rst = new JqDataTableInfo();
            IEnumerable<SaleInfo> filteredCompanies;

            List<SaleInfo> alllist = GetSaleList(status);

            //Check whether the companies should be filtered by keyword
            if (!string.IsNullOrEmpty(param.sSearch))
            {
                //Used if particulare columns are filtered 
                var nameFilter = Convert.ToString(Request["sSearch_1"]);

                //Optionally check whether the columns are searchable at all 
                var isNameSearchable = Convert.ToBoolean(Request["bSearchable_1"]);

                filteredCompanies = alllist
                   .Where(c => isNameSearchable && c.catalog_name != null && c.catalog_name.ToLower().Contains(param.sSearch.ToLower()));
            }
            else
            {
                filteredCompanies = alllist;
            }

            var isNameSortable = Convert.ToBoolean(Request["bSortable_1"]);
            var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
            Func<SaleInfo, string> orderingFunction = (c => sortColumnIndex == 1 && isNameSortable ? c.catalog_name :
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
                c.catalog_image,
                c.catalog_name,
                c.catalog_desc,
                Convert.ToString(c.eval),
                Convert.ToString(c.catalog_id),
                Convert.ToString(c.uid)
            };

            rst.sEcho = param.sEcho;
            rst.iTotalRecords = alllist.Count();
            rst.iTotalDisplayRecords = filteredCompanies.Count();
            rst.aaData = result;

            return rst;
        }

        public string GetShopPhonenum(long uid)
        {
            tbl_shop shop = (from m in db.tbl_shops
                             where m.deleted == 0 && m.uid == uid
                             select m).FirstOrDefault();

            if (shop != null)
                return shop.phonenum;
            else
                return "";
        }

        public void InsertSaleCatalog(long catalogid)
        {
            tbl_sale sale_item = new tbl_sale();
            sale_item = (from m in db.tbl_sales
                         where m.deleted == 0 && m.catalogid == catalogid && m.userid == CommonModel.GetCurrentUserId() && m.status == 0
                         select m).FirstOrDefault();
            if (sale_item == null)
            {
                sale_item = new tbl_sale();
                sale_item.catalogid = catalogid;
                sale_item.status = 0;
                sale_item.regtime = DateTime.Now;
                sale_item.userid = CommonModel.GetCurrentUserId();
                db.tbl_sales.InsertOnSubmit(sale_item);
                db.SubmitChanges();
            }
        }

        public bool InsertSaleData(long catalogid, int score, int count, int pay_type, byte using_score)
        {
            long userid = CommonModel.GetCurrentUserId();

            tbl_sale sale_item = (from m in db.tbl_sales
                                  where m.deleted == 0 && m.status == 0 && m.catalogid == catalogid && m.userid == userid
                                  select m).FirstOrDefault();

            tbl_catalog catalog = (from m in db.tbl_catalogs
                                   where m.deleted == 0 && m.uid == catalogid
                                   select m).FirstOrDefault();

            tbl_user user = (from m in db.tbl_users
                             where m.deleted == 0 && m.uid == userid
                             select m).FirstOrDefault();

            if (catalog != null && user != null)
            {
                if (sale_item == null)
                {
                    sale_item = new tbl_sale();
                    sale_item.catalogid = catalogid;
                    sale_item.userid = CommonModel.GetCurrentUserId();
                    sale_item.regtime = DateTime.Now;
                    db.tbl_sales.InsertOnSubmit(sale_item);
                    db.SubmitChanges();
                }
                sale_item.status = 0;
                sale_item.score = score;
                sale_item.using_score = using_score;
                sale_item.count = count;
                sale_item.price = count * catalog.price - score / 100;
                sale_item.identify = 0;
                sale_item.pay_type = pay_type;
                if (using_score == 0)
                    sale_item.score = 0;
                else
                    sale_item.score = score;

                db.SubmitChanges();

                user.score += ((count * catalog.price) / 100) - score;
                user.sale_cnt = user.sale_cnt + 1;

                db.SubmitChanges();

                catalog.count -= count;
                db.SubmitChanges();
            }
            

            return true;

        }

        public int CheckScore(long userid, long catalogid, int score, int count)
        {
            int status = 0;

            tbl_user user = (from m in db.tbl_users
                             where m.deleted == 0 && m.uid == userid
                             select m).FirstOrDefault();
            if (user != null)
            {
                if (user.score < score)
                {
                    status = 1;
               
                }
            }
            else
            {
                status = 1;
               
            }

            if (status != 0) return status;

            tbl_catalog catalog = (from m in db.tbl_catalogs
                                   where m.deleted == 0 && m.uid == catalogid
                                   select m).FirstOrDefault();

            if (catalog.using_score == 0)
            {
                status = 2;
            }
            else
            {
                if (catalog.score_limit < (score / count))
                    status = 3;
            }

            if (status != 0)  return status;

            if (catalog.count < count) status = 4;

            return status;
                
        }

        public int CheckCount(long catalogid, int count)
        {
            int status = 0;
            
           
            tbl_catalog catalog = (from m in db.tbl_catalogs
                                   where m.deleted == 0 && m.uid == catalogid
                                   select m).FirstOrDefault();

            if (catalog.count < count) status = 4;

            return status;

        }

        public void DeleteSale(long uid)
        {
            long userid = CommonModel.GetCurrentUserId();

            tbl_sale sale = (from m in db.tbl_sales
                             where m.deleted == 0 && m.userid == userid && m.catalogid == uid && m.status == 0
                             select m).FirstOrDefault();

            if (sale != null)
            {
                sale.deleted = 1;
                db.SubmitChanges();
            }
        }

        public bool IsCatalogOnSale(long catalog_id, long user_id) 
        {
            return (db.tbl_sales
                .Where(m => m.deleted == 0 && m.catalogid == catalog_id && m.userid == user_id && m.status == 0)
                .FirstOrDefault() != null);
        }

        public bool DeleteSale(long[] items)
        {
            string delSql = "UPDATE tbl_sale SET back = 1 WHERE ";
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

		public static int GetBuyingCountFromCatalogid(long catalogid)
        {
            DshDBModelDataContext db1 = new DshDBModelDataContext();

            return db1.tbl_sales
                .Where(m => m.deleted == 0 && m.catalogid == catalogid && m.status == 1 && m.back == 0)
                .Count();
        }

    }
}
