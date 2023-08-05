package com.damytech.dataclasses;

import org.json.JSONObject;

public class STRecommendGoodItem
{
    public long uid = 0;
    public String goodname = "";
    public String imgpath = "";

    public static STRecommendGoodItem decode(JSONObject jsonObj)
    {
        STRecommendGoodItem goodInfo = new STRecommendGoodItem();

        try { goodInfo.uid = jsonObj.getLong("uid"); } catch(Exception ex) {ex.printStackTrace();}
        try { goodInfo.goodname = jsonObj.getString("goodname"); } catch(Exception ex) {ex.printStackTrace();}
        try { goodInfo.imgpath = jsonObj.getString("imgpath"); } catch(Exception ex) {ex.printStackTrace();}

        return goodInfo;
    }
}