package com.damytech.dataclasses;

import org.json.JSONObject;

public class STGoodItem
{
    public long uid = 0;
	public String name = "";
	public String imgpath = "";
	public String noti = "";
	public int price = 0;
	public int selledcount = 0;

    public static STGoodItem decode(JSONObject jsonObj)
    {
        STGoodItem goodInfo = new STGoodItem();

        try { goodInfo.uid = jsonObj.getLong("uid"); } catch(Exception ex) {ex.printStackTrace();}
        try { goodInfo.name = jsonObj.getString("name"); } catch(Exception ex) {ex.printStackTrace();}
        try { goodInfo.imgpath = jsonObj.getString("imgpath"); } catch(Exception ex) {ex.printStackTrace();}
		try { goodInfo.noti = jsonObj.getString("noti"); } catch(Exception ex) {ex.printStackTrace();}
		try { goodInfo.price = jsonObj.getInt("price"); } catch(Exception ex) {ex.printStackTrace();}
		try { goodInfo.selledcount = jsonObj.getInt("selledcount"); } catch(Exception ex) {ex.printStackTrace();}

        return goodInfo;
    }
}