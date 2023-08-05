using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DSHWebService.Common;
using System.Reflection;
using System.IO;
using System.Net;
using System.Text;
using System.Security.Cryptography;
using System.Configuration;

namespace DSHWebService.Model
{
    public class ServiceBody
    {
        public static ServiceResponseData LoginUser(string username, string password, string macaddr, string devtype)
        {
            ServiceResponseData retData = new ServiceResponseData();
            DSHDBDataContext context = new DSHDBDataContext();
            
            try
            {
                tbl_user userInfo = (from m in context.tbl_users
                                     where m.deleted == 0 && m.userid.Equals(username) && m.password.Equals(Common.Common.GetMD5Hash(password))
                                     select m).FirstOrDefault();
                if (userInfo == null)
                {
                    retData.RetVal = Common.ServiceRetCode.ERR_NOTEXISTUSER;
                    retData.RetData = "您输入的或密码有误";
                }
                else
                {
                    tbl_userlog logInfo = new tbl_userlog();
                    logInfo.userid = userInfo.uid;
                    logInfo.macaddr = macaddr;
                    logInfo.devtype = byte.Parse(devtype);
                    logInfo.logintime = DateTime.Now;
                    logInfo.deleted = 0;

                    context.tbl_userlogs.InsertOnSubmit(logInfo);
                    context.SubmitChanges();

                    retData.RetData = userInfo.uid;
                }
            }
            catch (Exception ex)
            {
                Common.Common.WriteError(MethodBase.GetCurrentMethod().Name, ex.Message);
                retData.RetVal = Common.ServiceRetCode.ERR_SERVERINTERNALERROR;
                retData.RetData = "服务器内部错误";
            }

            return retData;
        }

        public static string SendTestSMS(string receiver, string contents)
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
            rst = rst.Replace("短信通密码", Common.Common.GetMD5Hash(smspass + smsuser));
            rst = rst.Replace("发送的手机号码", phonenum);
            rst = rst.Replace("发送的短信内容", HttpUtility.UrlEncode(Encoding.GetEncoding("GBK").GetString(Encoding.UTF8.GetBytes(contents))));
            rst = rst.Replace("其他接口参数1", param1);
            rst = rst.Replace("其他接口参数2", param2);

            return rst;
        }

        public static ServiceResponseData ReqVerifyKey(string phonenum)
        {
            ServiceResponseData retData = new ServiceResponseData();
            DSHDBDataContext context = new DSHDBDataContext();

            try
            {
                DateTime startTime = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0);
                DateTime endTime = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 23, 59, 59);
                int nCount = (from m in context.tbl_sms
                                  where m.deleted == 0 && m.phonenum.Equals(phonenum) && m.code_regtime >= startTime && m.code_regtime <= endTime
                                  select m.uid).Count();

                if (nCount < Common.Common.SMSREQCOUNT)
                {
                    string strVerifyKey = Common.Common.GetRandVerifyKey();
                    DateTime nowTime = DateTime.Now;
                    string smsbody = strVerifyKey + "（动态验证码），您于 " + nowTime.ToString("yyyy-MM-dd HH:mm:ss") + " 申请微信会员卡，请及时使用【与众科技】";

                    string retCode = SendTestSMS(phonenum, smsbody);
                    if (retCode.Contains(Common.Common.SMSSUCCESSPATTERN))
                    {
                        tbl_sm newLog = new tbl_sm();
                        newLog.code_regtime = nowTime;
                        newLog.phonenum = phonenum;
                        newLog.verify_code = strVerifyKey;
                        newLog.expired = 0;
                        newLog.deleted = 0;

                        context.tbl_sms.InsertOnSubmit(newLog);
                        context.SubmitChanges();
                    }
                    else
                    {
                        retData.RetVal = Common.ServiceRetCode.ERR_INVALIDPARAM;
                    }
                }
                else
                {
                    retData.RetVal = Common.ServiceRetCode.ERR_VERIFYOVER;
                }
            }
            catch (System.Exception ex)
            {
                Common.Common.WriteError(MethodBase.GetCurrentMethod().Name, ex.Message);
                retData.RetVal = Common.ServiceRetCode.ERR_SERVERINTERNALERROR;
            }

            return retData;
        }

        public static ServiceResponseData ConfirmVerifyKey(string phonenum, string verifykey)
        {
            ServiceResponseData retData = new ServiceResponseData();
            DSHDBDataContext context = new DSHDBDataContext();

            try
            {
                tbl_sm info = (from m in context.tbl_sms
                               where m.deleted == 0 && m.phonenum.Equals(phonenum) && m.verify_code.Equals(verifykey)
                               orderby m.code_regtime descending
                               select m).FirstOrDefault();

                if (info == null)
                {
                    retData.RetVal = Common.ServiceRetCode.ERR_INVALIDPARAM;
                }
                else
                {
                    DateTime toDate = DateTime.Now;
                    if (info.code_regtime.AddMinutes(3) >= toDate)
                    {
                        retData.RetVal = Common.ServiceRetCode.ERR_SUCCESS;
                    }
                    else
                    {
                        retData.RetVal = Common.ServiceRetCode.ERR_VERIFYEXPIRE;
                    }
                }
            }
            catch (System.Exception ex)
            {
                retData.RetVal = Common.ServiceRetCode.ERR_SERVERINTERNALERROR;
                Common.Common.WriteError(MethodBase.GetCurrentMethod().Name, ex.Message);
            }

            return retData;
        }

        public static ServiceResponseData RegisterUser(string username, string password, string phonenum, string macaddr, string devtype)
        {
            ServiceResponseData retData = new ServiceResponseData();
            DSHDBDataContext context = new DSHDBDataContext();

            try
            {
                tbl_user info = (from m in context.tbl_users
                                     where m.deleted == 0 && m.userid.Equals(username)
                                     select m).FirstOrDefault();

                if (info != null)
                {
                    retData.RetVal = Common.ServiceRetCode.ERR_EXISTEDUSER;
                }
                else
                {
                    info = (from m in context.tbl_users
                            where m.deleted == 0 && m.phonenum.Equals(phonenum)
                            select m).FirstOrDefault();
                    if (info != null)
                    {
                        retData.RetVal = Common.ServiceRetCode.ERR_EXISTEDPHONE;
                    }
                    else
                    {
                        tbl_user newUser = new tbl_user();
                        newUser.userid = username;
                        newUser.password = Common.Common.GetMD5Hash(password);
                        newUser.phonenum = phonenum;
                        newUser.regtime = DateTime.Now;
                        newUser.score = 0;
                        newUser.sale_cnt = 0;
                        newUser.deleted = 0;
                        newUser.birthday = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0);

                        context.tbl_users.InsertOnSubmit(newUser);
                        context.SubmitChanges();

                        tbl_user insertedUser = (from m in context.tbl_users
                                                     where m.deleted == 0 && m.userid.Equals(username) && m.password.Equals(Common.Common.GetMD5Hash(password))
                                                     select m).FirstOrDefault();

                        tbl_userlog logInfo = new tbl_userlog();
                        logInfo.userid = insertedUser.uid;
                        logInfo.macaddr = macaddr;
                        logInfo.devtype = byte.Parse(devtype);
                        logInfo.logintime = DateTime.Now;
                        logInfo.deleted = 0;

                        context.tbl_userlogs.InsertOnSubmit(logInfo);
                        context.SubmitChanges();

                        retData.RetVal = Common.ServiceRetCode.ERR_SUCCESS;
                        retData.RetData = insertedUser.uid;
                    }
                }                
            }
            catch (System.Exception ex)
            {
                retData.RetVal = Common.ServiceRetCode.ERR_SERVERINTERNALERROR;
                Common.Common.WriteError(MethodBase.GetCurrentMethod().Name, ex.Message);
            }

            return retData;
        }

        public static ServiceResponseData ResetPassword(string uid, string phonenum, string password)
        {
        	ServiceResponseData retData = new ServiceResponseData();
        	DSHDBDataContext context = new DSHDBDataContext();
        	
        	try
        	{
                long nUID = long.Parse(uid);

                if (nUID == 0)
                {
                    tbl_user info = (from m in context.tbl_users
                                     where m.deleted == 0 && m.phonenum.Equals(phonenum)
                                     select m).FirstOrDefault();
                    if (info == null)
                    {
                        retData.RetVal = Common.ServiceRetCode.ERR_NOTEXISTPHONE;
                    }
                    else
                    {
                        info.password = Common.Common.GetMD5Hash(password);

                        context.SubmitChanges();
                    }
                }
                else
                {
                    tbl_user info = (from m in context.tbl_users
                                     where m.deleted == 0 && m.uid == nUID
                                     select m).FirstOrDefault();
                    if (info == null)
                    {
                        retData.RetVal = Common.ServiceRetCode.ERR_NOTEXISTUSER;
                    }
                    else
                    {
                        info.password = Common.Common.GetMD5Hash(password);

                        context.SubmitChanges();
                    }
                }
        	}
        	catch (System.Exception ex)
        	{
        		retData.RetVal = Common.ServiceRetCode.ERR_SERVERINTERNALERROR;
        		Common.Common.WriteError(MethodBase.GetCurrentMethod().Name, ex.Message);
        	}
        	
        	return retData;
        }

        public class UserInfo
        {
            public long uid = 0;
            public string userid = string.Empty;
            public string username = string.Empty;
            public string birth = string.Empty;
            public string email = string.Empty;
            public int ordercount = 0;
            public string phonenum = string.Empty;
            public string imgpath = string.Empty;
            public int credit = 0;
        }

        public static ServiceResponseData GetUserInfo(string uid)
        {
            ServiceResponseData retData = new ServiceResponseData();
            DSHDBDataContext context = new DSHDBDataContext();

            UserInfo userInfo = new UserInfo();

            try
            {
                long nUID = long.Parse(uid);

                tbl_user info = (from m in context.tbl_users
                                         where m.deleted == 0 && m.uid == nUID
                                         select m).FirstOrDefault();

                if (userInfo == null)
                {
                    retData.RetVal = Common.ServiceRetCode.ERR_NOTEXISTUSER;
                    retData.RetData = null;
                }
                else
                {
                    userInfo.uid = nUID;
                    userInfo.userid = (info.userid == null) ? string.Empty : info.userid;
                    userInfo.username = (info.username == null) ? string.Empty : info.username;
                    userInfo.birth = String.Format("{0:yyyy-MM-dd}", info.birthday);
                    userInfo.email = (info.email == null) ? string.Empty : info.email;
                    userInfo.ordercount = info.sale_cnt;
                    userInfo.phonenum = (info.phonenum == null) ? string.Empty : info.phonenum;
                    userInfo.imgpath = (info.image == null) ? string.Empty : info.image;
                    userInfo.credit = info.score;

                    retData.RetVal = Common.ServiceRetCode.ERR_SUCCESS;
                    retData.RetData = userInfo;
                }
            }
            catch (System.Exception ex)
            {
                retData.RetVal = Common.ServiceRetCode.ERR_SERVERINTERNALERROR;
                retData.RetData = null;
                Common.Common.WriteError(MethodBase.GetCurrentMethod().Name, ex.Message);
            }

            return retData;
        }

        public static ServiceResponseData UpdateUserInfo(string uid, string username, string birthday, string email, string phonenum, string imgdata)
        {
        	ServiceResponseData retData = new ServiceResponseData();
        	DSHDBDataContext context = new DSHDBDataContext();
        	
        	try
        	{
                long nUID = long.Parse(uid);
                DateTime birthDay = Convert.ToDateTime(birthday);

                tbl_user userInfo = (from m in context.tbl_users
                                     where m.deleted == 0 && m.uid == nUID
                                     select m).FirstOrDefault();
                if (userInfo == null)
                {
                    retData.RetVal = Common.ServiceRetCode.ERR_NOTEXISTUSER;
                }
                else
                {
                    tbl_user userPhone = (from m in context.tbl_users
                                          where m.deleted == 0 && m.uid != nUID && m.phonenum.Equals(phonenum) == true
                                            select m).FirstOrDefault();
                    if (userPhone != null)
                    {
                        retData.RetVal = Common.ServiceRetCode.ERR_EXISTEDPHONE;
                    }
                    else
                    {
                        userInfo.username = username;
                        userInfo.birthday = birthDay;
                        userInfo.email = email;
                        userInfo.phonenum = phonenum;
                        if (imgdata.Length > 0)
                        {
                            string szPath = Common.Common.SaveImage(imgdata);
                            if (szPath != string.Empty)
                            {
                                userInfo.image = szPath;
                            }
                        }

                        context.SubmitChanges();
                        retData.RetVal = Common.ServiceRetCode.ERR_SUCCESS;
                    }
                }
        	}
        	catch (System.Exception ex)
        	{
        		retData.RetVal = Common.ServiceRetCode.ERR_SERVERINTERNALERROR;
        		Common.Common.WriteError(MethodBase.GetCurrentMethod().Name, ex.Message);
        	}
        	
        	return retData;
        }

        public class ServiceItem
        {
            public long uid = 0;
            public string title = string.Empty;
            public string content = string.Empty;
        }
        public static ServiceResponseData GetServiceList(string mode)
        {
        	ServiceResponseData retData = new ServiceResponseData();
        	DSHDBDataContext context = new DSHDBDataContext();

            List<ServiceItem> arrData = new List<ServiceItem>();
        	
        	try
        	{
                int nMode = int.Parse(mode);

                switch (nMode)
                {
                case (int)Common.ServiceMode.MODE_BANK:
                        arrData = (from m in context.tbl_cards
                                   where m.deleted == 0 && m.type == 0
                                   select new ServiceItem
                                   {
                                       uid = m.uid,
                                       title = m.title,
                                       content = m.content
                                   }).ToList();
                	break;
                case (int)Common.ServiceMode.MODE_CREDIT:
                    arrData = (from m in context.tbl_cards
                               where m.deleted == 0 && m.type == 1
                               select new ServiceItem
                               {
                                   uid = m.uid,
                                   title = m.title,
                                   content = m.content
                               }).ToList();
                    break;
                case (int)Common.ServiceMode.MODE_INSURANCE:
                    arrData = (from m in context.tbl_cards
                               where m.deleted == 0 && m.type == 2
                               select new ServiceItem
                               {
                                   uid = m.uid,
                                   title = m.title,
                                   content = m.content
                               }).ToList();
                    break;
                case (int)Common.ServiceMode.MODE_PROPERTY:
                    arrData = (from m in context.tbl_cards
                               where m.deleted == 0 && m.type == 3
                               select new ServiceItem
                               {
                                   uid = m.uid,
                                   title = m.title,
                                   content = m.content
                               }).ToList();
                    break;
                case (int)Common.ServiceMode.MODE_SMALLMONEY:
                    arrData = (from m in context.tbl_cards
                               where m.deleted == 0 && m.type == 4
                               select new ServiceItem
                               {
                                   uid = m.uid,
                                   title = m.title,
                                   content = m.content
                               }).ToList();
                    break;
                }

                if (arrData == null)
                    arrData = new List<ServiceItem>();

                retData.RetVal = Common.ServiceRetCode.ERR_SUCCESS;
                retData.RetData = arrData;
        	}
        	catch (System.Exception ex)
        	{
        		retData.RetVal = Common.ServiceRetCode.ERR_SERVERINTERNALERROR;
        		Common.Common.WriteError(MethodBase.GetCurrentMethod().Name, ex.Message);
        	}
        	
        	return retData;
        }

        public static ServiceResponseData AddServiceItem(string uid, string mode, string cardid, string name, string phonenum, string identiid, string address, string note)
        {
        	ServiceResponseData retData = new ServiceResponseData();
        	DSHDBDataContext context = new DSHDBDataContext();
        	
        	try
        	{
                long nUID = long.Parse(uid);
                int nMode = int.Parse(mode);
                long nCardID = long.Parse(cardid);

                tbl_user userInfo = (from m in context.tbl_users
                                         where m.deleted == 0 && m.uid == nUID
                                         select m).FirstOrDefault();
                if (userInfo == null)
                {
                    retData.RetVal = Common.ServiceRetCode.ERR_NOTEXISTUSER;
                }
                else
                {
                    tbl_card cardInfo = (from m in context.tbl_cards
                                     where m.deleted == 0 && m.uid == nCardID
                                     select m).FirstOrDefault();
                    if (cardInfo == null)
                    {
                        retData.RetVal = Common.ServiceRetCode.ERR_INVALIDPARAM;
                    }
                    else
                    {
                        tbl_cardinfo newInfo = new tbl_cardinfo();
                        newInfo.type = nMode;
                        newInfo.name = name;
                        newInfo.phonenum = phonenum;
                        newInfo.cardnum = identiid;
                        newInfo.addr = address;
                        newInfo.content = note;
                        newInfo.userid = nUID;
                        newInfo.regtime = DateTime.Now;
                        newInfo.cardid = nCardID;
                        newInfo.deleted = 0;

                        context.tbl_cardinfos.InsertOnSubmit(newInfo);
                        context.SubmitChanges();

                        retData.RetVal = Common.ServiceRetCode.ERR_SUCCESS;
                    }
                }                
        	}
        	catch (System.Exception ex)
        	{
        		retData.RetVal = Common.ServiceRetCode.ERR_SERVERINTERNALERROR;
        		Common.Common.WriteError(MethodBase.GetCurrentMethod().Name, ex.Message);
        	}
        	
        	return retData;
        }

        public class RecommendGoodItem
        {
            public long uid = 0;
            public string goodname = string.Empty;
            public string imgpath = string.Empty;
        }
        public static ServiceResponseData GetRecommendGoodList()
        {
        	ServiceResponseData retData = new ServiceResponseData();
        	DSHDBDataContext context = new DSHDBDataContext();

            DateTime dtToday = DateTime.Now;

            List<RecommendGoodItem> arrData = new List<RecommendGoodItem>();
        	
        	try
        	{
                arrData = (from m in context.tbl_catalogs
                           where m.deleted == 0 && m.recommend == 1 && m.startdate <= dtToday && dtToday <= m.enddate
                           orderby m.regtime descending
                           select new RecommendGoodItem
                           {
                               uid = m.uid,
                               goodname = m.name,
                               imgpath = m.recommend_image

                           }).ToList();

                if (arrData == null)
                {
                    arrData = new List<RecommendGoodItem>();

                    retData.RetData = arrData;
                }
                else
                {
                    retData.RetData = arrData.Take(6).ToList();  
                }
        	}
        	catch (System.Exception ex)
        	{
        		retData.RetVal = Common.ServiceRetCode.ERR_SERVERINTERNALERROR;
        		Common.Common.WriteError(MethodBase.GetCurrentMethod().Name, ex.Message);
        	}
        	
        	return retData;
        }

        public class GoodKindItem
        {
            public long uid = 0;
            public string title = string.Empty;
            public string imgpath = string.Empty;
        }
        public static ServiceResponseData GetGoodKindList()
        {
        	ServiceResponseData retData = new ServiceResponseData();
        	DSHDBDataContext context = new DSHDBDataContext();

            List<GoodKindItem> arrData = new List<GoodKindItem>();
        	
        	try
        	{
                arrData = (from m in context.tbl_kinds
                           where m.deleted == 0
                           orderby m.uid ascending
                           select new GoodKindItem
                           {
                               uid = m.uid,
                               title = m.name,
                               imgpath = m.image
                           }).ToList();

                if (arrData == null)
                {
                    arrData = new List<GoodKindItem>();
                    retData.RetData = arrData;
                }
                else
                {
                    retData.RetData = arrData;
                }
        	}
        	catch (System.Exception ex)
        	{
        		retData.RetVal = Common.ServiceRetCode.ERR_SERVERINTERNALERROR;
        		Common.Common.WriteError(MethodBase.GetCurrentMethod().Name, ex.Message);
        	}
        	
        	return retData;
        }

        public class GoodItem
        {
            public long uid = 0;
            public string name = string.Empty;
            public string imgpath = string.Empty;
            public string noti = string.Empty;
            public int price = 0;
            public int selledcount = 0;
        }
        public static int GetSelledGoodCount(long catalogid)
        {
            DSHDBDataContext context = new DSHDBDataContext();

            return context.tbl_sales
                .Where(m => m.deleted == 0 && m.catalogid == catalogid && m.status == 1 && m.back == 0)
                .Count();
        }
        public static ServiceResponseData GetGoodsList(string mode, string kindid, string pageno)
        {
            ServiceResponseData retData = new ServiceResponseData();
            DSHDBDataContext context = new DSHDBDataContext();

            DateTime dtToday = DateTime.Now;

            List<GoodItem> arrData = new List<GoodItem>();

            try
            {
                int nMode = int.Parse(mode); /* 0 : 特惠   1 ：精彩  2 : 网上车*/
                int nKindID = int.Parse(kindid);
                int nPageNo = int.Parse(pageno);

                if (nMode != 2)
                {
                    arrData = (from m in context.tbl_catalogs
                               where m.deleted == 0 && m.show == 1 && m.kindid == nKindID && m.startdate <= dtToday && dtToday <= m.enddate && m.type == nMode && m.count > 0
                               orderby m.uid descending
                               select new GoodItem
                               {
                                   uid = m.uid,
                                   name = m.name,
                                   imgpath = m.image1,
                                   noti = m.sale_desc,
                                   price = m.price,
                                   selledcount = GetSelledGoodCount(m.uid)
                               }).ToList();
                }
                else
                {
                    arrData = (from m in context.tbl_catalogs
                               where m.deleted == 0 && m.show == 1 && m.startdate <= dtToday && dtToday <= m.enddate && m.kindid == nKindID && m.count > 0
                               orderby m.uid descending
                               select new GoodItem
                               {
                                   uid = m.uid,
                                   name = m.name,
                                   imgpath = m.image1,
                                   noti = m.sale_desc,
                                   price = m.price,
                                   selledcount = GetSelledGoodCount(m.uid)
                               }).ToList();
                }

                if (arrData == null)
                {
                    retData.RetData = new List<GoodItem>();
                }
                else
                {
                    retData.RetData = arrData.Skip(nPageNo * Common.Common.GOODLIST_COUNT)
                                             .Take(Common.Common.GOODLIST_COUNT)
                                             .ToList();
                }
            }
            catch (System.Exception ex)
            {
                retData.RetVal = Common.ServiceRetCode.ERR_SERVERINTERNALERROR;
                Common.Common.WriteError(MethodBase.GetCurrentMethod().Name, ex.Message);
            }

            return retData;
        }

        public static ServiceResponseData FindGoodsList(string mode, string kindid, string goodname, string pageno)
        {
        	ServiceResponseData retData = new ServiceResponseData();
        	DSHDBDataContext context = new DSHDBDataContext();

            DateTime dtToday = DateTime.Now;

            List<GoodItem> arrData = new List<GoodItem>();

            try
            {
                int nMode = int.Parse(mode); /* 0 : 特惠   1 ：精彩 */
                int nKindID = int.Parse(kindid);
                int nPageNo = int.Parse(pageno);

                arrData = (from m in context.tbl_catalogs
                           where m.deleted == 0 && m.show == 1 && m.kindid == nKindID && m.startdate <= dtToday && dtToday <= m.enddate && m.type == nMode && m.name.Contains(goodname) && m.count > 0
                           orderby m.uid descending
                           select new GoodItem
                           {
                               uid = m.uid,
                               name = m.name,
                               imgpath = m.image1,
                               noti = m.sale_desc,
                               price = m.price,
                               selledcount = GetSelledGoodCount(m.uid)
                           }).ToList();

                if (arrData == null)
                {
                    retData.RetData = new List<GoodItem>();
                }
                else
                {
                    retData.RetData = arrData.Skip(nPageNo * Common.Common.GOODLIST_COUNT)
                                             .Take(Common.Common.GOODLIST_COUNT)
                                             .ToList();
                }
        	}
        	catch (System.Exception ex)
        	{
        		retData.RetVal = Common.ServiceRetCode.ERR_SERVERINTERNALERROR;
        		Common.Common.WriteError(MethodBase.GetCurrentMethod().Name, ex.Message);
        	}
        	
        	return retData;
        }

        public class GoodDetainInfo
        {
            public long goodid = 0;
            public string name = string.Empty;
            public int price = 0;
            public string imgpath1 = string.Empty;
            public string imgpath2 = string.Empty;
            public string imgpath3 = string.Empty;
            public string imgpath4 = string.Empty;
            public string gooddesc = string.Empty;
            public string shopaddr = string.Empty;
            public string shopphone = string.Empty;
            public string buydesc = string.Empty;
        }
        public static ServiceResponseData GetGoodDetailInfo(string goodid)
        {
        	ServiceResponseData retData = new ServiceResponseData();
        	DSHDBDataContext context = new DSHDBDataContext();

            DateTime dtToday = DateTime.Now;

            GoodDetainInfo detailInfo = new GoodDetainInfo();

        	try
        	{
                long nGoodID = long.Parse(goodid);

                detailInfo = (from m in context.tbl_catalogs
                              where m.deleted == 0 && m.uid == nGoodID && m.startdate <= dtToday && dtToday <= m.enddate
                              select new GoodDetainInfo
                              {
                                  goodid = m.uid,
                                  name = m.name,
                                  price = m.price,
                                  imgpath1 = (m.image1 == null) ? string.Empty : m.image1,
                                  imgpath2 = (m.image2 == null) ? string.Empty : m.image2,
                                  imgpath3 = (m.image3 == null) ? string.Empty : m.image3,
                                  imgpath4 = (m.image4 == null) ? string.Empty : m.image4,
                                  gooddesc = m.catalog_desc,
                                  shopaddr = (m.addr == null) ? string.Empty : m.addr,
                                  shopphone = (m.phonenum == null) ? string.Empty : m.phonenum,
                                  buydesc = m.sale_desc
                              }).FirstOrDefault();

                if (detailInfo == null)
                {
                    detailInfo = new GoodDetainInfo();
                }

                retData.RetData = detailInfo;
                retData.RetVal = Common.ServiceRetCode.ERR_SUCCESS;
        	}
        	catch (System.Exception ex)
        	{
        		retData.RetVal = Common.ServiceRetCode.ERR_SERVERINTERNALERROR;
        		Common.Common.WriteError(MethodBase.GetCurrentMethod().Name, ex.Message);
        	}
        	
        	return retData;
        }

        public static ServiceResponseData AddBusinessMoney(string uid,
                                            string cardid,
                                            string businessname,
                                            string corporatename,
                                            string corporateid,
                                            string corporatephone,
                                            string username,
                                            string userphone,
                                            string useraddress,
                                            string content)
        {
        	ServiceResponseData retData = new ServiceResponseData();
        	DSHDBDataContext context = new DSHDBDataContext();
        	
        	try
        	{
                long nUID = long.Parse(uid);
                long nCardID = long.Parse(cardid);

                tbl_user userInfo = (from m in context.tbl_users
                                     where m.deleted == 0 && m.uid == nUID
                                     select m).FirstOrDefault();
                if (userInfo == null)
                {
                    retData.RetVal = Common.ServiceRetCode.ERR_NOTEXISTUSER;
                }
                else
                {
                    tbl_card cardInfo = (from m in context.tbl_cards
                                         where m.deleted == 0 && m.uid == nCardID
                                         select m).FirstOrDefault();
                    if (cardInfo == null)
                    {
                        retData.RetVal = Common.ServiceRetCode.ERR_INVALIDPARAM;
                    }
                    else
                    {
                        tbl_lend newInfo = new tbl_lend();
                        newInfo.org_name = businessname;
                        newInfo.name = corporatename;
                        newInfo.cardnum = corporateid;
                        newInfo.phonenum = corporatephone;
                        newInfo.org_user = username;
                        newInfo.org_phonenum = userphone;
                        newInfo.org_addr = useraddress;
                        newInfo.content = content;
                        newInfo.cardid = nCardID;
                        newInfo.regtime = DateTime.Now;
                        newInfo.deleted = 0;

                        context.tbl_lends.InsertOnSubmit(newInfo);
                        context.SubmitChanges();

                        retData.RetVal = Common.ServiceRetCode.ERR_SUCCESS;
                    }
                }         
        	}
        	catch (System.Exception ex)
        	{
        		retData.RetVal = Common.ServiceRetCode.ERR_SERVERINTERNALERROR;
        		Common.Common.WriteError(MethodBase.GetCurrentMethod().Name, ex.Message);
        	}
        	
        	return retData;
        }

        public static string GetGoodImgPath(long goodid)
        {
            DSHDBDataContext context = new DSHDBDataContext();

            return (from m in context.tbl_catalogs where m.deleted == 0 && m.uid == goodid select m).FirstOrDefault().image1;
        }

        public static string GetGoodName(long goodid)
        {
            DSHDBDataContext context = new DSHDBDataContext();

            return (from m in context.tbl_catalogs where m.deleted == 0 && m.uid == goodid select m).FirstOrDefault().name;
        }

        public static string GetGoodDesc(long goodid)
        {
            DSHDBDataContext context = new DSHDBDataContext();

            return (from m in context.tbl_catalogs where m.deleted == 0 && m.uid == goodid select m).FirstOrDefault().sale_desc;
        }

        public class GoodStausItem
        {
            public long saleid = 0;
            public long goodid = 0;
            public string imgpath = string.Empty;
            public string goodname = string.Empty;
            public string gooddesc = string.Empty;
            public int evalstatus = 0;
            public int salestatus = 0;
            public int rejectstatus = 0;
            public string buydate = string.Empty;
            public string price = string.Empty;
        }

        public static int GetEvalStatus(long saleid)
        {
            DSHDBDataContext context = new DSHDBDataContext();

            tbl_eval evalInfo = context.tbl_evals
                .Where(m => m.deleted == 0 && m.sid == saleid)
                .Select(m => m).FirstOrDefault();

            if (evalInfo == null)
                return 0;
            else
                return 1;
        }

        public static ServiceResponseData GetMyOrderList(string uid, string mode, string pageno)
        {
        	ServiceResponseData retData = new ServiceResponseData();
        	DSHDBDataContext context = new DSHDBDataContext();

            List<GoodStausItem> arrData = new List<GoodStausItem>();

        	try
        	{
                long nUID = long.Parse(uid);
                int nMode = int.Parse(mode);
                int nPageNo = int.Parse(pageno);

                switch (nMode)
                {
                    case 0:
                        arrData = (from m in context.tbl_sales
                                   where m.deleted == 0 && m.userid == nUID && m.status == 1 && m.back == 0
                                   orderby m.regtime descending
                                   select new GoodStausItem
                                   {
                                       saleid = m.uid,
                                       goodid = m.catalogid,
                                       imgpath = GetGoodImgPath(m.catalogid),
                                       goodname = GetGoodName(m.catalogid),
                                       gooddesc = GetGoodDesc(m.catalogid),
                                       evalstatus = GetEvalStatus(m.uid),
                                       salestatus = (int)m.status,
                                       rejectstatus = (int)m.back,
                                       price = m.price.ToString(),
                                       buydate = String.Format("{0:yyyy-MM-dd}", m.regtime)
                                   }).ToList();
                        break;
                    case 1:
                        arrData = (from m in context.tbl_sales
                                   where m.deleted == 0 && m.userid == nUID && m.status == 0 && m.back == 0
                                   orderby m.regtime descending
                                   select new GoodStausItem
                                   {
                                       saleid = m.uid,
                                       goodid = m.catalogid,
                                       imgpath = GetGoodImgPath(m.catalogid),
                                       goodname = GetGoodName(m.catalogid),
                                       gooddesc = GetGoodDesc(m.catalogid),
                                       evalstatus = GetEvalStatus(m.uid),
                                       salestatus = (int)m.status,
                                       rejectstatus = (int)m.back,
                                       price = m.price.ToString(),
                                       buydate = String.Format("{0:yyyy-MM-dd}", m.regtime)
                                   }).ToList();
                        break;
                    case 2:
                        arrData = (from m in context.tbl_sales
                                   join n in context.tbl_catalogs on m.catalogid equals n.uid
                                   where m.deleted == 0 && m.userid == nUID && m.back == 0 && m.identify == 1 && n.back == 1
                                   orderby m.regtime descending
                                   select new GoodStausItem
                                   {
                                       saleid = m.uid,
                                       goodid = m.catalogid,
                                       imgpath = GetGoodImgPath(m.catalogid),
                                       goodname = GetGoodName(m.catalogid),
                                       gooddesc = GetGoodDesc(m.catalogid),
                                       evalstatus = GetEvalStatus(m.uid),
                                       salestatus = (int)m.status,
                                       rejectstatus = (int)m.back,
                                       price = m.price.ToString(),
                                       buydate = String.Format("{0:yyyy-MM-dd}", m.regtime)
                                   }).ToList();
                        break;
                }

                if (arrData == null)
                {
                    arrData = new List<GoodStausItem>();
                }

                retData.RetVal = Common.ServiceRetCode.ERR_SUCCESS;
                retData.RetData = arrData.Skip(Common.Common.GOODLIST_COUNT * nPageNo).Take(Common.Common.GOODLIST_COUNT).ToList();
        	}
        	catch (System.Exception ex)
        	{
        		retData.RetVal = Common.ServiceRetCode.ERR_SERVERINTERNALERROR;
        		Common.Common.WriteError(MethodBase.GetCurrentMethod().Name, ex.Message);
        	}
        	
        	return retData;
        }

        public static int GetUserMark(long userid)
        {
            DSHDBDataContext context = new DSHDBDataContext();

            return (from m in context.tbl_users where m.deleted == 0 && m.uid == userid select m).FirstOrDefault().score;
        }
        public static string GetUserPhone(long userid)
        {
            DSHDBDataContext context = new DSHDBDataContext();

            return (from m in context.tbl_users where m.deleted == 0 && m.uid == userid select m).FirstOrDefault().phonenum;
        }
        public class GoodOrderInfo
        {
            public long goodid = 0;
            public string goodname = string.Empty;
            public int price = 0;
            public int count = 0;
            public int usingmark = 0;
            public int marklimit = 0;
            public int usermark = 0;
            public string userphone = string.Empty;
            public int isreject = 0;
        }
        public static ServiceResponseData GetGoodOrderInfo(string uid, string goodid)
        {
        	ServiceResponseData retData = new ServiceResponseData();
        	DSHDBDataContext context = new DSHDBDataContext();

            DateTime dtToday = DateTime.Now;

            GoodOrderInfo orderInfo = new GoodOrderInfo();

        	try
        	{
                long nUID = long.Parse(uid);
                long nGoodID = long.Parse(goodid);

                string userPhone = GetUserPhone(nUID);

                orderInfo = (from m in context.tbl_catalogs
                             where m.deleted == 0 && m.uid == nGoodID && m.startdate <= dtToday && dtToday <= m.enddate
                             select new GoodOrderInfo
                             {
                                 goodid = nGoodID,
                                 goodname = m.name,
                                 price = m.price,
                                 count = m.count,
                                 usingmark = (int)m.using_score,
                                 marklimit = (m.score_limit == null)? 0 : Convert.ToInt32(m.score_limit),
                                 usermark = GetUserMark(nUID),
                                 userphone = (userPhone == null)?string.Empty:userPhone,
                                 isreject = (int)m.back
                             }).FirstOrDefault();

                retData.RetData = orderInfo;
        	}
        	catch (System.Exception ex)
        	{
        		retData.RetVal = Common.ServiceRetCode.ERR_SERVERINTERNALERROR;
        		Common.Common.WriteError(MethodBase.GetCurrentMethod().Name, ex.Message);
        	}
        	
        	return retData;
        }

        public static ServiceResponseData UploadOrderInfo(string uid,
                                            string goodid,
                                            string goodcount,
                                            string usingmark,
                                            string usedmark,
                                            string isreject,
                                            string price,
                                            string paymode)
        {
        	ServiceResponseData retData = new ServiceResponseData();
        	DSHDBDataContext context = new DSHDBDataContext();
        	
        	try
        	{
                long nUID = long.Parse(uid);
                long nGoodID = long.Parse(goodid);
                int nCount = int.Parse(goodcount);
                int nUsingMark = int.Parse(usingmark);
                int nUsedMark = int.Parse(usedmark);
                int nIsReject = int.Parse(isreject);
                int nPrice = int.Parse(price);
                int nPayMode = int.Parse(paymode);

                tbl_sale newInfo = new tbl_sale();
                newInfo.userid = nUID;
                newInfo.catalogid = nGoodID;
                newInfo.count = nCount;
                newInfo.using_score = (byte)nUsingMark;
                newInfo.score = nUsedMark;
                newInfo.status = 0;
                newInfo.identify = 0;
                newInfo.back = 0;
                newInfo.process = 0;
                newInfo.price = nPrice;
                newInfo.pay_type = nPayMode;
                newInfo.regtime = DateTime.Now;
                newInfo.deleted = 0;

                context.tbl_sales.InsertOnSubmit(newInfo);
                context.SubmitChanges();
        	}
        	catch (System.Exception ex)
        	{
        		retData.RetVal = Common.ServiceRetCode.ERR_SERVERINTERNALERROR;
        		Common.Common.WriteError(MethodBase.GetCurrentMethod().Name, ex.Message);
        	}
        	
        	return retData;
        }

        public static ServiceResponseData SetGoodEval(string uid, string goodid, string saleid, string eval)
        {
            ServiceResponseData retData = new ServiceResponseData();
            DSHDBDataContext context = new DSHDBDataContext();

            try
            {
                long nUID = long.Parse(uid);
                long nGoodID = long.Parse(goodid);
                long nSaleID = long.Parse(saleid);
                int nEval = int.Parse(eval);

                tbl_eval newInfo = new tbl_eval();
                newInfo.userid = nUID;
                newInfo.catalogid = nGoodID;
                newInfo.sid = nSaleID;
                newInfo.eval = nEval;
                newInfo.regtime = DateTime.Now;
                newInfo.deleted = 0;

                context.tbl_evals.InsertOnSubmit(newInfo);
                context.SubmitChanges();
            }
            catch (System.Exception ex)
            {
                retData.RetVal = Common.ServiceRetCode.ERR_SERVERINTERNALERROR;
                Common.Common.WriteError(MethodBase.GetCurrentMethod().Name, ex.Message);
            }

            return retData;
        }
    }    
}