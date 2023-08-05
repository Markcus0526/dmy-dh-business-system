using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using DSHWebService.Common;
using DSHWebService.Model;

namespace DSHWebService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "Service1" in code, svc and config file together.
    public class Service : IService
    {
        public ServiceResponseData GetData()
        {
            //return string.Format("You entered: {0}", ServiceBody.LoginUser("", "", "1", "").RetData);            
            //return ServiceBody.LoginUser("test", "admin", "1234567888", "1");
            return ServiceBody.UpdateUserInfo("6", "a", "2000-01-01", "a@a.a", "12345678900", "abcdefgh");
        }

        public ServiceResponseData LoginUser(string username, string password, string macaddr, string devtype)
        {
            return ServiceBody.LoginUser(username, password, macaddr, devtype);
        }

        public ServiceResponseData ReqVerifyKey(string phonenum)
        {
            return ServiceBody.ReqVerifyKey(phonenum);
        }

        public ServiceResponseData ConfirmVerifyKey(string phonenum, string verifykey)
        {
            return ServiceBody.ConfirmVerifyKey(phonenum, verifykey);
        }

        public ServiceResponseData RegisterUser(string username, string password, string phonenum, string macaddr, string devtype)
        {
            return ServiceBody.RegisterUser(username, password, phonenum, macaddr, devtype);
        }

        public ServiceResponseData ResetPassword(string uid, string phonenum, string password)
        {
            return ServiceBody.ResetPassword(uid, phonenum, password);
        }

        public ServiceResponseData GetUserInfo(string uid)
        {
            return ServiceBody.GetUserInfo(uid);
        }

        public ServiceResponseData UpdateUserInfo(string uid, string username, string birthday, string email, string phonenum, string imgdata)
        {
            return ServiceBody.UpdateUserInfo(uid, username, birthday, email, phonenum, imgdata);
        }

        public ServiceResponseData GetServiceList(string mode)
        {
            return ServiceBody.GetServiceList(mode);
        }

        public ServiceResponseData AddServiceItem(string uid, string mode, string cardno, string name, string phonenum, string identino, string address, string note)
        {
            return ServiceBody.AddServiceItem(uid, mode, cardno, name, phonenum, identino, address, note);
        }

        public ServiceResponseData GetRecommendGoodList()
        {
            return ServiceBody.GetRecommendGoodList();
        }

        public ServiceResponseData GetGoodKindList()
        {
            return ServiceBody.GetGoodKindList();
        }

        public ServiceResponseData GetGoodsList(string mode, string kindid, string pageno)
        {
            return ServiceBody.GetGoodsList(mode, kindid, pageno);
        }

        public ServiceResponseData FindGoodsList(string mode, string kindid, string goodname, string pageno)
        {
            return ServiceBody.FindGoodsList(mode, kindid, goodname, pageno);
        }

        public ServiceResponseData GetGoodDetailInfo(string goodid)
        {
            return ServiceBody.GetGoodDetailInfo(goodid);
        }

        public ServiceResponseData AddBusinessMoney(string uid,
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
            return ServiceBody.AddBusinessMoney(uid, cardid, businessname, corporatename, corporateid, corporatephone, username, userphone, useraddress, content);
        }

        public ServiceResponseData GetMyOrderList(string uid, string mode, string pageno)
        {
            return ServiceBody.GetMyOrderList(uid, mode, pageno);
        }

        public ServiceResponseData GetGoodOrderInfo(string uid, string goodid)
        {
            return ServiceBody.GetGoodOrderInfo(uid, goodid);
        }

        public ServiceResponseData UploadOrderInfo(string uid,
                                            string goodid,
                                            string goodcount,
                                            string usingmark,
                                            string usedmark,
                                            string isreject,
                                            string price,
                                            string paymode)
        {
            return ServiceBody.UploadOrderInfo(uid,
                                            goodid,
                                            goodcount,
                                            usingmark,
                                            usedmark,
                                            isreject,
                                            price,
                                            paymode);
        }

        public ServiceResponseData SetGoodEval(string uid, string goodid, string saleid, string eval)
        {
            return ServiceBody.SetGoodEval(uid, goodid, saleid, eval);
        }
    }
}
