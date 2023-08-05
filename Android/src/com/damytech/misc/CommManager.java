package com.damytech.misc;

import com.damytech.HttpConn.AsyncHttpClient;
import com.damytech.HttpConn.JsonHttpResponseHandler;
import com.damytech.HttpConn.RequestParams;
import org.apache.http.entity.StringEntity;
import org.json.JSONObject;

/**
 * Created by RiKS on 2014/10/16.
 */
public class CommManager {
    public static int getTimeOut() { return (4 * 1000); }
    public static int getLongTimeOut() { return (19 * 1000); }
    public static String getServiceBaseUrl() { return "http://218.60.131.41:10122/Service.SVC/"; }
    public static String getDevType() { return "1"; }

    public static void LoginUser(String username, String password, String macaddr, JsonHttpResponseHandler handler)
    {
        String url = getServiceBaseUrl() + "LoginUser";
        AsyncHttpClient client = new AsyncHttpClient();

        try
        {
            JSONObject jsonParams = new JSONObject();
            jsonParams.put("username", username);
            jsonParams.put("password", password);
            jsonParams.put("macaddr", macaddr);
            jsonParams.put("devtype", getDevType());
            StringEntity entity = new StringEntity(jsonParams.toString(), "utf-8");

            client.setTimeout(getTimeOut());
            client.post(null, url, entity, "application/json", handler);
        }
        catch (Exception ex)
        {
            ex.printStackTrace();

            if (handler != null)
                handler.onFailure(null, ex.getMessage());
        }
    }

    public static void ReqVerifyKey(String phonenum, JsonHttpResponseHandler handler)
    {
        String url = "";
        AsyncHttpClient client = new AsyncHttpClient();
        RequestParams param = new RequestParams();

        try {
            url = getServiceBaseUrl() + "ReqVerifyKey";
            param.put("phonenum", phonenum);
            client.setTimeout(getTimeOut());
            client.get(url, param, handler);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void ConfirmVerifyKey(String phonenum, String verifykey, JsonHttpResponseHandler handler)
    {
        String url = "";
        AsyncHttpClient client = new AsyncHttpClient();
        RequestParams param = new RequestParams();

        try {
            url = getServiceBaseUrl() + "ConfirmVerifyKey";
            param.put("phonenum", phonenum);
            param.put("verifykey", verifykey);
            client.setTimeout(getTimeOut());
            client.get(url, param, handler);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void RegisterUser(String username, String password, String phonenum, String macaddr, JsonHttpResponseHandler handler)
    {
        String url = getServiceBaseUrl() + "RegisterUser";
        AsyncHttpClient client = new AsyncHttpClient();

        try
        {
            JSONObject jsonParams = new JSONObject();
            jsonParams.put("username", username);
            jsonParams.put("password", password);
            jsonParams.put("phonenum", phonenum);
            jsonParams.put("macaddr", macaddr);
            jsonParams.put("devtype", getDevType());
            StringEntity entity = new StringEntity(jsonParams.toString(), "utf-8");

            client.setTimeout(getTimeOut());
            client.post(null, url, entity, "application/json", handler);
        }
        catch (Exception ex)
        {
            ex.printStackTrace();

            if (handler != null)
                handler.onFailure(null, ex.getMessage());
        }
    }

    public static void GetUserInfo(long uid, JsonHttpResponseHandler handler)
    {
        String url = "";
        AsyncHttpClient client = new AsyncHttpClient();
        RequestParams param = new RequestParams();

        try {
            url = getServiceBaseUrl() + "GetUserInfo";
            param.put("uid", "" + uid);
            client.setTimeout(getTimeOut());
            client.get(url, param, handler);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void UpdateUserInfo(long uid, String username, String birthday, String email, String phonenum, String imgdata, JsonHttpResponseHandler handler)
    {
        String url = getServiceBaseUrl() + "UpdateUserInfo";
        AsyncHttpClient client = new AsyncHttpClient();

        try
        {
            JSONObject jsonParams = new JSONObject();
            jsonParams.put("uid", "" + uid);
            jsonParams.put("username", username);
            jsonParams.put("birthday", birthday);
            jsonParams.put("email", email);
            jsonParams.put("phonenum", phonenum);
            jsonParams.put("imgdata", imgdata);
            StringEntity entity = new StringEntity(jsonParams.toString(), "utf-8");

            client.setTimeout(getLongTimeOut());
            client.post(null, url, entity, "application/json", handler);
        }
        catch (Exception ex)
        {
            ex.printStackTrace();

            if (handler != null)
                handler.onFailure(null, ex.getMessage());
        }
    }

    public static void GetServiceList(int mode, JsonHttpResponseHandler handler)
    {
        String url = "";
        AsyncHttpClient client = new AsyncHttpClient();
        RequestParams param = new RequestParams();

        try {
            url = getServiceBaseUrl() + "GetServiceList";
            param.put("mode", "" + mode);
            client.setTimeout(getTimeOut());
            client.get(url, param, handler);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void AddServiceItem(long uid, int mode, long cardno, String name, String phonenum, String identino, String address, String note, JsonHttpResponseHandler handler)
    {
        String url = getServiceBaseUrl() + "AddServiceItem";
        AsyncHttpClient client = new AsyncHttpClient();

        try
        {
            JSONObject jsonParams = new JSONObject();
            jsonParams.put("uid", "" + uid);
            jsonParams.put("mode", "" + mode);
            jsonParams.put("cardno", "" + cardno);
            jsonParams.put("name", name);
            jsonParams.put("phonenum", phonenum);
            jsonParams.put("identino", identino);
            jsonParams.put("address", address);
            jsonParams.put("note", note);
            StringEntity entity = new StringEntity(jsonParams.toString(), "utf-8");

            client.setTimeout(getTimeOut());
            client.post(null, url, entity, "application/json", handler);
        }
        catch (Exception ex)
        {
            ex.printStackTrace();

            if (handler != null)
                handler.onFailure(null, ex.getMessage());
        }
    }

    public static void ResetPassword(long uid, String phonenum, String password, JsonHttpResponseHandler handler)
    {
        String url = "";
        AsyncHttpClient client = new AsyncHttpClient();
        RequestParams param = new RequestParams();

        try {
            url = getServiceBaseUrl() + "ResetPassword";
            param.put("uid", "" + uid);
            param.put("phonenum", phonenum);
            param.put("password", password);
            client.setTimeout(getTimeOut());
            client.get(url, param, handler);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void GetRecommendGoodList(JsonHttpResponseHandler handler)
    {
        String url = "";
        AsyncHttpClient client = new AsyncHttpClient();

        try {
            url = getServiceBaseUrl() + "GetRecommendGoodList";
            client.setTimeout(getTimeOut());
            client.get(url, null, handler);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void GetGoodKindList(JsonHttpResponseHandler handler)
    {
        String url = "";
        AsyncHttpClient client = new AsyncHttpClient();

        try {
            url = getServiceBaseUrl() + "GetGoodKindList";
            client.setTimeout(getTimeOut());
            client.get(url, null, handler);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void GetGoodsList(int mode, long kindid, int pageno, JsonHttpResponseHandler handler)
    {
        String url = "";
        AsyncHttpClient client = new AsyncHttpClient();
        RequestParams params = new RequestParams();

        try {
            url = getServiceBaseUrl() + "GetGoodsList";
            params.put("mode", "" + mode);
            params.put("kindid", "" + kindid);
            params.put("pageno", "" + pageno);
            client.setTimeout(getTimeOut());
            client.get(url, params, handler);
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        return;
    }

    public static void FindGoodsList(int mode, long kindid, String goodname, int pageno, JsonHttpResponseHandler handler)
    {
        String url = "";
        AsyncHttpClient client = new AsyncHttpClient();
        RequestParams params = new RequestParams();

        try {
            url = getServiceBaseUrl() + "FindGoodsList";
            params.put("mode", "" + mode);
            params.put("kindid", "" + kindid);
            params.put("goodname", goodname);
            params.put("pageno", "" + pageno);
            client.setTimeout(getTimeOut());
            client.get(url, params, handler);
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        return;
    }

    public static void GetGoodDetailInfo(long goodid, JsonHttpResponseHandler handler)
    {
        String url = "";
        AsyncHttpClient client = new AsyncHttpClient();
        RequestParams params = new RequestParams();

        try {
            url = getServiceBaseUrl() + "GetGoodDetailInfo";
            params.put("goodid", "" + goodid);
            client.setTimeout(getTimeOut());
            client.get(url, params, handler);
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        return;
    }

    public static void AddBusinessMoney(long uid,
                                           long cardid,
                                           String businessname,
                                           String corporatename,
                                           String corporateid,
                                           String corporatephone,
                                           String username,
                                           String userphone,
                                           String useraddress,
                                           String content,
                                           JsonHttpResponseHandler handler)
    {
        String url = getServiceBaseUrl() + "AddBusinessMoney";
        AsyncHttpClient client = new AsyncHttpClient();

        try
        {
            JSONObject jsonParams = new JSONObject();
            jsonParams.put("uid", "" + uid);
            jsonParams.put("cardid", "" + cardid);
            jsonParams.put("businessname", businessname);
            jsonParams.put("corporatename", corporatename);
            jsonParams.put("corporateid", corporateid);
            jsonParams.put("corporateid", corporateid);
            jsonParams.put("corporatephone", corporatephone);
            jsonParams.put("username", username);
            jsonParams.put("userphone", userphone);
            jsonParams.put("useraddress", useraddress);
            jsonParams.put("content", content);
            StringEntity entity = new StringEntity(jsonParams.toString(), "utf-8");

            client.setTimeout(getTimeOut());
            client.post(null, url, entity, "application/json", handler);
        }
        catch (Exception ex)
        {
            ex.printStackTrace();

            if (handler != null)
                handler.onFailure(null, ex.getMessage());
        }
    }

    public static void GetMyOrderList(long uid, int mode, int pageno, JsonHttpResponseHandler handler)
    {
        String url = "";
        AsyncHttpClient client = new AsyncHttpClient();
        RequestParams params = new RequestParams();

        try {
            url = getServiceBaseUrl() + "GetMyOrderList";
            params.put("uid", "" + uid);
            params.put("mode", "" + mode);
            params.put("pageno", "" + pageno);
            client.setTimeout(getTimeOut());
            client.get(url, params, handler);
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        return;
    }

    public static void GetGoodOrderInfo(long uid, long goodid, JsonHttpResponseHandler handler)
    {
        String url = "";
        AsyncHttpClient client = new AsyncHttpClient();
        RequestParams params = new RequestParams();

        try {
            url = getServiceBaseUrl() + "GetGoodOrderInfo";
            params.put("uid", "" + uid);
            params.put("goodid", "" + goodid);
            client.setTimeout(getTimeOut());
            client.get(url, params, handler);
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        return;
    }

    public static void UploadOrderInfo(long uid,
                                       long goodid,
                                       int goodcount,
                                       int usingmark,
                                       int usedmark,
                                       int isreject,
                                       int price,
                                       int paymode,
                                       JsonHttpResponseHandler handler)
    {
        String url = getServiceBaseUrl() + "UploadOrderInfo";
        AsyncHttpClient client = new AsyncHttpClient();

        try
        {
            JSONObject jsonParams = new JSONObject();
            jsonParams.put("uid", "" + uid);
            jsonParams.put("goodid", "" + goodid);
            jsonParams.put("goodcount", "" + goodcount);
            jsonParams.put("usingmark", "" + usingmark);
            jsonParams.put("usedmark", "" + usedmark);
            jsonParams.put("isreject", "" + isreject);
            jsonParams.put("price", "" + price);
            jsonParams.put("paymode", "" + paymode);
            StringEntity entity = new StringEntity(jsonParams.toString(), "utf-8");

            client.setTimeout(getTimeOut());
            client.post(null, url, entity, "application/json", handler);
        }
        catch (Exception ex)
        {
            ex.printStackTrace();

            if (handler != null)
                handler.onFailure(null, ex.getMessage());
        }
    }

    public static void SetGoodEval(long uid, long goodid, long saleid, int eval, JsonHttpResponseHandler handler)
    {
        String url = "";
        AsyncHttpClient client = new AsyncHttpClient();
        RequestParams params = new RequestParams();

        try {
            url = getServiceBaseUrl() + "SetGoodEval";
            params.put("uid", "" + uid);
            params.put("goodid", "" + goodid);
            params.put("saleid", "" + saleid);
            params.put("eval", "" + eval);
            client.setTimeout(getTimeOut());
            client.get(url, params, handler);
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        return;
    }
}
