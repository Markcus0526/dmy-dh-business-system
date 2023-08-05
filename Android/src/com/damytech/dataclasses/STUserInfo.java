package com.damytech.dataclasses;

import org.json.JSONObject;

public class STUserInfo
{
    public long uid = 0;
    public String userid = "";
    public String username = "";
    public String birth = "";
    public String email = "";
    public int ordercount = 0;
    public String phonenum = "";
    public String imgpath = "";
    public int credit = 0;

    public static STUserInfo decode(JSONObject jsonObj)
    {
        STUserInfo userInfo = new STUserInfo();

        try { userInfo.uid = jsonObj.getLong("uid"); } catch(Exception ex) {ex.printStackTrace();}
        try { userInfo.userid = jsonObj.getString("userid"); } catch(Exception ex) {ex.printStackTrace();}
        try { userInfo.username = jsonObj.getString("username"); } catch(Exception ex) {ex.printStackTrace();}
        try { userInfo.birth = jsonObj.getString("birth"); } catch(Exception ex) {ex.printStackTrace();}
        try { userInfo.email = jsonObj.getString("email"); } catch(Exception ex) {ex.printStackTrace();}
        try { userInfo.ordercount = jsonObj.getInt("ordercount"); } catch(Exception ex) {ex.printStackTrace();}
        try { userInfo.phonenum = jsonObj.getString("phonenum"); } catch(Exception ex) {ex.printStackTrace();}
        try { userInfo.imgpath = jsonObj.getString("imgpath"); } catch(Exception ex) {ex.printStackTrace();}
        try { userInfo.credit = jsonObj.getInt("credit"); } catch(Exception ex) {ex.printStackTrace();}

        return userInfo;
    }
}