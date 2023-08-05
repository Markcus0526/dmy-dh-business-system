using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Configuration;
using System.Web.Security;
using System.Diagnostics;
using System.IO;
using System.Web.Hosting;
using System.Text;
using System.Xml;
using System.Security.Cryptography;


namespace DshBackend.Models
{
    public class ComboBoxDataItem
    {
        public long Id { get; set; }
        public string Text { get; set; }
    }

    public class Foreign_Operation
    {
        public long Id { get; set; }
        public string Name { get; set; }
    }

    public class Foreign_Allow
    {
        public long Id { get; set; }
        public string Name { get; set; }
    }

    public class Foreign_Priority
    {
        public string Id { get; set; }
        public string Name { get; set; }
    }

    public class Foreign_Sex
    {
        public long Id { get; set; }
        public string Name { get; set; }
    }

    public class SearchDateType
    {
        public string key { get; set; }
        public string value { get; set; }
    }

    public class SearchOption
    {
        public long key { get; set; }
        public string value { get; set; }
    }

    public class SmtpSecureOption
    {
        public string value { get; set; }
        public string name { get; set; }
    }

    public static class RESULTS
    {
        public const int ERROR = -1;
    }

    public static class DBRESULT
    {
        public const int CANNOT_DELETE = 520;
    }

    public class TopNavInfo
    {
        public TopNavInfo()
        {
            isend = true;
        }

        public bool isend { get; set; }
        public string title { get; set; }
        public string linkurl { get; set; }
    }


    public class UploadFileInfo
    {
        public string filename { get; set; }
        public long filesize { get; set; }
        public string path { get; set; }
    }

   

    public class CommonModel
    {
        #region Constants
        private static DshDBModelDataContext db = new DshDBModelDataContext();
        #endregion

        public static DshDBModelDataContext _db;
        public static string _logFilename = "Log.txt";
        public static int VERIFY_LENGTH = 6;

        public static string GetDisplayDateFormat()
        {
            return "yyyy年M月d日";
        }

        public static string GetDisplayDateTimeFormat()
        {
            return "yyyy年M月d日 HH:mm:ss";
        }

        public static string GetDisplayTimeFormat()
        {
            return "HH - mm";
        }

        public static string GetParamDateFormat()
        {
            return "yyyy-MM-dd";
        }

        public static string GetParamDateTimeFormat()
        {
            return "yyyy-MM-dd HH:mm:ss";
        }

        public static string ConnectionString
        {
            get 
            {
                return ConfigurationManager.ConnectionStrings["apkinstallerConnectionString"].ConnectionString;
            }
        }

        public static IQueryable<Foreign_Operation> GetOperationForeignList()
        {
            IList<Foreign_Operation> tmp = new List<Foreign_Operation>();

            tmp.Add(new Foreign_Operation { Id = 1, Name = "<span class='label label-success'>成功</span>" });
            tmp.Add(new Foreign_Operation { Id = 0, Name = "<span class='label label-danger'>- 失敗 -</span>" });
            return tmp.AsQueryable();
        }

        public static int getOperationState(bool bSuccess)
        {
            if (bSuccess == true)
                return 1;
            return 0;
        }

        public static IEnumerable<SmtpSecureOption> GetSmtpSecureOption()
        {
            IList<SmtpSecureOption> tmp = new List<SmtpSecureOption>();

            tmp.Add(new SmtpSecureOption { value = "", name = "" });
            tmp.Add(new SmtpSecureOption { value = "ssl", name = "ssl" });
            return tmp.AsEnumerable();
        }

        public static IQueryable<Foreign_Allow> GetStatusForeignList()
        {
            IList<Foreign_Allow> tmp = new List<Foreign_Allow>();

            tmp.Add(new Foreign_Allow { Id = 1, Name = "显示" });
            tmp.Add(new Foreign_Allow { Id = 0, Name = "不显示" });
            return tmp.AsQueryable();
        }
        
        public static IQueryable<Foreign_Priority> GetRoleForeignList()
        {
            IList<Foreign_Priority> tmp = new List<Foreign_Priority>();

            tmp.Add(new Foreign_Priority { Id = "Admin", Name = "系统管理员" });
            tmp.Add(new Foreign_Priority { Id = "Leader", Name = "领导" });
            tmp.Add(new Foreign_Priority { Id = "Normal", Name = "普通管理员" });
            return tmp.AsQueryable();
        }

        public static IQueryable<Foreign_Sex> GetSexForeignList()
        {
            IList<Foreign_Sex> tmp = new List<Foreign_Sex>();

            tmp.Add(new Foreign_Sex { Id = 0, Name = "女" });
            tmp.Add(new Foreign_Sex { Id = 1, Name = "男" });
            return tmp.AsQueryable();
        }

        public string[] GetUserRoles()
        {
            string cookieName = FormsAuthentication.FormsCookieName;// FormsAuthentication.FormsCookieName;

            HttpCookie authCookie = HttpContext.Current.Request.Cookies[cookieName];

            FormsAuthenticationTicket authTicket = FormsAuthentication.Decrypt(authCookie.Value);

            string[] roles = authTicket.UserData.Split(new char[] { '|' });

            return roles;
        }

        public bool CheckUserRoles(string p_role)
        {
            string[] uroles = GetUserRoles();
            if (uroles.Contains(p_role) == true) {
                return true;
            }

            return false;
        }

        public static string GetCurrentUserRole()
        {
            string cookieName = FormsAuthentication.FormsCookieName;// FormsAuthentication.FormsCookieName;

            HttpCookie authCookie = HttpContext.Current.Request.Cookies[cookieName];

            FormsAuthenticationTicket authTicket = FormsAuthentication.Decrypt(authCookie.Value);

            string[] roles = authTicket.UserData.Split(new char[] { '|' });

            return roles[0];
        }

        public static string GetCurrentUserName()
        {
            //return Convert.ToString(HttpContext.Current.Session["adminName"]);

            FormsIdentity id = (FormsIdentity)HttpContext.Current.User.Identity;

            if (id != null)
            {
                return id.Name;
            }

            return null;
        }

        public static long GetCurrentUserId()
        {
            string cookieName = FormsAuthentication.FormsCookieName;// FormsAuthentication.FormsCookieName;

            HttpCookie authCookie = HttpContext.Current.Request.Cookies[cookieName];

            FormsAuthenticationTicket authTicket = FormsAuthentication.Decrypt(authCookie.Value);

            string[] roles = authTicket.UserData.Split(new char[] { '|' });

            return long.Parse(roles[1]);
        }

        public static string GetCurrentUserType()
        {
            string cookieName = FormsAuthentication.FormsCookieName;// FormsAuthentication.FormsCookieName;

            HttpCookie authCookie = HttpContext.Current.Request.Cookies[cookieName];

            FormsAuthenticationTicket authTicket = FormsAuthentication.Decrypt(authCookie.Value);

            string[] cookies = authTicket.UserData.Split(new char[] { '|' });

            return cookies[2];
        }

        public static bool make_jpg(string input, string output, string basePath)
        {
            if (!System.IO.File.Exists(basePath + input)) return false;
            
            Process ffmpeg = new Process();
            //ffmpeg.StartInfo.Arguments = string.Format("-y -i {0} -an -ss 00:00:14.35 -r 1 -vframes 1 -f mjpeg  {1}", input, Path.ChangeExtension(output, "jpg"));
            ffmpeg.StartInfo.Arguments = string.Format("-i {0} -an -ss 00:00:0 -r 1 -vframes 1 -f mjpeg -y {1}", basePath + input, basePath + output);
            ffmpeg.StartInfo.FileName = basePath + "plug-in/ffmpeg/ffmpeg.exe";
            ffmpeg.StartInfo.CreateNoWindow = true;
            ffmpeg.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
            ffmpeg.Start();
            ffmpeg.WaitForExit(1000 * 10);

            return true;
        }

        public static void WriteLogFile(string fileName, string methodName, string message)
        {

            try
            {
                string filepath = HostingEnvironment.MapPath("~/") + "\\" + _logFilename;
                if (!string.IsNullOrEmpty(message))
                {
                    using (FileStream file = new FileStream(filepath, File.Exists(filepath)? FileMode.Append:FileMode.OpenOrCreate, FileAccess.Write))
                    {
                        StreamWriter streamWriter = new StreamWriter(file);
                        streamWriter.WriteLine((((System.DateTime.Now + " - ") + fileName + " - ") + methodName + " - ") + message);
                        streamWriter.Close();
                    }
                }
            }
            catch {

            }

        }

        public static string GetBaseUrl()
        {
            var request = HttpContext.Current.Request;
            var appUrl = HttpRuntime.AppDomainAppVirtualPath;
            var baseUrl = string.Format("{0}://{1}{2}", request.Url.Scheme, request.Url.Authority, appUrl);

            return baseUrl;
        }

        public static string GetContactPhone(string mobile_phone,
            string office_phone_region,
            string office_phone)
        {
            string ret = "";
            if (mobile_phone != null && mobile_phone.Trim().Length != 0)
                ret += mobile_phone.Trim();
            if (office_phone_region != null && office_phone_region.Trim().Length != 0)
            {
                if (office_phone != null && office_phone.Trim().Length != 0)
                {
                    if (ret != "")
                        ret = ret + ", ";
                    ret += office_phone_region.Trim() + "-";
                }
            }

            if (office_phone != null && office_phone.Trim().Length != 0)
            {
                if (ret != "")
                    if (office_phone_region == null || office_phone_region.Trim().Length == 0)
                        ret += ", ";
                ret += office_phone.Trim();
            }

            return ret;
        }

        public static bool CleanHistory()
        {
            string fileTempDir = HostingEnvironment.MapPath("~/FileTmp");
            if (Directory.Exists(fileTempDir))
            {
                DirectoryInfo dirInfo = new DirectoryInfo(fileTempDir);

                // Insert by AnH.(2013.03.18)
                DeleteDirectory(dirInfo);
                return true;
            }

            return false;
        }

        // Insert by AnH.(2013.03.20)
        public static bool DeleteDirectory(DirectoryInfo dirInfo)
        {
            foreach (System.IO.FileInfo file in dirInfo.GetFiles())
            {
                try
                {
                    if (file.IsReadOnly)
                        file.Attributes = FileAttributes.Normal;
                    file.Delete();
                }
                catch (System.Exception ex)
                {
                    CommonModel.WriteLogFile("CommonModel", "DeleteDirectory() -> Delete file", ex.ToString());
                }
            }

            foreach (System.IO.DirectoryInfo subDirectory in dirInfo.GetDirectories())
            {
                DeleteDirectory(subDirectory);

                try
                {
                    if (dirInfo.Attributes == FileAttributes.ReadOnly)
                        dirInfo.Attributes = FileAttributes.Normal;
                    dirInfo.Delete(true);
                }
                catch (System.Exception ex)
                {
                    CommonModel.WriteLogFile("CommonModel", "DeleteDirectory() -> Delete directory", ex.ToString());
                }
            }

            return true;
        }

        public static string GetSHA1Hash(string value)
        {
            SHA1 sha1Hasher = SHA1.Create();
            byte[] data = sha1Hasher.ComputeHash(Encoding.Default.GetBytes(value));
            StringBuilder sBuilder = new StringBuilder();
            for (int i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }
            return sBuilder.ToString();
        }

        public static DshDBModelDataContext GetDBContext()
        {
            _db = new DshDBModelDataContext(ConfigurationManager.ConnectionStrings["DshBackendConnectionString"].ConnectionString);
            return _db;
        }



        public static string GetNavTitle(string navname)
        {
            string rst = "NULL";
            switch (navname)
            {
                case "Home":
                    rst = "首頁";
                    break;
                case "Manager":
                    rst = "用戶個人資料";
                    break;
                case "Physiology":
                    rst = "生理資料";
                    break;
                case "SportRecord":
                    rst = "運動記錄";
                    break;
                case "FoodRecord":
                    rst = "飲食記錄";
                    break;
                case "PhysiologyRecord":
                    rst = "每日用戶記錄";
                    break;
                case "BaseData":
                    rst = "基礎數據";
                    break;
                case "Sport":
                    rst = "運動項目";
                    break;
                case "AddSport":
                    rst = "新增運動項目";
                    break;
                case "AddQuestionType":
                    rst = "新增Q&A分類";
                    break;
                case "Food":
                    rst = "飲食項目";
                    break;
                case "QuestionType":
                    rst = "Q&A論壇分類";
                    break;
                case "Note":
                    rst = "說明管理";
                    break;
                case "Health":
                    rst = "衛教資訊";
                    break;
                case "Video":
                    rst = "衛教影片";
                    break;
                case "News":
                    rst = "最新資訊";
                    break;
                case "QuestionRecord":
                    rst = "線上Q&A";
                    break;
                case "User":
                    rst = "帳號管理";
                    break;
                case "PhoneUser":
                    rst = "手機端帳號";
                    break;
                case "Admin":
                    rst = "管理帳號";
                    break;
                case "AddUser":
                    rst = "新增管理员";
                    break;
                case "EditUser":
                    rst = "编辑管理员";
                    break;
                case "AdminRole":
                    rst = "管理角色";
                    break;
                case "AddRole":
                    rst = "新增角色";
                    break;
                case "EditRole":
                    rst = "编辑角色";
                    break;
                case "AddNews":
                    rst = "新增資訊";
                    break;
                case "EditNews":
                    rst = "编辑資訊";
                    break;
                case "AddAgent":
                    rst = "新增帳號";
                    break;
                case "EditAgent":
                    rst = "编辑帳號";
                    break;
                case "ChangePwd":
                    rst = "修改密碼";
                    break;
            }

            return rst;
        }

        public static string GetNavLink(string navname, string rootUri)
        {
            string rst = "NULL";
            switch (navname)
            {
                case "Home":
                    rst = rootUri;
                    break;
                case "Manager":
                    rst = rootUri + "Manager";
                    break;
                case "Physiology":
                    rst = rootUri + "Physiology";
                    break;
                case "SportRecord":
                    rst = rootUri + "SportRecord";
                    break;
                case "FoodRecord":
                    rst = rootUri + "FoodRecord";
                    break;
                case "PhysiologyRecord":
                    rst = rootUri + "PhysiologyRecord";
                    break;
                case "BaseData":
                    rst = rootUri + "BaseData/Sport";
                    break;
                case "Sport":
                    rst = rootUri + "BaseData/Sport";
                    break;
                case "Food":
                    rst = rootUri + "BaseData/Food";
                    break;
                case "QuestionType":
                    rst = rootUri + "BaseData/QuestionType";
                    break;
                case "Note":
                    rst = rootUri + "BaseData/BMINote";
                    break;
                case "Health":
                    rst = rootUri + "Health/HealthViedo";
                    break;
                case "Video":
                    rst = rootUri + "Health/HealthViedo";
                    break;
                case "News":
                    rst = rootUri + "Health/HealthViedo";
                    break;
                case "QuestionRecord":
                    rst = rootUri + "QuestionRecord";
                    break;
                case "User":
                    rst = rootUri + "User/PhoneUser";
                    break;
                case "PhoneUser":
                    rst = rootUri + "User/PhoneUser";
                    break;
                case "Admin":
                    rst = rootUri + "User/Admin";
                    break;
                case "AdminRole":
                    rst = rootUri + "User/AdminRole";
                    break;
            }

            return rst;
        }

        public static List<TopNavInfo> GetTopNavInfo(string level1str, string level2str, string level3str, string level4str, string rootUri)
        {
            List<TopNavInfo> retlist = new List<TopNavInfo>();

            if (!String.IsNullOrEmpty(level1str))
            {
                TopNavInfo newitem = new TopNavInfo();

                if (!String.IsNullOrEmpty(level2str))
                {
                    newitem.isend = false;
                }

                newitem.title = GetNavTitle(level1str);
                newitem.linkurl = GetNavLink(level1str, rootUri);

                retlist.Add(newitem);
            }

            if (!String.IsNullOrEmpty(level2str))
            {
                TopNavInfo newitem = new TopNavInfo();

                if (!String.IsNullOrEmpty(level3str))
                {
                    newitem.isend = false;
                    newitem.linkurl = GetNavLink(level2str, rootUri);
                }
                else
                {
                    newitem.isend = true;
                }

                newitem.title = GetNavTitle(level2str);
                retlist.Add(newitem);
            }

            if (!String.IsNullOrEmpty(level3str))
            {
                TopNavInfo newitem = new TopNavInfo();

                if (!String.IsNullOrEmpty(level4str))
                {
                    newitem.isend = false;
                    newitem.linkurl = GetNavLink(level3str, rootUri);
                }
                else
                {
                    newitem.isend = true;
                }

                newitem.title = GetNavTitle(level3str);
                retlist.Add(newitem);
            }

            if (!String.IsNullOrEmpty(level4str))
            {
                TopNavInfo newitem = new TopNavInfo();

                newitem.isend = true;

                newitem.title = GetNavTitle(level4str);
                retlist.Add(newitem);
            }

            return retlist;
        }

        public static void releaseObject(object obj)
        {
            try
            {
                System.Runtime.InteropServices.Marshal.ReleaseComObject(obj);
                obj = null;
            }
            catch (Exception)
            {
                obj = null;
            }
            finally
            {
                GC.Collect();
            }
        }

        public static string GetUnescapedString(string s)
        {
            s = s.Replace("%3C", "<");
            s = s.Replace("%3E", ">");
            s = s.Replace("%0A", "");
            s = s.Replace("%09", "");
            s = s.Replace("%20", " ");
            s = s.Replace("%3D", "=");
            s = s.Replace("%22", "\"");
            s = s.Replace("%3A", ":");
            s = s.Replace("%23", "#");
            s = s.Replace("%3B", ";");

            return s;
        }

        public static string GetFirstActionForRole()
        {
            string cookieName = FormsAuthentication.FormsCookieName;// FormsAuthentication.FormsCookieName;

            HttpCookie authCookie = HttpContext.Current.Request.Cookies[cookieName];

            FormsAuthenticationTicket authTicket = FormsAuthentication.Decrypt(authCookie.Value);

            string[] udata = authTicket.UserData.Split(new Char[] { '|' });
            if (udata.Count() > 0)
            {
                string[] roles = udata[0].Split(new Char[] { ',' });
                if (roles.Count() > 0)
                {
                    if (roles[0] == "business")
                        return "Card";
                    else if (roles[0] == "shop")
                        return "Shop";
                    else if (roles[0] == "catalog")
                        return "Catalog";
                    else if (roles[0] == "money")
                        return "Money";
                    else if (roles[0] == "user")
                        return "User";
                    else if (roles[0] == "device")
                        return "Device";
                    else if (roles[0] == "role")
                        return "Admin";
                    else if (roles[0] == "basedata")
                        return "Admin";
                    else if (roles[0] == "admin")
                        return "Admin";
                    else if (roles[0] == "ownshop")
                        return "Shop";
                }
            }

            return "";
        }

        public static string GetFirstActionResultForRole()
        {
            string cookieName = FormsAuthentication.FormsCookieName;// FormsAuthentication.FormsCookieName;

            HttpCookie authCookie = HttpContext.Current.Request.Cookies[cookieName];

            FormsAuthenticationTicket authTicket = FormsAuthentication.Decrypt(authCookie.Value);

            string[] udata = authTicket.UserData.Split(new Char[] { '|' });
            if (udata.Count() > 0)
            {
                string[] roles = udata[0].Split(new Char[] { ',' });
                if (roles.Count() > 0)
                {
                    if (roles[0] == "business")
                        return "BankCard";
                    else if (roles[0] == "shop")
                        return "ShopList";
                    else if (roles[0] == "catalog")
                        return "ExtraCatalogList";
                    else if (roles[0] == "money")
                        return "SaleList";
                    else if (roles[0] == "user")
                        return "UserList";
                    else if (roles[0] == "device")
                        return "DeviceList";
                    else if (roles[0] == "role")
                        return "RoleList";
                    else if (roles[0] == "basedata")
                        return "KindList";
                    else if (roles[0] == "admin")
                        return "AdminList";
                    else if (roles[0] == "ownshop")
                        return "TicketList";
                }
            }

            return "";
        }

        public static string GetMD5Hash(string value)
        {
            MD5 md5Hasher = MD5.Create();
            byte[] data = md5Hasher.ComputeHash(Encoding.Default.GetBytes(value));
            StringBuilder sBuilder = new StringBuilder();
            for (int i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }
            return sBuilder.ToString();
        }

        public static string GetUserRoleInfo()
        {
            FormsIdentity fId = (FormsIdentity)HttpContext.Current.User.Identity;
            FormsAuthenticationTicket authTicket = fId.Ticket;
            string[] udata = authTicket.UserData.Split(new Char[] { '|' });
            string role = udata[0];

            return role;
        }

        public static string GetRandVerify()
        {
            Random _rng = new Random();
            string _chars = "0123456789";

            char[] buffer = new char[VERIFY_LENGTH];

            for (int i = 0;i < VERIFY_LENGTH;i++)
                buffer[i] = _chars[_rng.Next(_chars.Length)];

            return new string(buffer);
        }
    }
}