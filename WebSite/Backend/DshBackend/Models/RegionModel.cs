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
    public class RegionModel
    {
        static DshDBModelDataContext db = new DshDBModelDataContext();

        public static List<tbl_ecsregion> GetProvinceList()
        {
            return (from m in db.tbl_ecsregions
                    where m.regiontype == 1
                    select m).ToList();
        }

        public static List<tbl_ecsregion> GetCityList(long pid)
        {
            return (from m in db.tbl_ecsregions
                    where m.regiontype == 2 && m.parentid == pid
                    select m).ToList();
        }

        public static List<tbl_ecsregion> GetCityListByName(string provin)
        {
            long provinid = (from m in db.tbl_ecsregions
                             where m.regiontype == 1 && m.regionname == provin
                             select m.uid).FirstOrDefault();
            return (from m in db.tbl_ecsregions
                    where m.regiontype == 2 && m.parentid == provinid
                    select m).ToList();
        }


        public static List<string> GetCityNameList(string provin)
        {
            long provinid = (from m in db.tbl_ecsregions
                             where m.regionname == provin && m.regiontype == 1
                             select m.uid).FirstOrDefault();
            return (from m in db.tbl_ecsregions
                    where m.regiontype == 2 && m.parentid == provinid
                    select m.regionname).ToList();
        }

        public static List<string> GetDistrictNameList(string city)
        {
            long cityid = (from m in db.tbl_ecsregions
                           where m.regionname == city && m.regiontype == 2
                           select m.uid).FirstOrDefault();
            return (from m in db.tbl_ecsregions
                    where m.regiontype == 3 && m.parentid == cityid
                    select m.regionname).ToList();
        }

        public static List<tbl_ecsregion> GetDistrictList(long pid)
        {
            return (from m in db.tbl_ecsregions
                    where m.regiontype == 3 && m.parentid == pid
                    select m).ToList();
        }

        public static List<tbl_ecsregion> GetDistrictListByName(string city)
        {
            long cityid = (from m in db.tbl_ecsregions
                           where m.regiontype == 2 && m.regionname == city
                           select m.uid).FirstOrDefault();
            return (from m in db.tbl_ecsregions
                    where m.regiontype == 3 && m.parentid == cityid
                    select m).ToList();
        }

        public static tbl_ecsregion GetRegionInfo(long id)
        {
            return db.tbl_ecsregions
                .Where(m => m.uid == id)
                .FirstOrDefault();
        }

        public static string GetFullAddress(long id, string addr)
        {
            string ret = addr;

            tbl_ecsregion item = GetRegionInfo(id);
            if (item != null)
            {
                ret = item.regionname + " " + ret;
                if (item.parentid > 1)
                {
                    tbl_ecsregion item1 = GetRegionInfo(item.parentid);
                    if (item1 != null)
                    {
                        ret = item1.regionname + " " + ret;
                        if (item1.parentid > 1)
                        {
                            tbl_ecsregion item2 = GetRegionInfo(item1.parentid);
                            if (item2 != null)
                            {
                                ret = item2.regionname + " " + ret;
                            }
                        }
                    }
                }
            }

            return ret;
        }
    }
}