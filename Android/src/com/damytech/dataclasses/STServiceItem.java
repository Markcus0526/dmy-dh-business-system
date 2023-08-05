package com.damytech.dataclasses;

import org.json.JSONObject;

public class STServiceItem
{
    public long uid = 0;
    public String title = "";
    public String content = "";

    public static STServiceItem decode(JSONObject jsonObj)
    {
        STServiceItem serviceItem = new STServiceItem();

        try { serviceItem.uid = jsonObj.getLong("uid"); } catch (Exception ex) {ex.printStackTrace();}
        try { serviceItem.title = jsonObj.getString("title"); } catch (Exception ex) {ex.printStackTrace();}
        try { serviceItem.content = jsonObj.getString("content"); } catch (Exception ex) {ex.printStackTrace();}

        return serviceItem;
    }
}