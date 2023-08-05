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
    public class GoodsCatalogList
    {
        public long uid { get; set; }
        public string name { get; set; }
        public string image { get; set; }
        public string sale_desc { get; set; }
        public int buy_count { get; set; }
        public int price { get; set; }
        public decimal rating_val { get; set; }
    }


    public class CatalogModel
    {
        DshDBModelDataContext db = new DshDBModelDataContext();
        

        public tbl_catalog GetCatalogById(long uid)
        {
            return db.tbl_catalogs
                .Where(m => m.deleted == 0 && m.uid == uid)
                .FirstOrDefault();
        }

        public string GetCatalogNameById(long uid)
        {
            var item = GetCatalogById(uid);
            if (item != null)
                return item.name;
            else
                return "";
        }

        public string GetCatalogImageById(long uid)
        {
            var item = GetCatalogById(uid);
            if (item != null)
                return item.image1;
            else
                return "";
        }

        public string GetCatalogDescById(long uid)
        {
            var item = GetCatalogById(uid);
            if (item != null)
                return item.sale_desc;
            else
                return "";
        }

        public List<tbl_catalog> GetCatalogRecommendList()
        {
            DateTime dtToday = DateTime.Now;

            return db.tbl_catalogs
                .OrderByDescending(m => m.uid)
                .Where(m => m.deleted == 0 && m.recommend == 1 && m.show == 1 && m.startdate <= dtToday && dtToday <= m.enddate)
                .ToList();
        }

        public List<tbl_catalog> GetTop6CatalogRecommendList()
        {
            var list = GetCatalogRecommendList();

            return list.Take(6).ToList();
        }

        public static List<tbl_kind> GetKindList()
        {
            DshDBModelDataContext db1 = new DshDBModelDataContext();

            return db1.tbl_kinds
                .OrderBy(m => m.uid)
                .Where(m => m.deleted == 0)
                .ToList();
        }

        public static List<GoodsCatalogList> GetCatalogListWithKindPagenum(long kind, int pagenum, int type, String search_txt)
        {
            DshDBModelDataContext db1 = new DshDBModelDataContext();

            DateTime dtToday = DateTime.Now;

            List<tbl_catalog> list = db1.tbl_catalogs
                .OrderByDescending(m => m.uid)
                .Where(m => m.deleted == 0 && m.kindid == kind && m.type == type && m.show == 1 && m.startdate <= dtToday && dtToday <= m.enddate && m.name.Contains(search_txt) && m.count > 0 ).ToList();

            if (list != null)
            {
                List<tbl_catalog> itemList = list
                                                .Skip(pagenum * CommonModel.PAGESIZE)
                                                .Take(CommonModel.PAGESIZE)
                                                .ToList();

                List<GoodsCatalogList> newlist = new List<GoodsCatalogList>();

                for (int j = 0; j < itemList.Count; j++)
                {
                    GoodsCatalogList item = new GoodsCatalogList();

                    item.uid = itemList.ElementAt(j).uid;
                    item.name = itemList.ElementAt(j).name;

                    String tmp = itemList.ElementAt(j).sale_desc;
                    if ( tmp.Length > 20 )
                        tmp = tmp.Substring(0, 20) + "...";
                    item.sale_desc = tmp;
                    item.image = itemList.ElementAt(j).image1;
                    item.price = itemList.ElementAt(j).price;
                    item.buy_count = SaleModel.GetBuyingCountFromCatalogid(item.uid);

                    newlist.Add(item);
                }
                return newlist;
            }
            else
                return null;
        }

        public static List<List<GoodsCatalogList>> GetCatalogsFirstPageList(int type, String search_txt)
        {
            List<tbl_kind> kindlist = GetKindList();

            List<List<GoodsCatalogList>> retList = new List<List<GoodsCatalogList>>();

            for (int i = 0; i < kindlist.Count; i++)
            {
                List<GoodsCatalogList> newlist = GetCatalogListWithKindPagenum(kindlist.ElementAt(i).uid, 0, type, search_txt);
                retList.Add(newlist);
            }

            return retList;
        }
    }
}
