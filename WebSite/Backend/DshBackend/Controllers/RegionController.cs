using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DshBackend.Models.Library;
using DshBackend.Models;

namespace DshBackend.Controllers
{
    public class RegionController : Controller
    {
        [AjaxOnly]
        public JsonResult GetCityList(string provin)
        {
            List<string> citylist = RegionModel.GetCityNameList(provin);
            List<string> distlist = RegionModel.GetDistrictNameList(citylist.ElementAt(0));

            return Json(new { city = citylist, district = distlist }, JsonRequestBehavior.AllowGet);
        }

        [AjaxOnly]
        public JsonResult GetCityListFull(long provin)
        {
            List<tbl_ecsregion> citylist = RegionModel.GetCityList(provin);
            if (citylist == null || citylist.Count() == 0)
            {
                citylist = new List<tbl_ecsregion>();
                citylist.Add(RegionModel.GetRegionInfo(provin));
            }

            return Json(new { city = citylist }, JsonRequestBehavior.AllowGet);
        }

        [AjaxOnly]
        public JsonResult GetDistrictList(string city)
        {
            List<string> retlist = RegionModel.GetDistrictNameList(city);

            return Json(retlist, JsonRequestBehavior.AllowGet);
        }
        [AjaxOnly]
        public JsonResult GetDistrictListFull(long city)
        {
            List<tbl_ecsregion> districtlist = RegionModel.GetDistrictList(city);
            if (districtlist == null || districtlist.Count() == 0)
            {
                districtlist = new List<tbl_ecsregion>();
                districtlist.Add(RegionModel.GetRegionInfo(city));
            }

            return Json(new { district = districtlist }, JsonRequestBehavior.AllowGet);
        }
    }
}
