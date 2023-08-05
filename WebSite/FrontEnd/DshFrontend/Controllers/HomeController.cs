using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Configuration;
using DshFrontend.Models;
using DshFrontend.Models.Library;

namespace DshFrontend.Controllers
{
    public class HomeController : Controller
    {
        CatalogModel catalogModel = new CatalogModel();

        [Authorize]
        public ActionResult Main()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            ViewData["rootUri"] = rootUri;

            ViewData["backendUri"] = WebConfigurationManager.AppSettings["BackendUri"];

            ViewData["level1nav"] = "Home";
            ViewData["level2nav"] = "";
            ViewData["navinfo"] = CommonModel.GetTopNavInfo(ViewData["level1nav"].ToString(), ViewData["level2nav"].ToString(), "", "", rootUri);

            ViewData["cataloglist"] = catalogModel.GetTop6CatalogRecommendList();

            return View();
        }

    }
}
