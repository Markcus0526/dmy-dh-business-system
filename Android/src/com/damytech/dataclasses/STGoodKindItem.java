package com.damytech.dataclasses;

import org.json.JSONObject;

public class STGoodKindItem
{
    public long uid = 0;
    public String title = "";
    public String imgpath = "";

    public static STGoodKindItem decode(JSONObject jsonObj)
    {
        STGoodKindItem kindInfo = new STGoodKindItem();

        try { kindInfo.uid = jsonObj.getLong("uid"); } catch(Exception ex) {ex.printStackTrace();}
        try { kindInfo.title = jsonObj.getString("title"); } catch(Exception ex) {ex.printStackTrace();}
        try { kindInfo.imgpath = jsonObj.getString("imgpath"); } catch(Exception ex) {ex.printStackTrace();}

        return kindInfo;
    }
}