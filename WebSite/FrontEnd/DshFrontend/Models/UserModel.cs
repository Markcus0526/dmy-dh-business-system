using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Hosting;
using DshFrontend.Models.Library;
using System.Collections.Specialized;
using System.Security.Cryptography;
using System.Text;
using System.Web.Security;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;
using System.Globalization;
using System.IO;
using System.Net;

namespace DshFrontend.Models
{
    public class UserInfo
    {
        public long uid { get; set; }
        public string username { get; set; }
        public string rolename { get; set; }
        public string role { get; set; }
        public DateTime createtime { get; set; }
        public DateTime? lasttime { get; set; }
        public string lastip { get; set; }
    }
    
    public class UserModel
    {
        private DshDBModelDataContext db = new DshDBModelDataContext();

        #region User Register

        const int SMS_REQCOUNT = 3;

        public string SendTestSMS(string receiver, string contents)
        {
            string rst = "";

            string smsurl = GetSMSServiceUrl("http://api.sms.cn/mt/?uid=短信通账号&pwd=短信通密码&mobile=发送的手机号码&mobileids=其他接口参数1&content=发送的短信内容", "54513", "l45672", receiver, HttpUtility.UrlEncode(contents), "", "") + "&encode=utf8";

            var request = (HttpWebRequest)WebRequest.Create(smsurl);
            var postData = "";  //请填写post数据
            var data = Encoding.UTF8.GetBytes(postData);

            request.Method = "POST";
            request.ContentType = "application/x-www-form-urlencoded; charset=utf-8";
            request.ContentLength = data.Length;

            using (var stream = request.GetRequestStream())
            {
                stream.Write(data, 0, data.Length);
            }

            var response = (HttpWebResponse)request.GetResponse();

            rst = new StreamReader(response.GetResponseStream()).ReadToEnd();

            return rst;
        }

        public static string GetSMSServiceUrl(string orgurl, string smsuser, string smspass, string phonenum, string contents, string param1, string param2)
        {
            string rst = orgurl;

            rst = rst.Replace("短信通账号", smsuser);
            rst = rst.Replace("短信通密码", CommonModel.GetMD5Hash(smspass + smsuser));
            rst = rst.Replace("发送的手机号码", phonenum);
            rst = rst.Replace("发送的短信内容", HttpUtility.UrlEncode(Encoding.GetEncoding("GBK").GetString(Encoding.UTF8.GetBytes(contents))));
            rst = rst.Replace("其他接口参数1", param1);
            rst = rst.Replace("其他接口参数2", param2);

            return rst;
        }

        public static string SMSSUCCESSPATTERN = "sms&stat=100";
        public string InsertOrUpdatePhonenum(string phonenum)
        {
            DateTime startTime = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0);
            DateTime endTime = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 23, 59, 59);
            int nCount = (from m in db.tbl_sms
                          where m.deleted == 0 && m.phonenum.Equals(phonenum) && m.code_regtime >= startTime && m.code_regtime <= endTime
                          select m.uid).Count();

            if (nCount < SMS_REQCOUNT)
            {
                string strVerifyKey = CommonModel.GenerateRandomCode(6); ;
                DateTime nowTime = DateTime.Now;
                string smsbody = strVerifyKey + "（动态验证码），您于 " + nowTime.ToString("yyyy-MM-dd hh:mm:ss") + " 申请微信会员卡，请及时使用【与众科技】";

                string retCode = SendTestSMS(phonenum, smsbody);
                if (retCode.Contains(SMSSUCCESSPATTERN))
                {
                    tbl_sm newLog = new tbl_sm();
                    newLog.code_regtime = nowTime;
                    newLog.phonenum = phonenum;
                    newLog.verify_code = strVerifyKey;
                    newLog.expired = 0;
                    newLog.deleted = 0;

                    db.tbl_sms.InsertOnSubmit(newLog);
                    db.SubmitChanges();
                }
            }
            else
            {
                return "你已经邀请了3次，不能邀请";
            }

            return "";
        }

        public string InsertUserByPhonenum(string phonenum, string username, string userpwd)
        {
            string rst = "";
            tbl_user newitem = new tbl_user();

            newitem.phonenum = phonenum;
            newitem.userid = username;
            newitem.username = username;
            newitem.password = CommonModel.GetMD5Hash(userpwd);
            newitem.regtime = DateTime.Now;

            db.tbl_users.InsertOnSubmit(newitem);

            db.SubmitChanges();

            rst = "";

            return rst;
        }

        public tbl_user GetUserByPhonenum(string phonenum)
        {
            return db.tbl_users
                .Where(m => m.deleted == 0 && m.phonenum == phonenum)
                .FirstOrDefault();
        }

        public bool CheckDuplicateName(long rid, string username)
        {
            bool rst = true;
            rst = ((from m in db.tbl_users
                    where m.deleted == 0 && m.username == username && m.regtime != null /*m.code_flag == 1*/ && m.uid != rid
                    select m).FirstOrDefault() == null);

            return rst;
        }

        public bool CheckDuplicatePhonenum(long rid, string phonenum)
        {
            bool rst = true;
            rst = ((from m in db.tbl_users
                    where m.deleted == 0 && m.phonenum == phonenum && m.regtime != null /*m.code_flag == 1*/ && m.uid != rid
                    select m).FirstOrDefault() == null);

            return rst;
        }

        public bool CheckRightVerifyCode(string phonenum, string verify_code)
        {
            bool rst = false;
            var smsitem = (from m in db.tbl_sms
                    where m.deleted == 0 && m.phonenum == phonenum
                    orderby m.uid descending
                    select m).FirstOrDefault();
            if (smsitem != null)
            {
                if (smsitem.verify_code == verify_code)
                    return true;
            }

            return rst;
        }

        public bool CheckVerifyCodeAvailable(string phonenum, string verify_code)
        {
            bool rst = false;
            var smsitem = (from m in db.tbl_sms
                           where m.deleted == 0 && m.phonenum == phonenum
                           orderby m.uid descending
                           select m).FirstOrDefault();
            if (smsitem != null)
            {
                if (smsitem.verify_code == verify_code && (DateTime.Now - smsitem.code_regtime).TotalMinutes <= 3)
                    return true;
            }

            return rst;
        }

        #endregion
        
        #region User CRUD

        public tbl_user GetUserById(long uid)
        {
            return db.tbl_users
                .Where(m => m.deleted == 0 && m.uid == uid)
                .FirstOrDefault();
        }

        public string UpdateUser(long uid, string userid, string username, string birthday, string email, string phonenum, string image)
        {
            string rst = "";
            tbl_user edititem = GetUserById(uid);

            string savepath = "Content/uploads/img/" + String.Format("{0:yyyyMMdd}", DateTime.Now) + "/";
            string orgbase = HostingEnvironment.MapPath("~/");
            string targetbase = HostingEnvironment.MapPath("~/" + savepath);



            if (edititem != null)
            {
                edititem.userid = userid;
                edititem.username = username;
                edititem.birthday = Convert.ToDateTime(birthday);
                edititem.email = email;
                edititem.phonenum = phonenum;


                //if (File.Exists(orgbase + image))
                //{
                //    if (!Directory.Exists(targetbase))
                //    {
                //        Directory.CreateDirectory(targetbase);
                //    }
                //    File.Move(orgbase + image, targetbase + image);
                //    edititem.image = savepath + image;
                //}
                edititem.image = image;

                db.SubmitChanges();
                rst = "";
            }
            else
            {
                rst = "用户不存在";
            }

            return rst;
        }

        public string UpdateUserPassword(long uid, string password)
        {
            string rst = "";

             tbl_user edititem = GetUserById(uid);

             if (edititem != null)
             {
                 if (edititem.password != password)
                     edititem.password = CommonModel.GetMD5Hash(password);
                 db.SubmitChanges();
             }
             else
             {
                 rst = "用户不存在";
             }

            return rst;
        }

        #endregion

        #region Userlog

        public bool InsertUserLog(long userid, string macaddr)
        {
            tbl_userlog userlog = new tbl_userlog();

            userlog.logintime = DateTime.Now;
            userlog.devtype = 0;
            userlog.userid = userid;
            userlog.macaddr = macaddr;

            db.tbl_userlogs.InsertOnSubmit(userlog);

            db.SubmitChanges();

            return true;
        }

        #endregion
    }
}