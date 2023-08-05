using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Collections;
using System.IO;
using System.Text;
using System.Web.UI;
using System.Drawing;
using System.Globalization;
using System.Text.RegularExpressions;
using DshBackend.Models;
using DshBackend.Models.Library;

namespace DshBackend.Controllers
{
    public class UploadController : Controller
    {
        #region Image processing
        //[Authorize(Roles = "Administrator,Leader,Normal")]
        [HttpPost]
        [SessionExpireFilter]
        public string UploadImage(HttpPostedFileBase userfile)
        {
            string basePath = Server.MapPath("~/Content/uploads/temp");
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            string fileName = "";


            // Some browsers send file names with full path. This needs to be stripped.
            fileName = Path.GetFileName(userfile.FileName);
            var physicalPath = Path.Combine(basePath, fileName);
            if (!Directory.Exists(physicalPath))
            {
                Directory.CreateDirectory(physicalPath);
            }

            if (!System.IO.File.Exists(physicalPath))
            {

            }

            {
                string[] tmpFileName = fileName.Split('.');
                //string another = "";
                if (tmpFileName.Count() > 0)
                {
                    Random rand = new Random();
                    String prefix = String.Format("{0:F0}", rand.NextDouble() * 1000000);

                    fileName = prefix + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + "." + tmpFileName[tmpFileName.Count() - 1];
                    physicalPath = Path.Combine(basePath, fileName);
                }
            }

            userfile.SaveAs(physicalPath);

            //return Json(new { ImgUrl = "Content/uploads/temp/" + fileName }, "text/plain");
            ViewData["fileName"] = fileName;
            return "Content/uploads/temp/"+fileName;
        }

        //[Authorize(Roles = "Administrator,Leader,Normal")]
        //[SessionExpireFilter]
        public string RetrieveCropDialogHtml()
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            string basePath = Server.MapPath("~/");
            ViewData["rootUri"] = rootUri;

            if (Request.QueryString["cropfile"] != null)
            {
                string cropfile = Request.QueryString["cropfile"].ToString();
                ViewData["cropfile"] = cropfile;

                if (System.IO.File.Exists(basePath + cropfile))
                {
                    Bitmap img = new Bitmap(basePath + cropfile);
                    if (img.Height < 300)
                    {
                        ViewData["height"] = img.Height;
                        ViewData["width"] = img.Width;
                    }
                    else
                    {
                        ViewData["height"] = 300;
                        ViewData["width"] = Math.Round(img.Width * (300 / (decimal)img.Height));

                    }
                }
            }

            string ret = RenderPartialToString("~/Views/Shared/CropModal.ascx", ViewData);
            return ret;
        }

        //[Authorize(Roles = "Administrator,Leader,Normal")]
        //[SessionExpireFilter]
        public static string RenderPartialToString(string controlName, object viewData)
        {
            ViewPage viewPage = new ViewPage() { ViewContext = new ViewContext() };

            viewPage.ViewData = new ViewDataDictionary(viewData);
            viewPage.Controls.Add(viewPage.LoadControl(controlName));

            StringBuilder sb = new StringBuilder();
            using (StringWriter sw = new StringWriter(sb))
            {
                using (HtmlTextWriter tw = new HtmlTextWriter(sw))
                {
                    viewPage.RenderControl(tw);
                }
            }

            return sb.ToString();
        }
        
        [HttpPost]
        public string ResizeImage(decimal x, decimal y, decimal w, decimal h, string imgpath, string kind, string size)
        {
            ImageHelper helper = new ImageHelper();

            return helper.ResizeAndCrop(imgpath, x, y, w, h, kind, size);
        }

        //[Authorize(Roles = "Administrator")]
        [SessionExpireFilter]
        public string RemoveImage(string filename)
        {
            string basePath = Server.MapPath("~/");

            var physicalPath = Path.Combine(basePath, filename);

            // TODO: Verify user permissions

            if (System.IO.File.Exists(physicalPath))
            {
                // The files are not actually removed in this demo
                try
                {
                    System.IO.File.Delete(physicalPath);
                }
                catch (System.Exception ex)
                {
                    CommonModel.WriteLogFile(this.GetType().Name, "RemoveTempImg()", ex.Message.ToString());
                }
            }

            // Return an empty string to signify success
            return "";
        }
        #endregion

        #region KindEditor
        [HttpPost]
        [Authorize]
        public ActionResult UploadKindEditorImage(bool isAdmin = false)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            string savePath = "/Content/uploads/account_img/";
            string saveUrl = "/Content/uploads/account_img/";
            string fileTypes = "gif,jpg,jpeg,png,bmp";
            int maxSize = 2 * 1024 * 1024;   //2MB

            Hashtable hash = new Hashtable();


            long merchantUid = 1;// CommonModel.GetCurrAccountId();

            try
            {
                merchantUid = long.Parse(rootUri.Split('.')[0]);
            }
            catch (System.Exception ex)
            {
            	
            }

            string datelbl = String.Format("{0:yyyyMMdd}", DateTime.Now);
            string tempPath = Server.MapPath(savePath) + merchantUid.ToString() + "\\" + datelbl;

            if (!System.IO.Directory.Exists(tempPath))
            {
                System.IO.Directory.CreateDirectory(tempPath);
            }

            savePath = savePath + merchantUid.ToString() + "/" + datelbl + "/";
            saveUrl = savePath;

            HttpPostedFileBase file = Request.Files["imgFile"];
            if (file == null)
            {
                hash = new Hashtable();
                hash["error"] = 1;
                hash["message"] = "請選擇文件";
                return Json(hash, "text/html;charset=UTF-8");
            }

            string dirPath = Server.MapPath(savePath);
            if (!Directory.Exists(dirPath))
            {
                hash = new Hashtable();
                hash["error"] = 1;
                hash["message"] = "上傳目錄不存在";
                return Json(hash, "text/html;charset=UTF-8");
            }

            string fileName = file.FileName;
            string fileExt = Path.GetExtension(fileName).ToLower();

            ArrayList fileTypeList = ArrayList.Adapter(fileTypes.Split(','));

            if (file.InputStream == null || file.InputStream.Length > maxSize)
            {
                hash = new Hashtable();
                hash["error"] = 1;
                hash["message"] = "上傳文件大小超過限制";
                return Json(hash, "text/html;charset=UTF-8");
            }

            if (string.IsNullOrEmpty(fileExt) || Array.IndexOf(fileTypes.Split(','), fileExt.Substring(1).ToLower()) == -1)
            {
                hash = new Hashtable();
                hash["error"] = 1;
                hash["message"] = "上傳文件擴展名是不允許的擴展名";
                return Json(hash, "text/html;charset=UTF-8");
            }

            string newFileName = Path.GetFileNameWithoutExtension(fileName) + "_" + DateTime.Now.ToString("yyyyMMddHHmmss_ffff", DateTimeFormatInfo.InvariantInfo) + fileExt;
            string filePath = dirPath + newFileName;
            file.SaveAs(filePath);
            string fileUrl = saveUrl + newFileName;

            hash = new Hashtable();
            hash["error"] = 0;
            hash["url"] = fileUrl;

            return Json(hash, "text/html;charset=UTF-8");
        }

        [Authorize]
        public ActionResult ProcessKindEditorRequest(bool isAdmin = false)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            //String aspxUrl = context.Request.Path.Substring(0, context.Request.Path.LastIndexOf("/") + 1);

            //根目录路径，相对路径
            String rootPath = "/Content/uploads/account_img/";
            //根目录URL，可以指定绝对路径，
            String rootUrl = "/Content/uploads/account_img/";

            long merchantUid = 1;// CommonModel.GetCurrAccountId();

            try
            {
                merchantUid = long.Parse(rootUri.Split('.')[0]);
            }
            catch (System.Exception ex)
            {
            	
            }

            string datelbl = String.Format("{0:yyyyMMdd}", DateTime.Now);
            string tempPath = Server.MapPath(rootPath) + merchantUid.ToString() + "\\" + datelbl;

            if (!System.IO.Directory.Exists(tempPath))
            {
                System.IO.Directory.CreateDirectory(tempPath);
            }

            rootPath = rootPath + merchantUid.ToString() + "/";
            rootUrl = rootPath;

            //图片扩展名
            String fileTypes = "gif,jpg,jpeg,png,bmp";

            String currentPath = "";
            String currentUrl = "";
            String currentDirPath = "";
            String moveupDirPath = "";

            //根据path参数，设置各路径和URL
            String path = Request.QueryString["path"];
            path = String.IsNullOrEmpty(path) ? "" : path;
            if (path == "")
            {
                currentPath = Server.MapPath(rootPath);
                currentUrl = rootUrl;
                currentDirPath = "";
                moveupDirPath = "";
            }
            else
            {
                currentPath = Server.MapPath(rootPath) + path;
                currentUrl = rootUrl + path;
                currentDirPath = path;
                moveupDirPath = Regex.Replace(currentDirPath, @"(.*?)[^\/]+\/$", "$1");
            }

            //排序形式，name or size or type
            String order = Request.QueryString["order"];
            order = String.IsNullOrEmpty(order) ? "" : order.ToLower();

            //不允许使用..移动到上一级目录
            if (Regex.IsMatch(path, @"\.\."))
            {
                Response.Write("Access is not allowed.");
                Response.End();
            }
            //最后一个字符不是/
            if (path != "" && !path.EndsWith("/"))
            {
                Response.Write("Parameter is not valid.");
                Response.End();
            }
            //目录不存在或不是目录
            if (!Directory.Exists(currentPath))
            {
                Response.Write("Directory does not exist.");
                Response.End();
            }

            //遍历目录取得文件信息
            string[] dirList = Directory.GetDirectories(currentPath);
            string[] fileList = Directory.GetFiles(currentPath);

            switch (order)
            {
                case "size":
                    Array.Sort(dirList, new NameSorter());
                    Array.Sort(fileList, new SizeSorter());
                    break;
                case "type":
                    Array.Sort(dirList, new NameSorter());
                    Array.Sort(fileList, new TypeSorter());
                    break;
                case "name":
                default:
                    Array.Sort(dirList, new NameSorter());
                    Array.Sort(fileList, new NameSorter());
                    break;
            }

            Hashtable result = new Hashtable();
            result["moveup_dir_path"] = moveupDirPath;
            result["current_dir_path"] = currentDirPath;
            result["current_url"] = currentUrl;
            result["total_count"] = dirList.Length + fileList.Length;
            List<Hashtable> dirFileList = new List<Hashtable>();
            result["file_list"] = dirFileList;
            for (int i = 0; i < dirList.Length; i++)
            {
                DirectoryInfo dir = new DirectoryInfo(dirList[i]);
                Hashtable hash = new Hashtable();
                hash["is_dir"] = true;
                hash["has_file"] = (dir.GetFileSystemInfos().Length > 0);
                hash["filesize"] = 0;
                hash["is_photo"] = false;
                hash["filetype"] = "";
                hash["filename"] = dir.Name;
                hash["datetime"] = dir.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss");
                dirFileList.Add(hash);
            }
            for (int i = 0; i < fileList.Length; i++)
            {
                FileInfo file = new FileInfo(fileList[i]);
                Hashtable hash = new Hashtable();
                hash["is_dir"] = false;
                hash["has_file"] = false;
                hash["filesize"] = file.Length;
                hash["is_photo"] = (Array.IndexOf(fileTypes.Split(','), file.Extension.Substring(1).ToLower()) >= 0);
                hash["filetype"] = file.Extension.Substring(1);
                hash["filename"] = file.Name;
                hash["datetime"] = file.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss");
                dirFileList.Add(hash);
            }
            //Response.AddHeader("Content-Type", "application/json; charset=UTF-8");
            //context.Response.Write(JsonMapper.ToJson(result));
            //context.Response.End();
            return Json(result, "text/html;charset=UTF-8", JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        [Authorize]
        public ActionResult UploadKindEditorAudio(bool isAdmin = false)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            string savePath = "/Content/uploads/account_audio/";
            string saveUrl = "/Content/uploads/account_audio/";
            string fileTypes = "mp3";
            int maxSize = 3 * 1024 * 1024;

            Hashtable hash = new Hashtable();

            long merchantUid = 0;

            try
            {
                merchantUid = long.Parse(rootUri.Split('.')[0]);
            }
            catch (System.Exception ex)
            {
            	
            }

            string datelbl = String.Format("{0:yyyyMMdd}", DateTime.Now);
            string tempPath = Server.MapPath(savePath) + merchantUid.ToString() + "\\" + datelbl;

            if (!System.IO.Directory.Exists(tempPath))
            {
                System.IO.Directory.CreateDirectory(tempPath);
            }

            savePath = savePath + merchantUid.ToString() + "/" + datelbl + "/";
            saveUrl = savePath;

            HttpPostedFileBase file = Request.Files["imgFile"];
            if (file == null)
            {
                hash = new Hashtable();
                hash["error"] = 1;
                hash["message"] = "請選擇文件";
                return Json(hash, "text/html;charset=UTF-8");
            }

            string dirPath = Server.MapPath(savePath);
            if (!Directory.Exists(dirPath))
            {
                hash = new Hashtable();
                hash["error"] = 1;
                hash["message"] = "上傳目錄不存在";
                return Json(hash, "text/html;charset=UTF-8");
            }

            string fileName = file.FileName;
            string fileExt = Path.GetExtension(fileName).ToLower();

            ArrayList fileTypeList = ArrayList.Adapter(fileTypes.Split(','));

            if (file.InputStream == null || file.InputStream.Length > maxSize)
            {
                hash = new Hashtable();
                hash["error"] = 1;
                hash["message"] = "上傳文件大小超過限制";
                return Json(hash, "text/html;charset=UTF-8");
            }

            if (string.IsNullOrEmpty(fileExt) || Array.IndexOf(fileTypes.Split(','), fileExt.Substring(1).ToLower()) == -1)
            {
                hash = new Hashtable();
                hash["error"] = 1;
                hash["message"] = "上傳文件擴展名是不允許的擴展名";
                return Json(hash, "text/html;charset=UTF-8");
            }

            string newFileName = Path.GetFileNameWithoutExtension(fileName) + "_" + DateTime.Now.ToString("yyyyMMddHHmmss_ffff", DateTimeFormatInfo.InvariantInfo) + fileExt;
            string filePath = dirPath + newFileName;
            file.SaveAs(filePath);
            string fileUrl = saveUrl + newFileName;

            hash = new Hashtable();
            hash["error"] = 0;
            hash["url"] = fileUrl;

            return Json(hash, "text/html;charset=UTF-8");
        }

        [Authorize]
        public ActionResult ProcessKindEditorAudioRequest(bool isAdmin = false)
        {
            string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
            //String aspxUrl = context.Request.Path.Substring(0, context.Request.Path.LastIndexOf("/") + 1);

            //根目录路径，相对路径
            String rootPath = "/Content/uploads/account_audio/";
            //根目录URL，可以指定绝对路径，
            String rootUrl = "/Content/uploads/account_audio/";

            long merchantUid = 0;

            try
            {
                merchantUid = long.Parse(rootUri.Split('.')[0]);
            }
            catch (System.Exception ex)
            {
            	
            }

            string datelbl = String.Format("{0:yyyyMMdd}", DateTime.Now);
            string tempPath = Server.MapPath(rootPath) + merchantUid.ToString() + "\\" + datelbl;

            if (!System.IO.Directory.Exists(tempPath))
            {
                System.IO.Directory.CreateDirectory(tempPath);
            }

            rootPath = rootPath + merchantUid.ToString() + "/";
            rootUrl = rootPath;

            //图片扩展名
            String fileTypes = "mp3";

            String currentPath = "";
            String currentUrl = "";
            String currentDirPath = "";
            String moveupDirPath = "";

            //根据path参数，设置各路径和URL
            String path = Request.QueryString["path"];
            path = String.IsNullOrEmpty(path) ? "" : path;
            if (path == "")
            {
                currentPath = Server.MapPath(rootPath);
                currentUrl = rootUrl;
                currentDirPath = "";
                moveupDirPath = "";
            }
            else
            {
                currentPath = Server.MapPath(rootPath) + path;
                currentUrl = rootUrl + path;
                currentDirPath = path;
                moveupDirPath = Regex.Replace(currentDirPath, @"(.*?)[^\/]+\/$", "$1");
            }

            //排序形式，name or size or type
            String order = Request.QueryString["order"];
            order = String.IsNullOrEmpty(order) ? "" : order.ToLower();

            //不允许使用..移动到上一级目录
            if (Regex.IsMatch(path, @"\.\."))
            {
                Response.Write("Access is not allowed.");
                Response.End();
            }
            //最后一个字符不是/
            if (path != "" && !path.EndsWith("/"))
            {
                Response.Write("Parameter is not valid.");
                Response.End();
            }
            //目录不存在或不是目录
            if (!Directory.Exists(currentPath))
            {
                Response.Write("Directory does not exist.");
                Response.End();
            }

            //遍历目录取得文件信息
            string[] dirList = Directory.GetDirectories(currentPath);
            string[] fileList = Directory.GetFiles(currentPath);

            switch (order)
            {
                case "size":
                    Array.Sort(dirList, new NameSorter());
                    Array.Sort(fileList, new SizeSorter());
                    break;
                case "type":
                    Array.Sort(dirList, new NameSorter());
                    Array.Sort(fileList, new TypeSorter());
                    break;
                case "name":
                default:
                    Array.Sort(dirList, new NameSorter());
                    Array.Sort(fileList, new NameSorter());
                    break;
            }

            Hashtable result = new Hashtable();
            result["moveup_dir_path"] = moveupDirPath;
            result["current_dir_path"] = currentDirPath;
            result["current_url"] = currentUrl;
            result["total_count"] = dirList.Length + fileList.Length;
            List<Hashtable> dirFileList = new List<Hashtable>();
            result["file_list"] = dirFileList;
            for (int i = 0; i < dirList.Length; i++)
            {
                DirectoryInfo dir = new DirectoryInfo(dirList[i]);
                Hashtable hash = new Hashtable();
                hash["is_dir"] = true;
                hash["has_file"] = (dir.GetFileSystemInfos().Length > 0);
                hash["filesize"] = 0;
                hash["is_photo"] = false;
                hash["filetype"] = "";
                hash["filename"] = dir.Name;
                hash["datetime"] = dir.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss");
                dirFileList.Add(hash);
            }
            for (int i = 0; i < fileList.Length; i++)
            {
                FileInfo file = new FileInfo(fileList[i]);
                Hashtable hash = new Hashtable();
                hash["is_dir"] = false;
                hash["has_file"] = false;
                hash["filesize"] = file.Length;
                hash["is_photo"] = (Array.IndexOf(fileTypes.Split(','), file.Extension.Substring(1).ToLower()) >= 0);
                hash["filetype"] = file.Extension.Substring(1);
                hash["filename"] = file.Name;
                hash["datetime"] = file.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss");
                dirFileList.Add(hash);
            }
            //Response.AddHeader("Content-Type", "application/json; charset=UTF-8");
            //context.Response.Write(JsonMapper.ToJson(result));
            //context.Response.End();
            return Json(result, "text/html;charset=UTF-8", JsonRequestBehavior.AllowGet);
        }

        public class NameSorter : IComparer
        {
            public int Compare(object x, object y)
            {
                if (x == null && y == null)
                {
                    return 0;
                }
                if (x == null)
                {
                    return -1;
                }
                if (y == null)
                {
                    return 1;
                }
                FileInfo xInfo = new FileInfo(x.ToString());
                FileInfo yInfo = new FileInfo(y.ToString());

                return xInfo.FullName.CompareTo(yInfo.FullName);
            }
        }

        public class SizeSorter : IComparer
        {
            public int Compare(object x, object y)
            {
                if (x == null && y == null)
                {
                    return 0;
                }
                if (x == null)
                {
                    return -1;
                }
                if (y == null)
                {
                    return 1;
                }
                FileInfo xInfo = new FileInfo(x.ToString());
                FileInfo yInfo = new FileInfo(y.ToString());

                return xInfo.Length.CompareTo(yInfo.Length);
            }
        }

        public class TypeSorter : IComparer
        {
            public int Compare(object x, object y)
            {
                if (x == null && y == null)
                {
                    return 0;
                }
                if (x == null)
                {
                    return -1;
                }
                if (y == null)
                {
                    return 1;
                }
                FileInfo xInfo = new FileInfo(x.ToString());
                FileInfo yInfo = new FileInfo(y.ToString());

                return xInfo.Extension.CompareTo(yInfo.Extension);
            }
        }
        #endregion
        
        /*#region Image Processing
        [AcceptVerbs(HttpVerbs.Post)]
        public JsonResult UploadImage(HttpPostedFileBase uploadfile)
        {
            if (uploadfile != null)
            {
                try
                {
                    // 文件上传后的保存路径
                    string filePath = Server.MapPath("~/Content/uploads/image/");
                    if (!Directory.Exists(filePath))
                    {
                        Directory.CreateDirectory(filePath);
                    }
                    string fileName = Path.GetFileName(uploadfile.FileName);// 原始文件名称
                    string fileExtension = Path.GetExtension(fileName); // 文件扩展名
                    string saveName = Guid.NewGuid().ToString() + fileExtension; // 保存文件名称

                    uploadfile.SaveAs(filePath + saveName);

                    //return Json(new { Success = true, FileName = fileName, SaveName = "Content/uploads/video/" + saveName }, JsonRequestBehavior.AllowGet);
                    return Json("Content/uploads/image/" + saveName, JsonRequestBehavior.AllowGet);
                }
                catch (Exception ex)
                {
                    return Json(new { Success = false, Message = ex.Message }, JsonRequestBehavior.AllowGet);
                }
            }
            else
            {

                return Json(new { Success = false, Message = "請選擇要上傳的文件！" }, JsonRequestBehavior.AllowGet);
            }
        }

        //[HttpPost]
        //[SessionExpireFilter]
        //public string UploadImage(HttpPostedFileBase userfile)
        //{
        //    string basePath = Server.MapPath("~/Content/uploads/image");
        //    string rootUri = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content("~"));
        //    string fileName = "";


        //    // Some browsers send file names with full path. This needs to be stripped.
        //    fileName = Path.GetFileName(userfile.FileName);
        //    var physicalPath = Path.Combine(basePath, fileName);

        //    if (!System.IO.File.Exists(physicalPath))
        //    {

        //    }

        //    {
        //        string[] tmpFileName = fileName.Split('.');
        //        //string another = "";
        //        if (tmpFileName.Count() > 0)
        //        {
        //            Random rand = new Random();
        //            String prefix = String.Format("{0:F0}", rand.NextDouble() * 1000000);

        //            fileName = prefix + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + "." + tmpFileName[tmpFileName.Count() - 1];
        //            physicalPath = Path.Combine(basePath, fileName);
        //        }
        //    }

        //    userfile.SaveAs(physicalPath);

        //    //return Json(new { ImgUrl = "Content/uploads/temp/" + fileName }, "text/plain");
        //    return "Content/uploads/image/" + fileName;
        //}

        //[AcceptVerbs(HttpVerbs.Post)]
        //public JsonResult UploadMultipleImage(HttpPostedFileBase[] uploadfile)
        //{
        //    if (uploadfile != null && uploadfile.Length > 0)
        //    {
        //        try
        //        {
        //            // 文件上传后的保存路径
        //            string filePath = Server.MapPath("~/Content/uploads/image/");
        //            if (!Directory.Exists(filePath))
        //            {
        //                Directory.CreateDirectory(filePath);
        //            }

        //            List<UploadFileInfo> filelist = new List<UploadFileInfo>();
        //            for (int i = 0; i < uploadfile.Length; i++)
        //            {
        //                HttpPostedFileBase Filedata = uploadfile[i];
        //                string fileName = Path.GetFileName(Filedata.FileName);// 原始文件名称
        //                string fileExtension = Path.GetExtension(fileName); // 文件扩展名
        //                string saveName = Guid.NewGuid().ToString() + fileExtension; // 保存文件名称

        //                Filedata.SaveAs(filePath + saveName);

        //                filelist.Add(new UploadFileInfo { 
        //                    filename = fileName,
        //                    filesize = Filedata.InputStream.Length,
        //                    path = "Content/uploads/image/" + saveName
        //                });
        //            }

        //            return Json(filelist, JsonRequestBehavior.AllowGet);
        //        }
        //        catch (Exception ex)
        //        {
        //            return Json(new { Success = false, Message = ex.Message }, JsonRequestBehavior.AllowGet);
        //        }
        //    }
        //    else
        //    {
        //        return Json(new { Success = false, Message = "请选择要上传的文件！" }, JsonRequestBehavior.AllowGet);
        //    }
        //}
        #endregion*/

        /*#region Video Processing
        [AcceptVerbs(HttpVerbs.Post)]
        public JsonResult UploadVideo(HttpPostedFileBase Filedata)
        {
            if (Filedata != null)
            {
                try
                {
                    // 文件上传后的保存路径
                    string filePath = Server.MapPath("~/Content/uploads/video/");
                    if (!Directory.Exists(filePath))
                    {
                        Directory.CreateDirectory(filePath);
                    }
                    string fileName = Path.GetFileName(Filedata.FileName);// 原始文件名称
                    string fileExtension = Path.GetExtension(fileName); // 文件扩展名
                    string saveName = Guid.NewGuid().ToString() + fileExtension; // 保存文件名称

                    Filedata.SaveAs(filePath + saveName);

                    //return Json(new { Success = true, FileName = fileName, SaveName = "Content/uploads/video/" + saveName }, JsonRequestBehavior.AllowGet);
                    return Json("Content/uploads/video/" + saveName, JsonRequestBehavior.AllowGet);
                }
                catch (Exception ex)
                {
                    return Json(new { Success = false, Message = ex.Message }, JsonRequestBehavior.AllowGet);
                }
            }
            else
            {

                return Json(new { Success = false, Message = "請選擇要上傳的文件！" }, JsonRequestBehavior.AllowGet);
            }
        }
        #endregion*/
    }
}
