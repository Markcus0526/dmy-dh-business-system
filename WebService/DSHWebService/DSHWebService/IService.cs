using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using DSHWebService.Common;

namespace DSHWebService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IService1" in both code and config file together.
    [ServiceContract]
    public interface IService
    {

        [WebGet(
            BodyStyle = WebMessageBodyStyle.WrappedRequest,
            ResponseFormat = WebMessageFormat.Json,
            RequestFormat = WebMessageFormat.Json)]
        ServiceResponseData GetData();

        [OperationContract]
        [WebInvoke(
            BodyStyle = WebMessageBodyStyle.WrappedRequest,
            ResponseFormat = WebMessageFormat.Json,
            RequestFormat = WebMessageFormat.Json)]
        ServiceResponseData LoginUser(string username, string password, string macaddr, string devtype);

        [WebGet(
            BodyStyle = WebMessageBodyStyle.WrappedRequest,
            ResponseFormat = WebMessageFormat.Json,
            RequestFormat = WebMessageFormat.Json)]
        ServiceResponseData ReqVerifyKey(string phonenum);

        [WebGet(
            BodyStyle = WebMessageBodyStyle.WrappedRequest,
            ResponseFormat = WebMessageFormat.Json,
            RequestFormat = WebMessageFormat.Json)]
        ServiceResponseData ConfirmVerifyKey(string phonenum, string verifykey);

        [OperationContract]
        [WebInvoke(
            BodyStyle = WebMessageBodyStyle.WrappedRequest,
            ResponseFormat = WebMessageFormat.Json,
            RequestFormat = WebMessageFormat.Json)]
        ServiceResponseData RegisterUser(string username, string password, string phonenum, string macaddr, string devtype);

        [WebGet(
            BodyStyle = WebMessageBodyStyle.WrappedRequest,
            ResponseFormat = WebMessageFormat.Json,
            RequestFormat = WebMessageFormat.Json)]
        ServiceResponseData ResetPassword(string uid, string phonenum, string password);

        [WebGet(
            BodyStyle = WebMessageBodyStyle.WrappedRequest,
            ResponseFormat = WebMessageFormat.Json,
            RequestFormat = WebMessageFormat.Json)]
        ServiceResponseData GetUserInfo(string uid);

        [OperationContract]
        [WebInvoke(
            BodyStyle = WebMessageBodyStyle.WrappedRequest,
            ResponseFormat = WebMessageFormat.Json,
            RequestFormat = WebMessageFormat.Json)]
        ServiceResponseData UpdateUserInfo(string uid, string username, string birthday, string email, string phonenum, string imgdata);

        [WebGet(
            BodyStyle = WebMessageBodyStyle.WrappedRequest,
            ResponseFormat = WebMessageFormat.Json,
            RequestFormat = WebMessageFormat.Json)]
        ServiceResponseData GetServiceList(string mode);

        [OperationContract]
        [WebInvoke(
            BodyStyle = WebMessageBodyStyle.WrappedRequest,
            ResponseFormat = WebMessageFormat.Json,
            RequestFormat = WebMessageFormat.Json)]
        ServiceResponseData AddServiceItem(string uid, string mode, string cardno, string name, string phonenum, string identino, string address, string note);

        [WebGet(
            BodyStyle = WebMessageBodyStyle.WrappedRequest,
            ResponseFormat = WebMessageFormat.Json,
            RequestFormat = WebMessageFormat.Json)]
        ServiceResponseData GetRecommendGoodList();

        [WebGet(
            BodyStyle = WebMessageBodyStyle.WrappedRequest,
            ResponseFormat = WebMessageFormat.Json,
            RequestFormat = WebMessageFormat.Json)]
        ServiceResponseData GetGoodKindList();

        [WebGet(
            BodyStyle = WebMessageBodyStyle.WrappedRequest,
            ResponseFormat = WebMessageFormat.Json,
            RequestFormat = WebMessageFormat.Json)]
        ServiceResponseData GetGoodsList(string mode, string kindid, string pageno);

        [WebGet(
            BodyStyle = WebMessageBodyStyle.WrappedRequest,
            ResponseFormat = WebMessageFormat.Json,
            RequestFormat = WebMessageFormat.Json)]
        ServiceResponseData FindGoodsList(string mode, string kindid, string goodname, string pageno);

        [WebGet(
            BodyStyle = WebMessageBodyStyle.WrappedRequest,
            ResponseFormat = WebMessageFormat.Json,
            RequestFormat = WebMessageFormat.Json)]
        ServiceResponseData GetGoodDetailInfo(string goodid);

        [OperationContract]
        [WebInvoke(
            BodyStyle = WebMessageBodyStyle.WrappedRequest,
            ResponseFormat = WebMessageFormat.Json,
            RequestFormat = WebMessageFormat.Json)]
        ServiceResponseData AddBusinessMoney(string uid,
                                            string cardid,
                                            string businessname, 
                                            string corporatename, 
                                            string corporateid,
                                            string corporatephone, 
                                            string username, 
                                            string userphone,
                                            string useraddress,
                                            string content);

        [WebGet(
            BodyStyle = WebMessageBodyStyle.WrappedRequest,
            ResponseFormat = WebMessageFormat.Json,
            RequestFormat = WebMessageFormat.Json)]
        ServiceResponseData GetMyOrderList(string uid, string mode, string pageno);

        [WebGet(
            BodyStyle = WebMessageBodyStyle.WrappedRequest,
            ResponseFormat = WebMessageFormat.Json,
            RequestFormat = WebMessageFormat.Json)]
        ServiceResponseData GetGoodOrderInfo(string uid, string goodid);

        [OperationContract]
        [WebInvoke(
            BodyStyle = WebMessageBodyStyle.WrappedRequest,
            ResponseFormat = WebMessageFormat.Json,
            RequestFormat = WebMessageFormat.Json)]
        ServiceResponseData UploadOrderInfo(string uid,
                                            string goodid,
                                            string goodcount,
                                            string usingmark,
                                            string usedmark,
                                            string isreject,
                                            string price,
                                            string paymode);

        [WebGet(
            BodyStyle = WebMessageBodyStyle.WrappedRequest,
            ResponseFormat = WebMessageFormat.Json,
            RequestFormat = WebMessageFormat.Json)]
        ServiceResponseData SetGoodEval(string uid, string goodid, string saleid, string eval);
    }
}
