using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Runtime.Serialization;
using DSHWebService.Model;
using System.IO;
using System.Web.Hosting;
using System.Security.Cryptography;
using System.Text;
using System.Reflection;

namespace DSHWebService.Common
{
    #region Error constants
    public enum ServiceRetCode
    {
        ERR_SUCCESS = 0,
        ERR_SERVERINTERNALERROR = -1,
        ERR_TRIALVERSION = -2,
        ERR_NOTEXISTUSER = -3,
        ERR_NOTEXISTPHONE = -4,
        ERR_EXISTEDUSER = -5,
        ERR_EXISTEDPHONE = -6,
        ERR_VERIFYEXPIRE = -7,
        ERR_VERIFYOVER = -8,
        ERR_INVALIDPARAM = -9
    }

    public enum ServiceMode
    {
        MODE_BANK = 0,
        MODE_CREDIT = 1,
        MODE_INSURANCE = 2,
        MODE_PROPERTY = 3,
        MODE_SMALLMONEY = 4,
        MODE_INSURANCEBUSINESS = 5
    }
    #endregion

    #region [DataContract] - Common
    [DataContract]
    [Newtonsoft.Json.JsonObject(MemberSerialization = Newtonsoft.Json.MemberSerialization.OptIn)]
    public class ServiceResponseData
    {
        [DataMember(Name = "RETVAL", Order = 1)]
        public ServiceRetCode RetVal { get; set; }

        object retdata = new object();
        [DataMember(Name = "RETDATA", Order = 2), Newtonsoft.Json.JsonProperty]
        public object RetData
        {
            get { return retdata; }
            set { retdata = value; }
        }

        String baseurl = ConfigurationManager.AppSettings["ServerRootUri"];
        [DataMember(Name = "BASEURL", Order = 3)]
        public String BaseUrl
        {
            get { return baseurl; }
            set { baseurl = value; }
        }
    }
    #endregion

    public class Common
    {

        #region CONSTANT
        public static int SMSREQCOUNT = 3;
        public static int VERIFYKEY_LENGTH = 6;
        public static int GOODLIST_COUNT = 10;
        public static string    SMSSUCCESSPATTERN = "sms&stat=100";
        #endregion

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

        public static void WriteError(string errFunc, string strMessage)
        {
            DateTime dtNow = DateTime.Now;
            String strFileName = "DSHLog_" + dtNow.ToString("yyyMMdd") + ".log";

            try
            {
                StreamWriter w = File.AppendText(HostingEnvironment.ApplicationPhysicalPath + "\\" + strFileName);
                w.WriteLine("{0}--{1}--{2}--{3}", DateTime.Now.ToShortDateString(), DateTime.Now.ToShortTimeString(), errFunc, strMessage);
                w.Flush();
                w.Close();
            }
            catch { }
        }

        public static String GetRandVerifyKey()
        {
            Random _rng = new Random();
            string _chars = "0123456789";
            char[] buffer = new char[VERIFYKEY_LENGTH];

            for (int i = 0; i < VERIFYKEY_LENGTH; i++)
                buffer[i] = _chars[_rng.Next(_chars.Length)];

            return new string(buffer);
        }

        public static string SaveImage(string szImageData)
        {
            if (szImageData == string.Empty || szImageData == null)
                return string.Empty;

            string newPath = ConfigurationManager.AppSettings["uploadImagePath"];
            string savePath = ConfigurationManager.AppSettings["saveImagePath"];
            string szFileName = DateTime.Now.ToString("yyyyMMddHHmmss") + ".jpg";

            try
            {
                byte[] imgData = Convert.FromBase64String(szImageData);

                File.WriteAllBytes(newPath + savePath + szFileName, imgData);
            }
            catch (System.Exception ex)
            {
                WriteError(MethodBase.GetCurrentMethod().Name, ex.Message);

                return string.Empty;
            }

            return savePath + szFileName;
        }
    }
}